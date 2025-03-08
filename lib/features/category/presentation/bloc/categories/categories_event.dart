part of 'categories_bloc.dart';


abstract class CategoriesEvent extends Equatable{
  const CategoriesEvent();

  @override  
  List<Object?> get props => [];
}

class GetAllCategoriesEvent extends CategoriesEvent{
  @override
  List<Object?> get props => [];
}

class AddCategoryEvent extends CategoriesEvent {
  final Category category;

  const AddCategoryEvent({required this.category});

  @override
  List<Object?> get props => [category];
}