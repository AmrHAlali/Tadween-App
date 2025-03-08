import 'package:dartz/dartz.dart';
import 'package:tadween_app/core/error/exceptions.dart';
import 'package:tadween_app/core/error/failures.dart';
import 'package:tadween_app/core/network/network_info.dart';
import 'package:tadween_app/features/category/data/data_sources/remote_data_source.dart';
import 'package:tadween_app/features/category/data/models/category_model.dart';
import 'package:tadween_app/features/category/domain/entities/category.dart';
import 'package:tadween_app/features/category/domain/repositories/category_repository.dart';
import 'package:dartz/dartz.dart' as dartz;

class CategoryRepositoryImplementation extends CategoryRepository {
  final NetworkInfo networkInfo;
  final CategoriesRemoteDataSource remoteDataSource;

  CategoryRepositoryImplementation({
    required this.networkInfo,
    required this.remoteDataSource,
  });

  @override
  Future<Either<Failure, String>> addCategory({
    required Category category,
  }) async {
    final CategoryModel categoryModel = CategoryModel(
      icon: category.icon,
      id: category.id,
      name: category.name,
    );

    if (await networkInfo.isConnected) {
      try {
        await remoteDataSource.addCategory(categoryModel);
        return dartz.Right(categoryModel.id);
      } on ServerException {
        return dartz.Left(ServerFailure());
      }
    } else {
      return dartz.Left(ServerFailure());
    }
  }
  
  @override
  Future<Either<Failure, List<Category>>> getAllCategories() async {
    if (await networkInfo.isConnected) {
      try {
        final List<CategoryModel> tasks = await remoteDataSource.getAllCategories();
        return dartz.Right(tasks);
      } catch (e) {
        return dartz.Left(ServerFailure());
      }
    } else {
      return dartz.Left(ServerFailure());
    }
  }
}
