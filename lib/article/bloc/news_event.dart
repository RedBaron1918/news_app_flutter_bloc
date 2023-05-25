part of "news_bloc.dart";

class NewsEvent extends Equatable {
  @override
  List<Object?> get props => throw UnimplementedError();
}

class GetArticlesEvent extends NewsEvent {
  final String categoryName;
  final String countryName;
  final int page;
  final int pageSize;
  GetArticlesEvent(
      {this.categoryName = 'business',
      this.countryName = 'us',
      this.page = 1,
      this.pageSize = 5});
}
