import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive/hive.dart';

import '../models/task_model.dart';
import '../screens/components/boxes.dart';
part 'task_list_event.dart';
part 'task_list_state.dart';

class TaskListBloc extends Bloc<TaskListEvent, TaskListState>{
  TaskListBloc() : super(TaskListInitial(tasks: boxTasks)){
    on<AddTask>(_addTask);
    on<DeleteTask>(_deleteTask);
    on<UpdateTask>(_updateTask);
  }

  void _addTask(AddTask event, Emitter<TaskListState> emit){
    state.tasks.add(event.task);
    emit(TaskListUpdated(tasks: state.tasks));
  }

  void _deleteTask(DeleteTask event, Emitter<TaskListState> emit){
    state.tasks.delete(event.key);
    emit(TaskListUpdated(tasks: state.tasks));
  }

  void _updateTask(UpdateTask event, Emitter<TaskListState> emit){
    state.tasks.put(event.key, event.task);
    emit(TaskListUpdated(tasks: state.tasks));
  }
}