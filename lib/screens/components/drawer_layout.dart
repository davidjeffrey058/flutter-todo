import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:todo/bloc/task_list_bloc.dart';
import 'package:todo/screens/components/boxes.dart';
import '../../Cubit/drawer_cubit.dart';
import '../home.dart';
import 'methods.dart';

class DrawerLayout extends StatelessWidget {
  final DrawerOptions drawerOption;
  final List<DrawerOptions> options;
  final bool popDrawer;

  const DrawerLayout({
    super.key,
    required this.options,
    required this.drawerOption,
    this.popDrawer = true,
  });

  @override
  Widget build(BuildContext context) {

    final drawerCubit = BlocProvider.of<DrawerCubit>(context);
    final navigator = Navigator.of(context);

    return SafeArea(
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
                      style:
                          TextStyle(fontSize: 15, fontWeight: FontWeight.w500),
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
                //int index = options.indexOf(option);
                return Container(
                  margin: const EdgeInsets.only(bottom: 5),
                  child: Material(
                    color: drawerOption == option
                        ? getOptionProperties(option)['iconColor']
                            .withOpacity(0.1)
                        : Colors.transparent,
                    child: InkWell(
                      onTap: () async {
                        int drawerIndex = 0;
                        switch(option){
                          case DrawerOptions.myDay:
                            drawerIndex = 1;
                          case DrawerOptions.tasks:
                            drawerIndex = 2;
                          case DrawerOptions.important:
                            drawerIndex = 3;
                        }
                        await configBox.put('drawerValue', drawerIndex);
                        drawerCubit.selectedOption(option);
                        if (popDrawer) navigator.pop();
                      },
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 8.0, vertical: 10),
                        child: Row(
                          children: [
                            Icon(
                              getOptionProperties(option)['iconData'],
                              color: getOptionProperties(option)['iconColor'],
                            ),
                            const SizedBox(
                              width: 10,
                            ),
                            Text(getOptionProperties(option)['title']),
                            const Expanded(
                              child: SizedBox(),
                            ),
                            BlocBuilder<TaskListBloc, TaskListState>(
                              bloc: TaskListBloc(),
                              builder: (context, state) {
                                int categoryTaskListLength =
                                    categoryList(option, state.tasks).length +
                                        categoryList(option, state.tasks,
                                                isEmptyList: true)
                                            .length;
                                return Text(
                                  categoryTaskListLength <= 0
                                      ? ''
                                      : '$categoryTaskListLength',
                                  style: const TextStyle(color: Colors.grey),
                                );
                              },
                            )
                          ],
                        ),
                      ),
                    ),
                  ),
                );
              }).toList(),
            )
          ],
        ),
      ),
    );
  }
}
