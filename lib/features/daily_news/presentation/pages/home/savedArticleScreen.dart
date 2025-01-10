import 'package:check/features/daily_news/presentation/pages/onDetail/onDetail.dart';
import 'package:flutter/material.dart';
import 'package:check/features/daily_news/domain/entities/article.dart';

class SavedArticlesScreen extends StatelessWidget {
  final List<ArticleEntity> savedArticles;

  const SavedArticlesScreen({required this.savedArticles, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Saved Articles'),
        centerTitle: true,
        backgroundColor: Colors.white,
        elevation: 1,
      ),
      body: savedArticles.isEmpty
          ? const Center(
              child: Text(
                "No saved articles yet.",
                style: TextStyle(fontSize: 16, color: Colors.grey),
              ),
            )
          : ListView.builder(
              itemCount: savedArticles.length,
              itemBuilder: (context, index) {
                final article = savedArticles[index];
                return ListTile(
                  title: Text(article.title ?? "No Title"),
                  subtitle: Text(article.author ?? "No Author"),
                  onTap: () {
                    // Navigate to article details
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => ArticleDetailsScreen(article: article),
                      ),
                    );
                  },
                );
              },
            ),
    );
  }
}
