part of 'dish_bloc.dart';

abstract class DishEvent extends Equatable {
  const DishEvent();

  @override
  List<Object> get props => [];
}

class DishChosen extends DishEvent {
  final String dishName;

  const DishChosen({required this.dishName});

  @override
  List<Object> get props => [dishName];
}

class DishNewIngredientAdded extends DishEvent {
  final Item ingredient;

  const DishNewIngredientAdded({required this.ingredient});

  @override
  List<Object> get props => [ingredient];
}

class DishNewCategoryAdded extends DishEvent {
  final String categoryName;

  const DishNewCategoryAdded({required this.categoryName});

  @override
  List<Object> get props => [categoryName];
}

class DishSaved extends DishEvent {
  final Dish dish;

  const DishSaved({required this.dish});

  @override
  List<Object> get props => [dish];
}
