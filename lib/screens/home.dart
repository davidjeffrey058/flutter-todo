import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:todo/Cubit/drawer_cubit.dart';
import 'package:todo/components/boxes.dart';
import 'package:todo/components/category_title.dart';
import 'package:todo/components/drawer_option_layout.dart';
import 'package:todo/components/task_container.dart';
import 'package:todo/models/task_model.dart';

import '../components/custom_button.dart';
import '../components/methods.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

// late DrawerOptions selectedOption;
late TextEditingController _controller;
late FocusNode _focusNode;

List<TaskModel> tasks = [];
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
    // selectedOption = DrawerOptions.tasks;
    _controller = TextEditingController();
    _controller.addListener(() => setState(() {}));
    _focusNode = FocusNode();
  }

  @override
  void dispose() {
    super.dispose();
    _controller.dispose();
    _focusNode.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<DrawerCubit, DrawerOptions>(
      builder: (context, value){
        return GestureDetector(
          onTap: () => _focusNode.unfocus(),
          child: Container(
            decoration: BoxDecoration(
                image: DecorationImage(
                    image: AssetImage('images/${getOptionProperties(value)['backgroundImage']}'),
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
                        const PopupMenuItem(child: Text('Item one')),
                        const PopupMenuItem(child: Text('Item two')),
                      ];
                    },
                  )
                ],
              ),
              body: Column(
                children: [
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 10.0),
                      child: ListView(
                        shrinkWrap: true,
                        children: [
                          CategoryTitle(
                            properties: getOptionProperties(value),
                          ),
                          ListView.builder(
                            primary: false,
                            shrinkWrap: true,
                            itemCount: boxTasks.length,
                            itemBuilder: (context, index) {
                              // var item = tasks[index];
                              TaskModel task = boxTasks.getAt(index);

                              return Column(
                                children: [
                                  if (index == 0)
                                    const SizedBox(
                                      height: 5,
                                    ),
                                  TaskContainer(
                                    dismissibleKey: ValueKey(boxTasks.keyAt(index)),
                                    item: task,
                                    index: index,
                                    checkedOnPressed: () =>
                                        setState(() => updateState(index, true)),
                                    importantOnPressed: () =>
                                        setState(() => updateState(index, false)),
                                    onDismissed: (DismissDirection direction) {
                                      if(direction == DismissDirection.startToEnd){

                                      }
                                      if(direction == DismissDirection.endToStart){
                                        setState(() => removeTask(index));
                                        ScaffoldMessenger.of(context)
                                            .showSnackBar(const SnackBar(
                                          content: Text('Task Deleted'),
                                          duration: Duration(seconds: 1),
                                        ));
                                      }

                                    },
                                  ),
                                  const SizedBox(
                                    height: 5,
                                  )
                                ],
                              );
                            },
                          ),
                          if (completedTasks.isNotEmpty)
                            ExpansionTile(
                              title: Text('Completed (${completedTasks.length})'),
                              collapsedBackgroundColor: Colors.black38,
                              textColor: Colors.white,
                              collapsedTextColor: Colors.white,
                              collapsedIconColor: Colors.white,
                              iconColor: Colors.white,
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10)),
                              collapsedShape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10)),
                              children: completedTasks.map((e) {
                                int index = tasks.indexOf(e);
                                return TaskContainer(
                                  index: index,
                                  item: e,
                                  dismissibleKey: ValueKey(boxTasks.keyAt(index)),
                                );
                              }).toList(),
                            )
                        ],
                      ),
                    ),
                  ),

                  //Add task section
                  SizedBox(
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
                                    focusNode: _focusNode,
                                    textCapitalization:
                                    TextCapitalization.sentences,
                                    decoration: const InputDecoration(
                                        prefixIcon: Icon(Icons.circle_outlined),
                                        hintText: 'Add a task',
                                        border: InputBorder.none),
                                    controller: _controller,
                                    onSaved: (value) {},
                                  ),
                                ),
                                IconButton(
                                  style: ButtonStyle(
                                      backgroundColor: MaterialStatePropertyAll(
                                          _controller.text.isEmpty
                                              ? Colors.grey[400]
                                              : getOptionProperties(value)['iconColor']),
                                      shape: MaterialStatePropertyAll(
                                          RoundedRectangleBorder(
                                              borderRadius:
                                              BorderRadius.circular(10)))),
                                  onPressed: _controller.text.isEmpty
                                      ? null
                                      : () {
                                    setState(() {
                                      addTask(
                                          TaskModel(
                                              task: _controller.text,
                                              isChecked: false,
                                              isImportant: false,
                                              category: value ==
                                                  DrawerOptions.important
                                                  ? 'Tasks'
                                                  : getOptionProperties(value)['title'])
                                      );
                                    });
                                    _controller.clear();
                                  },
                                  icon: const Icon(
                                    Icons.arrow_upward,
                                    color: Colors.white,
                                  ),
                                ),
                              ],
                            ),
                            if (_controller.text.isNotEmpty)
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
                                      fontSize: 15, fontWeight: FontWeight.w500),
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
                                  BlocProvider.of<DrawerCubit>(context).selectedOption(option);
                                  Navigator.pop(context);
                                },
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

enum TaskOptions { delete, edit }
