import 'package:blocstoreapp/app.dart';
import 'package:blocstoreapp/article/data_provider/data_provider.dart';
import 'package:blocstoreapp/article/repository/news_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

void main() {
  final DataProvider dataProvider = DataProvider();
  final NewsRepository newsRepository =
      NewsRepository(dataProvider: dataProvider);
  runApp(RepositoryProvider(
    create: (_) => newsRepository,
    child: App(),
  ));
}
