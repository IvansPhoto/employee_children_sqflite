import 'package:flutter/material.dart';
import 'package:employee_children_sqflite/pages/NewEmployee/NewEmployeeForm.dart';

class NewEmployee extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final isNew = ModalRoute.of(context).settings.arguments;
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        title: const Text('The list of employees'),
      ),
      body: EmployeeForm(isNew),
    );
  }
}
