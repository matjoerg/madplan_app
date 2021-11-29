part of 'item_bloc.dart';

abstract class ItemEvent extends Equatable {
  const ItemEvent();
}

class ItemAdded extends ItemEvent {
  final Item ingredient;

  const ItemAdded({required this.ingredient});

  @override
  List<Object> get props => [ingredient];
}

class ItemCategoryAdded extends ItemEvent {
  final String categoryName;

  const ItemCategoryAdded({required this.categoryName});

  @override
  List<Object> get props => [categoryName];
}
