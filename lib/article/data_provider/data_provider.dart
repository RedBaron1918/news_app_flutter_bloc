import 'dart:convert';
import 'package:http/http.dart' as http;

import '../constants/api_constants.dart';
import '../model/article_model.dart';

class DataProvider {
  final client = http.Client();

  Future<List<Article>> getArticles(
      String? categoryName, String country, int page, int pageSize) async {
    final queryParameters = {
      'country': country,
      "category": categoryName,
      "apiKey": ApiConstants.apiKey,
      "page": page.toString(),
      "pageSize": pageSize.toString()
    };

    try {
      final uri = Uri.https(
        ApiConstants.endPointUrl,
        ApiConstants.unencodedPath,
        queryParameters,
      );
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
