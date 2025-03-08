import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:tadween_app/core/strings/failures.dart';
import 'package:tadween_app/features/category/domain/entities/category.dart';
import 'package:tadween_app/features/task/data/models/task_model.dart';
import 'package:tadween_app/features/task/domain/entities/task.dart';
import 'package:tadween_app/features/task/domain/usecases/add_task.dart';
import 'package:tadween_app/features/task/domain/usecases/delete_task.dart';
import 'package:tadween_app/features/task/domain/usecases/get_all_tasks.dart';

part 'tasks_event.dart';
part 'tasks_state.dart';

class TasksBloc extends Bloc<TasksEvent, TasksState> {
  final GetAllTasksUsecase getAllTasksUsecase;
  final AddTaskUsecase addTaskUsecase;
  final DeleteTaskUsecase deleteTaskUsecase;

  TasksBloc({
    required this.getAllTasksUsecase,
    required this.addTaskUsecase,
    required this.deleteTaskUsecase,
  }) : super(TasksInitial()) {
    on<GetAllTasksEvent>(_onGetAllTasksEvent);
    on<DeleteTaskEvent>(_onDeleteTaskEvent);
    on<AddTaskEvent>(_onAddTaskEvent);
  }

  void _onGetAllTasksEvent(event, emit) async {
    emit(LoadingTasksState());

    try {
      final tasksOrFailure = await getAllTasksUsecase(
        today: event.today,
        category: event.category,
      );
      tasksOrFailure.fold(
        (failure) => emit(ErrorTasksState(message: SERVER_FAILURE_MESSAGE)),
        (tasks) {
          tasks.sort((a, b) {
            int dateComparison = a.date.compareTo(b.date);
            if (dateComparison != 0) {
              return dateComparison;
            }
            if (a.startTime.hour == b.startTime.hour) {
              return a.startTime.minute.compareTo(b.startTime.minute);
            }
            return a.startTime.hour.compareTo(b.startTime.hour);
          });
          emit(TasksLoadedState(tasks: tasks));
        },
      );
    } catch (e) {
      emit(ErrorTasksState(message: e.toString()));
    }
  }

  void _onDeleteTaskEvent(
    DeleteTaskEvent event,
    Emitter<TasksState> emit,
  ) async {
    if (state is TasksLoadedState) {
      final currentTasks = List<TaskModel>.from(
        (state as TasksLoadedState).tasks,
      );
      int index = currentTasks.indexWhere((task) => task.id == event.taskId);

      final taskToRemove = currentTasks.firstWhere(
        (task) => task.id == event.taskId,
      );

      if (taskToRemove.id == '') {
        emit(ErrorTasksState(message: "Task not found!"));
        return;
      }

      currentTasks.removeWhere((task) => task.id == event.taskId);
      emit(TasksLoadedState(tasks: currentTasks));

      try {
        final deletedOrFailure = await deleteTaskUsecase(taskId: event.taskId);

        deletedOrFailure.fold((failure) {
          currentTasks.insert(index, taskToRemove);
          emit(ErrorTasksState(message: SERVER_FAILURE_MESSAGE));
          emit(TasksLoadedState(tasks: currentTasks));
        }, (_) {});
      } catch (e) {
        emit(ErrorTasksState(message: e.toString()));
      }
    }
  }

  void _onAddTaskEvent(AddTaskEvent event, Emitter<TasksState> emit) async {
    if (state is TasksLoadedState) {
      final currentTasks = List<TaskModel>.from(
        (state as TasksLoadedState).tasks,
      );

      final newTask = event.taskModel;
      currentTasks.add(newTask);
      emit(TasksLoadedState(tasks: currentTasks));

      try {
        final addedOrFailure = await addTaskUsecase(newTask);

        addedOrFailure.fold(
          (failure) => emit(ErrorTasksState(message: SERVER_FAILURE_MESSAGE)),
          (taskId) {
            newTask.id = taskId;
          },
        );
      } catch (e) {
        emit(ErrorTasksState(message: e.toString()));
      }
    }
  }
}
