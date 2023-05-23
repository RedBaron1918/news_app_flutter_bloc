import 'package:blocstoreapp/model/article_model.dart';
import 'package:blocstoreapp/screens/show_details/show_details.dart';
import 'package:flutter/material.dart';
import '../constants/colors.dart';
import 'package:intl/intl.dart';

class PostCard extends StatelessWidget {
  final double heigth;
  final double width;
  final double padding;

  final Article article;

  const PostCard(
      {Key? key,
      required this.heigth,
      required this.width,
      required this.padding,
      required this.article})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute<void>(
            builder: (BuildContext context) => ShowDetailPage(
              heigth: heigth * 0.55,
              width: width,
              padding: width * 0.03,
              article: article,
            ),
          ),
        );
      },
      child: Container(
        padding: EdgeInsets.all(padding),
        margin: EdgeInsets.only(bottom: width * 0.03),
        height: heigth,
        width: width,
        decoration: BoxDecoration(boxShadow: [
          BoxShadow(color: grey, spreadRadius: 1, blurRadius: width * 0.01),
        ], color: white, borderRadius: BorderRadius.circular(width * 0.05)),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            SizedBox(
              height: heigth * 0.15,
              child: Text(
                article.title,
                maxLines: 2,
                style: TextStyle(
                    overflow: TextOverflow.ellipsis,
                    fontSize: width * 0.055,
                    fontWeight: FontWeight.w400),
              ),
            ),
            SizedBox(
              height: heigth * 0.15,
              child: Text(
                article.description,
                overflow: TextOverflow.ellipsis,
                maxLines: 2,
                style: const TextStyle(fontWeight: FontWeight.w300),
              ),
            ),
            SizedBox(
              height: heigth * 0.55,
              child: FadeInImage(
                placeholder: Image.asset(
                        alignment: Alignment.center,
                        fit: BoxFit.scaleDown,
                        height: heigth * 0.02,
                        'assets/images/loading.gif')
                    .image,
                imageErrorBuilder: (context, error, stackTrace) {
                  return Container(
                    alignment: Alignment.center,
                    height: heigth * 0.59,
                    child: Image.asset('assets/images/placeholder.png'),
                  );
                },
                image: Image.network(
                  article.urlToImage,
                  fit: BoxFit.scaleDown,
                ).image,
              ),
            ),
            SizedBox(
              child: Text(
                DateFormat("yyyy-MM-dd'T'HH:mm:ss")
                    .parse(article.publishedAt)
                    .toLocal()
                    .toString(),
                style: const TextStyle(fontWeight: FontWeight.w300),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
