import 'package:employee_children_sqflite/database.dart';
import 'package:get_it/get_it.dart';
import 'package:employee_children_sqflite/Classes.dart';
import 'package:rxdart/rxdart.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart' as Services;

final GetIt gStore = GetIt.instance;

class GlobalStore {
  DBProvider dbProvider;

  GlobalStore({this.dbProvider});

  /// Setting up streams for the LIST of employees
  final _employeeList = BehaviorSubject<List<Employees>>();

  Stream get streamAllEmployees$ => _employeeList.stream;

  void getEmployeesToStream() async => _employeeList.add(await dbProvider.getAllEmployees());

  void filterEmployeesToStream(String searchString) async => _employeeList.add(await dbProvider.filterEmployees(searchString));

  Future<int> deleteSeveralEmployee(List<Employees> employeesList) async => await dbProvider.deleteSeveralEmployee(employeesList);

  /// Setting up streams for The employees
  final _theEmployee = BehaviorSubject<Employees>();

  Stream get streamTheEmployee$ => _theEmployee.stream;

  set setTheEmployee(Employees employee) => _theEmployee.add(employee);

  Employees get theEmployee => _theEmployee.value;

  void getTheEmployee(Employees employee) async => _theEmployee.add(await dbProvider.getTheEmployee(employee));

  /// Put the a new record to DB and set the completed record to the stream.
  void insertEmployee(Employees employee) async => _theEmployee.add(await dbProvider.insertEmployee(employee));

  /// Update the record.
  void updateEmployee(Employees employee) async => await dbProvider.updateEmployee(employee);

  void deleteEmployee(Employees employee) async => await dbProvider.deleteEmployee(employee);

  //Setting up streams for the LIST of children
  final _childrenList = BehaviorSubject<List<Children>>();

  Stream get streamChildrenList$ => _childrenList.stream;

  void getChildrenToStream() async => _childrenList.add(await dbProvider.getAllChildren());

  void filterChildrenToStream(String searchString) async => _childrenList.add(await dbProvider.filterChildren(searchString));

  /// Setting up streams for The child
  final _theChild = BehaviorSubject<Children>();

  Stream get streamTheChild$ => _theChild.stream;

  set setTheChild(Children child) => _theChild.add(child);

  Children get theChild => _theChild.value;

  /// Put the a new record to DB and set the completed record to the stream.
  void insertChild(Children child) async => _theChild.add(await dbProvider.insertChild(child));

  /// Update the record.
  void updateChild(Children child) async => await dbProvider.updateChild(child);

  void deleteChild(Children child) async => await dbProvider.deleteChild(child);

  void setEmployeeToChild({Employees employee, Children child}) async {
    child.parentId = employee.id;
    updateChild(child);
  }
}
