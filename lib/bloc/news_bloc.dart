import 'package:blocstoreapp/model/article_model.dart';
import 'package:blocstoreapp/repository/news_repository.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../bloc/news_event.dart';
import '../bloc/news_state.dart';

class NewsBloc extends Bloc<NewsEvent, NewsState> {
  NewsBloc() : super(NewsInitialState()) {
    on<NewsEvent>((event, emit) async {
      if (event is GetArticlesEvent) {
        emit(NewsLoadingState());
        try {
          String categoryName = event.categoryName;
          String countryName = event.countryName;
          final NewsRepository newsRepository = NewsRepository();
          List<Article> articles =
              await newsRepository.getArticles(categoryName, countryName);
          emit(NewsSuccessState(articles));
        } catch (e) {
          emit(NewsErrorState());
          throw ("Couldn't fetch data! BLOC Error!");
        }
      }
    });
  }
}
