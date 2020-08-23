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
          ButtonAddChildrenEmployee(snackBarText: 'An employee has been added.', genChild: false)
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: StreamBuilder(
                stream: gStore<GlobalStore>().streamEmployeeList$,
                builder: (BuildContext context, AsyncSnapshot snapshot) {
                  if (snapshot.connectionState != ConnectionState.active || snapshot.data == null) return Center(child: Text('No employee in the list')); //Return a text if there are no records.
                  return ListView.builder(
                    itemCount: snapshot.data.length,
                    itemBuilder: (context, index) {
                      Employees theEmployee = snapshot.data.elementAt(index);
                      return Card(
                        elevation: 0,
                        child: ListTile(
                          title: Text('${theEmployee.surName} ${theEmployee.name}'),
                          subtitle: Text(theEmployee.children == null || theEmployee.children.length == 0 ? 'No children' : '${theEmployee.children.length} children'),
                          onTap: () {
                            gStore<GlobalStore>().theEmployee = theEmployee; //Put the employee to the Global store
                            Navigator.of(context).pushNamed(RouteNames.showEmployee); //Go to the page for showing of the employee
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
