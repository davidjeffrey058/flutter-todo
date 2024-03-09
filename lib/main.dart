import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:todo/Cubit/drawer_cubit.dart';
import 'package:todo/bloc/ThemeBloc/theme_bloc.dart';
import 'package:todo/bloc/task_list_bloc.dart';
import 'package:todo/screens/components/boxes.dart';
import 'package:todo/screens/home.dart';
import 'package:todo/theme.dart';
import 'models/task_model.dart';

Future<void> main() async{
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp
  ]);

//Initialize hive
  await Hive.initFlutter();
  Hive.registerAdapter(TaskModelAdapter());
  boxTasks = await Hive.openBox<TaskModel>('taskBox');
  configBox = await Hive.openBox('config');

  runApp(MultiBlocProvider(
    providers: [
      BlocProvider<TaskListBloc>(create: (context) => TaskListBloc()),
      BlocProvider<DrawerCubit>(create: (context) => DrawerCubit()),
      BlocProvider<ThemeBloc>(create: (context) => ThemeBloc(),)
    ],
    child: BlocBuilder<ThemeBloc, ThemeMode>(
      builder: (context, state) {
        return MaterialApp(
          title: 'Sweet Todo',
          debugShowCheckedModeBanner: false,
          theme: lightTheme,
          darkTheme: darkTheme,
          themeMode: state,
          home: const Home(),
        );
      }
    ),
  ));
}