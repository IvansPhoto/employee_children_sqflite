import 'package:employee_children_sqflite/database.dart';
import 'package:employee_children_sqflite/Support.dart';
import 'package:get_it/get_it.dart';
import 'package:employee_children_sqflite/classes.dart';
import 'package:rxdart/rxdart.dart';
import 'package:flutter/material.dart';

final GetIt gStore = GetIt.instance;

class GlobalStore {
  DBProvider dbProvider;
  GlobalStore({this.dbProvider});

  //Setting up streams for the LIST of employees
  final _employeeList = BehaviorSubject<List<Employees>>();

  Stream get streamEmployeeList$ => _employeeList.stream;

  void setEmployeesToStream() async {
    _employeeList.add(await dbProvider.getAllEmployees());
  }

  void filterEmployees(String searchString) async {
    _employeeList.add(await dbProvider.filterEmployees(searchString));
  }

  //Setting up streams for The employees
  final _theEmployee = BehaviorSubject<Employees>();

  Stream get streamTheEmployee$ => _theEmployee.stream;

  void setTheEmployee(Employees employee) => _theEmployee.add(employee);

  get theEmployee => _theEmployee.value;

  void deleteEmployee(Employees employee) async {
    int number = await dbProvider.deleteEmployee(employee);
    _employeeList.add(await dbProvider.getAllEmployees());
    if (number != 1) {
      print('Error in deleting $number ${employee.id}');
    }
  }

  //Setting up streams for children
  final _childrenList = BehaviorSubject<List<Children>>();

  Stream get streamChildrenList$ => _childrenList.stream;

  void setChildrenToStream() async {
    _childrenList.add(await dbProvider.getAllChildren());
  }

  void filterChildren(String searchString) async {
    _childrenList.add(await dbProvider.filterChildren(searchString));
  }

  Children theChild;

}
