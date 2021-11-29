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

class DishSaved extends DishEvent {
  final Dish dish;

  const DishSaved({required this.dish});

  @override
  List<Object> get props => [dish];
}
