import 'package:flutter/material.dart';
import 'package:employee_children_sqflite/Classes.dart';
import 'package:employee_children_sqflite/GlobalStore.dart';

class NumberChildren extends StatelessWidget {
  final Employees employee;

  NumberChildren({this.employee});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Children>>(
      future: gStore<GlobalStore>().dbProvider.getChildrenOfEmployee(employee.id),
      builder: (context, AsyncSnapshot<List<Children>> snapshot) {
        if (!snapshot.hasData || snapshot.data.length == 0) return Text('No children', style: TextStyle(color: Colors.amber));
        return Text('Children: ${snapshot.data.length}');
      },
    );
  }
}
