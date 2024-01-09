import 'package:hive/hive.dart';

part 'task_model.g.dart';

@HiveType(typeId: 1)
class TaskModel {
  @HiveField(0)
  String task;

  @HiveField(1)
  bool isChecked;

  @HiveField(2)
  bool isImportant;

  @HiveField(3)
  String category;

  TaskModel(
      {required this.task,
      required this.isChecked,
      required this.isImportant,
      required this.category});
}
