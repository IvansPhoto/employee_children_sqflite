import 'package:employee_children_sqflite/database.dart';

abstract class RouteNames {
	static final index = '/';
	static final employeesList = '/EmployeesList';
	static final showEmployee = '/ShowEmployee';
	static final newEmployee = '/NewEmployee/NewEmployee';
	static final childrenList = '/ChildrenList';
	static final showChild = '/ShowChild';
	static final newChildren = '/NewChild/NewChild';
	static final selectChildren = '/SelectChildren/SelectChildren';
	static final deleteManyEmployees = '/DeleteManyRecords/DeleteManyRecordsEmployees';
	static final deleteManyChildren = '/DeleteManyEmployees/DeleteManyEmployees';
	static final employeeSliverList = '/SliverLists/EmployeeListSlivers';
}

class Employees {
	int id;

	String name;

	String surName;

	String patronymic;

	DateTime birthday;

	String position;

	List<Children> children;

	bool isSelected = false;

	Employees({this.id, this.name, this.surName, this.patronymic, this.birthday, this.position, this.children, this.isSelected});

	Employees.fromMap(Map<String, dynamic> employeeMap) {
		id = employeeMap[DBColumns.id];
		name = employeeMap[DBColumns.name];
		surName = employeeMap[DBColumns.surname];
		patronymic = employeeMap[DBColumns.patronymic];
		birthday = DateTime.parse(employeeMap[DBColumns.birthday]);
		position = employeeMap[DBColumns.position];
		// children = List.generate(employeeMap['child'], (index) => Children.fromMap(employeeMap['child'][index]));
	}

	Map<String, dynamic> toMap() {
		var map = <String, dynamic>{
			DBColumns.name: name,
			DBColumns.surname: surName,
			DBColumns.patronymic: patronymic,
			DBColumns.birthday: birthday.toIso8601String(),
			DBColumns.position: position,
		};
		if (id != null) map[DBColumns.id] = id;
		return map;
	}
}

class Children {
	int id;

	String name;

	String surName;

	String patronymic;

	DateTime birthday;

	int parentId;

	Employees employee;

	bool isSelected = false;

	Children({this.id, this.name, this.surName, this.patronymic, this.birthday, this.parentId, this.employee, this.isSelected});

	Children.fromMap(Map<String, dynamic> childrenMap) {
		id = childrenMap[DBColumns.id];
		name = childrenMap[DBColumns.name];
		surName = childrenMap[DBColumns.surname];
		patronymic = childrenMap[DBColumns.patronymic];
		birthday = DateTime.parse(childrenMap[DBColumns.birthday]);
		parentId = childrenMap[DBColumns.parentId];
	}

	Map<String, dynamic> toMap() {
		var map = <String, dynamic>{
			DBColumns.name: name,
			DBColumns.surname: surName,
			DBColumns.patronymic: patronymic,
			DBColumns.birthday: birthday.toIso8601String(),
			DBColumns.parentId: parentId ?? (employee == null ? null : employee.id),
		};
		if (id != null) map[DBColumns.id] = id;
		return map;
	}


}
