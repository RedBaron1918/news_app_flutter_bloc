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
    on<NewsEvent>((event, emit) async {
      if (event is GetArticlesEvent) {
        emit(state.copyWith(status: Status.loading));
        try {
          final String categoryName = event.categoryName;
          final String countryName = event.countryName;
          final List<Article> articles =
              await _newsRepository.getArticles(categoryName, countryName);
          emit(state.copyWith(
            status: Status.success,
            articles: articles,
          ));
        } catch (e) {
          emit(state.copyWith(
            status: Status.error,
            error: e.toString(),
          ));
        }
      }
    });
  }
}
