part of 'dish_bloc.dart';

abstract class DishState extends Equatable {
  const DishState();

  @override
  List<Object> get props => [];
}

class DishInitial extends DishState {}

class DishLoading extends DishState {}

class DishCreatingNew extends DishState {}

class DishLoaded extends DishState {
  final Dish chosenDish;

  const DishLoaded({required this.chosenDish});

  @override
  List<Object> get props => [chosenDish];
}
