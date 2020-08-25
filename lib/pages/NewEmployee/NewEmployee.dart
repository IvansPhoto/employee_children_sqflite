import 'package:employee_children_sqflite/Classes.dart';
import 'package:flutter/material.dart';
import 'package:employee_children_sqflite/pages/NewEmployee/NewEmployeeForm.dart';
import 'package:employee_children_sqflite/GlobalStore.dart';

class NewEmployee extends StatelessWidget {
  final store = gStore.get<GlobalStore>();

  @override
  Widget build(BuildContext context) {
    final Employees employee = store.theEmployee;
    final isNew = ModalRoute.of(context).settings.arguments;
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        title: const Text('The list of employees'),
      ),
      body: EmployeeForm(employee: employee, isNew: isNew,),
    );
  }
}
