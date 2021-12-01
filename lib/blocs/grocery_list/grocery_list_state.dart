part of 'grocery_list_bloc.dart';

abstract class GroceryListState extends Equatable {
  const GroceryListState();

  @override
  List<Object> get props => [];
}

class GroceryListLoaded extends GroceryListState {
  final GroceryList groceryList;

  const GroceryListLoaded({required this.groceryList});

  @override
  List<Object> get props => [groceryList];
}
