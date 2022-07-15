part of 'database_bloc.dart';

abstract class DatabaseState extends Equatable {
  const DatabaseState();

  @override
  List<Object> get props => [];
}

class DatabaseInitial extends DatabaseState {}

class DatabaseLoading extends DatabaseState {}

class DatabaseLoaded extends DatabaseState {
  final List<Dish> dishes;
  final List<Item> items;

  const DatabaseLoaded({
    required this.dishes,
    required this.items,
  });

  @override
  List<Object> get props => [dishes, items];
}

class DatabaseError extends DatabaseState {}
