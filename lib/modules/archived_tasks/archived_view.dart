import 'package:flutter/material.dart';

class ArchivedView extends StatelessWidget {
  const ArchivedView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text(
        'Archived Tasks',
        style: Theme.of(context).textTheme.labelMedium,
      ),
    );
  }
}
