import 'dart:async';
import 'package:get_it/get_it.dart';
import 'package:rxdart/rxdart.dart';
import 'package:employee_children_sqflite/database.dart';
import 'package:employee_children_sqflite/Classes.dart';
import 'package:employee_children_sqflite/Support.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart' as Services;

final GetIt gStore = GetIt.instance;

class GlobalStore {
  DBProvider dbProvider;

  GlobalStore({this.dbProvider});

  /// Setting up streams for the LIST of employees
  final _employeeList = BehaviorSubject<List<Employees>>();

  Stream get streamAllEmployees$ => _employeeList.stream;

  void getEmployeesToStream() async {
    try {
      _employeeList.add(await dbProvider.getAllEmployees());
    } catch (e) {
      _employeeList.addError(e);
    }
  }

  void filterEmployeesToStream(String searchString) async {
    try {
      _employeeList.add(await dbProvider.filterEmployees(searchString));
    } catch (e) {
      _employeeList.addError(e);
    }
  }

  Future<int> deleteSeveralEmployee(List<Employees> employeesList) async => await dbProvider.deleteSeveralEmployee(employeesList);

  /// Setting up streams for The employees
  final _theEmployee = BehaviorSubject<Employees>();

  Stream get streamTheEmployee$ => _theEmployee.stream;

  set setTheEmployee(Employees employee) => _theEmployee.add(employee);

  Employees get theEmployee => _theEmployee.value;

  void getTheEmployee(Employees employee) async {
    try {
      _theEmployee.add(await dbProvider.getTheEmployee(employee.id));
    } catch (e) {
      _theEmployee.addError(e);
    }
  }

  /// Put the a new record to DB and set the completed record to the stream.
  void insertEmployee(Employees employee) async {
    try {
      _theEmployee.add(await dbProvider.insertEmployee(employee));
    } catch (e) {
      _theEmployee.addError(e);
    }
  }

  /// Update the record.
  void updateEmployee(Employees employee) async => await dbProvider.updateEmployee(employee);

  void deleteEmployee(Employees employee) async => await dbProvider.deleteEmployee(employee);

  //Setting up streams for the LIST of children
  final _childrenList = BehaviorSubject<List<Children>>();

  Stream get streamChildrenList$ => _childrenList.stream;

  void getChildrenToStream() async {
    try {
      _childrenList.add(await dbProvider.getAllChildren());
    } catch (e) {
      _childrenList.addError(e);
    }
  }

  void filterChildrenToStream(String searchString) async {
    try {
      _childrenList.add(await dbProvider.filterChildren(searchString));
    } catch (e) {
      _childrenList.addError(e);
    }
  }

  /// Setting up streams for The child
  final _theChild = BehaviorSubject<Children>();

  Stream get streamTheChild$ => _theChild.stream;

  set setTheChild(Children child) => _theChild.add(child);

  Children get theChild => _theChild.value;

  /// Put the a new record to DB and set the completed record to the stream.
  void insertChild(Children child) async {
    try {
      _theChild.add(await dbProvider.insertChild(child));
    } catch (e) {
      _theChild.addError(e);
    }
  }

  /// Update the record.
  void updateChild(Children child) async => await dbProvider.updateChild(child);

  void deleteChild(Children child) async => await dbProvider.deleteChild(child);

  void setEmployeeToChild({Employees employee, Children child}) async {
    child.parentId = employee.id;
    updateChild(child);
  }
}

class EmployeeStore {
  DBProvider dbProvider;

  /// Setting up streams for the LIST of employees
  final BehaviorSubject<List<Employees>> _listEmployee = BehaviorSubject<List<Employees>>();

  Stream get ListEmployees$ => _listEmployee.stream;

  String _searchString = '';

  void getAllEmployees(String searchString) async {
    _searchString = searchString;
    try {
      _listEmployee.add(await dbProvider.filterEmployees(searchString));
    } catch (e) {
      _listEmployee.addError(e);
    }
  }

  void _deleteSeveralEmployee(List<Employees> employeesList) async {
    await dbProvider
      ..deleteSeveralEmployee(employeesList).catchError(_listEmployee.addError)
      ..filterEmployees(_searchString).then(_listEmployee.add).catchError(_listEmployee.addError);
  }

  /// Setting up streams for The employees
  final BehaviorSubject<Employees> _singleEmployee = BehaviorSubject<Employees>();

  Stream get SingleEmployee$ => _singleEmployee.stream;

  void set setEmployee(Employees employee) => _singleEmployee.add(employee);

  void getSingleEmployee(int employeeId) async => dbProvider.getTheEmployee(employeeId).then(_singleEmployee.add).catchError(_singleEmployee.addError);

  void updateEmployee({int id, String name, String surname, String patronymic, DateTime birthday, String position}) async {
    Employees newEmployee = Employees(
      id: id,
      name: name,
      surName: surname,
      patronymic: patronymic,
      birthday: birthday,
      position: position,
    );
    if (id == null)
      dbProvider..insertEmployee(newEmployee).catchError(_singleEmployee.addError)..filterEmployees(_searchString).then(_listEmployee.add).catchError(_singleEmployee.addError);
    else
      dbProvider
        ..updateEmployee(newEmployee).catchError(_singleEmployee.addError)
        ..filterEmployees(_searchString).then(_listEmployee.add).catchError(_listEmployee.addError)
        ..getTheEmployee(newEmployee.id).then(_singleEmployee.add).catchError(_singleEmployee.addError);
  }
}
