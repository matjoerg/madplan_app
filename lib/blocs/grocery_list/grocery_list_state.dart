part of 'grocery_list_bloc.dart';

class GroceryListState extends Equatable {
  final GroceryList groceryList;

  const GroceryListState({required this.groceryList});

  GroceryListState copyWith({
    GroceryList? groceryList,
  }) {
    return GroceryListState(
      groceryList: groceryList ?? this.groceryList,
    );
  }

  @override
  List<Object> get props => [groceryList];


}
