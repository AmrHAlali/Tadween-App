part of 'categories_bloc.dart';

@immutable
abstract class CategoriesState extends Equatable {
  const CategoriesState();

  @override
  List<Object?> get props => [];
}

class CategoriesInitial extends CategoriesState {}

class LoadingCategoriesState extends CategoriesState {}

class LoadedCategoriesState extends CategoriesState {
  final List<Category> categories;

  const LoadedCategoriesState({required this.categories});

  @override
  List<Object?> get props => [categories];
}

class ErrorCategoriesState extends CategoriesState {
  final String message;

  const ErrorCategoriesState({required this.message});

  @override
  List<Object?> get props => [message];
}

class AddedCategoryState extends CategoriesState {
  final String id;

  const AddedCategoryState({required this.id});

  @override
  List<Object?> get props => [id];
}

class MessageCategoriesState extends CategoriesState {
  final String message;

  const MessageCategoriesState({required this.message}); 

  @override
  List<Object> get props => [message];
}
