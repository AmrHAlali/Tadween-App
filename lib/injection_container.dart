import 'package:get_it/get_it.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:tadween_app/core/network/network_info.dart';
import 'package:tadween_app/features/category/data/data_sources/remote_data_source.dart';
import 'package:tadween_app/features/category/data/repositories/category_repository_implementation.dart';
import 'package:tadween_app/features/category/domain/repositories/category_repository.dart';
import 'package:tadween_app/features/category/domain/usecases/add_category.dart';
import 'package:tadween_app/features/category/domain/usecases/get_all_categories.dart';
import 'package:tadween_app/features/category/presentation/bloc/categories/categories_bloc.dart';
import 'package:tadween_app/features/task/data/data_sources/remote_data_source.dart';
import 'package:tadween_app/features/task/data/repositories/task_repositories_implementation.dart';
import 'package:tadween_app/features/task/domain/repositories/task_repository.dart';
import 'package:tadween_app/features/task/domain/usecases/add_task.dart';
import 'package:tadween_app/features/task/domain/usecases/delete_task.dart';
import 'package:tadween_app/features/task/domain/usecases/get_all_tasks.dart';
import 'package:tadween_app/features/task/presentation/bloc/tasks/tasks_bloc.dart';

final GetIt sl = GetIt.instance;

Future<void> init() async {
  // Features - tasks
  // Bloc
  sl.registerFactory(
    () => TasksBloc(
      getAllTasksUsecase: sl(),
      addTaskUsecase: sl(),
      deleteTaskUsecase: sl(),
    ),
  );

  // Usecases
  sl.registerLazySingleton(() => GetAllTasksUsecase(taskRepository: sl()));
  sl.registerLazySingleton(() => AddTaskUsecase(taskRepository: sl()));
  sl.registerLazySingleton(() => DeleteTaskUsecase(taskRepository: sl()));

  // Repository
  sl.registerLazySingleton<TaskRepository>(
    () => TaskRepositoriesImplementation(
      networkInfo: sl(),
      remoteDataSource: sl(),
    ),
  );

  // Datasources
  sl.registerLazySingleton<TasksRemoteDataSource>(
    () => TasksRemoteDataSourceImplementation(),
  );

  // Features - categories
  // Bloc
  sl.registerFactory(
    () => CategoriesBloc(addCategoryUsecase: sl(), getAllCategoryUsecase: sl()),
  );

  // Usecases
  sl.registerLazySingleton(
    () => GetAllCategoriesUsecase(categoryRepository: sl()),
  );
  sl.registerLazySingleton(() => AddCategoryUsecase(categoryRepository: sl()));

  // Repository
  sl.registerLazySingleton<CategoryRepository>(
    () => CategoryRepositoryImplementation(
      networkInfo: sl(),
      remoteDataSource: sl(),
    ),
  );

  // Datasources
  sl.registerLazySingleton<CategoriesRemoteDataSource>(
    () => CategoriesRemoteDataSourceImplementation(),
  );

  // Core
  sl.registerLazySingleton<NetworkInfo>(() => NetworkInfoImplementation(sl()));

  // External
  // final sharedPreferences = await SharedPreferences.getInstance();
  // sl.registerLazySingleton(() => sharedPreferences);
  // sl.registerLazySingleton(() => http.Client());
  sl.registerLazySingleton(() => InternetConnectionChecker());
}
