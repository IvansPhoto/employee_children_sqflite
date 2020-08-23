import 'package:employee_children_sqflite/database.dart';
import 'package:get_it/get_it.dart';
import 'package:employee_children_sqflite/classes.dart';
import 'package:rxdart/rxdart.dart';

final GetIt gStore = GetIt.instance;

class GlobalStore {
  DBProvider dbProvider;
  GlobalStore({this.dbProvider});

  //Setting up streams for employees
  final _employeeList = BehaviorSubject<List<Employees>>();

  Stream get streamEmployeeList$ => _employeeList.stream;

  void setEmployeesToStream() async {
    _employeeList.add(await dbProvider.getAllEmployees());
  }

  void filterEmployees(String searchString) async {
    _employeeList.add(await dbProvider.filterEmployees(searchString));
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

  Employees theEmployee;
  Children theChild;

}
