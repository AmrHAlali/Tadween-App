
import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tadween_app/core/screens/home_screen.dart';
import 'package:tadween_app/features/task/presentation/bloc/tasks/tasks_bloc.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _timer = Timer(Duration(seconds: 3), () {
      Navigator.of(context).pushReplacement(
        PageRouteBuilder(
          pageBuilder: (BuildContext context, _, __) {
            return HomeScreen(getAllTasksMethod: () {
              context.read<TasksBloc>().add(GetAllTasksEvent(today: true));
            },);
          },
          transitionsBuilder: (
            _,
            Animation<double> animation,
            __,
            Widget child,
          ) {
            return FadeTransition(opacity: animation, child: child);
          },
        ),
      );
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: Center(
        child: SizedBox(
          width: 150.35 * 1.5,
          height: 150.31 * 1.5,
          child: Center(child: Text('Tadween', style: Theme.of(context).textTheme.bodyLarge!.copyWith(fontSize: 50),),),
        ),
      ),
    );
  }
}
