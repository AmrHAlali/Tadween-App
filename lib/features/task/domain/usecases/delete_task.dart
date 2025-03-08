
import 'package:tadween_app/features/task/domain/repositories/task_repository.dart';
import 'package:dartz/dartz.dart' as dartz;
import 'package:tadween_app/core/error/failures.dart';

class DeleteTaskUsecase {
  final TaskRepository taskRepository;

  const DeleteTaskUsecase({required this.taskRepository});

  Future<dartz.Either<Failure, dartz.Unit>>  call({required String taskId}) async {
    return await taskRepository.deleteTask(taskId: taskId);
  }
}