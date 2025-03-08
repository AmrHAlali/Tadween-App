
import 'package:tadween_app/core/error/failures.dart';
import 'package:tadween_app/features/category/domain/entities/category.dart';
import 'package:tadween_app/features/task/domain/entities/task.dart';
import 'package:tadween_app/features/task/domain/repositories/task_repository.dart';
import 'package:dartz/dartz.dart' as dartz;

class GetAllTasksUsecase {
  final TaskRepository taskRepository;

  const GetAllTasksUsecase({required this.taskRepository});

  Future<dartz.Either<Failure, List<Task>>> call({bool? today, Category? category}) async {
    return await taskRepository.getAllTasks(today: today, category: category);
  }
}