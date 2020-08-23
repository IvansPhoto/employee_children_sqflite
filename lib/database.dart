import 'dart:async';
import 'package:flutter/widgets.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

abstract class ColumnDataBase {
  static final String id = 'id';
  static final String name = 'name';
  static final String surname = 'surname';
  static final String patronymic = 'patronymic';
  static final String birthday = 'birthday';
  static final String position = 'position';
  static final String parentId = 'parentId';
}

class DBProvider {
  Database db;

  Future<void> initDataBase() async {
    db = await openDatabase(
      join(await getDatabasesPath(), 'employee_children.db'),
      onCreate: (db, version) {
        return db.execute(
          "CREATE TABLE employee(${ColumnDataBase.id} INTEGER PRIMARY KEY, ${ColumnDataBase.name} TEXT, ${ColumnDataBase.surname} TEXT, ${ColumnDataBase.patronymic} TEXT, ${ColumnDataBase.birthday} TEXT, ${ColumnDataBase.position} TEXT)",
        );
      },
      version: 1,
    );
  }
}
