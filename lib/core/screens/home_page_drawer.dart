import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tadween_app/core/screens/home_screen.dart';
import 'package:tadween_app/features/category/domain/entities/category.dart';
import 'package:tadween_app/features/category/presentation/bloc/categories/categories_bloc.dart';
import 'package:tadween_app/features/category/presentation/widgets/add_category_widget.dart';
import 'package:tadween_app/features/task/presentation/bloc/tasks/tasks_bloc.dart';

class HomePageDrawer extends StatelessWidget {
  const HomePageDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(left: 15),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 60),

            _buildAddNewTextButton(
              icon: Icons.category_rounded,
              text: 'Add New Category',
              context: context,
              onPressed: () {
                Navigator.pop(context);
                showModalBottomSheet(
                  isScrollControlled: true,
                  context: context,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.vertical(top: Radius.circular(25)),
                  ),
                  builder: (context) {
                    return AddCategoryWidget();
                  },
                );
              },
            ),
            _buildDivider(context),
        
            _buildAddNewTextButton(
              context: context,
              icon: Icons.archive_rounded,
              text: 'Archived Tasks',
              onPressed: () {
                Navigator.of(context).popUntil((route) => route.isFirst);
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder:
                        (context) => HomeScreen(
                          getAllTasksMethod: () {
                            context.read<TasksBloc>().add(
                              GetAllTasksEvent(today: false),
                            );
                          },
                        ),
                  ),
                );
              },
            ),
            _buildDivider(context),
        
            _buildAddNewTextButton(
              context: context,
              icon: Icons.home_rounded,
              text: 'Home Screen',
              onPressed: () {
                Navigator.of(context).popUntil((route) => route.isFirst);
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder:
                        (context) => HomeScreen(
                          getAllTasksMethod: () {
                            context.read<TasksBloc>().add(
                              GetAllTasksEvent(today: true),
                            );
                          },
                        ),
                  ),
                );
              },
            ),
            _buildDivider(context),
        
            _buildCategroiesBlocListView(context),
          ],
        ),
      ),
    );
  }

  Widget _buildCategroiesBlocListView(BuildContext context) {
    return BlocBuilder<CategoriesBloc, CategoriesState>(
      builder: (context, state) {
        if (state is ErrorCategoriesState) {
          return Center(child: Icon(Icons.error_outline_sharp));
        }
        if (state is LoadedCategoriesState) {
          return _buildListView(context, state.categories);
        }
        return CircularProgressIndicator();
      },
    );
  }

  Widget _buildListView(BuildContext context, List<Category> categories) {
    return ListView.separated(
      shrinkWrap: true,
      physics: const BouncingScrollPhysics(),
      padding: EdgeInsets.zero,
      itemCount: categories.length,
      itemBuilder: (context, index) {
        final category = categories[index];

        return Align(
          alignment: Alignment.centerLeft,
          child: _buildAddNewTextButton(
            context: context,
            icon: category.icon,
            text: category.name,
            onPressed: () => _goCategoryScreen(context, category),
          ),
        );
      },
      separatorBuilder: (context, index) => _buildDivider(context),
    );
  }

  void _goCategoryScreen(BuildContext context, Category category) {
    Navigator.of(context).popUntil((route) => route.isFirst);
    Navigator.of(context).push(
      MaterialPageRoute(
        builder:
            (context) => HomeScreen(
              getAllTasksMethod: () {
                context.read<TasksBloc>().add(
                  GetAllTasksEvent(category: category),
                );
              },
            ),
      ),
    );
  }

  Widget _buildAddNewTextButton({
    required BuildContext context,
    required void Function() onPressed,
    required IconData icon,
    required String text,
  }) {
    return TextButton.icon(
      icon: Icon(icon, size: 28, color: Theme.of(context).iconTheme.color),
      label: Text(text, style: Theme.of(context).textTheme.bodyLarge),
      onPressed: onPressed,
    );
  }

  Widget _buildDivider(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(right: 20),
      child: const Divider(),
    );
  }
}
