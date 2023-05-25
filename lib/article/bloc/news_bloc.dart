import 'package:blocstoreapp/article/model/article_model.dart';
import 'package:blocstoreapp/article/repository/news_repository.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'news_event.dart';
part 'news_state.dart';

class NewsBloc extends Bloc<NewsEvent, NewsState> {
  final NewsRepository _newsRepository;
  NewsBloc({required newsRepository})
      : _newsRepository = newsRepository,
        super(const NewsState()) {
    on<GetArticlesEvent>((event, emit) async {
      if (state.hasReachedMax) return;
      emit(state.copyWith(status: Status.loading));
      try {
        final List<Article> articles = await _newsRepository.getArticles(
          event.categoryName,
          event.countryName,
          event.page,
          event.pageSize,
        );
        emit(articles.isEmpty
            ? state.copyWith(hasReachedMax: true)
            : state.copyWith(
                status: Status.success,
                articles: articles,
              ));
      } catch (e) {
        emit(state.copyWith(
          status: Status.error,
          error: e.toString(),
        ));
      }
    });
  }
}
