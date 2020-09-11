import 'dart:io';
import 'package:employee_children_sqflite/Classes.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:rxdart/rxdart.dart';

abstract class DBColumns {
  /// Employee table columns
  static final String employeeTable = 'employeeTable';
  static final String employeeId = 'employeeId';
  static final String employeeName = 'employeeName';
  static final String employeeSurname = 'employeeSurname';
  static final String employeePatronymic = 'employeePatronymic';
  static final String employeeBirthday = 'employeeBirthday';
  static final String employeePosition = 'employeePosition';

  /// Child table columns
  static final String childrenTable = 'childrenTable';
  static final String childId = 'childId';
  static final String childName = 'childName';
  static final String childSurname = 'childSurname';
  static final String childPatronymic = 'childPatronymic';
  static final String childBirthday = 'childBirthday';
  static final String childParentId = 'childParentId';
}

class DBProvider {
  Database db;

  Future<void> _onConfigure(Database db) async {
    await db.execute('PRAGMA foreign_keys = ON');
  }

  Future<void> _onOpen(Database db) async {
    print('db version ${await db.getVersion()}');
  }

  Future<void> initDataBase() async {
    try {
      print('DB is opening...');
      var databasesPath = await getDatabasesPath();
      await Directory(databasesPath).create(recursive: true);
    } catch (_) {
      print(_);
    }

    db = await openDatabase(
      join(await getDatabasesPath(), 'employee_children.db'),
      onCreate: (db, version) {
        db.execute("CREATE TABLE ${DBColumns.employeeTable}(${DBColumns.employeeId} INTEGER PRIMARY KEY AUTOINCREMENT, "
            "${DBColumns.employeeName} TEXT, ${DBColumns.employeeSurname} TEXT, ${DBColumns.employeePatronymic} TEXT, ${DBColumns.employeeBirthday} TEXT, ${DBColumns.employeePosition} TEXT); ");
        db.execute("CREATE TABLE ${DBColumns.childrenTable}(${DBColumns.childId} INTEGER PRIMARY KEY AUTOINCREMENT, "
            "${DBColumns.childName} TEXT, ${DBColumns.childSurname} TEXT, ${DBColumns.childPatronymic} TEXT, ${DBColumns.childBirthday} TEXT, ${DBColumns.childParentId} INTEGER, "
            "FOREIGN KEY(${DBColumns.childParentId}) REFERENCES ${DBColumns.employeeTable}(${DBColumns.employeeId}) ON UPDATE CASCADE ON DELETE CASCADE);");
        return db.execute("CREATE INDEX childrenindex ON ${DBColumns.childrenTable}(${DBColumns.childParentId});");
      },
      onConfigure: _onConfigure,
      onOpen: _onOpen,
      version: 1,
    ).whenComplete(() => print('open'));
  }

  void clearDataBase() async {
    await deleteDatabase(join(await getDatabasesPath(), 'employee_children.db'));
    await initDataBase();
  }

  /// Insert an employee record in db.
  Future<Employees> insertEmployee(Employees employee) async {
    try {
      employee.id = await db.insert(DBColumns.employeeTable, employee.toMap(), conflictAlgorithm: ConflictAlgorithm.replace);
      return employee;
    } catch (e) {
      print(e);
      return e;
    }
  }

  /// Insert a child record in db.
  Future<Children> insertChild(Children child) async {
    try {
      child.id = await db.insert(DBColumns.childrenTable, child.toMap(), conflictAlgorithm: ConflictAlgorithm.replace);
      return child;
    } catch (e) {
      print(e);
      return e;
    }
  }

  /// Delete an employee record from db.
  Future<int> deleteEmployee(Employees employee) async => await db.delete(DBColumns.employeeTable, where: "${DBColumns.employeeId} = ?", whereArgs: [employee.id]);

  /// Delete several employee records from db.
  Future<int> deleteSeveralEmployee(List<Employees> employeesList) async {
    var batch = db.batch();

    employeesList.forEach((employee) async {
      batch.delete(DBColumns.employeeTable, where: "${DBColumns.employeeId} = ?", whereArgs: [employee.id]);
    });

    List<dynamic> result = await batch.commit().catchError((e) => throw e);
    return result.length;
  }

  /// Delete an child record from db.
  Future<int> deleteChild(Children child) async {
    int id;
    try {
      id = await db.delete(DBColumns.childrenTable, where: "${DBColumns.childId} = ?", whereArgs: [child.id]);
    } catch (e) {
      print('error in deleteChild');
      print(e);
    }
    print(id);
    return id;
  }

