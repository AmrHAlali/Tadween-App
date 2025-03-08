
import 'package:tadween_app/core/error/failures.dart';
import 'package:tadween_app/features/task/domain/entities/task.dart';
import 'package:tadween_app/features/task/domain/repositories/task_repository.dart';
import 'package:dartz/dartz.dart' as dartz;

class AddTaskUsecase {
  final TaskRepository taskRepository;

  const AddTaskUsecase({required this.taskRepository});

  Future<dartz.Either<Failure, String>> call(Task task) async {
    return await taskRepository.addTask(task: task);
  } 
}
