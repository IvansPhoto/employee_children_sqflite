import 'package:flutter/material.dart';
import 'package:employee_children_sqflite/Classes.dart';
import 'package:employee_children_sqflite/GlobalStore.dart';
import 'package:employee_children_sqflite/Support.dart';

class EmployeesList extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
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
                stream: gStore<GlobalStore>().streamAllEmployees$,
                // ignore: missing_return
                builder: (BuildContext context, AsyncSnapshot<List<Employees>> snapshot) {
                  if (snapshot.hasError)
                    return Center(child: Text('Some error occurred:\n${snapshot.error}'));
                  else
                    switch (snapshot.connectionState) {
                      case ConnectionState.none:
                      case ConnectionState.waiting:
                        return Center(child: Text('Waiting database...'));
                        break;
                      case ConnectionState.active:
                      case ConnectionState.done:
                        if (!snapshot.hasData)
                          return Center(child: Text('No employee in the list'));
                        else
                          return ListView.builder(
                            itemExtent: 75,
                            itemCount: snapshot.data.length,
                            itemBuilder: (context, index) {
                              Employees employee = snapshot.data.elementAt(index);
                              return Card(
                                elevation: 0,
                                child: ListTile(
                                  title: Text('${employee.name} ${employee.surName} ${employee.position}'),
                                  subtitle: employee.children.isNotEmpty
                                      ? Text('Children ${employee.children.length}')
                                      : const Text('No children', style: TextStyle(color: Colors.amber)),
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
                    }
                  ;
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
        onPressed: () async {
          final message = await Navigator.pushNamed(context, RouteNames.newEmployee, arguments: true);
          if (message != null) {
            final Employees newEmployee = gStore<GlobalStore>().theEmployee;
            Scaffold.of(context)
              ..removeCurrentSnackBar()
              ..showSnackBar(SnackBar(
                content: Text('${newEmployee.name} ${newEmployee.surName} $message'),
                duration: Duration(seconds: 1),
              ));
          }
        },
        iconSize: iconSize,
      ),
    );
  }
}
