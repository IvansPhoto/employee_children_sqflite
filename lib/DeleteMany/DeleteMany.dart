import 'package:flutter/material.dart';
import 'package:employee_children_sqflite/GlobalStore.dart';
import 'package:employee_children_sqflite/Classes.dart';
import 'package:employee_children_sqflite/Support.dart';
import 'package:employee_children_sqflite/DeleteMany/EmployeeCard.dart';

class DeleteMany extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Expanded(
            child: StreamBuilder<List<Employees>>(
                stream: gStore<GlobalStore>().streamEmployeesList$,
                builder: (BuildContext context, AsyncSnapshot<List<Employees>> snapshot) {
                  //Return a text if there are no records.
                  if (snapshot.connectionState != ConnectionState.active || snapshot.data == null) return Center(child: Text('No employee in the list'));
                  print(snapshot.data.length);
                  return ListView.builder(
                    itemCount: snapshot.data.length,
                    itemBuilder: (context, index) {
                      Employees employee = snapshot.data.elementAt(index);
                      employee.isSelected ??= false;
                      print('$index ${employee.isSelected}');
                      return EmployeeCard(
                        employee: employee,
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
        icon: Icon(Icons.delete_forever),
        iconSize: iconSize,
        onPressed: () => showDialog(
          context: context,
          child: Dialog(
		          elevation: 0,
		          child: Column(
			          mainAxisAlignment: MainAxisAlignment.center,
			          crossAxisAlignment: CrossAxisAlignment.center,
			          mainAxisSize: MainAxisSize.min,
			          children: [
				          Text('Are you sure to Delete selected employees?', textAlign: TextAlign.center, textScaleFactor: textScaleFactor),
				          ButtonBar(
					          children: [
						          FlatButton(
							          color: Colors.red,
							          onPressed: () async {
							          	print('Pushed Yes');
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
    );
  }
}
