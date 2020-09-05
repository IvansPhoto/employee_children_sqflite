import 'package:flutter/material.dart';
import 'package:employee_children_sqflite/database.dart';
import 'package:employee_children_sqflite/Classes.dart';
import 'package:employee_children_sqflite/GlobalStore.dart';
import 'package:employee_children_sqflite/pages/Index.dart';
import 'package:employee_children_sqflite/pages/EmployeesList.dart';
import 'package:employee_children_sqflite/pages/ChildrenList.dart';
import 'package:employee_children_sqflite/pages/ShowEmployee/ShowEmployee.dart';
import 'package:employee_children_sqflite/pages/ShowChild/ShowChild.dart';
import 'package:employee_children_sqflite/pages/NewEmployee/NewEmployee.dart';
import 'package:employee_children_sqflite/pages/NewChild/NewChild.dart';
import 'package:employee_children_sqflite/pages/SelectChildren/SelectChildren.dart';
import 'package:employee_children_sqflite/DeleteMany/DeleteMany.dart';

void main() async {
	//For database.
	WidgetsFlutterBinding.ensureInitialized();

	//Init a global store with database.
	gStore.registerSingleton<GlobalStore>(GlobalStore(dbProvider: DBProvider()));

	runApp(MaterialApp(
		title: 'Employees and their children.',
		initialRoute: RouteNames.index,
		routes: {
			RouteNames.index: (BuildContext context) => Index(),
			RouteNames.employeesList: (BuildContext context) => EmployeesList(),
			RouteNames.childrenList: (BuildContext context) => ChildrenList(),
			RouteNames.showEmployee: (BuildContext context) => ShowEmployee(),
			RouteNames.showChild: (BuildContext context) => ShowChild(),
			RouteNames.newEmployee: (BuildContext context) => NewEmployee(),
			RouteNames.newChildren: (BuildContext context) => NewChild(),
			RouteNames.selectChildren: (BuildContext context) => SelectChildren(),
			RouteNames.deleteMany: (BuildContext context) => DeleteMany(),
		},
		theme: ThemeData(
			fontFamily: 'RobotoMono',
			brightness: Brightness.light,
			primaryColor: Colors.red[900],
			primaryColorDark: Colors.red[700],
			primaryColorLight: Colors.red[500],
		),
		darkTheme: ThemeData(
			fontFamily: 'RobotoMono',
			iconTheme: IconThemeData(size: 35, color: Colors.amber),
			brightness: Brightness.dark,
			primaryColor: Colors.red[900],
			primaryColorDark: Colors.red[700],
			primaryColorLight: Colors.red[500],
			buttonTheme: ButtonThemeData(
				textTheme: ButtonTextTheme.normal,
				height: 15,
				buttonColor: Colors.red[900],
			),
			textTheme: TextTheme(
					bodyText1: TextStyle(color: Colors.red, fontSize: 20),
					bodyText2: TextStyle(color: Colors.amber, fontSize: 20),
					caption: TextStyle(color: Color.fromRGBO(15, 205, 205, 1), fontSize: 20),
					button: TextStyle(color: Colors.blue, fontSize: 20),
					subtitle1: TextStyle(color: Colors.deepOrange, fontSize: 20),
					headline3: TextStyle(decoration: TextDecoration.overline, fontSize: 20)),
			dialogTheme: DialogTheme(
				elevation: 0,
				titleTextStyle: TextStyle(color: Colors.purple, fontSize: 20),
				contentTextStyle: TextStyle(color: Colors.blueAccent, fontSize: 20),
			),
			buttonBarTheme: ButtonBarThemeData(
				alignment: MainAxisAlignment.center,
				buttonHeight: 35,
				buttonMinWidth: 150,
			),
		),
	));
}

//Необходимо создать приложение на Flutter в котором будет реализована возможность вноса списка сотрудников и их детей.
//Должна быть возможность просмотра "подчиненного списка" детей
//Сцены:

//При открытии приложения появляется список в который можно внести сотрудников. Для внесения необходимы данные:
//1.      Фамилия
//2.      Имя
//3.      Отчество
//4.      Дата рождения
//5.      Должность

//При выборе сотрудника появляется список для ввода детей данного сотрудника, должна быть возможность внесения данных по ребенку:
//1.      Фамилия
//2.      Имя
//3.      Отчество
//4.      Дата рождения

//Должна быть возможность вернуться назад к Родителю.

//В списке сотрудников при наличии у них детей должно отображаться количество детей.

//Вариант хранения данных можно выбрать по своему усмотрению (XML, SQLLite, прочее). Возможен вариант реализации без хранения данных.
