import 'package:flutter/material.dart';
import 'package:tadween_app/core/data/icons.dart';
import 'package:tadween_app/features/category/domain/entities/category.dart';

class CategoryModel extends Category {
  CategoryModel({required super.icon, required super.id, required super.name});

  CategoryModel.remoteSource({
    required super.id,
    required super.name,
    required String iconName,
  }) : super(icon: categoryIconsMap[iconName]!);

  static String getIconFromString(IconData icon) {
    return categoryIconsMap.entries
        .firstWhere((element) => element.value == icon)
        .key;
  }
}
