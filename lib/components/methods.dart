import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:todo/models/task_model.dart';

import '../screens/home.dart';

Map<String, dynamic> getOptionProperties(DrawerOptions option){
  switch (option){
    case DrawerOptions.myDay:
      return {
        'title' : 'My day',
        'iconData' : Icons.light_mode_outlined,
        'iconColor' :  Colors.green,
        'backgroundImage' : 'nature.jpg',
      };
    case DrawerOptions.tasks:
      return {
        'title' : 'Tasks',
        'iconData' : Icons.task_outlined,
        'iconColor' :  Colors.purple,
        'backgroundImage' : 'purple_sky.jpg'
      };
    case DrawerOptions.important:
      return {
        'title' : 'Important',
        'iconData' : Icons.star_border,
        'iconColor' :  Colors.orange,
        'backgroundImage' : 'sunset.jpg'
      };
  }
}

// void removeTask(int index) => boxTasks.deleteAt(index);

List<Map> categoryList(DrawerOptions options, Box taskBox){
  late List<Map> items;

  switch (options){
    case DrawerOptions.myDay:
      items = [];
      for(int i = 0; i < taskBox.length; i++){
        TaskModel value = taskBox.getAt(i);
        if(value.category == 'My day'){
          items.add({
            'task': value.task,
            'key' : taskBox.keyAt(i),
            'category' : value.category,
            'isImportant' : value.isImportant,
            'isChecked' : value.isChecked
          });
        }
      }
      return items;

    case DrawerOptions.tasks:
      items = [];
      for(int i = 0; i < taskBox.length; i++){
        TaskModel value = taskBox.getAt(i);
        if(value.category == 'Tasks'){
          items.add({
            'task': value.task,
            'key' : taskBox.keyAt(i),
            'category' : value.category,
            'isImportant' : value.isImportant,
            'isChecked' : value.isChecked
          });
        }
      }
      return items;

    case DrawerOptions.important:
      items = [];
      for(int i = 0; i < taskBox.length; i++){
        TaskModel value = taskBox.getAt(i);
        if(value.isImportant){
          items.add({
            'task': value.task,
            'key' : taskBox.keyAt(i),
            'category' : value.category,
            'isImportant' : value.isImportant,
            'isChecked' : value.isChecked
          });
        }
      }
      return items;
  }
}

