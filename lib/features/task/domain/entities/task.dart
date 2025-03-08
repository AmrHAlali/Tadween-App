import 'package:flutter/material.dart';

class Task {
  String id;
  final String title;
  final String description;
  final String categoryId;
  final TimeOfDay startTime;
  final TimeOfDay endTime;
  final DateTime date;

  Task({
    required this.title,
    required this.description,
    required this.categoryId,
    required this.startTime,
    required this.endTime,
    required this.date,
    required this.id,
  });
}
