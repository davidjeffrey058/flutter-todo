import 'package:flutter/material.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:todo/components/boxes.dart';
import 'package:todo/screens/home.dart';
import 'models/task_model.dart';

Future<void> main() async{
//Initialize hive
  await Hive.initFlutter();
  Hive.registerAdapter(TaskModelAdapter());
  boxTasks = await Hive.openBox<TaskModel>('taskBox');

  runApp(MaterialApp(
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
  ));
}