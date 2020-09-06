import 'package:flutter/material.dart';
import 'package:employee_children_sqflite/Classes.dart';
import 'package:employee_children_sqflite/GlobalStore.dart';
import 'package:employee_children_sqflite/Support.dart';
import 'package:employee_children_sqflite/SupportWidgets/NumberChildren.dart';

class EmployeesList extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        title: const Text('The employees'),
        actions: [
          ButtonAddChildrenEmployee(forChild: false),
          IconButton(
            icon: Icon(Icons.delete_forever),
            onPressed: () {
              Navigator.pushNamed(context, RouteNames.deleteManyEmployees);
              // Navigator.of(context).pushNamed(RouteNames.deleteManyEmployees);
            },
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: StreamBuilder<List<Employees>>(
                stream: gStore<GlobalStore>().streamEmployeesList$,
                builder: (BuildContext context, AsyncSnapshot<List<Employees>> snapshot) {
                  if (snapshot.connectionState != ConnectionState.active || snapshot.data == null)
                    //Return a text if there are no records.
                    return Center(child: Text('No employee in the list'));
                  return ListView.builder(
                    itemCount: snapshot.data.length,
                    itemBuilder: (context, index) {
                      Employees employee = snapshot.data.elementAt(index);
                      return Card(
                        elevation: 0,
                        child: ListTile(
                          title: Text('${employee.name} ${employee.surName} ${employee.position}'),
                          subtitle: NumberChildren(employee: employee),
                          onTap: () {
                            //Set the employee to the Global store.
                            gStore<GlobalStore>().setTheEmployee = employee;
                            //Go to the page for showing of the employee and await the message 'edited' or 'deleted'.
                            Navigator.of(context).pushNamed(RouteNames.showEmployee);
                          },
                        ),
                      );
                    },
                  );
                }),
          ),
          Padding(
            padding: filterPadding,
            child: TextFormField(
              maxLength: 50,
              decoration: const InputDecoration(hintText: 'Matches in name or surname', labelText: 'Searching', hintStyle: TextStyle(fontSize: 15)),
              onChanged: (text) => text == null || text.length == 0 ? gStore<GlobalStore>().getEmployeesToStream() : gStore<GlobalStore>().filterEmployeesToStream(text),
            ),
          )
        ],
      ),
      floatingActionButton: IconButton(
        icon: const Icon(Icons.add_circle),
        onPressed: () => Navigator.pushNamed(context, RouteNames.newEmployee, arguments: true),
        iconSize: iconSize,
      ),
    );
  }
}
