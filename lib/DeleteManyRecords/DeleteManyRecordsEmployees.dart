import 'package:flutter/material.dart';
import 'package:employee_children_sqflite/GlobalStore.dart';
import 'package:employee_children_sqflite/Classes.dart';
import 'package:employee_children_sqflite/DeleteManyRecords/SelectedEmplyees.dart';

class DeleteManyEmployees extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    print('Build DeleteManyEmployees');
    return Scaffold(
      appBar: AppBar(elevation: 0, title: const Text('Select employees')),
      body: StreamBuilder<List<Employees>>(
          stream: gStore<GlobalStore>().streamEmployeesList$,
          builder: (BuildContext context, AsyncSnapshot<List<Employees>> snapshot) {
            print('Build DeleteMany StreamBuilder');
            if (!snapshot.hasData) return Center(child: Text('No employee in the list'));
            return SelectedEmployees(employeeList: snapshot.data);
          }),
    );
  }
}
