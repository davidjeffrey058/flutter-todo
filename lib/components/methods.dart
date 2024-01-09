import 'package:flutter/material.dart';
import 'package:todo/components/boxes.dart';
import 'package:todo/models/task_model.dart';

import '../screens/home.dart';

String getOptionText(DrawerOptions option) {
  switch (option) {
    case DrawerOptions.myDay:
      return 'My day';
    case DrawerOptions.tasks:
      return 'Tasks';
    case DrawerOptions.important:
      return 'Important';
    default:
      return 'Unknown';
  }
}

IconData getOptionIcon(DrawerOptions option) {
  switch (option) {
    case DrawerOptions.myDay:
      return Icons.light_mode_outlined;
    case DrawerOptions.tasks:
      return Icons.task_outlined;
    case DrawerOptions.important:
      return Icons.star_border;
    default:
      return Icons.error;
  }
}

Color getOptionIconColor(DrawerOptions option) {
  switch (option) {
    case DrawerOptions.myDay:
      return Colors.green;
    case DrawerOptions.tasks:
      return Colors.purple;
    case DrawerOptions.important:
      return Colors.orange;
    default:
      return Colors.red;
  }
}

void addTask(String key, TaskModel value) {
  boxTasks.put(key, value);
}

void removeTask(int index) {
  boxTasks.deleteAt(index);
}

void updateState(int index, bool forChecked) {
  TaskModel item = boxTasks.getAt(index);

  if (forChecked) {
    boxTasks.putAt(
        index,
        TaskModel(
            task: item.task,
            isChecked: !item.isChecked,
            isImportant: item.isImportant,
            category: item.category
        )
    );
  } else{
    boxTasks.putAt(
        index,
        TaskModel(
            task: item.task,
            isChecked: item.isChecked,
            isImportant: !item.isImportant,
            category: item.category
        )
    );
  }
}
