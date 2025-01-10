import 'package:check/features/core/resources/data_state.dart';
import 'package:check/features/daily_news/presentation/bloc/article/remote/remote_article_event.dart';
import 'package:check/features/daily_news/presentation/bloc/article/remote/remote_article_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../domain/usecases/get_article.dart';

class RemoteArticleBloc extends Bloc<RemoteArticleEvent, RemoteArticleState> {
  final GetArticleUseCase _getArticleUseCase;

  RemoteArticleBloc(this._getArticleUseCase) : super(RemoteArticleLoading()) {
    on<GetArticles>(onGetArticles);
    on<RetryGetArticles>(onRetryGetArticles);
  }

  Future<void> onGetArticles(GetArticles event, Emitter<RemoteArticleState> emit) async {
    final dataState = await _getArticleUseCase();
    if (dataState is DataSuccess && dataState.data != null && dataState.data!.isNotEmpty) {
      emit(RemoteArticleDone(dataState.data!));
    } else if (dataState is DataError) {
      emit(RemoteArticleError(dataState.error!));
    }
  }

  Future<void> onRetryGetArticles(RetryGetArticles event, Emitter<RemoteArticleState> emit) async {
    emit(RemoteArticleLoading());
    final dataState = await _getArticleUseCase();
    if (dataState is DataSuccess && dataState.data != null && dataState.data!.isNotEmpty) {
      emit(RemoteArticleDone(dataState.data!));
    } else if (dataState is DataError) {
      emit(RemoteArticleError(dataState.error!));
    }
  }
}
