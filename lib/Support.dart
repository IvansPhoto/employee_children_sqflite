import 'dart:math';
import 'package:flutter/material.dart';
import 'package:employee_children_sqflite/classes.dart';
import 'package:hive/hive.dart';
import 'package:rxdart/rxdart.dart';

class SL {
  List<EmployeesData> get allEmployee => Hive.box<EmployeesData>(Boxes.employeesBox).values.toList();

  final _employee = BehaviorSubject<EmployeesData>();
  Stream get streamEmployee$ => _employee.stream;
  EmployeesData get currentEmployee => _employee.value;
  set setEmployee(EmployeesData employee) => _employee.add(employee);

  final _allEmployee = BehaviorSubject<List<EmployeesData>>.seeded(Hive.box<EmployeesData>(Boxes.employeesBox).values.toList());
  Stream get streamAllEmployee$ => _allEmployee.stream;
  List<EmployeesData> get currentListOfEmployee => _allEmployee.value;
  set setListEmployee(List<EmployeesData> newListOfEmployee) => _allEmployee.add(newListOfEmployee);
  set addEmployee(EmployeesData newEmployee) => Hive.box<EmployeesData>(Boxes.employeesBox).add(newEmployee);

}

String monthFromNumber(DateTime dateTime) {
  String month;
  switch (dateTime.month) {
    case 1:
      month = 'January';
      break;
    case 2:
      month = 'February';
      break;
    case 3:
      month = 'March';
      break;
    case 4:
      month = 'April';
      break;
    case 5:
      month = 'May';
      break;
    case 6:
      month = 'June';
      break;
    case 7:
      month = 'July';
      break;
    case 8:
      month = 'August';
      break;
    case 9:
      month = 'September';
      break;
    case 10:
      month = 'October';
      break;
    case 11:
      month = 'November';
      break;
    case 12:
      month = 'December';
      break;
  }
  return '${dateTime.day} $month ${dateTime.year}';
}

abstract class GeneratePersons {
  static final names = <String>['Brad', 'Ben', 'Paul', 'Jonas', 'Elias', 'Leon', 'Finn', 'Noah', 'Felix', 'Mia', 'Emma', 'Sofia', 'Hanna', 'Anna', 'Emilia'];
  static final surnames = <String>['Muller', 'Schmidt', 'Fischer', 'Weber', 'Meyer', 'Wagner', 'Becker', 'Schulz', 'Hoffman'];
  static final position = <String>['Engineer', 'Chemist', 'Marketing', 'Developer', 'Sales', 'Logistic'];

  static void generateEmployees() async {
    int _randomName = Random().nextInt(names.length);
    int _randomSurname = Random().nextInt(surnames.length);
    int _randomPosition = Random().nextInt(position.length);
    int _randomBirthdayYear = Random().nextInt(45) + 1955;
    int _randomBirthdayMonth= Random().nextInt(12);
    int _randomBirthdayDay= Random().nextInt(_randomBirthdayMonth == 2 ? 28 : 30);
    await Hive.box<EmployeesData>(Boxes.employeesBox).add(EmployeesData(
      name: names[_randomName],
      surName: surnames[_randomSurname],
      position: position[_randomPosition],
      patronymic: 'Hive',
      birthday: DateTime(_randomBirthdayYear, _randomBirthdayMonth, _randomBirthdayDay),
      children: HiveList(Hive.box<ChildrenData>(Boxes.childrenBox))
    ));
  }
  static void generateChildren() async {
    int _randomName = Random().nextInt(names.length);
    int _randomSurname = Random().nextInt(surnames.length);
    int _randomBirthdayYear = Random().nextInt(45) + 1985;
    int _randomBirthdayMonth= Random().nextInt(12);
    int _randomBirthdayDay= Random().nextInt(_randomBirthdayMonth == 2 ? 28 : 30);
    await Hive.box<ChildrenData>(Boxes.childrenBox).add(ChildrenData(
      name: names[_randomName],
      surName: surnames[_randomSurname],
      patronymic: 'Hive',
      birthday: DateTime(_randomBirthdayYear, _randomBirthdayMonth, _randomBirthdayDay)
    ));
  }
}


class ButtonAddChildrenEmployee extends StatelessWidget {
  final String snackBarText;
  final bool genChild;

  ButtonAddChildrenEmployee({this.snackBarText, this.genChild});

  @override
  Widget build(BuildContext context) {
    return IconButton(
        icon: Icon(Icons.get_app),
        onPressed: () {
          genChild ? GeneratePersons.generateChildren() : GeneratePersons.generateEmployees();
          Scaffold.of(context)
            ..removeCurrentSnackBar()
            ..showSnackBar(SnackBar(content: Text(snackBarText)));
        });
  }
}
