import 'package:employee_children_sqflite/database.dart';

abstract class RouteNames {
  static final index = '/';
  static final employeesList = '/EmployeesList';
  static final showEmployee = '/ShowEmployee';
  static final newEmployee = '/NewEmployee/NewEmployee';
  static final childrenList = '/ChildrenList';
  static final showChild = '/ShowChild';
  static final newChildren = '/NewChild/NewChild';
  static final selectChildren = '/SelectChildren/SelectChildren';
}

class SelectedChildren {
  ChildrenData child;
  bool selected;

  SelectedChildren({this.child, this.selected});

  void unSelect() => selected = !selected;
}

class EmployeesData {
  int id;

  String name;

  String surName;

  String patronymic;

  DateTime birthday;

  String position;

  List<ChildrenData> children;

  EmployeesData({this.id, this.name, this.surName, this.patronymic, this.birthday, this.position, this.children});

  EmployeesData.fromMap(Map<String, dynamic> employeeMap) {
    id = employeeMap[ColumnDataBase.id];
    name = employeeMap[ColumnDataBase.name];
    surName = employeeMap[ColumnDataBase.surname];
    patronymic = employeeMap[ColumnDataBase.patronymic];
    birthday = DateTime(employeeMap[ColumnDataBase.birthday]);
    position = employeeMap[ColumnDataBase.position];
  }

  Map<String, dynamic> toMap() {
    var map = <String, dynamic>{
      ColumnDataBase.name: name,
      ColumnDataBase.surname: surName,
      ColumnDataBase.patronymic: patronymic,
      ColumnDataBase.birthday: birthday.toString(),
      ColumnDataBase.position: position,
    };
    if (id != null) map[ColumnDataBase.id] = id;
    return map;
  }
}

class ChildrenData {
  int id;

  String name;

  String surName;

  String patronymic;

  DateTime birthday;

  int parentId;

  ChildrenData({this.id, this.name, this.surName, this.patronymic, this.birthday, this.parentId});

  ChildrenData.fromMap(Map<String, dynamic> childrenMap) {
    id = childrenMap[ColumnDataBase.id];
    name = childrenMap[ColumnDataBase.name];
    surName = childrenMap[ColumnDataBase.surname];
    patronymic = childrenMap[ColumnDataBase.patronymic];
    birthday = DateTime(childrenMap[ColumnDataBase.birthday]);
    parentId = childrenMap[ColumnDataBase.parentId];
  }

  Map<String, dynamic> toMap() {
    var map = <String, dynamic>{
      ColumnDataBase.name: name,
      ColumnDataBase.surname: surName,
      ColumnDataBase.patronymic: patronymic,
      ColumnDataBase.birthday: birthday.toString(),
      ColumnDataBase.parentId: parentId
    };
    if (id != null) map[ColumnDataBase.id] = id;
    return map;
  }
}
