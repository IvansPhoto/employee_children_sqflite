import 'package:flutter/material.dart';
import 'package:employee_children_sqflite/Classes.dart';
import 'package:employee_children_sqflite/GlobalStore.dart';
import 'package:employee_children_sqflite/Support.dart';

class SelectEmployeeForChild extends StatelessWidget {
  final Children child;

  SelectEmployeeForChild({this.child});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        title: Text('Parent of ${child.name} ${child.surName}'),
      ),
      body: FutureBuilder<List<Employees>>(
        future: gStore<GlobalStore>().dbProvider.getAllEmployees(),
        builder: (BuildContext context, AsyncSnapshot<List<Employees>> snapshot) {
          if (!snapshot.hasData)
            return Text('Loading...');
          else
            return ListView.builder(
              itemCount: snapshot.data.length,
              itemBuilder: (BuildContext context, index) {
                Employees employee = snapshot.data.elementAt(index);
                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 6),
                  child: Card(
                    elevation: 0,
                    child: ListTile(
                      title: Text('${employee.name} ${employee.surName}'),
                      onTap: () => showDialog(
                        context: context,
                        child: Dialog(
                          elevation: 0,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(
                                'Are you sure to',
                                textAlign: TextAlign.center,
                                textScaleFactor: textScaleFactor,
                              ),
                              if (child.parentId != null)
                                Text(
                                  'remove ${child.employee.name} ${child.employee.surName} and add ${employee.name} ${employee.surName} to ${child.name} ${child.surName}?',
                                  textAlign: TextAlign.center,
                                  textScaleFactor: textScaleFactor,
                                )
                              else
                                Text(
                                  'add ${employee.name} ${employee.surName} to ${child.name} ${child.surName}?',
                                  textAlign: TextAlign.center,
                                  textScaleFactor: textScaleFactor,
                                ),
                              ButtonBar(
                                children: [
                                  FlatButton(
                                    color: Colors.red,
                                    onPressed: () async {
                                      gStore<GlobalStore>().setEmployeeToChild(child: child, employee: employee);
                                      Navigator.pop(context);
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
                    ),
                  ),
                );
              },
            );
        },
      ),
    );
  }
}
