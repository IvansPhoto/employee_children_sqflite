import 'package:flutter/material.dart';
import 'package:employee_children_sqflite/Classes.dart';
import 'package:employee_children_sqflite/GlobalStore.dart';
import 'package:employee_children_sqflite/Support.dart';

class SelectEmployeeForChild extends StatelessWidget {
  final Children child;

  SelectEmployeeForChild({this.child});

  void _confirmation({Employees employee, BuildContext context}) {
    child.parentId = employee.id;
    gStore<GlobalStore>()
      ..setEmployeeToChild(child: child, employee: employee)
      ..setTheChild = child
      ..setTheEmployee = employee
      ..getChildrenToStream();
    Navigator.of(context)..pop('added')..pop('added');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Parent for ${child.name} ${child.surName}')),
      body: StreamBuilder<List<Employees>>(
        stream: gStore<GlobalStore>().streamAllEmployees$,
        builder: (BuildContext context, AsyncSnapshot<List<Employees>> snapshot) {
          if (!snapshot.hasData)
            return Center(child: Text('No employees in the list.'));
          else
            return ListView.builder(
              itemExtent: 65,
              itemCount: snapshot.data.length,
              itemBuilder: (BuildContext context, index) {

                int employeeId = snapshot.data.indexWhere((employee) => employee.id == child.parentId);
                Employees selectedEmployee = snapshot.data.removeAt(employeeId);
                snapshot.data.insert(0, selectedEmployee);

                // snapshot.data.sort((e1, e2) => e1.id == child.parentId ? 0 : 1);

                // snapshot.data.reversed;
                Employees employee = snapshot.data.elementAt(index);
                return Center(
                  child: Card(
                    elevation: 0,
                    // margin: EdgeInsets.all(5),
                    child: ListTile(
                      title: Text('${employee.name} ${employee.surName} - ${employee.position}'),
                      trailing: child.parentId == employee.id ? Icon(Icons.check_circle_outline) : null,
                      onTap: () => showDialog(
                        context: context,
                        builder: (BuildContext context) => Dialog(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text('Are you sure to', textAlign: TextAlign.center, textScaleFactor: textScaleFactor),
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
                                    onPressed: () => _confirmation(employee: employee, context: context),
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
