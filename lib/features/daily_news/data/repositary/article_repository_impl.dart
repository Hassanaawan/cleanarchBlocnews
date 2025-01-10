import 'dart:io';


import 'package:check/features/core/constants/constants.dart';
import 'package:check/features/core/resources/data_state.dart';
import 'package:check/features/daily_news/data/data_sources/remote/news_api_service.dart';
import 'package:check/features/daily_news/data/models/article.dart';
import 'package:check/features/daily_news/domain/repositaries/article_repository.dart';
import 'package:dio/dio.dart';

class ArticleRepositoryImpl implements ArticleRepository {
  final NewsApiService _newsApiService;

  ArticleRepositoryImpl(this._newsApiService);

  @override
  Future<DataState<List<ArticleModel>>> getNewsArticles() async {
    try {
      final httpResponse = await _newsApiService.getNewsArticles(
        apiKey: apiKey, // Ensure 'apiKey' is defined
        country: countryQuery, // Ensure 'countryQuery' is defined
        category: categoryQuery, // Ensure 'categoryQuery' is defined
      );
      if (httpResponse.response.statusCode == HttpStatus.ok) {
        return DataSuccess(httpResponse.data);
      } else {
        return DataError(DioException(
          error: httpResponse.response.statusMessage,
          response: httpResponse.response,
          type: DioExceptionType.badResponse,
          requestOptions: httpResponse.response.requestOptions,
        ));
      }
    } on DioException catch (e) {
      return DataError(e);
    }
  }
}
