import 'package:flutter/material.dart';

class TaskItem extends StatelessWidget {
  const TaskItem({Key? key, this.task}) : super(key: key);
  final Map? task;
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 100,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Card(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          color: Colors.indigo.shade50,
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
                color: Colors.black87,
              ),
              Expanded(
                flex: 3,
                child: Text(
                  task != null ? task!['title'] : 'Task Title',
                  style: Theme.of(context).textTheme.labelMedium,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
