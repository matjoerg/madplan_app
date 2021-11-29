part of 'grocery_list_bloc.dart';

abstract class GroceryListState extends Equatable {
  const GroceryListState();

  @override
  List<Object> get props => [];
}

class GroceryListInitial extends GroceryListState {}
