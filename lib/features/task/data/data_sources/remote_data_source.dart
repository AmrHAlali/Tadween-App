import 'dart:convert';
import 'package:tadween_app/core/error/exceptions.dart';
import 'package:tadween_app/core/server/data_base.dart';
import 'package:tadween_app/features/category/domain/entities/category.dart';
import 'package:tadween_app/features/task/data/models/task_model.dart';
import 'package:dartz/dartz.dart' as dartz;
import 'package:http/http.dart' as http;

abstract class TasksRemoteDataSource {
  Future<List<TaskModel>> getAllTasks({
    bool? today,
    Category? category,
  });
  Future<dartz.Unit> deleteTask(String postId);
  Future<String> addTask(TaskModel taskModel);
}

class TasksRemoteDataSourceImplementation implements TasksRemoteDataSource {
  @override
  Future<String> addTask(TaskModel taskModel) async {
    final url = Uri.https(DATA_BASE_URL, '/tasks.json');

    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: json.encode({
        'title': taskModel.title,
        'description': taskModel.description,
        'categoryId': taskModel.categoryId,
        'startTime': taskModel.getStringTimeOfDay(taskModel.startTime),
        'endTime': taskModel.getStringTimeOfDay(taskModel.endTime),
        'date': taskModel.getStringDate(),
      }),
    );

    var responseData = json.decode(response.body);
    if (response.statusCode == 201 || response.statusCode == 200) {
      final String taskId = responseData['name'];
      return taskId;
    } else {
      throw ServerException();
    }
  }

  @override
  Future<dartz.Unit> deleteTask(String postId) async {
    final url = Uri.https(DATA_BASE_URL, '/tasks/$postId.json');

    final response = await http.delete(url);

    if (response.statusCode == 200 || response.statusCode == 204) {
      return Future.value(dartz.unit);
    } else {
      throw ServerException();
    }
  }

  @override
  Future<List<TaskModel>> getAllTasks({
    bool? today,
    Category? category,
  }) async {
    final List<TaskModel> tasks = [];

    final url = Uri.https(DATA_BASE_URL, '/tasks.json');

    final response = await http.get(url);
    if (response.body == 'null') return [];
    final Map<String, dynamic> listData = json.decode(response.body);
    if (listData.isEmpty) return [];

    for (final task in listData.entries) {
      tasks.add(
        TaskModel.remoteSource(
          title: task.value['title'],
          description: task.value['description'],
          categoryId: task.value['categoryId'],
          startTimeString: task.value['startTime'],
          endTimeString: task.value['endTime'],
          id: task.key,
          stringDate: task.value['date'],
        ),
      );
    }

    if (today != null && today) {
      tasks.removeWhere(
        (task) =>
            task.date.year != DateTime.now().year ||
            task.date.month != DateTime.now().month ||
            task.date.day != DateTime.now().day,
      );
    } else if(today != null){
      tasks.removeWhere(
        (task) =>
            task.date.year == DateTime.now().year &&
            task.date.month == DateTime.now().month &&
            task.date.day == DateTime.now().day,
      );
    }

    if(category != null) tasks.removeWhere((task) => task.categoryId != category.id);

    return tasks;
  }
}
