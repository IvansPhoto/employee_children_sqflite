import 'package:flutter/material.dart';
import 'package:employee_children_sqflite/pages/NewEmployee/EmployeeForm.dart';

class NewEmployee extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final isNew = ModalRoute.of(context).settings.arguments;
    return EmployeeForm(isNew);
  }
}
