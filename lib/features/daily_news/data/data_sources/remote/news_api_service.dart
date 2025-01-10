import 'package:check/features/core/constants/constants.dart';
import 'package:check/features/daily_news/data/models/article.dart';
import 'package:dio/dio.dart';
import 'package:retrofit/retrofit.dart';

part 'news_api_service.g.dart'; // Ensure this file is properly generated using Retrofit

@RestApi(baseUrl: newsAPIBASEURL)
abstract class NewsApiService {
  factory NewsApiService(Dio dio, {String? baseUrl}) = _NewsApiService;

  @GET("/top-headlines")
  Future<HttpResponse<List<ArticleModel>>> getNewsArticles({
    @Query("apiKey") required String apiKey,
    @Query("country") String? country,
    @Query("category") String? category,
  });
}
