
import 'package:dartz/dartz.dart' as dartz; 
import 'package:tadween_app/core/error/failures.dart';
import 'package:tadween_app/features/category/domain/entities/category.dart';
import 'package:tadween_app/features/task/domain/entities/task.dart';

abstract class TaskRepository {
  Future<dartz.Either<Failure, List<Task>>> getAllTasks({required bool? today, Category? category});
  Future<dartz.Either<Failure, dartz.Unit>> deleteTask({required String taskId});
  Future<dartz.Either<Failure, String>> addTask({required Task task});
}
