import 'package:flutter/material.dart';
import 'package:employee_children_sqflite/classes.dart';
import 'package:employee_children_sqflite/GlobalStore.dart';

class DeleteConfirmation extends StatelessWidget {
  final Employees employee;
  final Children child;

  DeleteConfirmation({this.employee, this.child});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
                  if (employee != null) gStore<GlobalStore>().deleteEmployee(employee);
//                  if (child != null) await child.delete(); //TODO: Deleting of the records for childrenList
                  Navigator.pop(context);
                  Navigator.pop(context, 'deleted');
                },
              )
            ],
          ),
        ));
  }
}
