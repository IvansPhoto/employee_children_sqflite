import 'package:employee_children_sqflite/GlobalStore.dart';
import 'package:employee_children_sqflite/Classes.dart';
import 'package:employee_children_sqflite/Support.dart';
import 'package:flutter/material.dart';

class Index extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Home page'),
        centerTitle: true,
        actions: [
          IconButton(
            icon: Icon(Icons.clear),
            onPressed: () => showDialog(
              context: context,
              child: Dialog(
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
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            FlatButton(
              onPressed: () {
                Navigator.pushNamed(context, RouteNames.employeesList);
                gStore<GlobalStore>().getEmployeesToStream();
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
          ],
        ),
      ),
      floatingActionButton: IconButton(
        icon: Icon(Icons.info),
        onPressed: () => showAboutDialog(
          context: context,
          applicationName: 'Employees and their children',
          children: [
            Text('This is a training application for storage a list of employees and their children.', style: Theme.of(context).textTheme.bodyText1),
            Text('For state management it uses Streams (RxDart) with StreamBuilders.', style: Theme.of(context).textTheme.bodyText2),
            Text('SQLite is used as persist database.', style: Theme.of(context).textTheme.bodyText1),
            Text('Colors and TextTheme are selected for DarkTheme only.', style: Theme.of(context).textTheme.bodyText2),
          ],
        ),
        iconSize: iconSize,
      ),
    );
  }
}
