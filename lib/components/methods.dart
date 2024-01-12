import 'package:flutter/material.dart';
import 'package:todo/components/boxes.dart';
import 'package:todo/models/task_model.dart';

import '../screens/home.dart';

Map<String, dynamic> getOptionProperties(DrawerOptions option){
  switch (option){
    case DrawerOptions.myDay:
      return {
        'title' : 'My day',
        'iconData' : Icons.light_mode_outlined,
        'iconColor' :  Colors.green,
        'backgroundImage' : 'nature.jpg'
      };
    case DrawerOptions.tasks:
      return {
        'title' : 'Tasks',
        'iconData' : Icons.task_outlined,
        'iconColor' :  Colors.purple,
        'backgroundImage' : 'purple.jpg'
      };
    case DrawerOptions.important:
      return {
        'title' : 'Important',
        'iconData' : Icons.star_border,
        'iconColor' :  Colors.orange,
        'backgroundImage' : 'orange.jpg'
      };
  }
}

void addTask(TaskModel value) => boxTasks.add(value);

void removeTask(int index) => boxTasks.deleteAt(index);

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
