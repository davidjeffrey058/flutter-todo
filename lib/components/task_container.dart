import 'package:flutter/material.dart';

import '../models/task_model.dart';

class TaskContainer extends StatelessWidget {
  final Key dismissibleKey;
  final int index;
  final TaskModel item;
  final void Function()? checkedOnPressed;
  final void Function()? importantOnPressed;
  final void Function()? onLongPressed;
  final void Function(DismissDirection)? onDismissed;

  const TaskContainer({
      super.key,
      required this.index,
      required this.item,
      this.checkedOnPressed,
      this.importantOnPressed,
      this.onLongPressed,
      required this.dismissibleKey,
      this.onDismissed
    }
  );

  @override
  Widget build(BuildContext context) {
    return Dismissible(
      key: dismissibleKey,
      secondaryBackground: Flexible(
        child: Container(
          color: Colors.red,
          child: const Icon(Icons.delete, color: Colors.white,),
        ),
      ),
      background: Container(
        color: Colors.grey[400],
        child: const Icon(Icons.edit, color: Colors.white,),
      ),
      onDismissed: onDismissed,
      child: Material(
        clipBehavior: Clip.hardEdge,
        color: item.isChecked ? Colors.blue[50] : Colors.white,
        borderRadius: BorderRadius.circular(5),
        child: ListTile(
          onLongPress: onLongPressed,
          contentPadding: const EdgeInsets.symmetric(vertical: 10),
          title: Text(
            item.task,
            style: TextStyle(
                color: item.isChecked ? Colors.grey : Colors.black,
                fontStyle: item.isChecked ? FontStyle.italic : FontStyle.normal,
                decoration: item.isChecked
                    ? TextDecoration.lineThrough
                    : TextDecoration.none),
          ),
          leading: IconButton(
            icon: item.isChecked
                ? const Icon(Icons.check_circle)
                : const Icon(Icons.circle_outlined),
            onPressed: checkedOnPressed,
          ),
          trailing: IconButton(
            icon: item.isImportant
                ? const Icon(Icons.star_rate_rounded, color: Colors.amberAccent)
                : const Icon(
                    Icons.star_border_rounded,
                  ),
            onPressed: importantOnPressed,
          ),
        ),
      ),
    );
  }
}
