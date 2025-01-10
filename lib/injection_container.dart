

import 'package:check/features/daily_news/data/data_sources/remote/news_api_service.dart';
import 'package:check/features/daily_news/data/repositary/article_repository_impl.dart';
import 'package:check/features/daily_news/domain/repositaries/article_repository.dart';
import 'package:check/features/daily_news/domain/usecases/get_article.dart';
import 'package:check/features/daily_news/presentation/bloc/article/remote/remote_article_bloc.dart';
import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';

final sl =GetIt.instance;
Future<void> intilizeDependencies()async{
  sl.registerSingleton<Dio>(Dio());
  sl.registerSingleton<NewsApiService>(NewsApiService(sl()));
  sl.registerSingleton<ArticleRepository>(ArticleRepositoryImpl(sl()));
  sl.registerSingleton<GetArticleUseCase>(GetArticleUseCase(sl()));
  sl.registerFactory<RemoteArticleBloc>(()=> RemoteArticleBloc(sl()));
}