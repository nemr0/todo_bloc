import 'package:flutter/material.dart';

class DoneView extends StatelessWidget {
  const DoneView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text(
        'Done Tasks',
        style: Theme.of(context).textTheme.labelMedium,
      ),
    );
  }
}
