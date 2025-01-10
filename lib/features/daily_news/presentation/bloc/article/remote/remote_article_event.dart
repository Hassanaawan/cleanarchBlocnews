abstract class RemoteArticleEvent {
  const RemoteArticleEvent();
}
class GetArticles extends RemoteArticleEvent {
  const GetArticles();
}

class RetryGetArticles extends RemoteArticleEvent {
  const RetryGetArticles();
}
