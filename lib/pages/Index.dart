import 'package:employee_children_sqflite/GlobalStore.dart';
import 'package:employee_children_sqflite/Classes.dart';
import 'package:flutter/material.dart';

class Index extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        title: const Text('Home page'),
      ),
      body: Center(
        child: FutureBuilder(
          future: gStore<GlobalStore>().dbProvider.initDataBase(), //For asynchronous opening the database.
          // ignore: missing_return
          builder: (context, snapshot) {
	          if (snapshot.hasError) return Center(child: Text('Error ${snapshot.data}'));
            switch (snapshot.connectionState) {
              case ConnectionState.waiting:
                return Center(child: Text('Loading...'));
              case ConnectionState.active:
              case ConnectionState.done:
                return Column(
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
                        gStore<GlobalStore>().setChildrenToStream();
                        Navigator.pushNamed(context, RouteNames.childrenList);
                      },
                      child: const Text('Children List'),
                      color: Colors.red[900],
                    ),
                  ],
                );
              case ConnectionState.none:
                return Center(child: Text('Error'));
            }
          },
        ),
      ),
    );
  }
}
