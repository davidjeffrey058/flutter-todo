import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:todo/components/boxes.dart';
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

late DrawerOptions selectedOption;
late TextEditingController _controller;
late GlobalKey formKey;

List<TaskModel> tasks = [];
List<TaskModel> completedTasks = [];

List<DrawerOptions> options = [
  DrawerOptions.myDay,
  DrawerOptions.tasks,
  DrawerOptions.important
];

class _HomeState extends State<Home> {
  @override
  void initState() {
    super.initState();
    selectedOption = DrawerOptions.tasks;
    formKey = GlobalKey<FormState>();
    _controller = TextEditingController();
    _controller.addListener(() => setState(() {}));

    if (kDebugMode) {
      print('Total items: ${boxTasks.length}');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
          image: DecorationImage(
              image: AssetImage('images/sea.jpg'), fit: BoxFit.cover)),
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
                    const Row(
                      children: [
                        Icon(
                          Icons.task,
                          size: 30,
                          color: Colors.white,
                        ),
                        SizedBox(
                          width: 10,
                        ),
                        Text(
                          'Tasks',
                          style: TextStyle(
                              fontSize: 30,
                              color: Colors.white,
                              fontWeight: FontWeight.w500),
                        )
                      ],
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
                            TaskContainer(
                              dismissibleKey: ValueKey(boxTasks.keyAt(index)),
                              item: task,
                              index: index,
                              checkedOnPressed: () =>
                                  setState(() => updateState(index, true)),
                              importantOnPressed: () =>
                                  setState(() => updateState(index, false)),
                              onDismissed: (direction) {
                                setState(() => removeTask(index));
                                ScaffoldMessenger.of(context)
                                    .showSnackBar(const SnackBar(
                                  content: Text('Task Deleted'),
                                  duration: Duration(seconds: 1),
                                ));
                              },
                            ),
                            const SizedBox(height: 5,)
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
                      Form(
                        key: formKey,
                        child: Row(
                          children: [
                            Flexible(
                              child: TextFormField(
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
                                          : Colors.blue),
                                  shape: MaterialStatePropertyAll(
                                      RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(10)))),
                              onPressed: _controller.text.isEmpty
                                  ? null
                                  : () {
                                      setState(() {
                                        addTask(
                                            '${boxTasks.length}',
                                            TaskModel(
                                                task: _controller.text,
                                                isChecked: false,
                                                isImportant: false,
                                                category: determineCategory()));
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
                          name: getOptionText(option),
                          icon: getOptionIcon(option),
                          color: getOptionIconColor(option),
                          isSelected: option == selectedOption,
                          optionOnPressed: () {
                            setState(() => selectedOption = option);
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
    );
  }

  String determineCategory() {
    switch (selectedOption) {
      case DrawerOptions.tasks:
        return 'tasks';
      case DrawerOptions.myDay:
        return 'myDay';
      case DrawerOptions.important:
        return 'important';
    }
  }
}

enum DrawerOptions {
  myDay,
  tasks,
  important,
}

enum TaskOptions { delete, edit }
