import 'package:flutter/material.dart';
import 'package:employee_children_sqflite/classes.dart';
import 'package:employee_children_sqflite/GlobalStore.dart';
import 'package:employee_children_sqflite/Support.dart';
import 'package:employee_children_sqflite/database.dart';

class EmployeesList extends StatelessWidget {
  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        title: const Text('The list of employees'),
        actions: [
          ButtonAddChildrenEmployee(snackBarText: 'An employee has been added.', forChild: false)
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: StreamBuilder(
                stream: gStore<GlobalStore>().streamEmployeesList$,
                builder: (BuildContext context, AsyncSnapshot snapshot) {
                  if (snapshot.connectionState != ConnectionState.active || snapshot.data == null) return Center(child: Text('No employee in the list')); //Return a text if there are no records.
                  return ListView.builder(
                    itemCount: snapshot.data.length,
                    itemBuilder: (context, index) {
                      Employees employee = snapshot.data.elementAt(index);
                      return Card(
                        elevation: 0,
                        child: ListTile(
                          title: Text('${employee.surName} ${employee.name}'),
                          subtitle: Text(employee.children == null || employee.children.length == 0 ? 'No children' : '${employee.children.length} children'),
                          onTap: () async {
                            gStore<GlobalStore>().setTheEmployee(employee); //Put the employee to the Global store
                            //Go to the page for showing of the employee and await the message 'edited' or 'deleted'.
                            final message = await Navigator.of(context).pushNamed(RouteNames.showEmployee);
                            Scaffold.of(context)
                              ..removeCurrentSnackBar()
                              ..showSnackBar(SnackBar(content: Text('${employee.name} ${employee.surName} ${message ?? ''}')));
                          },
                        ),
                      );
                    },
                  );
                }),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(15, 1, 65, 1),
            child: TextFormField(
              maxLength: 50,
              decoration: const InputDecoration(hintText: 'Matches in name or surname', labelText: 'Searching', hintStyle: TextStyle(fontSize: 15)),
              onChanged: (text) => gStore<DBProvider>().filterEmployees(text),
            ),
          )
        ],
      ),
//      floatingActionButton: IconButton(
//        icon: const Icon(Icons.add_circle),
//        onPressed: () => Navigator.pushNamed(context, RouteNames.newEmployee, arguments: true),
//        iconSize: 35,
//      ),
    );
  }
}
