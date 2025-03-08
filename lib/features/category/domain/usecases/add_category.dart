
import 'package:tadween_app/features/category/domain/entities/category.dart';
import 'package:tadween_app/features/category/domain/repositories/category_repository.dart';
import 'package:dartz/dartz.dart' as dartz; 
import 'package:tadween_app/core/error/failures.dart';

class AddCategoryUsecase {
  final CategoryRepository categoryRepository;

  const AddCategoryUsecase({required this.categoryRepository});

  Future<dartz.Either<Failure, String>> call({required Category category}) async {
    return await categoryRepository.addCategory(category: category);
  }
}
