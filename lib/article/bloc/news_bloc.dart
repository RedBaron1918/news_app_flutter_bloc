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
        super(NewsInitialState()) {
    on<NewsEvent>((event, emit) async {
      if (event is GetArticlesEvent) {
        emit(NewsLoadingState());
        try {
          final String categoryName = event.categoryName;
          final String countryName = event.countryName;
          final List<Article> articles =
              await _newsRepository.getArticles(categoryName, countryName);
          emit(NewsSuccessState(articles));
        } catch (e) {
          emit(NewsErrorState(e.toString()));
        }
      }
    });
  }
}