  /// Update an employee record in db.
  Future<int> updateEmployee(Employees employee) async =>
      await db.update(DBColumns.employeeTable, employee.toMap(), where: "${DBColumns.employeeId} = ?", whereArgs: [employee.id]);

  /// Update a child record in db.
  Future<int> updateChild(Children child) async => await db.update(DBColumns.childrenTable, child.toMap(), where: "${DBColumns.childId} = ?", whereArgs: [child.id]);

  /// Get all employee records from db.
  Future<List<Employees>> getAllEmployees() async {
    final List<Employees> employeeList = [];

    final List<Map<String, dynamic>> listMap = await db.rawQuery('SELECT * FROM ${DBColumns.employeeTable} '
        'LEFT JOIN ${DBColumns.childrenTable} ON ${DBColumns.childrenTable}.${DBColumns.childParentId} = ${DBColumns.employeeTable}.${DBColumns.employeeId}');

    if (listMap.isNotEmpty) {
      listMap.forEach((employeeMap) {
        Employees newEmployee = Employees.fromMapChildren(employeeMap);

        int length = employeeList.length;
        bool isEmployeeInList = false;
        for (int i = 0; i < length; i++) {
          Employees existingEmployee = employeeList.elementAt(i);
          if (existingEmployee.id == newEmployee.id) {
            existingEmployee.children.add(newEmployee.children.first);
            isEmployeeInList = true;
          }
        }
        if (!isEmployeeInList) employeeList.add(newEmployee);
      });
      // print(employeeList.length);

      // employeeList.forEach((Employees existingEmployee) => existingEmployee.toMap().forEach((key, value) => print('$key - $value')));
      // employeeList.forEach((Employees existingEmployee) => existingEmployee.children.forEach((Children child) => print('${child.id} ${child.name}')));

      return employeeList;
    } else
      return null;
  }

  /// Get all employee records from db with their children.
  Future<Employees> getTheEmployee(Employees employee) async {
    final employeeList = List<Employees>();
    // final List employeeList = <Employees>[];
    // final List<Employees> employeeList = [];

    // final List<Children> mewList1 = [];
    // final List mewList2 = <Children>[];
    // final mewList3 = List<Children>();

    List<Map<String, dynamic>> listMap = await db.rawQuery(
        'SELECT * FROM ${DBColumns.employeeTable} '
        'LEFT JOIN ${DBColumns.childrenTable} ON ${DBColumns.childrenTable}.${DBColumns.childParentId} = ${DBColumns.employeeTable}.${DBColumns.employeeId} '
        'WHERE ${DBColumns.employeeId} = ?',
        [employee.id]);

    // print('listMap.isEmpty - ${listMap.isEmpty}');
    // listMap.forEach((element) => print('listMap: $element'));

    if (listMap.isNotEmpty) {
      listMap.forEach((employeeMap) {
        Employees newEmployee = Employees.fromMapChildren(employeeMap);

        int length = employeeList.length;
        bool isEmployeeInList = false;
        for (int i = 0; i < length; i++) {
          Employees existingEmployee = employeeList.elementAt(i);
          if (existingEmployee.id == newEmployee.id) {
            existingEmployee.children.add(newEmployee.children.first);
            isEmployeeInList = true;
          }
        }
        if (!isEmployeeInList) employeeList.add(newEmployee);
      });

      // print(employeeList.length);
      // employeeList.forEach((Employees existingEmployee) => existingEmployee.toMap().forEach((key, value) => print('$key - $value')));
      // employeeList.forEach((Employees existingEmployee) => existingEmployee.children.forEach((Children child) => print('${child.id} ${child.name}')));

      return employeeList.first;
    } else
      return null;
  }

  /// Get all child records from db.
  Future<List<Children>> getAllChildren() async {
    final List<Children> childrenList = [];
    final List<Map<String, dynamic>> childrenMapList = await db.query(
      DBColumns.childrenTable,
      columns: [DBColumns.childId, DBColumns.childName, DBColumns.childSurname, DBColumns.childPatronymic, DBColumns.childBirthday, DBColumns.childParentId],
    );
    if (childrenMapList.isNotEmpty) {
      childrenMapList.forEach((employeeMap) {
        childrenList.add(Children.fromMap(employeeMap));
      });

      /// For debugging
      // childrenList.forEach((Children child) => child.toMap().forEach((key, value) => print('$key - $value')));

      return childrenList;
    } else
      return null;
  }

