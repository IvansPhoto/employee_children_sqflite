import 'dart:math';
import 'package:flutter/services.dart';
import 'package:sqflite/sqflite.dart';
import 'package:flutter/material.dart';
import 'package:employee_children_sqflite/database.dart';
import 'package:employee_children_sqflite/Classes.dart';
import 'package:employee_children_sqflite/GlobalStore.dart';

final double iconSize = 40.0;
final double textScaleFactor = 1.25;
final EdgeInsetsGeometry filterPadding = EdgeInsets.fromLTRB(15, 0, 85, 1);

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

  static Future<Employees> generateTheEmployee(Database db) async {
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
      children: <Children>[],
    );
    employee.id = await db.insert(
      DBColumns.employeeTable,
      employee.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
    return employee;
  }

  static Future<int> generateSeveralEmployees({Database db, int quantity}) async {
    var batch = db.batch();

    for (int i = 0; i < quantity; i++) {
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

      batch.insert(DBColumns.employeeTable, employee.toMap(), conflictAlgorithm: ConflictAlgorithm.replace);
    }

    List<dynamic> result = await batch.commit().catchError((e) => throw e);
    return result.length;
  }

  static Future<int> generateSeveralChildren({Database db, int quantity}) async {
    var batch = db.batch();

    for (int i = 0; i < quantity; i++) {
      int _randomName = Random().nextInt(names.length);
      int _randomSurname = Random().nextInt(surnames.length);
      int _randomBirthdayYear = Random().nextInt(45) + 1985;
      int _randomBirthdayMonth = Random().nextInt(12);
      int _randomBirthdayDay = Random().nextInt(_randomBirthdayMonth == 2 ? 28 : 30);
      Children child = Children(
        name: names[_randomName],
        surName: surnames[_randomSurname],
        patronymic: 'Child',
        birthday: DateTime(_randomBirthdayYear, _randomBirthdayMonth, _randomBirthdayDay),
        // parentId: null,
      );
      batch.insert(DBColumns.childrenTable, child.toMap(), conflictAlgorithm: ConflictAlgorithm.replace);
    }
    List<dynamic> result = await batch.commit().catchError((e) => throw e);
    return result.length;
  }

  Stream<List<Employees>> getEmployeesWithException() async* {
    final List<Employees> employeeList = [];
    for (var i = 0; i < 10; i++) {
      await Future.delayed(Duration(milliseconds: 2500));
      employeeList.add(Employees(
          name: employeeList.length.toString(),
          surName: employeeList.length.toString(),
          patronymic: employeeList.length.toString(),
          children: [],
          id: employeeList.length,
          position: employeeList.length.toString(),
          birthday: DateTime.now()));
      yield employeeList;
      if (i == 3) throw Exception('Some exception');
    }
  }
}

class ButtonAddChildrenEmployee extends StatelessWidget {
  final bool forChild;

  ButtonAddChildrenEmployee({this.forChild});

  @override
  Widget build(BuildContext context) {
    Database db = gStore<GlobalStore>().dbProvider.db;
    int number = 1;
    return Row(
      children: [
        IconButton(
          icon: Icon(Icons.get_app),
          onPressed: () async => await showDialog(
              context: context,
              child: Dialog(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 1, vertical: 5),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text('Number of records:'),
                      TextFormField(
                        textAlignVertical: TextAlignVertical.center,
                        textAlign: TextAlign.center,
                        maxLength: 3,
                        autovalidate: true,
                        validator: (text) {
                          if (int.tryParse(text, radix: 10) > 100 || int.tryParse(text, radix: 10) < 1 || text == null)
                            return 'From 1 to 100';
                          else
                            return null;
                        },
                        onChanged: (text) => number = int.parse(text, radix: 10),
                        initialValue: number.toString(),
                        inputFormatters: <TextInputFormatter>[
                          WhitelistingTextInputFormatter.digitsOnly,
                        ],
                        enableSuggestions: false,
                        keyboardType: TextInputType.number,
                      ),
                      RaisedButton(
                        elevation: 0,
                        child: const Text('Add records.'),
                        onPressed: () async {
                          if (forChild) {
                            number = await GeneratePersons.generateSeveralChildren(db: db, quantity: number);
                            gStore<GlobalStore>().getChildrenToStream();
                          } else {
                            number = await GeneratePersons.generateSeveralEmployees(db: db, quantity: number);
                            gStore<GlobalStore>().getEmployeesToStream();
                          }
                          Navigator.pop(context);
                          Scaffold.of(context)
                            ..removeCurrentSnackBar()
                            ..showSnackBar(SnackBar(content: Text('$number records added')));
                        },
                      ),
                    ],
                  ),
                ),
              )),
        ),
      ],
    );
  }
}
