part of 'database_bloc.dart';

abstract class DatabaseEvent extends Equatable {
  const DatabaseEvent();

  @override
  List<Object> get props => [];
}

class DatabaseAppStarted extends DatabaseEvent {
}

class DatabaseItemAdded extends DatabaseEvent {
  final Item ingredient;

  const DatabaseItemAdded({required this.ingredient});

  @override
  List<Object> get props => [ingredient];
}

class DatabaseCategoryAdded extends DatabaseEvent {
  final String categoryName;

  const DatabaseCategoryAdded({required this.categoryName});

  @override
  List<Object> get props => [categoryName];
}
