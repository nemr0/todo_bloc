import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:todo_bloc/layout/home_layout.dart';
import 'package:todo_bloc/shared/cubit/home_cubit.dart';

import '../../shared/components/task_item.dart';

class TasksView extends StatelessWidget {
  const TasksView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final double width = MediaQuery.of(context).size.width;
    return BlocConsumer<HomeCubit, HomeState>(
      builder: (BuildContext context, state) {
        List<Map> newTasks = HomeCubit.get(context).newTasks;

        if (state is CreateOrOpenDBState || state is LoadingDBState) {
          return const Center(
              child: SizedBox(
                  height: 30,
                  width: 30,
                  child: CircularProgressIndicator.adaptive()));
        }
        if (newTasks.isEmpty) {
          return const Center(
            child: Text('No Available Tasks Yet.'),
          );
        }
        return ListView.separated(
            itemBuilder: (context, index) => TaskItem(
                  task: newTasks[index],
                ),
            separatorBuilder: (context, index) => Divider(
                  indent: width * .09,
                  endIndent: width * .09,
                ),
            itemCount: newTasks.length);
      },
      listener: (BuildContext context, Object? state) {},
    );
  }
}
