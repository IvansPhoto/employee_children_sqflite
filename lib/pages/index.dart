import 'package:employee_children_sqflite/GlobalStore.dart';
import 'package:employee_children_sqflite/classes.dart';
import 'package:flutter/material.dart';
import 'package:employee_children_sqflite/database.dart';

class Index extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        title: const Text('Home page'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            FlatButton(
              onPressed: () {
                gStore<GlobalStore>().setEmployeesToStream();
                Navigator.pushNamed(context, RouteNames.employeesList);
              },
              child: const Text('Employees List'),
              color: Colors.red[900],
            ),
            FlatButton(
              onPressed: () {
//                gStore<GlobalStore>().setChildrenToStream();
                Navigator.pushNamed(context, RouteNames.childrenList);
              },
              child: const Text('Children List'),
              color: Colors.red[900],
            ),
          ],
        ),
      ),
    );
  }
}
