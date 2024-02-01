
part of 'task_list_bloc.dart';

sealed class TaskListEvent{}

class AddTask extends TaskListEvent{
  final TaskModel task;

  AddTask({required this.task});
}

class RemoveTask extends TaskListEvent{
  final TaskModel task;

  RemoveTask({required this.task});
}

class DeleteTask extends TaskListEvent{
  final dynamic key;

  DeleteTask({required this.key,});
}

class UpdateTask extends TaskListEvent{
  final TaskModel task;
  final dynamic key;

  UpdateTask({required this.task, required this.key});
}