import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tadween_app/core/screens/home_screen.dart';
import 'package:tadween_app/features/task/presentation/bloc/tasks/tasks_bloc.dart';

class HomeScreenBottomAppBar extends StatelessWidget {
  const HomeScreenBottomAppBar({super.key});

  @override
  Widget build(BuildContext context) {
    return BottomAppBar(
      child: IconButton(
        icon: Icon(
          Icons.home,
          color: Theme.of(context).textTheme.titleLarge!.color,
          size: 30,
        ),
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
    );
  }
}
