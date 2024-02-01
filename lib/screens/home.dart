import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:todo/Cubit/drawer_cubit.dart';
import 'package:todo/bloc/task_list_bloc.dart';
import 'package:todo/components/category_title.dart';
import 'package:todo/components/drawer_layout.dart';
import 'package:todo/components/empty_message_widget.dart';
import 'package:todo/components/task_container.dart';
import 'package:todo/models/task_model.dart';
import 'package:todo/screens/test_page.dart';

import '../components/add_task_layout.dart';
import '../components/methods.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}
int myDayListLength = 0;
int taskListLength = 0;
int importantListLength = 0;

late TextEditingController _controller;
late FocusNode _focusNode;
late TextEditingController _editingController;
late ScrollController _scrollController;

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

    var listBloc = BlocProvider.of<TaskListBloc>(context);

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
                  BlocBuilder<TaskListBloc, TaskListState>(
                    builder: (context, state) {

                      if (categoryList(value, state.tasks).isEmpty) {
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
                              itemCount: categoryList(value, state.tasks).length,
                              itemBuilder: (context, index) {
                                Map task = categoryList(value, state.tasks)[index];

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
                                        listBloc.add(UpdateTask(task: TaskModel(
                                          task: task['task'],
                                          isChecked: !task['isChecked'],
                                          isImportant: task['isImportant'],
                                          category: task['category']
                                        ), key: task['key'])
                                        );
                                      },
                                      importantOnPressed: (){
                                        listBloc.add(UpdateTask(task: TaskModel(
                                            task: task['task'],
                                            isChecked: task['isChecked'],
                                            isImportant: !task['isImportant'],
                                            category: task['category']
                                        ), key: task['key']));
                                      },
                                      onDismissed: (DismissDirection direction) {
                                        if (direction == DismissDirection.endToStart) {
                                          listBloc.add(DeleteTask(key: task['key']));
                                          ScaffoldMessenger.of(context)
                                              .showSnackBar(const SnackBar(
                                            content: Text('Task Deleted'),
                                            duration: Duration(seconds: 1),
                                          ));
                                        }
                                      },
                                      confirmDismiss: (DismissDirection direction) async {
                                        if (direction == DismissDirection.startToEnd) {

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
                                                  listBloc.add(UpdateTask(task: TaskModel(
                                                      task: _editingController.text,
                                                      isChecked: task['isChecked'],
                                                      isImportant: task['isImportant'],
                                                      category: task['category']
                                                  ), key: task['key']));

                                                  Navigator.pop(context);
                                                }, child: const Text('Save')),
                                                OutlinedButton(onPressed: () => Navigator.pop(context), child: const Text('Cancel'))
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
                    listBloc: listBloc,
                  ),
                ],
              ),


              drawer: DrawerLayout(
                options: options,
                drawerOption: value,
                lengthList: [myDayListLength, taskListLength, importantListLength],
              )
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
