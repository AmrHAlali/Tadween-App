part of 'tasks_bloc.dart';

abstract class TasksEvent extends Equatable {
  const TasksEvent();

  @override
  List<Object> get props => [];
}

class GetAllTasksEvent extends TasksEvent {
  final bool? today;
  final Category? category;

  const GetAllTasksEvent({this.today, this.category});
}

class AddTaskEvent extends TasksEvent {
  final TaskModel taskModel;

  const AddTaskEvent({required this.taskModel});

  @override
  List<Object> get props => [taskModel];
}

class DeleteTaskEvent extends TasksEvent {
  final String  taskId;

  const DeleteTaskEvent({required this.taskId});

  @override
  List<Object> get props => [taskId];
}