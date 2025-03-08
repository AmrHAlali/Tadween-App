part of 'tasks_bloc.dart';

abstract class TasksState extends Equatable {
  const TasksState();
  
  @override
  List<Object> get props => [];
}

class TasksInitial extends TasksState {}

class TasksLoadedState extends TasksState {
  final List<Task> tasks;

  const TasksLoadedState({required this.tasks});

  @override
  List<Object> get props => [tasks];
}

class ErrorTasksState extends TasksState {
  final String message;

  const ErrorTasksState({required this.message}); 

  @override
  List<Object> get props => [message];
}

class LoadingTasksState extends TasksState {}

class MessageTasksState extends TasksState {
  final String message;

  const MessageTasksState({required this.message}); 

  @override
  List<Object> get props => [message];
}