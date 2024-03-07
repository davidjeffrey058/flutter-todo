import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:todo/bloc/ThemeBloc/theme_bloc.dart';
import 'package:todo/screens/components/boxes.dart';
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
  final void Function()? gestureDetectorOnTap;
  final DrawerOptions value;
  final ScrollController scrollController;
  final TaskListBloc listBloc;
  final TextEditingController editingController;
  final TextEditingController controller;
  final FocusNode focusNode;

  const HomeLayout({
    super.key,
    this.gestureDetectorOnTap,
    required this.value,
    required this.scrollController,
    required this.listBloc,
    required this.editingController,
    required this.controller,
    required this.focusNode,
  });

  @override
  Widget build(BuildContext context) {

    final maxWidth = MediaQuery.of(context).size.width;
    // final maxHeight = MediaQuery.of(context).size.height;
    final navigator = Navigator.of(context);
    final readThemeBloc = context.read<ThemeBloc>();


    return GestureDetector(
        onTap: gestureDetectorOnTap,
        child: Container(
          decoration: BoxDecoration(
            image: DecorationImage(
                image: AssetImage(
                    'images/${getOptionProperties(value)['backgroundImage']}'),
                fit: BoxFit.cover),
          ),
          child: Scaffold(
            backgroundColor: Colors.transparent,
            appBar: AppBar(
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
                      PopupMenuItem(
                        child: SwitchListTile(
                          title: const Text('Dark mode'),
                          value: context.read<ThemeBloc>().state == ThemeMode.dark,
                          onChanged: (value) async {
                            await configBox.put('isDark', value);
                            navigator.pop();
                            if(!value){
                              readThemeBloc.add(LightModeTheme());
                            } else {
                              readThemeBloc.add(DarkModeTheme());
                            }

                          },
                        ),
                      ),
                    ];
                  },
                )
              ],
            ),
            body: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // Category title
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  child: CategoryTitle(
                    properties: getOptionProperties(value),
                  ),
                ),

                // List of Tasks section
                BlocBuilder<TaskListBloc, TaskListState>(
                  builder: (context, state) {
                    final emptyList =
                        categoryList(value, state.tasks, isEmptyList: true);

                    if (categoryList(value, state.tasks).isEmpty &&
                        emptyList.isEmpty) {
                      return EmptyMessageWidget(
                          imageName:
                              getOptionProperties(value)['emptyMessageImage'],
                          message: getOptionProperties(value)['emptyMessage']);
                    } else {
                      return Expanded(
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 10),
                          child: SingleChildScrollView(
                            controller: scrollController,
                            child: Column(
                              children: [
                                taskListLayout(state, false),
                                const SizedBox(
                                  height: 10,
                                ),

                                // Task completed section
                                if (emptyList.isNotEmpty)
                                  Align(
                                    alignment: Alignment.centerLeft,
                                    child: Container(
                                      width: 140,
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 10,
                                        vertical: 5,
                                      ),
                                      decoration: BoxDecoration(
                                          color: Colors.black.withOpacity(0.4),
                                          borderRadius:
                                              BorderRadius.circular(10)),
                                      child: Row(
                                        children: [
                                          Text(
                                            'Completed  (${emptyList.length})',
                                            style: const TextStyle(
                                              color: Colors.white,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                          const Spacer(),
                                          const Icon(
                                            Icons.keyboard_arrow_down_rounded,
                                            color: Colors.white,
                                          )
                                        ],
                                      ),
                                    ),
                                  ),
                                if (emptyList.isNotEmpty)
                                  SizedBox(
                                    child: taskListLayout(state, true),
                                  )
                              ],
                            ),
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



  taskListLayout(TaskListState state, bool isEmptyList) {
    return ListView.builder(
      primary: false,
      shrinkWrap: true,
      itemCount:
          categoryList(value, state.tasks, isEmptyList: isEmptyList).length,
      itemBuilder: (context, index) {
        Map task =
            categoryList(value, state.tasks, isEmptyList: isEmptyList)[index];
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
                if (direction == DismissDirection.endToStart) {
                  listBloc.add(DeleteTask(key: task['key']));
                  ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                    content: Text('Task Deleted'),
                    duration: Duration(seconds: 1),
                  ));
                }
              },
              confirmDismiss: (DismissDirection direction) async {
                if (direction == DismissDirection.startToEnd) {
                  editingController.text = task['task'];
                  showDialog(
                      context: context,
                      builder: (context) {
                        return AlertDialog(
                          title: const Text('Edit task'),
                          content: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              TextFormField(
                                minLines: 2,
                                maxLines: 3,
                                controller: editingController,
                                autofocus: true,
                              )
                            ],
                          ),
                          actions: [
                            OutlinedButton(
                                onPressed: () {
                                  listBloc.add(UpdateTask(
                                    task: TaskModel(
                                      task: editingController.text,
                                      isChecked: task['isChecked'],
                                      isImportant: task['isImportant'],
                                      category: task['category'],
                                    ),
                                    key: task['key'],
                                  ));

                                  Navigator.pop(context);
                                },
                                child: const Text('Save')),
                            OutlinedButton(
                                onPressed: () => Navigator.pop(context),
                                child: const Text('Cancel'))
                          ],
                        );
                      });
                  return false;
                }
                if (direction == DismissDirection.endToStart) {
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
    );
  }
}
