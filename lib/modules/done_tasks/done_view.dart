import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../shared/components/task_item.dart';
import '../../shared/cubit/home_cubit.dart';

class DoneView extends StatelessWidget {
  const DoneView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final double width = MediaQuery.of(context).size.width;
    return BlocConsumer<HomeCubit, HomeState>(
      builder: (BuildContext context, state) {
        List<Map> doneTasks = HomeCubit.get(context).doneTasks;

        if (state is CreateOrOpenDBState || state is LoadingDBState) {
          return const Center(
              child: SizedBox(
                  height: 30,
                  width: 30,
                  child: CircularProgressIndicator.adaptive()));
        }
        if (state is! CreateOrOpenDBState &&
            state is! LoadingDBState &&
            doneTasks.isEmpty) {
          return const Center(
            child: Text('No Done Tasks Yet.'),
          );
        }
        return ListView.separated(
            itemBuilder: (context, index) => TaskItem(
                  task: doneTasks[index],
                ),
            separatorBuilder: (context, index) => Divider(
                  indent: width * .09,
                  endIndent: width * .09,
                ),
            itemCount: doneTasks.length);
      },
      listener: (BuildContext context, Object? state) {},
    );
  }
}
