
part of 'task_list_bloc.dart';

sealed class TaskListEvent{}

class AddTask extends TaskListEvent{
  final TaskModel task;

  AddTask({required this.task});
}

class RemoveTask extends TaskListEvent{
  final TaskModel task;

  RemoveTask(this.task);
}

class DeleteTask extends TaskListEvent{
  final dynamic key;
  final TaskModel task;

  DeleteTask(this.key, this.task);
}

class UpdateTask extends TaskListEvent{
  final TaskModel task;
  final dynamic key;

  UpdateTask(this.task, this.key);
}