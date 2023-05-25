part of "news_bloc.dart";

enum Status { initial, loading, success, error }

class NewsState extends Equatable {
  final Status status;
  final List<Article> articles;
  final String error;
  final bool hasReachedMax;

  const NewsState({
    this.status = Status.initial,
    this.articles = const [],
    this.error = '',
    this.hasReachedMax = false,
  });

  NewsState copyWith(
      {Status? status,
      List<Article>? articles,
      String? error,
      bool? hasReachedMax}) {
    return NewsState(
        status: status ?? this.status,
        articles: articles ?? this.articles,
        error: error ?? this.error,
        hasReachedMax: hasReachedMax ?? this.hasReachedMax);
  }

  @override
  List<Object> get props => [status, articles, error, hasReachedMax];
}
