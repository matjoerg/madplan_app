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
  final List<Category> categories;

  const DatabaseLoaded({
    required this.dishes,
    required this.items,
    required this.categories,
  });

  @override
  List<Object> get props => [dishes, items, categories];
}

class DatabaseError extends DatabaseState {}
