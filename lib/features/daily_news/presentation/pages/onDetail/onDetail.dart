import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shimmer/shimmer.dart';
import 'package:intl/intl.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:check/features/daily_news/domain/entities/article.dart';

class ArticleDetailsScreen extends StatefulWidget {
  final ArticleEntity article;

  const ArticleDetailsScreen({required this.article, Key? key}) : super(key: key);

  @override
  State<ArticleDetailsScreen> createState() => _ArticleDetailsScreenState();
}

class _ArticleDetailsScreenState extends State<ArticleDetailsScreen> {
  bool isSaved = false;

  @override
  void initState() {
    super.initState();
    _loadSavedState();
  }

  // Load the saved state from SharedPreferences
  void _loadSavedState() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      isSaved = prefs.getBool(widget.article.title ?? '') ?? false;
    });
  }

  // Toggle save article state and store it in SharedPreferences
  void _toggleSaveArticle() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      isSaved = !isSaved;
    });
    await prefs.setBool(widget.article.title ?? '', isSaved);

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(isSaved ? 'Article saved!' : 'Article unsaved!'),
      ),
    );
  }

  // Shimmer effect for loading state
  Widget _buildShimmerEffect() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Shimmer.fromColors(
            baseColor: Colors.grey.shade300,
            highlightColor: Colors.grey.shade100,
            child: Container(
              width: double.infinity,
              height: 250,
              color: Colors.grey,
            ),
          ),
          const SizedBox(height: 16),
          Shimmer.fromColors(
            baseColor: Colors.grey.shade300,
            highlightColor: Colors.grey.shade100,
            child: Container(
              width: 200,
              height: 30,
              color: Colors.grey,
            ),
          ),
          const SizedBox(height: 8),
          Shimmer.fromColors(
            baseColor: Colors.grey.shade300,
            highlightColor: Colors.grey.shade100,
            child: Container(
              width: 120,
              height: 20,
              color: Colors.grey,
            ),
          ),
          const SizedBox(height: 16),
          Shimmer.fromColors(
            baseColor: Colors.grey.shade300,
            highlightColor: Colors.grey.shade100,
            child: Container(
              width: double.infinity,
              height: 100,
              color: Colors.grey,
            ),
          ),
        ],
      ),
    );
  }

  // Date formatting method
  String _formatDate(String dateString) {
    try {
      final date = DateTime.parse(dateString);
      final DateFormat formatter = DateFormat('MMM dd, yyyy');
      return formatter.format(date);
    } catch (e) {
      return "Invalid date format";
    }
  }

  // Function to launch URL in a web browser
  void _launchURL(String url, BuildContext context) async {
    final Uri uri = Uri.parse(url);
    try {
      if (await launchUrl(uri)) {
        // Successfully opened the URL
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Could not launch $url')),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error launching URL: $url')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Article Details'),
        centerTitle: true,
        actions: [
          IconButton(
            icon: Icon(isSaved ? Icons.bookmark : Icons.bookmark_border),
            onPressed: _toggleSaveArticle,
            tooltip: isSaved ? 'Unsave Article' : 'Save Article',
          ),
        ],
      ),
      body: widget.article.title == null || widget.article.content == null
          ? _buildShimmerEffect()
          : SingleChildScrollView(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Article Image
                  if (widget.article.urlToImage != null &&
                      widget.article.urlToImage!.isNotEmpty)
                    ClipRRect(
                      borderRadius: BorderRadius.circular(12.0),
                      child: Image.network(
                        widget.article.urlToImage!,
                        width: double.infinity,
                        height: 250,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) =>
                            const Icon(
                          Icons.broken_image,
                          size: 100,
                          color: Colors.grey,
                        ),
                      ),
                    )
                  else
                    const Icon(
                      Icons.image_not_supported,
                      size: 100,
                      color: Colors.grey,
                    ),
                  const SizedBox(height: 16),

                  // Article Title
                  Text(
                    widget.article.title ?? "No Title",
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                  ),
                  const SizedBox(height: 8),

                  // Article Metadata
                  Row(
                    children: [
                      if (widget.article.author != null &&
                          widget.article.author!.isNotEmpty)
                        Flexible(
                          child: Text(
                            "By ${widget.article.author}",
                            style: const TextStyle(
                                fontSize: 14, fontStyle: FontStyle.italic),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      if (widget.article.publishedAt != null)
                        Flexible(
                          child: Text(
                            " • ${_formatDate(widget.article.publishedAt!)}",
                            style: const TextStyle(
                                fontSize: 14, color: Colors.grey),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                    ],
                  ),
                  const SizedBox(height: 16),

                  // Article Content
                  Text(
                    widget.article.content ?? "No Content Available.",
                    style: const TextStyle(fontSize: 16, height: 1.5),
                  ),
                  const SizedBox(height: 16),

                  // Article URL
                  if (widget.article.url != null && widget.article.url!.isNotEmpty)
                    GestureDetector(
                      onTap: () {
                        _launchURL(widget.article.url!, context);
                      },
                      child: Text(
                        "Read More: ${widget.article.url}",
                        style: const TextStyle(
                          fontSize: 14,
                          color: Colors.blue,
                          decoration: TextDecoration.underline,
                        ),
                      ),
                    ),
                ],
              ),
            ),
    );
  }
}
