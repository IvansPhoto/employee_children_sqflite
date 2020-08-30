import 'dart:io';
import 'package:employee_children_sqflite/Classes.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:rxdart/rxdart.dart';

abstract class DBColumns {
  static final String employeeTable = 'employee';
  static final String childrenTable = 'children';
  static final String id = 'id';
  static final String name = 'name';
  static final String surname = 'surname';
  static final String patronymic = 'patronymic';
  static final String birthday = 'birthday';
  static final String position = 'position';
  static final String parentId = 'parentId';
  static final String childrenId = 'childrenId';
}

class DBProvider {
//  DBProvider() {
//    initDataBase();
//  }

  Database db;

  Future<void> _onConfigure(Database db) async {
    await db.execute('PRAGMA foreign_keys = ON');
  }

  Future<void> _onOpen(Database db) async {
    print('db version ${await db.getVersion()}');
  }

  Future<void> initDataBase() async {
    //To delete the database
//    await deleteDatabase(join(await getDatabasesPath(), 'employee_children.db'));
    print('opening...');
    try {
      var databasesPath = await getDatabasesPath();
      await Directory(databasesPath).create(recursive: true);
    } catch (_) {
      print(_);
    }

    db = await openDatabase(
      join(await getDatabasesPath(), 'employee_children.db'),
      onCreate: (db, version) {
        db.execute("CREATE TABLE ${DBColumns.employeeTable}(${DBColumns.id} INTEGER PRIMARY KEY AUTOINCREMENT, "
            "${DBColumns.name} TEXT, ${DBColumns.surname} TEXT, ${DBColumns.patronymic} TEXT, ${DBColumns.birthday} TEXT, ${DBColumns.position} TEXT); ");
        db.execute("CREATE TABLE ${DBColumns.childrenTable}(${DBColumns.id} INTEGER PRIMARY KEY AUTOINCREMENT, "
            "${DBColumns.name} TEXT, ${DBColumns.surname} TEXT, ${DBColumns.patronymic} TEXT, ${DBColumns.birthday} TEXT, ${DBColumns.parentId} INTEGER, "
            "FOREIGN KEY(${DBColumns.parentId}) REFERENCES ${DBColumns.employeeTable}(${DBColumns.id}) ON UPDATE NO ACTION ON DELETE NO ACTION); ");
        return db.execute("CREATE INDEX childrenindex ON ${DBColumns.childrenTable}(${DBColumns.parentId});");
      },
      onConfigure: _onConfigure,
      onOpen: _onOpen,
      version: 1,
    ).whenComplete(() => print('open'));
  }

  Future<Employees> insertEmployee(Employees employee) async {
    try {
      employee.id = await db.insert(DBColumns.employeeTable, employee.toMap(), conflictAlgorithm: ConflictAlgorithm.replace);
      return employee;
    } catch (e) {
      print(e);
      return e;
    }
  }

  Future<Children> insertChild(Children child) async {
    try {
      child.id = await db.insert(DBColumns.childrenTable, child.toMap(), conflictAlgorithm: ConflictAlgorithm.replace);
      return child;
    } catch (e) {
      print(e);
      return e;
    }
  }

  Future<int> deleteEmployee(Employees employee) async => await db.delete(DBColumns.employeeTable, where: "${DBColumns.id} = ?", whereArgs: [employee.id]);

  Future<int> deleteChild(Children child) async => await db.delete(DBColumns.childrenTable, where: "${DBColumns.id} = ?", whereArgs: [child.id]);

  Future<int> updateEmployee(Employees employee) async => await db.update(DBColumns.employeeTable, employee.toMap(), where: "${DBColumns.id} = ?", whereArgs: [employee.id]);

  Future<int> updateChild(Children child) async => await db.update(DBColumns.childrenTable, child.toMap(), where: "${DBColumns.id} = ?", whereArgs: [child.id]);

  Future<List<Employees>> getAllEmployees() async {
    List<Employees> employeeList = [];
    List<Map<String, dynamic>> employeeMapList = await db.query(
      DBColumns.employeeTable,
      columns: [DBColumns.id, DBColumns.name, DBColumns.surname, DBColumns.patronymic, DBColumns.position, DBColumns.birthday],
    );
    if (employeeMapList.length > 0) {
      employeeMapList.forEach((employeeMap) {
        employeeList.add(Employees.fromMap(employeeMap));
      });
      return employeeList;
    } else
      return null;
  }

  Future<List<Children>> getAllChildren() async {
    List<Children> childrenList = [];
    List<Map<String, dynamic>> childrenMapList = await db.query(
      DBColumns.childrenTable,
      columns: [DBColumns.id, DBColumns.name, DBColumns.surname, DBColumns.patronymic, DBColumns.birthday, DBColumns.parentId],
    );
    if (childrenMapList.length > 0) {
      childrenMapList.forEach((employeeMap) {
        childrenList.add(Children.fromMap(employeeMap));
      });
      return childrenList;
    } else
      return null;
  }

  Future<List<Employees>> filterEmployees(String searchString) async {
    List<Employees> employeeList = [];
    List<Map<String, dynamic>> employeeMapList = await db.query(
      DBColumns.employeeTable,
      columns: [DBColumns.id, DBColumns.name, DBColumns.surname, DBColumns.patronymic, DBColumns.position, DBColumns.birthday],
      where: '${DBColumns.id} = ? OR ${DBColumns.name} = ? OR ${DBColumns.surname} = ? OR ${DBColumns.patronymic} = ? OR ${DBColumns.position} = ?',
      whereArgs: [searchString],
    );
    if (employeeMapList.length > 0) {
      employeeMapList.forEach((employeeMap) {
        employeeList.add(Employees.fromMap(employeeMap));
      });
      return employeeList;
    } else
      return null;
  }

  Future<List<Children>> filterChildren(String searchString) async {
    List<Children> childrenList = [];
    List<Map<String, dynamic>> childrenMapList = await db.query(
      DBColumns.childrenTable,
      columns: [DBColumns.id, DBColumns.name, DBColumns.surname, DBColumns.patronymic, DBColumns.birthday, DBColumns.parentId],
      where: '${DBColumns.id} = ? OR ${DBColumns.name} = ? OR ${DBColumns.surname} = ? OR ${DBColumns.patronymic} = ?',
      whereArgs: [searchString],
    );
    if (childrenMapList.length > 0) {
      childrenMapList.forEach((employeeMap) {
        childrenList.add(Children.fromMap(employeeMap));
      });
      return childrenList;
    } else
      return null;
  }

  Future<List<Children>> getEmployeeChildren(int employeeId) async {
    List<Children> childrenList = [];
    List<Map<String, dynamic>> childrenMapList = await db.query(
      DBColumns.childrenTable,
      columns: [DBColumns.id, DBColumns.name, DBColumns.surname, DBColumns.patronymic, DBColumns.birthday, DBColumns.parentId],
      where: '${DBColumns.parentId} = ?',
      whereArgs: [employeeId],
    );
    if (childrenMapList.length > 0) {
      childrenMapList.forEach((employeeMap) {
        childrenList.add(Children.fromMap(employeeMap));
      });
      return childrenList;
    } else
      return null;
  }
}
