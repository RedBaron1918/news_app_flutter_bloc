import 'package:blocstoreapp/article/bloc/bloc.dart';
import 'package:blocstoreapp/article/repository/news_repository.dart';
import 'package:blocstoreapp/article/screens/list_articles/list_articles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ListPage extends StatelessWidget {
  const ListPage({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocProvider(
        create: (ctx) => NewsBloc(newsRepository: ctx.read<NewsRepository>()),
        child: const ListArticles(),
      ),
    );
  }
}
