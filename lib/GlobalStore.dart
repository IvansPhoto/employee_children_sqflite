import 'package:get_it/get_it.dart';
import 'package:employee_children_sqflite/classes.dart';
import 'package:rxdart/rxdart.dart';

final GetIt gStore = GetIt.instance;

class GlobalStore {
  Employees theEmployee;

//  final employeeList = BehaviorSubject<List<Employees>>();
//
//  Stream get streamEmployeeList$ => employeeList.stream;
//
//  List<Employees> get currentEmployeeList => employeeList.value;
//
//  set setEmployeeList(List<Employees> newEmployeeList) => employeeList.add(newEmployeeList);
//
//  void filterEmployee(String searchingText) {
//    employeeList.add(
//        currentEmployeeList.where((employee) => employee.name.contains(searchingText) || employee.surName.contains(searchingText) || employee.patronymic.contains(searchingText)));
//  }

  Children theChild;

//  final childrenList = BehaviorSubject<List<Children>>();
//
//  Stream get streamChildrenList$ => childrenList.stream;
//
//  List<Children> get currentChildrenList => childrenList.value;
//
//  set setChildrenList(List<Children> newChildrenList) => childrenList.add(newChildrenList);
//
//  void filterChildren(String searchingText) {
//    childrenList.add(currentChildrenList.where((child) => child.name.contains(searchingText) || child.surName.contains(searchingText) || child.patronymic.contains(searchingText)));
//  }
}
