part of 'item_bloc.dart';

abstract class ItemState extends Equatable {
  const ItemState();

  @override
  List<Object> get props => [];
}

class ItemInitial extends ItemState {
  @override
  List<Object> get props => [];
}

class ItemLoading extends ItemState {}

class ItemError extends ItemState {}

class ItemSavedSuccess extends ItemState {}

class ItemCategorySavedSuccess extends ItemState {}