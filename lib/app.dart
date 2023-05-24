import 'package:blocstoreapp/article/screens/list_page.dart';
import 'package:flutter/material.dart';

class App extends MaterialApp {
  App({super.key})
      : super(
            title: "News App",
            debugShowCheckedModeBanner: false,
            theme: ThemeData(primarySwatch: Colors.green),
            home: const ListPage());
}
