import 'package:hive/hive.dart';
import 'package:get_it/get_it.dart';
import 'package:employee_children_sqflite/classes.dart';
import 'package:rxdart/rxdart.dart';

final GetIt gStore = GetIt.instance;

class GlobalStore {
  Box<ChildrenData> childrenBox;
  Box<EmployeesData> employeeBox;
  BehaviorSubject childrenList;
  BehaviorSubject employeeList;

  GlobalStore({this.childrenBox, this.employeeBox}) {
    this.childrenBox = childrenBox;
    this.childrenList = BehaviorSubject<List<ChildrenData>>.seeded(childrenBox.values.toList());
    this.childrenBox = childrenBox;
    this.employeeList = BehaviorSubject<List<EmployeesData>>.seeded(employeeBox.values.toList());
  }

  EmployeesData theEmployee;

  Stream get streamEmployeeList$ => employeeList.stream;

  List<ChildrenData> get currentEmployeeList => employeeList.value;

  void setEmployeeList(List<EmployeesData> newEmployeeList) => employeeList.add(newEmployeeList);

  void addEmployee(EmployeesData newEmployee) => Hive.box<EmployeesData>(Boxes.employeesBox).add(newEmployee);

  Stream boxStreamEmployee$ = Hive.box<EmployeesData>(Boxes.employeesBox).watch();

  void filterEmployee(String searchingText) {
    employeeList.add(Hive.box<EmployeesData>(Boxes.employeesBox)
        .values
        .where((employee) => employee.name.contains(searchingText) || employee.surName.contains(searchingText) || employee.patronymic.contains(searchingText))
        .toList());
    print(searchingText);
  }

  ChildrenData theChild;

  Stream get streamChildrenList$ => childrenList.stream;

  List<ChildrenData> get currentChildrenList => childrenList.value;

  void setChildrenList(List<ChildrenData> newChildrenList) => childrenList.add(newChildrenList);

  void addChildren(ChildrenData newChild) => Hive.box<ChildrenData>(Boxes.childrenBox).add(newChild);

  Stream boxStreamChildren$ = Hive.box<ChildrenData>(Boxes.childrenBox).watch();

  void filterChildren(String searchingText) {
    childrenList.add(Hive.box<ChildrenData>(Boxes.childrenBox)
        .values
        .where((child) => child.name.contains(searchingText) || child.surName.contains(searchingText) || child.patronymic.contains(searchingText))
        .toList());
    print(searchingText);
  }
}
