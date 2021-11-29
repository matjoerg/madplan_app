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
