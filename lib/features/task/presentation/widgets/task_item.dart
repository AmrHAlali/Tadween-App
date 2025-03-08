import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tadween_app/features/category/domain/entities/category.dart';
import 'package:tadween_app/features/task/data/models/task_model.dart';
import 'package:tadween_app/features/task/presentation/bloc/tasks/tasks_bloc.dart';
import 'package:tadween_app/features/task/presentation/screens/task_screen.dart';

class TaskItem extends StatelessWidget {
  final TaskModel taskModel;
  final Category category;

  const TaskItem({super.key, required this.category, required this.taskModel});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      child: Dismissible(
        key: Key(taskModel.id),
        direction: DismissDirection.horizontal,
        background: _dismissBackground(),

        child: _buildTaskWidget(
          category: category,
          taskModel: taskModel,
          context: context,
        ),
        onDismissed: (direction) {
          _onTaskDeleted(context, taskModel);
        },
      ),
    );
  }
}

Widget _dismissBackground() {
  return Container(
    color: const Color.fromARGB(255, 231, 80, 69),
    alignment: Alignment.centerRight,
    padding: EdgeInsets.symmetric(horizontal: 20),
    child: Icon(Icons.delete, color: Colors.white),
  );
}

Widget _buildTaskWidget({
  required TaskModel taskModel,
  required BuildContext context,
  required Category category,
}) {
  String taskStartTime = taskModel.getStringTimeOfDay(taskModel.startTime);
  String taskEndTime = taskModel.getStringTimeOfDay(taskModel.endTime);
  double taskNumberOfHours = taskModel.getNumberOfHours();

  return InkWell(
    child: ListTile(
      title: Text(taskModel.title, maxLines: 2),
      subtitle: Padding(
        padding: const EdgeInsets.symmetric(vertical: 5),
        child: Row(
          children: [
            Icon(
              Icons.access_time,
              color: Theme.of(context).listTileTheme.iconColor,
              size: 20,
            ),
            const SizedBox(width: 5),
            Text(
              '$taskStartTime - $taskEndTime   ($taskNumberOfHours hours)',
              style: Theme.of(
                context,
              ).textTheme.bodyMedium!.copyWith(fontSize: 15),
            ),
          ],
        ),
      ),
      trailing: Icon(category.icon, size: 40),
      onTap: () {
        _buildTaskScreenNavigator(context, taskModel, category);
      },
    ),
  );
}

void _buildTaskScreenNavigator(BuildContext context, TaskModel taskModel, Category category) {
  Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) {
              return TaskScreen(
                taskModel: taskModel,
                category: category,
                onTaskDeleted: () {
                  _onTaskDeleted(context, taskModel);
                },
              );
            },
          ),
        );
}

void _onTaskDeleted(BuildContext context, TaskModel taskModel) {
  final tasksBloc = context.read<TasksBloc>();

  tasksBloc.add(DeleteTaskEvent(taskId: taskModel.id));

  ScaffoldMessenger.of(context).hideCurrentSnackBar();
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: const Text('Task deleted successfully!'),
      action: SnackBarAction(
        label: 'Undo',
        onPressed: () {
          tasksBloc.add(AddTaskEvent(taskModel: taskModel));
        },
      ),
      duration: const Duration(seconds: 3),
    ),
  );
}
