import 'package:flutter/material.dart';
import 'package:tadween_app/core/screens/chart/chart_bar.dart';
import 'package:tadween_app/features/category/domain/entities/category.dart';
import 'package:tadween_app/features/task/data/models/task_model.dart';
import 'package:tadween_app/features/task/domain/entities/task.dart';

class ChartController extends StatefulWidget {
  final List<Task> tasks;
  final List<Category> categories;

  const ChartController({
    super.key,
    required this.tasks,
    required this.categories,
  });

  @override
  State<ChartController> createState() => _ChartControllerState();
}

class _ChartControllerState extends State<ChartController> {
  @override
  Widget build(BuildContext context) {
    Map<Category, double> categoriesStatistics = {};

    for (Category category in widget.categories) {
      double totalMinutes = widget.tasks
          .where((task) => task.categoryId == category.id)
          .fold(
            0.0,
            (sum, task) =>
                sum +
                TaskModel.castingFromTask(task: task).getNumberOfMinutes(),
          );

      categoriesStatistics[category] = totalMinutes / 60;
    }

    return BarChartSample3(
      gradientColors: [
        const Color.fromARGB(255, 10, 61, 120),
        const Color.fromARGB(255, 35, 108, 191),
      ],
      textColor: Theme.of(context).textTheme.bodyLarge!.color!,
      categoriesStatistics: categoriesStatistics,
    );
  }
}