  Future<List<Employees>> filterEmployees(String searchString) async {
    final List<Employees> employeeList = [];

    final List<Map<String, dynamic>> listMap = await db.rawQuery(
        'SELECT * FROM ${DBColumns.employeeTable} '
        'LEFT JOIN ${DBColumns.childrenTable} ON ${DBColumns.childrenTable}.${DBColumns.childParentId} = ${DBColumns.employeeTable}.${DBColumns.employeeId} '
        'WHERE ${DBColumns.employeeName} LIKE ? OR ${DBColumns.employeeSurname} LIKE ? OR ${DBColumns.employeePatronymic} LIKE ?',
        ['%$searchString%', '%$searchString%', '%$searchString%']);

    listMap.forEach((element) => print(element));

    if (listMap.isNotEmpty) {
      listMap.forEach((employeeMap) {
        Employees newEmployee = Employees.fromMapChildren(employeeMap);

        int length = employeeList.length;
        bool isEmployeeInList = false;
        for (int i = 0; i < length; i++) {
          Employees existingEmployee = employeeList.elementAt(i);
          if (existingEmployee.id == newEmployee.id) {
            existingEmployee.children.add(newEmployee.children.first);
            isEmployeeInList = true;
          }
        }
        if (!isEmployeeInList) employeeList.add(newEmployee);
      });
      // print(employeeList.length);

      // employeeList.forEach((Employees existingEmployee) => existingEmployee.toMap().forEach((key, value) => print('$key - $value')));
      // employeeList.forEach((Employees existingEmployee) => existingEmployee.children.forEach((Children child) => print('${child.id} ${child.name}')));

      return employeeList;
    } else
      return null;

    // List<Employees> employeeList = [];
    //
    // List<Map<String, dynamic>> employeeMapList = await db.query(
    //   DBColumns.employeeTable,
    //   columns: [DBColumns.childId, DBColumns.employeeName, DBColumns.employeeSurname, DBColumns.employeePatronymic, DBColumns.employeePatronymic, DBColumns.employeeBirthday],
    //   where: '${DBColumns.employeeName} LIKE ? OR ${DBColumns.employeeSurname} LIKE ? OR ${DBColumns.employeePatronymic} LIKE ?',
    //   whereArgs: ['%$searchString%', '%$searchString%', '%$searchString%'],
    // );
    //
    // if (employeeMapList.isNotEmpty) {
    //   employeeMapList.forEach((employeeMap) {
    //     employeeList.add(Employees.fromMap(employeeMap));
    //   });
    //   return employeeList;
    // } else
    //   return null;
  }

  Future<List<Children>> filterChildren(String searchString) async {
    final List<Children> childrenList = [];
    final List<Map<String, dynamic>> childrenMapList = await db.query(
      DBColumns.childrenTable,
      columns: [DBColumns.childId, DBColumns.childName, DBColumns.childSurname, DBColumns.childPatronymic, DBColumns.childBirthday, DBColumns.childParentId],
      where: '${DBColumns.childName} LIKE ? OR ${DBColumns.childSurname} LIKE ? OR ${DBColumns.childPatronymic} LIKE ?',
      whereArgs: ['%$searchString%', '%$searchString%', '%$searchString%'],
    );
    if (childrenMapList.isNotEmpty) {
      childrenMapList.forEach((employeeMap) {
        childrenList.add(Children.fromMap(employeeMap));
      });
      return childrenList;
    } else
      return null;
  }

  /// Get child records of the employee from db.
  Future<List<Children>> getChildrenOfEmployee(int employeeId) async {
    final List<Children> childrenList = [];
    final List<Map<String, dynamic>> childrenMapList = await db.query(
      DBColumns.childrenTable,
      columns: [DBColumns.childId, DBColumns.childName, DBColumns.childSurname, DBColumns.childPatronymic, DBColumns.childBirthday, DBColumns.childParentId],
      where: '${DBColumns.childParentId} = ?',
      whereArgs: [employeeId],
    );
    if (childrenMapList.isNotEmpty) {
      childrenMapList.forEach((employeeMap) {
        childrenList.add(Children.fromMap(employeeMap));
      });
      return childrenList;
    } else
      return null;
  }

  /// Get the employee record of the child from db.
  Future<Employees> getEmployeeOfChild(int employeeId) async {
    if (employeeId == null) return null;
    List<Map<String, dynamic>> employeeMapList = await db.query(
      DBColumns.employeeTable,
      columns: [DBColumns.employeeId, DBColumns.employeeName, DBColumns.employeeSurname, DBColumns.employeePatronymic, DBColumns.employeePosition, DBColumns.employeeBirthday],
      where: '${DBColumns.employeeId} = ?',
      whereArgs: [employeeId],
    );
    if (employeeMapList.isNotEmpty)
      return Employees.fromMap(employeeMapList.first);
    else
      return null;
  }
}
