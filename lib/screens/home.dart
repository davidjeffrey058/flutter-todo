import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive/hive.dart';
import 'package:todo/Cubit/drawer_cubit.dart';
import 'package:todo/Cubit/tasks_list_cubit.dart';
import 'package:todo/components/addTaskLayout.dart';
import 'package:todo/components/boxes.dart';
import 'package:todo/components/category_title.dart';
import 'package:todo/components/drawer_option_layout.dart';
import 'package:todo/components/empty_message_widget.dart';
import 'package:todo/components/task_container.dart';
import 'package:todo/models/task_model.dart';
import 'package:todo/screens/test_page.dart';

import '../components/methods.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}
late int myDayListLength;
late int taskListLength;
late int importantListLength;
late TextEditingController _controller;
late FocusNode _focusNode;
late TextEditingController _editingController;
late ScrollController _scrollController;
// late List<Map> taskList;
// late List<Map> myDayList;
// late List<Map> importantList;

List<TaskModel> completedTasks = [];
final List<DrawerOptions> options = [
  DrawerOptions.myDay,
  DrawerOptions.tasks,
  DrawerOptions.important
];

class _HomeState extends State<Home> {
  @override
  void initState() {
    super.initState();
    _controller = TextEditingController();
    _controller.addListener(() => setState(() {}));
    _focusNode = FocusNode();
    _editingController = TextEditingController();
    _scrollController = ScrollController();
  }

  @override
  void dispose() {
    super.dispose();
    _controller.dispose();
    _focusNode.dispose();
    _editingController.dispose();
    _scrollController.dispose();
  }

