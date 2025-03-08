import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tadween_app/core/screens/splash_screen.dart';
import 'package:tadween_app/core/theme/theme.dart';
import 'package:tadween_app/features/category/presentation/bloc/categories/categories_bloc.dart';
import 'package:tadween_app/features/task/presentation/bloc/tasks/tasks_bloc.dart';
import 'package:tadween_app/injection_container.dart' as di;

void main() async {
  await di.init();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<TasksBloc>(
          create: (context) => di.sl<TasksBloc>(),
        ),
        BlocProvider<CategoriesBloc>(
          create: (context) => di.sl<CategoriesBloc>(),
        )
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: LightTheme().theme,
        darkTheme: DarkTheme().theme,
        home: SplashScreen(),
      ),
    );
  }
}
