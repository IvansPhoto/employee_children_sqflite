import 'package:flutter/material.dart';
import 'package:employee_children_sqflite/Classes.dart';
import 'package:employee_children_sqflite/Support.dart';
import 'package:employee_children_sqflite/GlobalStore.dart';
import 'package:employee_children_sqflite/SupportWidgets/DeleteConfirmation.dart';

class ActionButtons extends StatelessWidget {
  final Employees employee;
  final Children child;

  ActionButtons({this.employee, this.child});

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: <Widget>[
        //Button for editing the employee in the Form
        FlatButton.icon(
          onPressed: () async {
            if (employee != null) {
              //Go to the page for editing of the employee and await the message 'updated' or null. Arguments initializes a state of the form.
              final message = await Navigator.of(context).pushNamed(RouteNames.newEmployee, arguments: false);
              if (message != null)
                Scaffold.of(context)
                  ..removeCurrentSnackBar()
                  ..showSnackBar(SnackBar(
                    content: Text('${employee.name} ${employee.surName}'),
                    duration: Duration(seconds: 1),
                  ));
            }
            if (child != null) {
              //Go to the page for editing of the employee and await the message 'updated' or null. Arguments initializes a state of the form.
              final message = await Navigator.of(context).pushNamed(RouteNames.newChildren, arguments: false);
              if (message != null)
                Scaffold.of(context)
                  ..removeCurrentSnackBar()
                  ..showSnackBar(SnackBar(
                    content: Text('${child.name} ${child.surName} ${message ?? ''}'),
                    duration: Duration(seconds: 1),
                  ));
            }
          },
          icon: Icon(Icons.edit),
          label: Text('Edit'),
        ),
        //Button for show dialog to delete a record.
        FlatButton.icon(
          onPressed: () => showDialog(
            context: context,
            child: DeleteConfirmation(employee: employee, child: child),
            useSafeArea: true,
          ),
          icon: Icon(Icons.delete_forever),
          label: Text('Delete'),
        )
      ],
    );
  }
}
