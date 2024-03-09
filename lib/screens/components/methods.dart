import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:todo/models/task_model.dart';

import '../home.dart';

Map<String, dynamic> getOptionProperties(DrawerOptions option){
  switch (option){
    case DrawerOptions.myDay:
      return {
        'title' : 'My day',
        'iconData' : Icons.light_mode_outlined,
        'iconColor' :  Colors.green,
        'backgroundImage' : 'nature.jpg',
        'emptyMessageImage' : 'empty.png',
        'emptyMessage'  : 'Try adding a task to spice up your day'
      };
    case DrawerOptions.tasks:
      return {
        'title' : 'Tasks',
        'iconData' : Icons.task_outlined,
        'iconColor' :  Colors.purple,
        'backgroundImage' : 'purple_sky.jpg',
        'emptyMessageImage' : 'empty2.png',
        'emptyMessage' : 'No task here. Add a task'
      };
    case DrawerOptions.important:
      return {
        'title' : 'Important',
        'iconData' : Icons.star_border,
        'iconColor' :  Colors.orange,
        'backgroundImage' : 'sunset.jpg',
        'emptyMessageImage' : 'empty2.png',
        'emptyMessage' : 'Try starring some tasks to see them here'
      };
  }
}

List<Map> categoryList(DrawerOptions options, Box taskBox, {bool isEmptyList = false}){
  late List<Map> items;

  switch (options){
    case DrawerOptions.myDay:
      items = [];
      for(int i = taskBox.length - 1; i >= 0; i--){
        TaskModel value = taskBox.getAt(i);
        bool checkedValue = isEmptyList ? value.isChecked : !value.isChecked;
        if(value.category == 'My day' && checkedValue){
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
      for(int i = taskBox.length - 1; i >= 0; i--){
        TaskModel value = taskBox.getAt(i);
        bool checkedValue = isEmptyList ? value.isChecked : !value.isChecked;
        if(value.category == 'Tasks' && checkedValue){
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
      for(int i = taskBox.length - 1; i >= 0; i--){
        TaskModel value = taskBox.getAt(i);
        bool checkedValue = isEmptyList ? value.isChecked : !value.isChecked;
        if(value.isImportant && checkedValue){
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


