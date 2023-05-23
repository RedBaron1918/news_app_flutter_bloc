import 'dart:convert';
import 'package:http/http.dart' as http;

import '../constants/api_constants.dart';
import '../model/article_model.dart';

class DataProvider {
  final endPointUrl = "newsapi.org";
  final unencodedPath = "/v2/top-headlines";
  final client = http.Client();

  Future<List<Article>> getArticles(String categoryName, String country) async {
    final queryParameters = {'country': country};

    if (categoryName[1] != 'o') {
      queryParameters['category'] = categoryName;
    }

    queryParameters['apiKey'] = ApiConstants.apiKey;

    try {
      final uri = Uri.https(endPointUrl, unencodedPath, queryParameters);
      final response = await client.get(uri);

      final json = jsonDecode(response.body) as Map<String, dynamic>;
      final body = json['articles'] as List<dynamic>;

      final articles = body.map((item) => Article.fromJson(item)).toList();

      return articles;
    } catch (e) {
      throw Exception("Can't get the Articles!");
    }
  }
}
