import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';
import 'package:tadween_app/core/strings/failures.dart';
import 'package:tadween_app/features/category/domain/entities/category.dart';
import 'package:tadween_app/features/category/domain/usecases/add_category.dart';
import 'package:tadween_app/features/category/domain/usecases/get_all_categories.dart';

part 'categories_event.dart';
part 'categories_state.dart';

class CategoriesBloc extends Bloc<CategoriesEvent, CategoriesState> {
  final GetAllCategoriesUsecase getAllCategoryUsecase;
  final AddCategoryUsecase addCategoryUsecase;

  CategoriesBloc({
    required this.getAllCategoryUsecase,
    required this.addCategoryUsecase,
  }) : super(CategoriesInitial()) {
    on<GetAllCategoriesEvent>(_onGetAllCategoriesEvent);
    on<AddCategoryEvent>(_onAddCategoryEvent);
  }

  void _onGetAllCategoriesEvent(event, emit) async {
    emit(LoadingCategoriesState());

    try {
      final categoriesOrFailure = await getAllCategoryUsecase();
      categoriesOrFailure.fold(
        (failure) => emit(ErrorCategoriesState(message: SERVER_FAILURE_MESSAGE)),
        (categories) => emit(LoadedCategoriesState(categories: categories)),
      );
    } catch (e) {
      emit(ErrorCategoriesState(message: e.toString()));
    }
  }

  void _onAddCategoryEvent(AddCategoryEvent event, Emitter<CategoriesState> emit) async {
    emit(LoadingCategoriesState());

    try {
      final addedOrFailure = await addCategoryUsecase(category: event.category);
      addedOrFailure.fold(
        (failure) => emit(ErrorCategoriesState(message: SERVER_FAILURE_MESSAGE)),
        (categoryId) {
          event.category.id = categoryId;
          emit(MessageCategoriesState(message: 'Category added successfully!'));
          add(GetAllCategoriesEvent());
        },
      );
    } catch (e) {
      emit(ErrorCategoriesState(message: e.toString()));
    }
  }
}

