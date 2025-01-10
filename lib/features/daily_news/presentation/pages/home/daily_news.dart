import 'package:check/features/daily_news/presentation/pages/home/savedArticleScreen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:check/features/daily_news/domain/entities/article.dart';
import 'package:check/features/daily_news/presentation/pages/onDetail/onDetail.dart';
import 'package:check/features/daily_news/presentation/bloc/article/remote/remote_article_bloc.dart';
import 'package:check/features/daily_news/presentation/bloc/article/remote/remote_article_state.dart';
import 'package:check/features/daily_news/presentation/bloc/article/remote/remote_article_event.dart';
import 'package:shimmer/shimmer.dart';
import 'package:intl/intl.dart';


class DailyNews extends StatefulWidget {
  const DailyNews({super.key});

  @override
  _DailyNewsState createState() => _DailyNewsState();
}

class _DailyNewsState extends State<DailyNews> {
  int _selectedIndex = 0; // To track the selected bottom nav item
  final List<ArticleEntity> _savedArticles = []; // List to hold saved articles

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Daily News',
          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: Colors.white,
        elevation: 1,
        centerTitle: true,
      ),
      body: _selectedIndex == 0
          ? BlocBuilder<RemoteArticleBloc, RemoteArticleState>(
              builder: (_, state) {
                if (state is RemoteArticleLoading) {
                  // Shimmer effect for loading state
                  return ListView.builder(
                    padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                    itemCount: 5,
                    itemBuilder: (context, index) {
                      return Shimmer.fromColors(
                        baseColor: Colors.grey.shade300,
                        highlightColor: Colors.grey.shade100,
                        child: Card(
                          elevation: 2,
                          margin: const EdgeInsets.only(bottom: 16),
                          child: Padding(
                            padding: const EdgeInsets.all(12),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Container(
                                  width: 100,
                                  height: 100,
                                  color: Colors.grey.shade300,
                                ),
                                const SizedBox(width: 12),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Container(
                                        height: 16,
                                        color: Colors.grey.shade300,
                                      ),
                                      const SizedBox(height: 8),
                                      Container(
                                        height: 12,
                                        color: Colors.grey.shade300,
                                      ),
                                      const SizedBox(height: 8),
                                      Container(
                                        height: 12,
                                        color: Colors.grey.shade300,
                                        width: 80,
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                    },
                  );
                }

                if (state is RemoteArticleError) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(Icons.error, color: Colors.red, size: 48),
                        const SizedBox(height: 8),
                        const Text(
                          "Something went wrong. Please try again.",
                          style: TextStyle(fontSize: 16, color: Colors.grey),
                        ),
                        const SizedBox(height: 12),
                        ElevatedButton(
                          onPressed: () {
                            // Trigger retry event
                            context.read<RemoteArticleBloc>().add(const RetryGetArticles());
                          },
                          child: const Text("Retry"),
                        ),
                      ],
                    ),
                  );
                }

                if (state is RemoteArticleDone) {
                  if (state.articles == null || state.articles!.isEmpty) {
                    return const Center(
                      child: Text(
                        "No articles found.",
                        style: TextStyle(fontSize: 16, color: Colors.grey),
                      ),
                    );
                  }

                  return ListView.builder(
                    padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                    itemCount: state.articles!.length,
                    itemBuilder: (context, index) {
                      final article = state.articles![index];
                      return Card(
                        elevation: 4,
                        margin: const EdgeInsets.only(bottom: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: InkWell(
                          onTap: () {
                            // Handle navigation to article details
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => ArticleDetailsScreen(article: article),
                              ),
                            );
                          },
                          child: Padding(
                            padding: const EdgeInsets.all(12),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                // Article Image
                                ClipRRect(
                                  borderRadius: BorderRadius.circular(8),
                                  child: article.urlToImage != null && article.urlToImage!.isNotEmpty
                                      ? Image.network(
                                          article.urlToImage!,
                                          width: 100,
                                          height: 100,
                                          fit: BoxFit.cover,
                                        )
                                      : Container(
                                          width: 100,
                                          height: 100,
                                          color: Colors.grey.shade300,
                                          child: const Icon(Icons.image_not_supported, size: 40, color: Colors.grey),
                                        ),
                                ),
                                const SizedBox(width: 12),
                                // Article Details
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        article.title?.isNotEmpty == true ? article.title! : "No Title Available",
                                        style: const TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 16,
                                        ),
                                        maxLines: 2,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                      const SizedBox(height: 8),
                                      Text(
                                        article.description?.isNotEmpty == true
                                            ? article.description!
                                            : "No description available.",
                                        style: const TextStyle(
                                          color: Colors.grey,
                                          fontSize: 14,
                                        ),
                                        maxLines: 3,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                      const SizedBox(height: 8),
                                      // Date Formatting
                                      Text(
                                        article.publishedAt?.isNotEmpty == true
                                            ? "Published on: ${_formatDate(article.publishedAt!)}"
                                            : "Date unavailable",
                                        style: const TextStyle(
                                          color: Colors.grey,
                                          fontSize: 12,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                    },
                  );
                }

                return const SizedBox.shrink(); // Default fallback
              },
            )
          : SavedArticlesScreen(savedArticles: _savedArticles),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.article),
            label: 'Daily News',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.bookmark),
            label: 'Saved Articles',
          ),
        ],
      ),
    );
  }

  // Handle bottom navigation bar taps
  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
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
}
