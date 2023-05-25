part of "news_bloc.dart";

enum Status { initial, loading, success, error }

class NewsState extends Equatable {
  final Status status;
  final List<Article> articles;
  final String error;

  const NewsState({
    this.status = Status.initial,
    this.articles = const [],
    this.error = '',
  });

  NewsState copyWith({
    Status? status,
    List<Article>? articles,
    String? error,
  }) {
    return NewsState(
      status: status ?? this.status,
      articles: articles ?? this.articles,
      error: error ?? this.error,
    );
  }

  @override
  List<Object> get props => [status, articles, error];
}
