part of 'task_list_bloc.dart';

abstract class TaskListState {
  Box tasks;
  TaskListState({required this.tasks});
}

class TaskListInitial extends TaskListState{
  TaskListInitial({required Box tasks}) : super(tasks: tasks);
}

class TaskListUpdated extends TaskListState{
  TaskListUpdated({required Box tasks}) : super(tasks: tasks);
}