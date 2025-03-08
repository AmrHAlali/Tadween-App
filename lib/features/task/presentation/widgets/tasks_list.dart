import 'package:flutter/material.dart';
import 'package:tadween_app/features/category/domain/entities/category.dart';
import 'package:tadween_app/features/task/data/models/task_model.dart';
import 'package:tadween_app/features/task/domain/entities/task.dart';
import 'package:tadween_app/features/task/presentation/widgets/task_item.dart';

class TasksList extends StatefulWidget {
  @override
  State<TasksList> createState() => _TasksListState();

  final List<Task> tasks;
  final List<Category> categories;

  const TasksList({super.key, required this.tasks, required this.categories});
}

class _TasksListState extends State<TasksList> {
  @override
  Widget build(BuildContext context) {
    return _buildTasksList(categories: widget.categories);
  }

  Widget _buildTasksList({required List<Category> categories}) {
    return ListView.separated(
      itemCount: widget.tasks.length,
      separatorBuilder: (context, index) {
        return Divider();
      },
      itemBuilder: (context, index) {
        return TaskItem(
          taskModel: TaskModel.castingFromTask(task: widget.tasks[index]),
          category: categories.firstWhere(
            (category) => category.id == widget.tasks[index].categoryId,
          ),
        );
      },
    );
  }
}
