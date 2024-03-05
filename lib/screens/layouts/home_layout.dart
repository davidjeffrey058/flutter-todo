import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:todo/screens/home.dart';

import '../../bloc/task_list_bloc.dart';
import '../../models/task_model.dart';
import '../components/add_task_layout.dart';
import '../components/category_title.dart';
import '../components/drawer_layout.dart';
import '../components/empty_message_widget.dart';
import '../components/methods.dart';
import '../components/task_container.dart';
import '../test_page.dart';

class HomeLayout extends StatelessWidget {
  final double? emptyMessageWidth;
  final void Function()? gestureDetectorOnTap;
  final DrawerOptions value;
  final ScrollController scrollController;
  final TaskListBloc listBloc;
  final TextEditingController editingController;
  final TextEditingController controller;
  final FocusNode focusNode;
  // final bool showDrawer;
  // final bool isMobile;

  const HomeLayout({
    super.key,
    this.gestureDetectorOnTap,
    required this.value,
    required this.scrollController,
    required this.listBloc,
    required this.editingController,
    required this.controller,
    required this.focusNode,
    this.emptyMessageWidth,
  });

  @override
  Widget build(BuildContext context) {

    final maxWidth = MediaQuery.of(context).size.width;
    final maxHeight = MediaQuery.of(context).size.height;

    return GestureDetector(
        onTap: gestureDetectorOnTap,
        child: Container(
          decoration: BoxDecoration(
              image: DecorationImage(
                  image: AssetImage(
                      'images/${getOptionProperties(value)['backgroundImage']}'),
                  fit: BoxFit.cover)),
          child: Scaffold(
            backgroundColor: Colors.transparent,
            appBar: myAppBar(),
            body: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  child: CategoryTitle(
                    properties: getOptionProperties(value),
                  ),
                ),
                BlocBuilder<TaskListBloc, TaskListState>(
                  builder: (context, state) {
                    if (categoryList(value, state.tasks).isEmpty) {
                      return EmptyMessageWidget(
                          emptyMessageWidth: emptyMessageWidth,
                          imageName:
                              getOptionProperties(value)['emptyMessageImage'],
                          message: getOptionProperties(value)['emptyMessage']);
                    } else {
                      return Expanded(
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 10.0),
                          child: ListView.builder(
                            controller: scrollController,
                            shrinkWrap: true,
                            itemCount: categoryList(value, state.tasks).length,
                            itemBuilder: (context, index) {
                              Map task =
                                  categoryList(value, state.tasks)[index];

                              //Gets number of tasks per category
                              myDayListLength = categoryList(DrawerOptions.myDay, state.tasks).length;
                              taskListLength = categoryList(DrawerOptions.tasks, state.tasks).length;
                              importantListLength = categoryList(DrawerOptions.important, state.tasks).length;

                              return Column(
                                children: [
                                  if (index == 0)
                                    const SizedBox(
                                      height: 5,
                                    ),
                                  TaskContainer(
                                    dismissibleKey: ValueKey(task['key']),
                                    item: task,
                                    index: index,
                                    checkedOnPressed: () {
                                      listBloc.add(UpdateTask(
                                          task: TaskModel(
                                              task: task['task'],
                                              isChecked: !task['isChecked'],
                                              isImportant: task['isImportant'],
                                              category: task['category']),
                                          key: task['key']));
                                    },
                                    importantOnPressed: () {
                                      listBloc.add(UpdateTask(
                                          task: TaskModel(
                                              task: task['task'],
                                              isChecked: task['isChecked'],
                                              isImportant: !task['isImportant'],
                                              category: task['category']),
                                          key: task['key']));
                                    },
                                    onDismissed: (DismissDirection direction) {
                                      if (direction ==
                                          DismissDirection.endToStart) {
                                        listBloc
                                            .add(DeleteTask(key: task['key']));
                                        ScaffoldMessenger.of(context)
                                            .showSnackBar(const SnackBar(
                                          content: Text('Task Deleted'),
                                          duration: Duration(seconds: 1),
                                        ));
                                      }
                                    },
                                    confirmDismiss:
                                        (DismissDirection direction) async {
                                      if (direction ==
                                          DismissDirection.startToEnd) {
                                        editingController.text = task['task'];
                                        showDialog(
                                            context: context,
                                            builder: (context) {
                                              return AlertDialog(
                                                title: const Text('Edit task'),
                                                content: Column(
                                                  mainAxisSize:
                                                      MainAxisSize.min,
                                                  children: [
                                                    TextFormField(
                                                      minLines: 2,
                                                      maxLines: 3,
                                                      controller:
                                                          editingController,
                                                      autofocus: true,
                                                    )
                                                  ],
                                                ),
                                                actions: [
                                                  OutlinedButton(
                                                      onPressed: () {
                                                        listBloc.add(UpdateTask(
                                                          task: TaskModel(
                                                            task:
                                                                editingController
                                                                    .text,
                                                            isChecked: task[
                                                                'isChecked'],
                                                            isImportant: task[
                                                                'isImportant'],
                                                            category: task[
                                                                'category'],
                                                          ),
                                                          key: task['key'],
                                                        ));

                                                        Navigator.pop(context);
                                                      },
                                                      child:
                                                          const Text('Save')),
                                                  OutlinedButton(
                                                      onPressed: () =>
                                                          Navigator.pop(
                                                              context),
                                                      child:
                                                          const Text('Cancel'))
                                                ],
                                              );
                                            });
                                        return false;
                                      }
                                      if (direction ==
                                          DismissDirection.endToStart) {
                                        return true;
                                      }
                                      return null;
                                    },
                                  ),
                                  const SizedBox(
                                    height: 5,
                                  )
                                ],
                              );
                            },
                          ),
                        ),
                      );
                    }
                  },
                ),

                //Add task section
                SizedBox(
                  height: maxWidth <= 992 && !focusNode.hasFocus ? 0 : null,
                  child: AddTaskLayout(
                    scrollController: scrollController,
                    iconColor: getOptionProperties(value)['iconColor'],
                    category: getOptionProperties(value)['title'],
                    focusNode: focusNode,
                    controller: controller,
                    value: value,
                    listBloc: listBloc,
                  ),
                ),
              ],
            ),
            drawer: maxWidth <= 992
                ? Drawer(
                    child: DrawerLayout(
                      options: options,
                      drawerOption: value,
                      lengthList: [
                        myDayListLength,
                        taskListLength,
                        importantListLength
                      ],
                    ),
                  )
                : null,
            floatingActionButton: maxWidth <= 992 && !focusNode.hasFocus
                ? FloatingActionButton(
                    onPressed: () => focusNode.requestFocus(),
                    backgroundColor: getOptionProperties(value)['iconColor'],
                    tooltip: 'Add task',
                    child: const Icon(
                      Icons.add,
                      color: Colors.white,
                    ),
                  )
                : null,
          ),
        ));
  }

  PreferredSizeWidget myAppBar() {
    return AppBar(
      centerTitle: true,
      title: const Text('Todo'),
      actions: [
        PopupMenuButton(
          itemBuilder: (context) {
            return [
              PopupMenuItem(
                child: const Text('Item one'),
                onTap: () => Navigator.push(context,
                    MaterialPageRoute(builder: (context) => const TestPage())),
              ),
              const PopupMenuItem(child: Text('Item two')),
            ];
          },
        )
      ],
    );
  }
}
