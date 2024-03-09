import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:todo/Cubit/drawer_cubit.dart';
import 'package:todo/models/task_model.dart';
import 'package:todo/screens/layouts/home_layout.dart';
import 'components/drawer_layout.dart';


class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

List<TaskModel> completedTasks = [];

final List<DrawerOptions> options = [
  DrawerOptions.myDay,
  DrawerOptions.tasks,
  DrawerOptions.important
];

class _HomeState extends State<Home>{
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<DrawerCubit, DrawerOptions>(
      builder: (context, value) {
        return LayoutBuilder(
          builder: (context, constraint) {
            if (constraint.maxWidth <= 992) {
              return HomeLayout(value: value,);
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
                      child: HomeLayout(value: value,),
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

