

import 'package:check/features/core/resources/data_state.dart';
import 'package:check/features/core/use_cases/usecase.dart';
import 'package:check/features/daily_news/domain/entities/article.dart';
import 'package:check/features/daily_news/domain/repositaries/article_repository.dart';

class GetArticleUseCase implements UseCase<DataState<List<ArticleEntity>>, void> {
  final ArticleRepository _articleRepository;

  GetArticleUseCase(this._articleRepository);
  @override
  Future<DataState<List<ArticleEntity>>> call({void params}) {
   return _articleRepository.getNewsArticles();
  }
  
}