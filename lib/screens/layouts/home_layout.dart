import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:todo/bloc/SelectionBloc/selection_bloc.dart';
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
import 'dart:math' as pi;

class HomeLayout extends StatefulWidget {
  final DrawerOptions value;

  const HomeLayout({
    super.key,
    required this.value,
  });

  @override
  State<HomeLayout> createState() => _HomeLayoutState();
}
late AnimationController _animationController;
late Animation animation;
late TextEditingController _controller;
late FocusNode _focusNode;
late TextEditingController _editingController;
late ScrollController _scrollController;
late bool isOpened;

class _HomeLayoutState extends State<HomeLayout> with SingleTickerProviderStateMixin{

  @override
  void initState() {
    super.initState();
    isOpened = false;
    _controller = TextEditingController();
    _controller.addListener(() => setState(() {}));
    _focusNode = FocusNode();
    _focusNode.addListener(() => setState(() {}));
    _editingController = TextEditingController();
    _scrollController = ScrollController();
    _animationController = AnimationController(vsync: this, duration: const Duration(milliseconds: 200));
    animation = Tween(begin: 0, end: 1).animate(_animationController);
  }

  @override
  void dispose() {
    super.dispose();
    _controller.dispose();
    _focusNode.dispose();
    _editingController.dispose();
    _scrollController.dispose();
    _animationController.dispose();
    TaskListBloc().close();
    SelectionBloc().close();
  }

  @override
  Widget build(BuildContext context) {

    final maxWidth = MediaQuery.of(context).size.width;
    final navigator = Navigator.of(context);
    final readThemeBloc = context.read<ThemeBloc>();
    TaskListBloc listBloc = BlocProvider.of<TaskListBloc>(context);
    // final theme = Theme.of(context);
    final readSelectionBloc = context.read<SelectionBloc>();

    return BlocBuilder<SelectionBloc, SelectionState>(
      bloc: SelectionBloc(),
      builder: (context, state) {
        return GestureDetector(
            onTap: () => _focusNode.unfocus(),
            child: Container(
              decoration: BoxDecoration(
                image: DecorationImage(
                    image: AssetImage(
                        'images/${getOptionProperties(widget.value)['backgroundImage']}'),
                    fit: BoxFit.cover),
              ),
              child: Scaffold(
                backgroundColor: Colors.transparent,
                appBar: AppBar(
                  centerTitle: state.selectedList.isEmpty ? true : false,
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
                        properties: getOptionProperties(widget.value),
                      ),
                    ),

                    // List of Tasks section
                    BlocBuilder<TaskListBloc, TaskListState>(
                      builder: (context, state) {
                        final emptyList =
                            categoryList(widget.value, state.tasks, isEmptyList: true);

                        if (categoryList(widget.value, state.tasks).isEmpty &&
                            emptyList.isEmpty) {
                          return EmptyMessageWidget(
                              imageName:
                                  getOptionProperties(widget.value)['emptyMessageImage'],
                              message: getOptionProperties(widget.value)['emptyMessage']);
                        } else {
                          return Expanded(
                            child: Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 10),
                              child: SingleChildScrollView(
                                controller: _scrollController,
                                child: Column(
                                  children: [
                                    taskListLayout(state, false, listBloc, readSelectionBloc),
                                    const SizedBox(
                                      height: 10,
                                    ),

                                    // Task completed section
                                    if (emptyList.isNotEmpty)AnimatedBuilder(
                                      animation: animation,
                                      builder: (context, child) {
                                        return Column(
                                          children: [
                                            Align(
                                              alignment: Alignment.centerLeft,
                                              child: InkWell(
                                                onTap: () {
                                                  if(!isOpened){
                                                    _animationController.forward();
                                                  } else{
                                                    _animationController.reverse();
                                                  }
                                                  setState(() => isOpened = !isOpened);
                                                },
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
                                                      Transform(
                                                        alignment: Alignment.center,
                                                        transform: Matrix4.rotationZ((_animationController.value * 90) * (pi.pi / 180)),
                                                        child: const Icon(
                                                          Icons.keyboard_arrow_right,
                                                          color: Colors.white,
                                                        ),
                                                      )
                                                    ],
                                                  ),
                                                ),
                                              ),
                                            ),
                                            SizedBox(
                                              // color: Colors.grey,
                                              height: emptyListHeight(_animationController.value, emptyList.length),
                                              child: taskListLayout(state, true, listBloc, readSelectionBloc),
                                            )
                                          ],
                                        );
                                      }
                                    ),
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
                      height: maxWidth <= 992 && !_focusNode.hasFocus ? 0 : null,
                      child: AddTaskLayout(
                        scrollController: _scrollController,
                        iconColor: getOptionProperties(widget.value)['iconColor'],
                        category: getOptionProperties(widget.value)['title'],
                        focusNode: _focusNode,
                        controller: _controller,
                        value: widget.value,
                        listBloc: listBloc,
                      ),
                    ),
                  ],
                ),
                drawer: maxWidth <= 992
                    ? Drawer(
                        child: DrawerLayout(
                          options: options,
                          drawerOption: widget.value,
                        ),
                      )
                    : null,
                floatingActionButton: maxWidth <= 992 && !_focusNode.hasFocus
                    ? FloatingActionButton(
                        onPressed: () => _focusNode.requestFocus(),
                        backgroundColor: getOptionProperties(widget.value)['iconColor'],
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
    );
  }

  taskListLayout(TaskListState state, bool isEmptyList, TaskListBloc listBloc, SelectionBloc readSelectionBloc) {
    return ListView.builder(
      primary: false,
      shrinkWrap: true,
      itemCount:
          categoryList(widget.value, state.tasks, isEmptyList: isEmptyList).length,
      itemBuilder: (context, index) {
        Map task =
            categoryList(widget.value, state.tasks, isEmptyList: isEmptyList)[index];
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
              onLongPressed: (){
                readSelectionBloc.add(Select(id: task['key']));
              },
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
                  _editingController.text = task['task'];
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
                                controller: _editingController,
                                autofocus: true,
                              )
                            ],
                          ),
                          actions: [
                            OutlinedButton(
                                onPressed: () {
                                  listBloc.add(UpdateTask(
                                    task: TaskModel(
                                      task: _editingController.text,
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

  double emptyListHeight(double animationValue, int listLength){
    return ((_animationController.value * 90) * listLength);
  }
}
