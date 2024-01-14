import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive/hive.dart';
import 'package:todo/components/boxes.dart';

import '../models/task_model.dart';

class TasksListCubit extends Cubit<Box>{
  TasksListCubit() : super(boxTasks);

  Future<int> addTask(TaskModel value){
    return state.add(value);
  }

  void removeTask(dynamic key){
    state.delete(key);
  }

  void updateState(dynamic key, bool forChecked) {
    TaskModel item = state.get(key);

    if (forChecked) {
      state.put(
          key,
          TaskModel(
              task: item.task,
              isChecked: !item.isChecked,
              isImportant: item.isImportant,
              category: item.category
          )
      );
      emit(state);
    } else{
      state.put(
          key,
          TaskModel(
              task: item.task,
              isChecked: item.isChecked,
              isImportant: !item.isImportant,
              category: item.category
          )
      );
    }
    emit(state);
  }


}