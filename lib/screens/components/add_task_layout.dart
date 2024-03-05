import 'package:flutter/material.dart';
import 'package:todo/bloc/task_list_bloc.dart';
import 'package:todo/screens/home.dart';
import '../../models/task_model.dart';
import 'custom_button.dart';

class AddTaskLayout extends StatelessWidget {
  final DrawerOptions value;
  final FocusNode focusNode;
  final TextEditingController controller;
  final Color iconColor;
  final TaskListBloc listBloc;
  final String category;
  final ScrollController scrollController;

  const AddTaskLayout({
    super.key,
    required this.focusNode,
    required this.controller,
    required this.value,
    required this.iconColor,
    required this.listBloc,
    required this.category,
    required this.scrollController,
  });

  @override
  Widget build(BuildContext context) {
    final maxWidth = MediaQuery.of(context).size.width;
    final maxHeight = MediaQuery.of(context).size.height;

    return SizedBox(
      width: MediaQuery.of(context).size.width,
      child: Container(
        decoration: BoxDecoration(
            boxShadow: focusNode.hasFocus && maxWidth <= 992
                ? [
                    BoxShadow(
                        color: Colors.grey.withOpacity(0.5),
                        offset: const Offset(0, -1),
                        blurRadius: 6,
                        spreadRadius: 3)
                  ]
                : null),
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
                        onFieldSubmitted: maxWidth >= 992 ? (value) => onFieldSubmitted() : null,
                      ),
                    ),
                    if (controller.text.isNotEmpty && maxWidth >= 992)
                      const Row(
                        children: [
                          Tooltip(
                            message: 'Set Due Date',
                            child: IconButton(
                              onPressed: null,
                              icon: Icon(Icons.calendar_month),
                            ),
                          ),
                          SizedBox(
                            width: 10,
                          ),
                          Tooltip(
                            message: 'Remind me',
                            child: IconButton(
                              onPressed: null,
                              icon: Icon(Icons.notifications),
                            ),
                          ),
                          SizedBox(
                            width: 10,
                          ),
                          Tooltip(
                            message: 'Repeat',
                            child: IconButton(
                              onPressed: null,
                              icon: Icon(Icons.repeat),
                            ),
                          ),
                          SizedBox(
                            width: 10,
                          ),
                        ],
                      ),
                    IconButton(
                      style: ButtonStyle(
                          backgroundColor: MaterialStatePropertyAll(
                              controller.text.isEmpty
                                  ? Colors.grey[400]
                                  : iconColor),
                          shape: MaterialStatePropertyAll(
                              RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10)))),
                      onPressed: controller.text.isEmpty
                          ? null
                          : () => onFieldSubmitted(),
                      icon: const Icon(
                        Icons.arrow_upward,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
                if (controller.text.isNotEmpty && maxWidth <= 992 )
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
      ),
    );
  }

  onFieldSubmitted() {
    listBloc.add(AddTask(
        task: TaskModel(
            task: controller.text,
            isChecked: false,
            isImportant:
            value == DrawerOptions.important
                ? true
                : false,
            category: value == DrawerOptions.important
                ? 'Tasks'
                : category)));

    controller.clear();
    scrollController.animateTo(
      0.0,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeIn,
    );
  }
}
