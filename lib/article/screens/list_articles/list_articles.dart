import 'package:blocstoreapp/article/constants/categories.dart';
import 'package:blocstoreapp/article/model/article_model.dart';
import 'package:blocstoreapp/article/screens/widgets/bottom_loader.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../bloc/bloc.dart';
import '../constants/colors.dart';
import 'category_button.dart';
import '../widgets/post_card.dart';

class ListArticles extends StatefulWidget {
  const ListArticles({Key? key}) : super(key: key);

  @override
  State<ListArticles> createState() => _ListArticlesState();
}

class _ListArticlesState extends State<ListArticles> {
  int selectedButtonID = 0;
  String selectedCategory = "business";
  String selectedCountryEmoji = "us";
  String selectedCountryCode = "us";
  final _scrollController = ScrollController();
  int _page = 1;
  final int _pageSize = 10;

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
    context.read<NewsBloc>().add(GetArticlesEvent(
        categoryName: selectedCategory,
        countryName: selectedCountryCode,
        page: _page,
        pageSize: _pageSize));
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;

    List<Widget> buttonList = List.generate(
      categories.length,
      (index) => CategoryButton(
        category: categories[index],
        country: selectedCountryCode,
        buttonID: index,
        isSelected: index == selectedButtonID,
        onClicked: (category, id) {
          selectedCategory = category;
          selectedButtonID = id;
          setState(() {});
        },
      ),
    );

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text("Top Headlines"),
        actions: [
          PopupMenuButton(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.all(
                Radius.circular(width * 0.05),
              ),
            ),
            icon: Text(selectedCountryEmoji),
            color: Colors.green.shade400,
            itemBuilder: (context) => [
              const PopupMenuItem<int>(
                value: 0,
                child: Text(
                  "Great Britain",
                  style: TextStyle(color: Colors.white),
                ),
              ),
              const PopupMenuItem<int>(
                value: 1,
                child: Text(
                  "United States",
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ],
            onSelected: (item) {
              selectedCountryEmoji = (item == 0) ? "us" : "gb";
              selectedCountryCode = (item == 0) ? "gb" : "us";
              setState(() {});
              BlocProvider.of<NewsBloc>(context).add(
                GetArticlesEvent(
                  categoryName: selectedCategory,
                  countryName: selectedCountryCode,
                ),
              );
            },
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            flex: 1,
            child: ListView(
              padding: EdgeInsets.only(
                bottom: width * 0.02,
                top: width * 0.02,
                left: width * 0.015,
                right: width * 0.015,
              ),
              scrollDirection: Axis.horizontal,
              children: [...buttonList],
            ),
          ),
          Expanded(
            flex: 14,
            child: BlocBuilder<NewsBloc, NewsState>(
              builder: (context, state) {
                if (state.status == Status.initial) {
                  context
                      .read<NewsBloc>()
                      .add(GetArticlesEvent(countryName: 'us'));
                } else if (state.status == Status.loading) {
                  return Center(
                    child: CircularProgressIndicator(
                      color: green,
                    ),
                  );
                } else if (state.status == Status.success) {
                  return RefreshIndicator(
                      onRefresh: () async {
                        BlocProvider.of<NewsBloc>(context).add(
                          GetArticlesEvent(
                              categoryName: selectedCategory,
                              countryName: selectedCountryCode),
                        );
                      },
                      child: _ArticleBuilder(
                        width: width,
                        scrollController: _scrollController,
                        article: state.articles,
                        hasReachedMax: state.hasReachedMax,
                      ));
                } else if (state.status == Status.error) {
                  return RefreshIndicator(
                    onRefresh: () async {
                      BlocProvider.of<NewsBloc>(context).add(
                        GetArticlesEvent(
                            categoryName: selectedCategory,
                            countryName: selectedCountryCode),
                      );
                    },
                    child: Center(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(Icons.error_outline),
                          Text(state.error),
                        ],
                      ),
                    ),
                  );
                }
                return const Center(child: Text('Something Else Happened!'));
              },
            ),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _scrollController
      ..removeListener(_onScroll)
      ..dispose();
    super.dispose();
  }

  void _onScroll() {
    if (_isBottom) {
      _page++;
      context.read<NewsBloc>().add(GetArticlesEvent(
          categoryName: selectedCategory,
          countryName: selectedCountryCode,
          page: _page,
          pageSize: _pageSize));
    }
  }

  bool get _isBottom {
    if (!_scrollController.hasClients) return false;
    final maxScroll = _scrollController.position.maxScrollExtent;
    final currentScroll = _scrollController.offset;
    return currentScroll >= (maxScroll * 1);
  }
}

class _ArticleBuilder extends StatelessWidget {
  const _ArticleBuilder({
    required this.article,
    required this.hasReachedMax,
    required this.width,
    required ScrollController scrollController,
  }) : _scrollController = scrollController;

  final double width;
  final ScrollController _scrollController;
  final bool hasReachedMax;
  final List<Article> article;
  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Expanded(
          flex: 1,
          child: ListView.builder(
              padding: EdgeInsets.only(
                  left: width * 0.025, right: width * 0.025, top: width * 0.01),
              itemCount: hasReachedMax ? article.length : article.length + 1,
              controller: _scrollController,
              itemBuilder: ((context, index) {
                return index >= article.length
                    ? const BottomLoader()
                    : PostCard(
                        heigth: MediaQuery.of(context).size.height * 0.56,
                        width: width,
                        padding: width * 0.03,
                        article: article[index],
                      );
              })),
        ),
      ],
    );
  }
}
