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
  static final deleteManyEmployees = '/DeleteManyRecords/DeleteManyRecordsEmployees';
  static final deleteManyChildren = '/DeleteManyEmployees/DeleteManyEmployees';
  static final employeeSliverList = '/SliverLists/EmployeeListSlivers';
}

abstract class People {
  int id;

  String name;

  String surName;

  String patronymic;

  DateTime birthday;
}

class Employees implements People {
  int id;

  String name;

  String surName;

  String patronymic;

  DateTime birthday;

  String position;

  List<Children> children;

  bool isSelected = false;

  Employees({this.id, this.name, this.surName, this.patronymic, this.birthday, this.position, this.children, this.isSelected});

  Employees.fromMap(Map<String, dynamic> employeeMap) {
    id = employeeMap[DBColumns.employeeId];
    name = employeeMap[DBColumns.employeeName];
    surName = employeeMap[DBColumns.employeeSurname];
    patronymic = employeeMap[DBColumns.employeePatronymic];
    birthday = DateTime.parse(employeeMap[DBColumns.employeeBirthday]);
    position = employeeMap[DBColumns.employeePosition];
  }

  Employees.fromMapChildren(Map<String, dynamic> employeeMap) {
    id = employeeMap[DBColumns.employeeId];
    name = employeeMap[DBColumns.employeeName];
    surName = employeeMap[DBColumns.employeeSurname];
    patronymic = employeeMap[DBColumns.employeePatronymic];
    birthday = DateTime.parse(employeeMap[DBColumns.employeeBirthday]);
    position = employeeMap[DBColumns.employeePosition];

    /// Get children from map. Work in progress.
    children = [];
    if (employeeMap[DBColumns.childId] != null)
      children.add(Children(
        id: employeeMap[DBColumns.childId],
        name: employeeMap[DBColumns.childName],
        surName: employeeMap[DBColumns.childSurname],
        patronymic: employeeMap[DBColumns.childPatronymic],
        birthday: DateTime.parse(employeeMap[DBColumns.childBirthday]),
        parentId: employeeMap[DBColumns.childParentId],
      ));
  }

  Map<String, dynamic> toMap() {
    var map = <String, dynamic>{
      DBColumns.employeeName: name,
      DBColumns.employeeSurname: surName,
      DBColumns.employeePatronymic: patronymic,
      DBColumns.employeeBirthday: birthday.toIso8601String(),
      DBColumns.employeePosition: position,
    };
    if (id != null) map[DBColumns.employeeId] = id;
    return map;
  }
}

class Children implements People {
  int id;

  String name;

  String surName;

  String patronymic;

  DateTime birthday;

  int parentId;

  Employees employee;

  bool isSelected = false;

  Children({this.id, this.name, this.surName, this.patronymic, this.birthday, this.parentId, this.employee, this.isSelected});

  Children.fromMap(Map<String, dynamic> childrenMap) {
    id = childrenMap[DBColumns.childId];
    name = childrenMap[DBColumns.childName];
    surName = childrenMap[DBColumns.childSurname];
    patronymic = childrenMap[DBColumns.childPatronymic];
    birthday = DateTime.parse(childrenMap[DBColumns.childBirthday]);
    parentId = childrenMap[DBColumns.childParentId];
  }

  Map<String, dynamic> toMap() {
    var map = <String, dynamic>{
      DBColumns.childName: name,
      DBColumns.childSurname: surName,
      DBColumns.childPatronymic: patronymic,
      DBColumns.childBirthday: birthday.toIso8601String(),
      DBColumns.childParentId: parentId ?? (employee == null ? null : employee.id),
    };
    if (id != null) map[DBColumns.childId] = id;
    return map;
  }

  // final factoriesFromSql = <Type, Function>{
  //   String: (sql) => BaseWord.fromSql(sql: sql),
  //   int: (sql) => WordType1.fromSql(sql: sql),
  //   Children: (sql) => Children(name: 'Tom'),
  // };
}