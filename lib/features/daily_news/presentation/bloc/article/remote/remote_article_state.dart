
import 'package:check/features/daily_news/domain/entities/article.dart';
import 'package:equatable/equatable.dart';
import 'package:dio/dio.dart';
abstract class RemoteArticleState extends Equatable
{
  final List<ArticleEntity> ? articles;
  final DioException ? error;
  const RemoteArticleState({this.articles, this.error});
  @override
  // TODO: implement props
  List<Object?> get props => [articles!, error!];
}
class RemoteArticleLoading extends RemoteArticleState{
  const RemoteArticleLoading();
}
class RemoteArticleDone extends RemoteArticleState{
  const RemoteArticleDone(List<ArticleEntity> articles) : super(articles: articles);
}
class RemoteArticleError extends RemoteArticleState{
  const RemoteArticleError(DioException error) : super(error: error);
}