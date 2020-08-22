import 'package:flutter/material.dart';
import 'package:employee_children_sqflite/classes.dart';

class DeleteConfirmation extends StatelessWidget {
  final EmployeesData employee;
  final ChildrenData child;

  DeleteConfirmation({this.employee, this.child});

  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        key: _scaffoldKey,
        appBar: AppBar(
          elevation: 0,
          centerTitle: true,
          title: const Text('Confirmation'),
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Text('Are you sure to delete of:'),
              if (employee != null) Text('${employee.name} ${employee.surName}'),
              if (child != null) Text('${child.name} ${child.surName}'),
              FlatButton.icon(
                icon: const Icon(Icons.restore),
                label: const Text('Stay in the list!'),
                onPressed: () => Navigator.pop(context),
              ),
              FlatButton.icon(
                icon: Icon(Icons.delete_forever),
                label: const Text('Remove from the list!'),
                onPressed: () async {
                  if (employee != null) await employee.delete();
                  if (child != null) await child.delete();
                  Navigator.pop(context);
                  Navigator.pop(context);
                  _scaffoldKey.currentState
                    ..removeCurrentSnackBar()
                    ..showSnackBar(SnackBar(
                      content: const Text('The record has been deleted.'),
                      duration: Duration(seconds: 5),
                      elevation: 0,
                    ));
                },
              )
            ],
          ),
        ));
  }
}
