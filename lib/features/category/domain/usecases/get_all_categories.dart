
import 'package:tadween_app/features/category/domain/entities/category.dart';
import 'package:tadween_app/features/category/domain/repositories/category_repository.dart';
import 'package:dartz/dartz.dart' as dartz; 
import 'package:tadween_app/core/error/failures.dart';

class GetAllCategoriesUsecase {
  final CategoryRepository categoryRepository;

  const GetAllCategoriesUsecase({required this.categoryRepository});

  Future<dartz.Either<Failure, List<Category>>> call() async {
    return await categoryRepository.getAllCategories();
  }
}