import 'package:flutter/material.dart';
import 'package:todo/Cubit/tasks_list_cubit.dart';
import 'package:todo/screens/home.dart';

import '../models/task_model.dart';
import 'custom_button.dart';

class AddTaskLayout extends StatelessWidget {
  final DrawerOptions value;
  final FocusNode focusNode;
  final TextEditingController controller;
  final Color iconColor;
  final TasksListCubit listCubit;
  final String category;
  final ScrollController scrollController;

  const AddTaskLayout(
      {super.key,
      required this.focusNode,
      required this.controller,
      required this.value,
      required this.iconColor,
      required this.listCubit,
      required this.category,
      required this.scrollController});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: MediaQuery.of(context).size.width,
      child: Material(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              Row(
                children: [
                  Flexible(
                    child: TextFormField(
                      focusNode: focusNode,
                      textCapitalization: TextCapitalization.sentences,
                      decoration: const InputDecoration(
                          prefixIcon: Icon(Icons.circle_outlined),
                          hintText: 'Add a task',
                          border: InputBorder.none),
                      controller: controller,
                      onSaved: (value) {},
                    ),
                  ),
                  IconButton(
                    style: ButtonStyle(
                        backgroundColor: MaterialStatePropertyAll(
                            controller.text.isEmpty
                                ? Colors.grey[400]
                                : iconColor),
                        shape: MaterialStatePropertyAll(RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10)))),
                    onPressed: controller.text.isEmpty
                        ? null
                        : () {
                            listCubit.addTask(TaskModel(
                                task: controller.text,
                                isChecked: false,
                                isImportant: value == DrawerOptions.important
                                    ? true
                                    : false,
                                category: value == DrawerOptions.important
                                    ? 'Tasks'
                                    : category));
                            controller.clear();
                            scrollController.animateTo(
                                0.0,
                                duration: const Duration(milliseconds: 300),
                                curve: Curves.easeIn
                            );
                          },
                    icon: const Icon(
                      Icons.arrow_upward,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
              if (controller.text.isNotEmpty)
                const Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    CustomButton(
                      text: 'Set Due Date',
                      icon: Icon(Icons.calendar_month),
                    ),
                    CustomButton(
                      text: 'Remind me',
                      icon: Icon(Icons.notifications),
                    ),
                    CustomButton(
                      text: 'Repeat',
                      icon: Icon(Icons.repeat),
                    ),
                  ],
                )
            ],
          ),
        ),
      ),
    );
  }
}