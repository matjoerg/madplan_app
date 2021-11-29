part of 'item_bloc.dart';

abstract class ItemState extends Equatable {
  const ItemState();

  @override
  List<Object> get props => [];
}

class ItemIdle extends ItemState {}

class ItemLoading extends ItemState {}
