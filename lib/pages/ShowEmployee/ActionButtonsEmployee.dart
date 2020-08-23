import 'package:flutter/material.dart';
import 'package:employee_children_sqflite/classes.dart';
import 'package:employee_children_sqflite/GlobalStore.dart';
import 'package:employee_children_sqflite/pages/DeleteConfirmation.dart';

class ActionButtons extends StatelessWidget {
  final Employees employee;

  ActionButtons({this.employee});

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
      	//Button for editing the employee in the Form
        FlatButton.icon(
          onPressed: () {
            Navigator.of(context).pushNamed(RouteNames.newEmployee);
          },
          icon: Icon(Icons.edit),
          label: Text('Edit'),
        ),
	      //Button for show dialog to delete the employee
	      FlatButton.icon(
          onPressed: () => Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => DeleteConfirmation(employee: employee), fullscreenDialog: true),
          ),
          icon: Icon(Icons.delete_forever),
          label: Text('Delete'),
        )
      ],
    );
  }
}
