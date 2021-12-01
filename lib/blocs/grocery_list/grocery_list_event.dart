part of 'grocery_list_bloc.dart';

abstract class GroceryListEvent extends Equatable {
  const GroceryListEvent();
}

class GroceryListCreated extends GroceryListEvent {
  final MealPlan mealPlan;

  const GroceryListCreated({required this.mealPlan});

  @override
  List<Object> get props => [mealPlan];
}

class GroceryListItemAdded extends GroceryListEvent {
  final Item item;

  const GroceryListItemAdded({required this.item});

  @override
  List<Object> get props => [item];
}

class GroceryListItemRemoved extends GroceryListEvent {
  final Item item;

  const GroceryListItemRemoved({required this.item});

  @override
  List<Object> get props => [item];
}
