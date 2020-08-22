import 'package:flutter/material.dart';
import 'package:employee_children_sqflite/classes.dart';
import 'package:employee_children_sqflite/pages/DeleteConfirmation.dart';

class ActionButtonsChild extends StatelessWidget {
  final ChildrenData child;
  ActionButtonsChild({this.child});
  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        FlatButton.icon(
          onPressed: () => Navigator.of(context).pushNamed(RouteNames.newChildren, arguments: child),
          icon: Icon(Icons.edit),
          label: Text('Edit'),
        ),
        FlatButton.icon(
          onPressed: () => Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => DeleteConfirmation(child: child), fullscreenDialog: true),
          ),
          icon: Icon(Icons.delete_forever),
          label: Text('Delete'),
        )
      ],
    );

  }
}
