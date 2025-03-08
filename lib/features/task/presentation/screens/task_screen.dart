import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tadween_app/core/widgets/add_or_update_widget.dart';
import 'package:tadween_app/features/category/domain/entities/category.dart';
import 'package:tadween_app/features/category/presentation/bloc/categories/categories_bloc.dart';
import 'package:tadween_app/features/task/data/models/task_model.dart';

class TaskScreen extends StatelessWidget {
  final TaskModel taskModel;
  final Category category;
  final Function onTaskDeleted;

  const TaskScreen({
    super.key,
    required this.taskModel,
    required this.category,
    required this.onTaskDeleted,
  });

  @override
  Widget build(BuildContext context) {
    String taskStartTime = taskModel.getStringTimeOfDay(taskModel.startTime);
    String taskEndTime = taskModel.getStringTimeOfDay(taskModel.endTime);
    double taskNumberOfHours = taskModel.getNumberOfHours();

    return Scaffold(
      appBar: _buildAppBar(context),

      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: [
            _buildTitleText(context),
            const SizedBox(height: 20),

            _buildRow(
              category.icon,
              _formatedTitle(title: category.name),
              context,
            ),
            _buildRow(
              Icons.access_time,
              '$taskStartTime - $taskEndTime   ($taskNumberOfHours hours)',
              context,
            ),
            _buildRow(
              Icons.date_range_rounded,
              taskModel.getStringDate(),
              context,
            ),
            _buildRow(Icons.note, taskModel.description, context),
            const SizedBox(height: 10),

            _buildDeleteButton(context),
            const SizedBox(height: 50),
          ],
        ),
      ),

      floatingActionButton: _buildUpdateButton(context),
    );
  }

  Widget _buildUpdateButton(BuildContext context) {
    return BlocBuilder<CategoriesBloc, CategoriesState>(
      builder: (context, state) {
        if (state is LoadedCategoriesState) {
          return FloatingActionButton(
            child: Icon(Icons.edit),
            onPressed: () {
              _buildUpdateBottomSheet(context, state.categories);
            },
          );
        }
        return FloatingActionButton(
          onPressed: null,
          backgroundColor: Colors.transparent,
          foregroundColor: Colors.grey,
          child: Icon(
            Icons.edit,
            color: const Color.fromARGB(68, 158, 158, 158),
          ),
        );
      },
    );
  }

  Widget _buildDeleteButton(BuildContext context) {
    return ElevatedButton.icon(
      onPressed: () {
        onTaskDeleted();
        Navigator.pop(context);
      },
      icon: Icon(Icons.delete),
      label: Text('Delete', style: TextStyle(color: Colors.white)),
    );
  }

  Widget _buildTitleText(BuildContext context) {
    return Text(
      _formatedTitle(title: taskModel.title),
      style: Theme.of(context).textTheme.bodyLarge!.copyWith(
        fontWeight: FontWeight.bold,
        fontSize: 30,
      ),
    );
  }

  AppBar _buildAppBar(BuildContext context) {
    return AppBar(
      title: Text('Your Task', style: Theme.of(context).textTheme.titleLarge),
    );
  }

  void _buildUpdateBottomSheet(
    BuildContext context,
    List<Category> categories,
  ) {
    showModalBottomSheet(
      isScrollControlled: true,
      context: context,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(25)),
      ),
      builder: (context) {
        return AddOrUpdateWidget(
          categories: categories,
          taskModel: taskModel,
          addOrUpdate: 'update',
        );
      },
    );
  }

  Widget _buildRow(IconData icon, String text, BuildContext context) {
    return Column(
      children: [
        InkWell(
          child: Container(
            margin: const EdgeInsets.symmetric(vertical: 10),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Icon(
                  icon,
                  size: 40,
                  color: Theme.of(context).listTileTheme.iconColor,
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Text(
                    text,
                    style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                      fontSize: 22,
                      fontWeight: FontWeight.normal,
                    ),
                    softWrap: true,
                  ),
                ),
              ],
            ),
          ),
        ),
        Divider(),
      ],
    );
  }

  String _formatedTitle({required String title}) {
    return title[0].toUpperCase() + title.substring(1);
  }
}
