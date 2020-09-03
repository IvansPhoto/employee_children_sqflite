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
}

class SelectedChildren {
	Children child;
	bool selected;

	SelectedChildren({this.child, this.selected});

	void unSelect() => selected = !selected;
}

class Employees {
	int id;

	String name;

	String surName;

	String patronymic;

	DateTime birthday;

	String position;

	List<Children> children;

	List<int> childrenId;

	Employees({this.id, this.name, this.surName, this.patronymic, this.birthday, this.position, this.children});

	Employees.fromMap(Map<String, dynamic> employeeMap) {
		id = employeeMap[DBColumns.id];
		name = employeeMap[DBColumns.name];
		surName = employeeMap[DBColumns.surname];
		patronymic = employeeMap[DBColumns.patronymic];
		birthday = DateTime.parse(employeeMap[DBColumns.birthday]);
		position = employeeMap[DBColumns.position];
		childrenId = employeeMap[DBColumns.childrenId];
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

	Children({this.id, this.name, this.surName, this.patronymic, this.birthday, this.parentId});

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
			DBColumns.parentId: parentId	?? (employee == null ? null : employee.id),
		};
		if (id != null) map[DBColumns.id] = id;
		return map;
	}


}
