import 'package:dartz/dartz.dart' as dartz; 
import 'package:tadween_app/core/error/failures.dart';
import 'package:tadween_app/features/category/domain/entities/category.dart';

abstract class CategoryRepository {
  Future<dartz.Either<Failure, List<Category>>> getAllCategories();
  Future<dartz.Either<Failure, String>> addCategory({required Category category});
}