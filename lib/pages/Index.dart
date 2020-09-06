import 'package:employee_children_sqflite/GlobalStore.dart';
import 'package:employee_children_sqflite/Classes.dart';
import 'package:employee_children_sqflite/Support.dart';
import 'package:flutter/material.dart';

class Index extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        title: const Text('Home page'),
        centerTitle: true,
        actions: [
          IconButton(
            icon: Icon(Icons.clear),
            onPressed: () => showDialog(
              context: context,
              child: Dialog(
                elevation: 0,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text('Are you sure to clear the database?', textAlign: TextAlign.center, textScaleFactor: textScaleFactor),
                    ButtonBar(
                      children: [
                        FlatButton(
                          color: Colors.red,
                          onPressed: () async {
                            gStore<GlobalStore>().dbProvider.clearDataBase();
                            Navigator.pop(context);
                          },
                          child: Text('Yes'),
                        ),
                        FlatButton(
                          onPressed: () => Navigator.pop(context),
                          child: Text("No"),
                          color: Colors.blue,
                        )
                      ],
                    )
                  ],
                ),
              ),
            ),
          )
        ],
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
                        gStore<GlobalStore>().getEmployeesToStream();
                        Navigator.pushNamed(context, RouteNames.employeesList);
                      },
                      child: const Text('Employees List'),
                      color: Colors.red[900],
                    ),
                    FlatButton(
                      onPressed: () {
                        gStore<GlobalStore>().getChildrenToStream();
                        Navigator.pushNamed(context, RouteNames.childrenList);
                      },
                      child: const Text('Children List'),
                      color: Colors.red[900],
                    ),
                    FlatButton(
                      onPressed: () {
                        gStore<GlobalStore>().getEmployeesToStream();
                        Navigator.pushNamed(context, RouteNames.employeeSliverList);
                      },
                      child: const Text('Employee SliverList'),
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
      floatingActionButton: IconButton(
        icon: Icon(Icons.info),
        onPressed: () => showAboutDialog(
          context: context,
          applicationName: 'Employees and their children',
        ),
        iconSize: iconSize,
      ),
    );
  }
}
