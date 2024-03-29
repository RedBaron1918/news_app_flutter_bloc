import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../bloc/bloc.dart';

class CategoryButton extends StatefulWidget {
  final Function onClicked;
  final String category;
  final String country;
  final int buttonID;
  final bool isSelected;

  const CategoryButton({
    required this.onClicked,
    required this.isSelected,
    required this.category,
    required this.buttonID,
    required this.country,
    Key? key,
  }) : super(key: key);

  @override
  State<CategoryButton> createState() => _CategoryButtonState();
}

class _CategoryButtonState extends State<CategoryButton> {
  @override
  Widget build(BuildContext context) {
    final double width = MediaQuery.of(context).size.width;
    return Container(
      margin: EdgeInsets.symmetric(horizontal: width * 0.007),
      child: ElevatedButton(
        onPressed: () {
          GetArticlesEvent eventWithCategory = GetArticlesEvent(
              categoryName: widget.category, countryName: widget.country);
          if (BlocProvider.of<NewsBloc>(context).state.status !=
              Status.loading) {
            BlocProvider.of<NewsBloc>(context).add(eventWithCategory);
          }
          widget.onClicked(widget.category, widget.buttonID);
        },
        style: ElevatedButton.styleFrom(
          backgroundColor:
              widget.isSelected ? Colors.green.shade700 : Colors.green.shade300,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(width * 0.1),
          ),
        ),
        child: Text(widget.category),
      ),
    );
  }
}
