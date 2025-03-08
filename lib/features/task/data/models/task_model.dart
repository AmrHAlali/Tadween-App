import 'package:flutter/material.dart';
import 'package:tadween_app/features/task/domain/entities/task.dart';
import 'package:intl/intl.dart';

class TaskModel extends Task {
  TaskModel({
    required super.title,
    required super.description,
    required super.categoryId,
    required super.startTime,
    required super.endTime,
    required super.id,
  }) : super(date: DateTime.now());

  TaskModel.forUpdate({
    required super.title,
    required super.description,
    required super.categoryId,
    required super.startTime,
    required super.endTime,
    required super.id,
    required super.date,
});


  TaskModel.remoteSource({
    required super.title,
    required super.description,
    required super.categoryId,
    required String startTimeString,
    required String endTimeString,
    required super.id,
    required String stringDate,
  }) : super(
         date: getDateFromString(stringDate),
         startTime: getTimeOfDayFromString(startTimeString),
         endTime: getTimeOfDayFromString(endTimeString),
       );

  TaskModel.castingFromTask({required Task task})
    : super(
        categoryId: task.categoryId,
        date: task.date,
        description: task.description,
        endTime: task.endTime,
        id: task.id,
        startTime: task.startTime,
        title: task.title,
      );

  String getStringDate() {
    return DateFormat('dd-MM-yyyy').format(date);
  }

  static DateTime getDateFromString(String stringDate) {
    return DateFormat('dd-MM-yyyy').parse(stringDate);
  }

  static TimeOfDay getTimeOfDayFromString(String stringDayOfTime) {
    List<String> timeParts = stringDayOfTime.split(':');
    int hour = int.parse(timeParts[0]);
    int minute = int.parse(timeParts[1]);

    TimeOfDay timeOfDay = TimeOfDay(hour: hour, minute: minute);

    return timeOfDay;
  }

  String getStringTimeOfDay(TimeOfDay timeOfDay) {
    return '${timeOfDay.hour.toString().padLeft(2, '0')}:${timeOfDay.minute.toString().padLeft(2, '0')}';
  }

  double getNumberOfHours(){
    double startHour = double.parse(getStringTimeOfDay(startTime).split(':')[0]);
    double startMinute = double.parse(getStringTimeOfDay(startTime).split(':')[1]);

    double endHour = double.parse(getStringTimeOfDay(endTime).split(':')[0]);
    double endMinute = double.parse(getStringTimeOfDay(endTime).split(':')[1]);

    double minutes = (endMinute - startMinute);
    double hours = (endHour - startHour);

    if(minutes < 0) {
      hours--;
      minutes += 60;
    }

    return hours + minutes/100;
  }

  int getNumberOfMinutes(){
    int startHour = int.parse(getStringTimeOfDay(startTime).split(':')[0]);
    int startMinute = int.parse(getStringTimeOfDay(startTime).split(':')[1]);

    int endHour = int.parse(getStringTimeOfDay(endTime).split(':')[0]);
    int endMinute = int.parse(getStringTimeOfDay(endTime).split(':')[1]);

    int minutes = (endMinute - startMinute);
    int hours = (endHour - startHour);

    return minutes + hours * 60;
  }
}
