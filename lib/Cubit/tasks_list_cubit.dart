import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive/hive.dart';
import 'package:todo/components/boxes.dart';

import '../models/task_model.dart';

class TasksListCubit extends Cubit<Box>{
  TasksListCubit() : super(boxTasks);

  void addTask(TaskModel value) => emit(state.add(value) as Box);
}