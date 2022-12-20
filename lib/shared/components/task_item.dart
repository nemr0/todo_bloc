import 'package:flutter/material.dart';
import 'package:todo_bloc/models/task_status_enum.dart';
import 'package:todo_bloc/shared/cubit/home_cubit.dart';

class TaskItem extends StatelessWidget {
  const TaskItem({Key? key, this.task}) : super(key: key);
  final Map? task;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 150,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Card(
          child: Dismissible(
            background: Container(
              decoration: BoxDecoration(
                color: Colors.red,
                borderRadius: BorderRadius.circular(30),
              ),
              child: const Align(
                alignment: AlignmentDirectional.centerEnd,
                child: Icon(
                  Icons.delete,
                  size: 40,
                ),
              ),
            ),
            key: Key(task!['id'].toString()),
            onDismissed: (direction) =>
                HomeCubit.get(context).deleteTaskInDB(task!['id']),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Expanded(
                  flex: 2,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        task != null ? task!['time'] : 'HH:MM',
                        style: Theme.of(context).textTheme.labelMedium,
                      ),
                      Text(
                        task != null ? task!['date'] : 'DD/MM/YYYY',
                        style: Theme.of(context).textTheme.labelSmall,
                      )
                    ],
                  ),
                ),
                const VerticalDivider(
                  endIndent: 9,
                  indent: 9,
                  thickness: 1,
                ),
                Expanded(
                  flex: 3,
                  child: Row(
                    mainAxisSize: MainAxisSize.max,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Text(
                          task != null ? task!['title'] : 'Task Title',
                          style: Theme.of(context).textTheme.labelMedium,
                          maxLines: 4,
                        ),
                      ),
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          IconButton(
                            onPressed: (task!['status'] == TaskStatus.todo.name)
                                ? () => HomeCubit.get(context).updateTaskInDB(
                                    TaskStatus.done, task!['id'])
                                : null,
                            icon: Icon(
                              Icons.check_box,
                              size: 30,
                              color: (task!['status'] == TaskStatus.todo.name)
                                  ? Colors.green
                                  : Colors.black54,
                            ),
                          ),
                          IconButton(
                            onPressed: (task!['status'] !=
                                    TaskStatus.archived.name)
                                ? () => HomeCubit.get(context).updateTaskInDB(
                                    TaskStatus.archived, task!['id'])
                                : null,
                            icon: Icon(
                              Icons.archive,
                              color:
                                  (task!['status'] != TaskStatus.archived.name)
                                      ? Colors.blueGrey
                                      : Colors.black54,
                              size: 30,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
