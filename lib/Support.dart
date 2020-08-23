import 'dart:math';
import 'package:employee_children_sqflite/database.dart';
import 'package:flutter/material.dart';
import 'package:employee_children_sqflite/classes.dart';
import 'package:sqflite/sqflite.dart';

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

  static void generateEmployees(Database db) async {
    int _randomName = Random().nextInt(names.length);
    int _randomSurname = Random().nextInt(surnames.length);
    int _randomPosition = Random().nextInt(position.length);
    int _randomBirthdayYear = Random().nextInt(45) + 1955;
    int _randomBirthdayMonth = Random().nextInt(12);
    int _randomBirthdayDay = Random().nextInt(_randomBirthdayMonth == 2 ? 28 : 30);

    Employees employee = Employees(
      name: names[_randomName],
      surName: surnames[_randomSurname],
      position: position[_randomPosition],
      patronymic: 'SQFlite',
      birthday: DateTime(_randomBirthdayYear, _randomBirthdayMonth, _randomBirthdayDay),
    );
    await db.insert(
      DBColumns.employeeTable,
      employee.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  static void generateChildren(Database db) async {
    int _randomName = Random().nextInt(names.length);
    int _randomSurname = Random().nextInt(surnames.length);
    int _randomBirthdayYear = Random().nextInt(45) + 1985;
    int _randomBirthdayMonth = Random().nextInt(12);
    int _randomBirthdayDay = Random().nextInt(_randomBirthdayMonth == 2 ? 28 : 30);
    Children child = Children(
      name: names[_randomName],
      surName: surnames[_randomSurname],
      patronymic: 'SQFlite',
      birthday: DateTime(_randomBirthdayYear, _randomBirthdayMonth, _randomBirthdayDay),
    );
    child.id = await db.insert(
      DBColumns.employeeTable,
      child.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
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
