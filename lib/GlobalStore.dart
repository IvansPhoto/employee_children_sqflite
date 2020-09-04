import 'package:employee_children_sqflite/database.dart';
import 'package:employee_children_sqflite/Support.dart';
import 'package:get_it/get_it.dart';
import 'package:employee_children_sqflite/Classes.dart';
import 'package:rxdart/rxdart.dart';
import 'package:flutter/material.dart';

final GetIt gStore = GetIt.instance;

class GlobalStore {
	DBProvider dbProvider;
	GlobalStore({this.dbProvider});

	//Setting up streams for the LIST of employees
	final _employeeList = BehaviorSubject<List<Employees>>();

	Stream get streamEmployeesList$ => _employeeList.stream;

	void getEmployeesToStream() async {
		_employeeList.add(await dbProvider.getAllEmployees());
	}

	void filterEmployeesToStream(String searchString) async {
		// print(searchString);
		_employeeList.add(await dbProvider.filterEmployees(searchString));
	}

	//Setting up streams for The employees
	final _theEmployee = BehaviorSubject<Employees>();

	Stream get streamTheEmployee$ => _theEmployee.stream;

	set setTheEmployee(Employees employee) => _theEmployee.add(employee);

	Employees get theEmployee => _theEmployee.value;

	void insertEmployee(Employees employee) async {
		//Put the a new record to DB and set the completed record to the stream.
		_theEmployee.add(await dbProvider.insertEmployee(employee));
		//Update the stream of LIST of employees.
		_employeeList.add(await dbProvider.getAllEmployees());
	}

	void updateEmployee(Employees employee) async {
		//Update the record.
		await dbProvider.updateEmployee(employee);
		//Update the stream of the employee
		_theEmployee.add(employee);
		//Update the stream of LIST of employees.
		_employeeList.add(await dbProvider.getAllEmployees());
	}

	void deleteEmployee(Employees employee) async {
		int number = await dbProvider.deleteEmployee(employee);
		_employeeList.add(await dbProvider.getAllEmployees());
		if (number != 1) {
			print('Error in deleting $number ${employee.id}');
		}
	}

	//Setting up streams for the LIST of children
	final _childrenList = BehaviorSubject<List<Children>>();

	Stream get streamChildrenList$ => _childrenList.stream;

	void getChildrenToStream() async {
		_childrenList.add(await dbProvider.getAllChildren());
	}

	void filterChildrenToStream(String searchString) async {
		_childrenList.add(await dbProvider.filterChildren(searchString));
	}

	//Setting up streams for The child
	final _theChild = BehaviorSubject<Children>();

	Stream get streamTheChild$ => _theChild.stream;

	set setTheChild(Children child) => _theChild.add(child);

	Children get theChild => _theChild.value;

	void insertChild(Children child) async {
		//Put the a new record to DB and set the completed record to the stream.
		_theChild.add(await dbProvider.insertChild(child));
		//Update the stream of LIST of children.
		_childrenList.add(await dbProvider.getAllChildren());
	}

	void updateChild(Children child) async {
		//Update the record.
		await dbProvider.updateChild(child);
		//Update the stream of the child
		_theChild.add(child);
		//Update the stream of LIST of children.
		_childrenList.add(await dbProvider.getAllChildren());
		//Update the stream of LIST of employees.
		_employeeList.add(await dbProvider.getAllEmployees());
	}

	void deleteChild(Children child) async {
		int number = await dbProvider.deleteChild(child);
		_childrenList.add(await dbProvider.getAllChildren());
		if (number != 1) {
			print('Error in deleting $number ${child.id}');
		}
	}
}
