import 'package:flutter/material.dart';
import 'package:tadween_app/core/widgets/add_or_update_widget.dart';
import 'package:tadween_app/features/category/domain/entities/category.dart';

class HomeScreenFloatingButton extends StatelessWidget {
  final List<Category> categories;

  const HomeScreenFloatingButton({super.key, required this.categories});

  @override
  Widget build(BuildContext context) {
    return FloatingActionButton(
      child: Icon(Icons.add),
      onPressed: () {
        showModalBottomSheet(
          isScrollControlled: true,
          context: context,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(top: Radius.circular(25)),
          ),
          builder: (context) {
            return AddOrUpdateWidget(
              addOrUpdate: 'add',
              categories: categories,
            );
          },
        );
      },
    );
  }
}
