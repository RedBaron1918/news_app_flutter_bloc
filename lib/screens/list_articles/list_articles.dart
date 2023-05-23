import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../bloc/bloc.dart';
import '../constants/colors.dart';
import 'category_button.dart';
import '../widgets/post_card.dart';
import '../../model/article_model.dart';
import '../../repository/news_repository.dart';

class ListArticles extends StatefulWidget {
  const ListArticles({Key? key}) : super(key: key);

  @override
  State<ListArticles> createState() => _ListArticlesState();
}

class _ListArticlesState extends State<ListArticles> {
  String currentHeading = "Top Headlines";
  int selectedButtonID = 0;
  String selectedCategory = "topheadlines";

  final NewsRepository repository = NewsRepository();
  String selectedCountryEmoji = "us";
  String selectedCountryCode = "gb";

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    List<String> categories = [
      "topheadlines",
      "business",
      "entertainment",
      "general",
      "health",
      "science",
      "sports",
      "technology"
    ];
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
        title: Text(currentHeading),
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
                  "England",
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
              selectedCountryEmoji = (item == 0) ? "us" : "uk";
              selectedCountryCode = (item == 0) ? "gb" : "us";
              setState(() {});
              BlocProvider.of<NewsBloc>(context).add(
                GetArticlesEvent(
                    categoryName: selectedCategory,
                    countryName: selectedCountryCode),
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
                if (state is NewsInitialState) {
                  context
                      .read<NewsBloc>()
                      .add(GetArticlesEvent(categoryName: 'topheadlines'));
                } else if (state is NewsLoadingState) {
                  return Center(
                    child: CircularProgressIndicator(
                      color: green,
                    ),
                  );
                } else if (state is NewsSuccessState) {
                  return RefreshIndicator(
                      onRefresh: () async {
                        BlocProvider.of<NewsBloc>(context).add(
                          GetArticlesEvent(
                              categoryName: selectedCategory,
                              countryName: selectedCountryCode),
                        );
                      },
                      child: buildArticles(context, state.articles));
                } else if (state is NewsErrorState) {
                  return RefreshIndicator(
                    onRefresh: () async {
                      BlocProvider.of<NewsBloc>(context).add(
                        GetArticlesEvent(
                            categoryName: selectedCategory,
                            countryName: selectedCountryCode),
                      );
                    },
                    child: const Center(
                        child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.error_outline),
                        Text("Connection Error!"),
                      ],
                    )),
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

  Widget buildArticles(BuildContext context, List<Article>? articles) {
    double heigth = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Expanded(
          flex: 1,
          child: ListView.builder(
              padding: EdgeInsets.only(
                  left: width * 0.025, right: width * 0.025, top: width * 0.01),
              itemCount: articles!.length,
              itemBuilder: ((context, index) {
                return PostCard(
                  heigth: heigth * 0.451,
                  width: width,
                  padding: width * 0.03,
                  article: articles[index],
                );
              })),
        ),
      ],
    );
  }

  void putOffOtherButtons(List<bool> buttonStatus) {
    for (int i = 0; i < buttonStatus.length; i++) {
      if (i != selectedButtonID) {
        buttonStatus[i] = false;
      }
    }
    buttonStatus[selectedButtonID] = true;
    if (selectedCategory[1] == 'o') {
      currentHeading = 'Top Headlines';
    } else {
      selectedCategory = currentHeading =
          selectedCategory[0].toUpperCase() + selectedCategory.substring(1);
    }
  }
}
