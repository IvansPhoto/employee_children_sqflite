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

abstract class EmployeeColumns {
	static final String employeeTable = 'employeeTable';
	static final String employeeId = 'employeeId';
	static final String employeeName = 'employeeName';
	static final String employeeSurname = 'employeeSurname';
	static final String employeePatronymic = 'employeePatronymic';
	static final String employeeBirthday = 'employeeBirthday';
	static final String employeePosition = 'employeePosition';
}

abstract class ChildColumns {
	static final String childrenTable = 'childrenTable';
	static final String childId = 'childId';
	static final String childName = 'childName';
	static final String childSurname = 'childSurname';
	static final String childPatronymic = 'childPatronymic';
	static final String childBirthday = 'childBirthday';
	static final String childPosition = 'childPosition';
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
		print('DB is opening...');
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
						"FOREIGN KEY(${DBColumns.parentId}) REFERENCES ${DBColumns.employeeTable}(${DBColumns.id}) ON UPDATE CASCADE ON DELETE CASCADE); ");
				return db.execute("CREATE INDEX childrenindex ON ${DBColumns.childrenTable}(${DBColumns.parentId});");
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
	Future<int> deleteEmployee(Employees employee) async => await db.delete(DBColumns.employeeTable, where: "${DBColumns.id} = ?", whereArgs: [employee.id]);

	/// Delete several employee records from db.
	Future<int> deleteSeveralEmployee(List<Employees> employeesList) async {
		var batch = db.batch();

		employeesList.forEach((employee) async {
			batch.delete(DBColumns.employeeTable, where: "${DBColumns.id} = ?", whereArgs: [employee.id]);
		});

		List<dynamic> result = await batch.commit().catchError((e) => throw e);
		return result.length;
	}

	/// Delete an child record from db.
	Future<int> deleteChild(Children child) async => await db.delete(DBColumns.childrenTable, where: "${DBColumns.id} = ?", whereArgs: [child.id]);

	/// Update an employee record in db.
	Future<int> updateEmployee(Employees employee) async => await db.update(DBColumns.employeeTable, employee.toMap(), where: "${DBColumns.id} = ?", whereArgs: [employee.id]);

	/// Update a child record in db.
	Future<int> updateChild(Children child) async => await db.update(DBColumns.childrenTable, child.toMap(), where: "${DBColumns.id} = ?", whereArgs: [child.id]);

	/// Get all employee records from db.
	Future<List<Employees>> getAllEmployees() async {
		List<Employees> employeeList = [];
		List<Map<String, dynamic>> employeeMapList = await db.query(
			DBColumns.employeeTable,
			columns: [DBColumns.id, DBColumns.name, DBColumns.surname, DBColumns.patronymic, DBColumns.position, DBColumns.birthday],
		);
		if (employeeMapList.isNotEmpty) {
			employeeMapList.forEach((employeeMap) {
				employeeList.add(Employees.fromMap(employeeMap));
			});
			return employeeList;
		} else
			return null;
	}

	/// Get all employee records from db with their children. Work in progress!
	void getAllEmployeesWithChildren() async {
		List<Employees> employeeList = [];
		List<Map<String, dynamic>> employeeMapList = await db.rawQuery('SELECT * FROM ${DBColumns.employeeTable} '
				'LEFT JOIN ${DBColumns.childrenTable} ON ${DBColumns.childrenTable}.${DBColumns.parentId} = ${DBColumns.employeeTable}.${DBColumns.id}');
		employeeMapList.forEach(print);
		// List<Employees> employeeList = [];
		// List<Map<String, dynamic>> employeeMapList = await db.query(
		// 	DBColumns.employeeTable,
		// 	columns: [DBColumns.id, DBColumns.name, DBColumns.surname, DBColumns.patronymic, DBColumns.position, DBColumns.birthday],
		//
		// );
		//
		// if (employeeMapList.isNotEmpty) {
		// 	employeeMapList.forEach((employeeMap) {
		// 		employeeList.add(Employees.fromMap(employeeMap));
		// 	});
		// 	return employeeList;
		// } else
		// 	return null;
	}

	/// Get all child records from db.
	Future<List<Children>> getAllChildren() async {
		List<Children> childrenList = [];
		List<Map<String, dynamic>> childrenMapList = await db.query(
			DBColumns.childrenTable,
			columns: [DBColumns.id, DBColumns.name, DBColumns.surname, DBColumns.patronymic, DBColumns.birthday, DBColumns.parentId],
		);
		if (childrenMapList.isNotEmpty) {
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
			where: '${DBColumns.name} LIKE ? OR ${DBColumns.surname} LIKE ? OR ${DBColumns.patronymic} LIKE ?',
			whereArgs: ['%$searchString%', '%$searchString%', '%$searchString%'],
		);

		if (employeeMapList.isNotEmpty) {
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
			where: '${DBColumns.name} LIKE ? OR ${DBColumns.surname} LIKE ? OR ${DBColumns.patronymic} LIKE ?',
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
		List<Children> childrenList = [];
		List<Map<String, dynamic>> childrenMapList = await db.query(
			DBColumns.childrenTable,
			columns: [DBColumns.id, DBColumns.name, DBColumns.surname, DBColumns.patronymic, DBColumns.birthday, DBColumns.parentId],
			where: '${DBColumns.parentId} = ?',
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
		if(employeeId == null) return null;
		List<Map<String, dynamic>> employeeMapList = await db.query(
			DBColumns.employeeTable,
			columns: [DBColumns.id, DBColumns.name, DBColumns.surname, DBColumns.patronymic, DBColumns.position, DBColumns.birthday],
			where: '${DBColumns.id} = ?',
			whereArgs: [employeeId],
		);
		if (employeeMapList.isNotEmpty)
			return Employees.fromMap(employeeMapList.first);
		else
			return null;
	}
}
