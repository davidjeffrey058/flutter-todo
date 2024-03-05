import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:todo/Cubit/drawer_cubit.dart';
import 'package:todo/bloc/task_list_bloc.dart';
import 'package:todo/models/task_model.dart';
import 'package:todo/screens/layouts/home_layout.dart';
import 'components/drawer_layout.dart';


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
    _focusNode.addListener(() => setState(() {}));
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
    TaskListBloc listBloc = BlocProvider.of<TaskListBloc>(context);

    return BlocBuilder<DrawerCubit, DrawerOptions>(
      builder: (context, value) {
        return LayoutBuilder(
          builder: (context, constraint) {
            if (constraint.maxWidth <= 992) {
              return HomeLayout(
                gestureDetectorOnTap: () => _focusNode.unfocus(),
                value: value,
                scrollController: _scrollController,
                listBloc: listBloc,
                editingController: _editingController,
                controller: _controller,
                focusNode: _focusNode,
              );
            } else {
              return Scaffold(
                backgroundColor: Colors.transparent,
                body: Row(
                  children: [
                    SizedBox(
                      width: 300,
                      child: Material(
                        child: DrawerLayout(
                          options: options,
                          drawerOption: value,
                          popDrawer: false,
                        ),
                      ),
                    ),
                    Expanded(
                      child: HomeLayout(
                        gestureDetectorOnTap: () => _focusNode.unfocus(),
                        value: value,
                        scrollController: _scrollController,
                        listBloc: listBloc,
                        editingController: _editingController,
                        controller: _controller,
                        focusNode: _focusNode,
                      )
                    )
                  ],
                ),
              );
            }
          },
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

int returnLength(DrawerOptions option) {
  switch (option) {
    case DrawerOptions.myDay:
      return myDayListLength;
    case DrawerOptions.tasks:
      return taskListLength;
    case DrawerOptions.important:
      return importantListLength;
  }
}

enum TaskOptions { delete, edit }
