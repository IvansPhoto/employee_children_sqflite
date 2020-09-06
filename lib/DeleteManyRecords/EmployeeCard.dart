import 'package:flutter/material.dart';
import 'package:employee_children_sqflite/Classes.dart';

class EmployeeCard extends StatefulWidget {
  final Employees employee;

  EmployeeCard({this.employee});

  @override
  _EmployeeCardState createState() => _EmployeeCardState();
}

class _EmployeeCardState extends State<EmployeeCard> {
  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 0,
      child: ListTile(
        leading: widget.employee.isSelected ? Icon(Icons.check_circle_outline) : Icon(Icons.radio_button_unchecked),
        title: Text('${widget.employee.surName} ${widget.employee.name} ${widget.employee.patronymic}'),
        onTap: () async {
          setState(() {
            widget.employee.isSelected = !widget.employee.isSelected ;
          });
        },
      ),
    );
  }
}
