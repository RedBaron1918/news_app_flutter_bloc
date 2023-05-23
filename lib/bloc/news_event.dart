import 'package:equatable/equatable.dart';

class NewsEvent extends Equatable {
  @override
  List<Object?> get props => throw UnimplementedError();
}

class GetArticlesEvent extends NewsEvent {
  final String categoryName;
  final String countryName;
  GetArticlesEvent({this.categoryName = 'business', this.countryName = 'us'});
}
