import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:todo/Cubit/drawer_cubit.dart';
import 'package:todo/bloc/task_list_bloc.dart';
import 'package:todo/screens/components/boxes.dart';
import 'package:todo/screens/home.dart';
import 'models/task_model.dart';

Future<void> main() async{

//Initialize hive
  await Hive.initFlutter();
  Hive.registerAdapter(TaskModelAdapter());
  boxTasks = await Hive.openBox<TaskModel>('taskBox');

  runApp(MultiBlocProvider(
    providers: [
      BlocProvider<TaskListBloc>(create: (context) => TaskListBloc()),
      BlocProvider<DrawerCubit>(create: (context) => DrawerCubit()),
    ],
    child: MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
        appBarTheme: const AppBarTheme(
          backgroundColor: Colors.transparent,
          titleTextStyle: TextStyle(color: Colors.white, fontSize: 20),
          iconTheme: IconThemeData(color: Colors.white)
        )
      ),
      home: const Home(),
    ),
  ));
}