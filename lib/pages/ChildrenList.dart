import 'package:flutter/material.dart';
import 'package:employee_children_sqflite/GlobalStore.dart';
import 'package:employee_children_sqflite/Classes.dart';
import 'package:employee_children_sqflite/Support.dart';
import 'package:employee_children_sqflite/database.dart';

class ChildrenList extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        title: const Text('The list of children'),
        actions: [ButtonAddChildrenEmployee(snackBarText: 'A child has been added.', forChild: true)],
      ),
      body: Column(
        children: [
          Expanded(
            child: StreamBuilder(
                stream: gStore<GlobalStore>().streamChildrenList$,
                // ignore: missing_return
                builder: (BuildContext context, AsyncSnapshot snapshot) {
                  if (snapshot.hasError) return Center(child: Text('Error ${snapshot.data}'));
                  if (!snapshot.hasData) return Center(child: Text('No children in the list'));
                  switch (snapshot.connectionState) {
                    case ConnectionState.active:
                    case ConnectionState.done:
                      return ListView.builder(
                        itemCount: snapshot.data.length,
                        itemBuilder: (context, index) {
                          Children child = snapshot.data.elementAt(index);
                          return Card(
                            elevation: 0,
                            child: ListTile(
                              title: Text('${child.surName} ${child.name}'),
                              subtitle: Text(monthFromNumber(child.birthday)),
                              onTap: () async {
                                //Set the child to the Global store.
                                gStore<GlobalStore>().setTheChild = child;
                                //Go to the page for showing of the child and await the message 'edited' or 'deleted'.
                                final message = await Navigator.of(context).pushNamed(RouteNames.showChild, arguments: child);
                                Scaffold.of(context)
                                  ..removeCurrentSnackBar()
                                  ..showSnackBar(SnackBar(content: Text('${child.name} ${child.surName} ${message ?? ''}')));
                              },
                            ),
                          );
                        },
                      );
                    case ConnectionState.none:
                      return Center(child: Text('Error'));
                    case ConnectionState.waiting:
                      return Center(child: Text('Loading'));
                  } //Return a text if there are no records.
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
