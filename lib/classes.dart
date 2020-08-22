import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';


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

abstract class Boxes {
  static final String employeesBox = 'employees';
  static final String childrenBox = 'children';
}


class SelectedChildren {
  ChildrenData child;
  bool selected;
  SelectedChildren({this.child, this.selected});
  void unSelect() => selected = !selected;
}


@HiveType(typeId: 0)
class EmployeesData extends HiveObject {
  @HiveField(0)
  String name;

  @HiveField(1)
  String surName;

  @HiveField(2)
  String patronymic;

  @HiveField(3)
  DateTime birthdate;

  @HiveField(4)
  String position;

  @HiveField(5)
  HiveList<ChildrenData> children;

  EmployeesData({this.name, this.surName, this.patronymic, this.birthdate, this.position, this.children});
}

@HiveType(typeId: 1)
class ChildrenData extends HiveObject {
  @HiveField(0)
  String name;

  @HiveField(1)
  String surName;

  @HiveField(2)
  String patronymic;

  @HiveField(3)
  DateTime birthdate;

  @HiveField(4)
  EmployeesData parent;

  set setParent(EmployeesData newParent) => parent = newParent;

  ChildrenData({this.name, this.surName, this.patronymic, this.birthdate});
}
