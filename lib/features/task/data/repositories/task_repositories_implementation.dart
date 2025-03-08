import 'package:dartz/dartz.dart' as dartz;
import 'package:tadween_app/core/error/exceptions.dart';
import 'package:tadween_app/core/error/failures.dart';
import 'package:tadween_app/core/network/network_info.dart';
import 'package:tadween_app/features/category/domain/entities/category.dart';
import 'package:tadween_app/features/task/data/data_sources/remote_data_source.dart';
import 'package:tadween_app/features/task/data/models/task_model.dart';
import 'package:tadween_app/features/task/domain/entities/task.dart';
import 'package:tadween_app/features/task/domain/repositories/task_repository.dart';

class TaskRepositoriesImplementation extends TaskRepository {
  final NetworkInfo networkInfo;
  final TasksRemoteDataSource remoteDataSource;

  TaskRepositoriesImplementation({
    required this.networkInfo,
    required this.remoteDataSource,
  });

  @override
  Future<dartz.Either<Failure, String>> addTask({
    required Task task,
  }) async {
    final TaskModel taskModel = TaskModel.castingFromTask(task: task);

    if (await networkInfo.isConnected) {
      try {
        String taskId = await remoteDataSource.addTask(taskModel);
        return dartz.Right(taskId);
      } on ServerException {
        return dartz.Left(ServerFailure());
      }
    } else {
      return dartz.Left(ServerFailure());
    }
  }

  @override
  Future<dartz.Either<Failure, dartz.Unit>> deleteTask({
    required String taskId,
  }) async {
    if (await networkInfo.isConnected) {
      try {
        await remoteDataSource.deleteTask(taskId);
        return dartz.Right(dartz.unit);
      } catch (e) {
        return dartz.Left(ServerFailure());
      }
    } else {
      return dartz.Left(ServerFailure());
    }
  }

  @override
  Future<dartz.Either<Failure, List<Task>>> getAllTasks({bool? today, Category? category}) async {
    if (await networkInfo.isConnected) {
      try {
        final List<TaskModel> tasks = await remoteDataSource.getAllTasks(today: today, category: category);
        return dartz.Right(tasks);
      } catch(e) {
        print('Server Failure');
        return dartz.Left(ServerFailure());
      }
    } else {
      print('Offline Failure');
      return dartz.Left(OfflineFailure());
    }
  }
}
