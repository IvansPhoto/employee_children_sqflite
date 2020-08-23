import 'package:get_it/get_it.dart';
import 'package:employee_children_sqflite/classes.dart';
import 'package:rxdart/rxdart.dart';

final GetIt gStore = GetIt.instance;

class GlobalStore {
  final employeeList = BehaviorSubject<List<EmployeesData>>();
  final childrenList = BehaviorSubject<List<ChildrenData>>();

  EmployeesData theEmployee;

  Stream get streamEmployeeList$ => employeeList.stream;

  List<EmployeesData> get currentEmployeeList => employeeList.value;

  void setEmployeeList(List<EmployeesData> newEmployeeList) => employeeList.add(newEmployeeList);

  void filterEmployee(String searchingText) {
    employeeList.add(
        currentEmployeeList.where((employee) => employee.name.contains(searchingText) || employee.surName.contains(searchingText) || employee.patronymic.contains(searchingText)));
  }

  ChildrenData theChild;

  Stream get streamChildrenList$ => childrenList.stream;

  List<ChildrenData> get currentChildrenList => childrenList.value;

  void setChildrenList(List<ChildrenData> newChildrenList) => childrenList.add(newChildrenList);

  void filterChildren(String searchingText) {
    childrenList.add(currentChildrenList.where((child) => child.name.contains(searchingText) || child.surName.contains(searchingText) || child.patronymic.contains(searchingText)));
  }
}
