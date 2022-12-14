import 'package:flutter/material.dart';
import 'package:todo_bloc/layout/home_layout.dart';

import '../../shared/components/task_item.dart';

class TasksView extends StatelessWidget {
  const TasksView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final double width = MediaQuery.of(context).size.width;
    return tasks.isEmpty
        ? const CircularProgressIndicator.adaptive()
        : ListView.separated(
            itemBuilder: (context, index) => TaskItem(
                  task: tasks[index],
                ),
            separatorBuilder: (context, index) => Divider(
                  indent: width * .09,
                  endIndent: width * .09,
                  color: Colors.indigo,
                ),
            itemCount: tasks.length);
  }
}
