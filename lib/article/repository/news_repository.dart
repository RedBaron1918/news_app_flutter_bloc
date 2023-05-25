import '../data_provider/data_provider.dart';
import '../model/article_model.dart';

class NewsRepository {
  final DataProvider dataProvider;
  const NewsRepository({required this.dataProvider});

  Future<List<Article>> getArticles(
      String categoryName, String country, int page, int pageSize) async {
    return await dataProvider.getArticles(
        categoryName, country, page, pageSize);
  }
}