  @override
  Widget build(BuildContext context) {

    var listCubit = BlocProvider.of<TasksListCubit>(context);
    var drawerCubit = BlocProvider.of<DrawerCubit>(context);
    myDayListLength = categoryList(DrawerOptions.myDay, boxTasks).length;
    taskListLength = categoryList(DrawerOptions.tasks, boxTasks).length;
    importantListLength = categoryList(DrawerOptions.important, boxTasks).length;

    return BlocBuilder<DrawerCubit, DrawerOptions>(
      builder: (context, value) {
        return GestureDetector(
          onTap: () => _focusNode.unfocus(),
          child: Container(
            decoration: BoxDecoration(
                image: DecorationImage(
                    image: AssetImage(
                        'images/${getOptionProperties(value)['backgroundImage']}'),
                    fit: BoxFit.cover)),
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
                          onTap: () => Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => const TestPage())),
                        ),
                        const PopupMenuItem(child: Text('Item two')),
                      ];
                    },
                  )
                ],
              ),
              body: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    child: CategoryTitle(
                      properties: getOptionProperties(value),
                    ),
                  ),
                  BlocBuilder<TasksListCubit, Box>(
                    builder: (context, state) {
                      if (categoryList(value, state).isEmpty) {
                        return EmptyMessageWidget(
                            imageName: getOptionProperties(value)['emptyMessageImage'],
                            message: getOptionProperties(value)['emptyMessage']
                        );
                      } else {
                        return Expanded(
                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 10.0),
                            child: ListView.builder(
                              controller: _scrollController,
                              shrinkWrap: true,
                              itemCount: categoryList(value, state).length,
                              itemBuilder: (context, index) {
                                Map task = categoryList(value, state)[index];
                                // TaskModel task = state.getAt(index);
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
                                      checkedOnPressed: () => setState(() => listCubit.updateState(task['key'], true)),
                                      importantOnPressed: () => setState(() => listCubit.updateState(task['key'], false)),
                                      onDismissed: (DismissDirection direction) {
                                        if (direction == DismissDirection.endToStart) {
                                          setState(() => listCubit.removeTask(task['key']));
                                          ScaffoldMessenger.of(context)
                                              .showSnackBar(const SnackBar(
                                            content: Text('Task Deleted'),
                                            duration: Duration(seconds: 1),
                                          ));
                                        }
                                      },
                                      confirmDismiss: (DismissDirection direction) async {
                                        if (direction ==
                                            DismissDirection.startToEnd) {
                                          // _focusNode.requestFocus();
                                          _editingController.text = task['task'];

                                          showDialog(context: context, builder: (context){
                                            return AlertDialog(
                                              title: const Text('Edit task'),
                                              content: Column(
                                                mainAxisSize: MainAxisSize.min,
                                                children: [
                                                  TextFormField(
                                                    minLines: 2,
                                                    maxLines: 3,
                                                    controller: _editingController,
                                                    autofocus: true,
                                                  )
                                                ],
                                              ),
                                              actions: [
                                                OutlinedButton(onPressed: (){
                                                  setState(() {
                                                    listCubit.updateTask(task['key'], _editingController.text);
                                                  });

                                                  Navigator.pop(context);
                                                }, child: const Text('Save')),
                                                OutlinedButton(onPressed: () => Navigator.pop(context), child: const Text('Cancel'))
                                              ],
                                            );
                                          });
                                          return false;
                                        }
                                        if (direction ==
                                            DismissDirection.endToStart) {
                                          // late bool result;
                                          // showDialog(context: context, builder: (context){
                                          //   return AlertDialog(
                                          //     title: const Text('Confirm delete'),
                                          //     content: const Text('Do you want to delete the task?'),
                                          //     actions: [
                                          //       ElevatedButton(
                                          //         onPressed: (){
                                          //           Navigator.of(context).pop();
                                          //           result = false;
                                          //         },
                                          //         child: const Text('Cancel'),
                                          //       ),
                                          //       ElevatedButton(
                                          //         onPressed: (){
                                          //           Navigator.of(context).pop();
                                          //           result = true;
                                          //         },
                                          //         child: const Text('Yes'),
                                          //       )
                                          //     ],
                                          //   );
                                          // });

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
                  AddTaskLayout(
                    scrollController: _scrollController,
                    iconColor: getOptionProperties(value)['iconColor'],
                    category: getOptionProperties(value)['title'],
                    focusNode: _focusNode,
                    controller: _controller,
                    value: value,
                    listCubit: listCubit,
                  ),
                ],
              ),
              drawer: Drawer(
                child: SafeArea(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      children: [
                        Row(
                          children: [
                            Container(
                              width: 50,
                              height: 50,
                              decoration: const BoxDecoration(
                                  shape: BoxShape.circle, color: Colors.blue),
                              child: Center(
                                  child: Text(
                                'dj'.toUpperCase(),
                                style: const TextStyle(color: Colors.white),
                              )),
                            ),
                            const SizedBox(
                              width: 10,
                            ),
                            const Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'David Jeffrey',
                                  style: TextStyle(
                                      fontSize: 15,
                                      fontWeight: FontWeight.w500),
                                ),
                                Text(
                                  'davidjeffrey058@gmail.com',
                                  style: TextStyle(
                                    fontSize: 11,
                                  ),
                                ),
                              ],
                            )
                          ],
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        ListView(
                          shrinkWrap: true,
                          children: options.map((option) {
                            return Container(
                              margin: const EdgeInsets.only(bottom: 5),
                              child: DrawerOptionLayout(
                                name: getOptionProperties(option)['title'],
                                icon: getOptionProperties(option)['iconData'],
                                color: getOptionProperties(option)['iconColor'],
                                isSelected: option == value,
                                optionOnPressed: () {
                                  drawerCubit.selectedOption(option);
                                  Navigator.pop(context);
                                },
                                listLength: returnLength(option),
                              ),
                            );
                          }).toList(),
                        )
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}

enum DrawerOptions {
  myDay,
  tasks,
  important,
}

int returnLength(DrawerOptions option){
  switch(option){
    case DrawerOptions.myDay:
      return myDayListLength;
    case DrawerOptions.tasks:
      return taskListLength;
    case DrawerOptions.important:
      return importantListLength;
  }
}

enum TaskOptions { delete, edit }
