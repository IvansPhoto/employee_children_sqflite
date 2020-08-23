import 'package:flutter/material.dart';
import 'package:employee_children_sqflite/GlobalStore.dart';
import 'package:employee_children_sqflite/classes.dart';
import 'package:employee_children_sqflite/Support.dart';
import 'package:employee_children_sqflite/database.dart';

class ChildrenList extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        title: const Text('The list of children'),
        actions: [
          ButtonAddChildrenEmployee(snackBarText: 'A child has been added.', genChild: true)
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: StreamBuilder(
                stream: gStore<GlobalStore>().streamChildrenList$,
                builder: (BuildContext context, AsyncSnapshot snapshot) {
                  if (snapshot.connectionState != ConnectionState.active) return Center(child: Text('No children in the list')); //Return a text if there are no records.
                  return ListView.builder(
                    itemCount: snapshot.data.length,
                    itemBuilder: (context, index) {
                      Children theChild = snapshot.data.elementAt(index);
                      return Card(
                        elevation: 0,
                        child: ListTile(
                          title: Text('${theChild.surName} ${theChild.name}'),
                          subtitle: Text(monthFromNumber(theChild.birthday)),
                          onTap: () => Navigator.of(context).pushNamed(RouteNames.showChild, arguments: theChild),
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
              onChanged: (text) => gStore<DBProvider>().filterChildren(text),
            ),
          )
        ],
      ),
      floatingActionButton: IconButton(
        icon: const Icon(Icons.add_circle),
        onPressed: () => Navigator.pushNamed(context, RouteNames.newChildren),
	      iconSize: 35,
      ),
    );
  }
}
