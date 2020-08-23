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
  Children child;
  bool selected;

  SelectedChildren({this.child, this.selected});

  void unSelect() => selected = !selected;
}

class Employees {
  int id;

  String name;

  String surName;

  String patronymic;

  DateTime birthday;

  String position;

  List<Children> children;

  Employees({this.id, this.name, this.surName, this.patronymic, this.birthday, this.position, this.children});

  Employees.fromMap(Map<String, dynamic> employeeMap) {
    id = employeeMap[DBColumns.id];
    name = employeeMap[DBColumns.name];
    surName = employeeMap[DBColumns.surname];
    patronymic = employeeMap[DBColumns.patronymic];
    birthday = DateTime(employeeMap[DBColumns.birthday]);
    position = employeeMap[DBColumns.position];
  }

  Map<String, dynamic> toMap() {
    var map = <String, dynamic>{
      DBColumns.name: name,
      DBColumns.surname: surName,
      DBColumns.patronymic: patronymic,
      DBColumns.birthday: birthday.toString(),
      DBColumns.position: position,
    };
    if (id != null) map[DBColumns.id] = id;
    return map;
  }
}

class Children {
  int id;

  String name;

  String surName;

  String patronymic;

  DateTime birthday;

  int parentId;

  Children({this.id, this.name, this.surName, this.patronymic, this.birthday, this.parentId});

  Children.fromMap(Map<String, dynamic> childrenMap) {
    id = childrenMap[DBColumns.id];
    name = childrenMap[DBColumns.name];
    surName = childrenMap[DBColumns.surname];
    patronymic = childrenMap[DBColumns.patronymic];
    birthday = DateTime(childrenMap[DBColumns.birthday]);
    parentId = childrenMap[DBColumns.parentId];
  }

  Map<String, dynamic> toMap() {
    var map = <String, dynamic>{
      DBColumns.name: name,
      DBColumns.surname: surName,
      DBColumns.patronymic: patronymic,
      DBColumns.birthday: birthday.toString(),
      DBColumns.parentId: parentId
    };
    if (id != null) map[DBColumns.id] = id;
    return map;
  }
}
