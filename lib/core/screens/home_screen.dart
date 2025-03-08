import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tadween_app/core/screens/chart/chart_controller.dart';
import 'package:tadween_app/core/screens/home_page_drawer.dart';
import 'package:tadween_app/core/widgets/home_screen_bottom_app_bar.dart';
import 'package:tadween_app/core/widgets/home_screen_floating_button.dart';
import 'package:tadween_app/features/category/domain/entities/category.dart';
import 'package:tadween_app/features/category/presentation/bloc/categories/categories_bloc.dart';
import 'package:tadween_app/features/task/domain/entities/task.dart';
import 'package:tadween_app/features/task/presentation/bloc/tasks/tasks_bloc.dart';
import 'package:tadween_app/features/task/presentation/widgets/tasks_list.dart';

class HomeScreen extends StatefulWidget {
  final void Function() getAllTasksMethod;
  const HomeScreen({super.key, required this.getAllTasksMethod});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
    super.initState();

    widget.getAllTasksMethod();
    context.read<CategoriesBloc>().add(GetAllCategoriesEvent());
  }

  @override
  Widget build(BuildContext context) {
    return _buildHomeScreenTasks();
  }

  Widget _buildHomeScreenTasks() {
    return BlocBuilder<TasksBloc, TasksState>(
      builder: (context, stateTasks) {
        if (stateTasks is TasksLoadedState) {
          return _buildHomeScreenCategories(tasks: stateTasks.tasks);
        }
        if (stateTasks is ErrorTasksState) {
          return Scaffold(
            body: Center(child: Text('There is something wrong!')),
          );
        }
        return Scaffold(body: Center(child: CircularProgressIndicator()));
      },
    );
  }

  Widget _buildHomeScreenCategories({required List<Task> tasks}) {
    return BlocBuilder<CategoriesBloc, CategoriesState>(
      builder: (context, stateCategories) {
        if (stateCategories is LoadedCategoriesState) {
          return Scaffold(
            appBar: _buildAppBar(context),
            body: _buildContent(tasks, stateCategories.categories),

            floatingActionButton: HomeScreenFloatingButton(
              categories: stateCategories.categories,
            ),
            drawer: _buildDrawer(context),
            bottomNavigationBar:
                MediaQuery.of(context).size.width <= 600
                    ? const HomeScreenBottomAppBar()
                    : null,
          );
        }
        if (stateCategories is ErrorCategoriesState) {
          return Scaffold(
            body: Center(child: Text('There is something wrong!')),
          );
        }
        return Scaffold(body: Center(child: CircularProgressIndicator()));
      },
    );
  }

  Widget _buildContent(List<Task> tasks, List<Category> categories) {
    List<Widget> children = [
      ChartController(categories: categories, tasks: tasks),
      const VerticalDivider(),
      const Divider(),
      Expanded(child: _buildBody(context, tasks, categories)),
    ];

    double width = MediaQuery.of(context).size.width;
    if (width <= 600) {
      return Column(children: children);
    } else {
      return Row(children: children);
    }
  }

  AppBar _buildAppBar(BuildContext context) {
    return AppBar(
      title: Text('Home Screen', style: Theme.of(context).textTheme.titleLarge),
    );
  }

  Widget _buildBody(
    BuildContext context,
    List<Task> tasks,
    List<Category> categories,
  ) {
    if (tasks.isEmpty) {
      return Center(
        child: Text(
          'Add some tasks!',
          style: Theme.of(context).textTheme.bodyLarge,
        ),
      );
    }
    return TasksList(tasks: tasks, categories: categories);
  }

  Widget _buildDrawer(BuildContext context) {
    return Drawer(child: HomePageDrawer());
  }
}
