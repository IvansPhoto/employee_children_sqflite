import 'package:flutter/material.dart';
import 'package:employee_children_sqflite/Classes.dart';
import 'package:employee_children_sqflite/Support.dart';
import 'package:employee_children_sqflite/GlobalStore.dart';
import 'package:employee_children_sqflite/SupportWidgets/ActionButtons.dart';

class ShowChild extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final Children child = gStore<GlobalStore>().theChild;
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        title: Text('${child.name} ${child.surName}'),
      ),
      body: StreamBuilder(
        stream: gStore<GlobalStore>().streamTheChild$,
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting || snapshot.connectionState == ConnectionState.none)
            return Center(child: Text('Loading'));
          else
            return ListView(
              padding: EdgeInsets.symmetric(vertical: 10, horizontal: 5),
              children: <Widget>[
                Text('Name:'),
                Text('${child.name ?? 'Not specified'}', style: Theme.of(context).textTheme.bodyText1),
                Divider(),
                Text('Surname:'),
                Text('${child.surName ?? 'Not specified'}', style: Theme.of(context).textTheme.bodyText1),
                Divider(),
                Text('Patronymic:'),
                Text('${child.patronymic ?? 'Not specified'}', style: Theme.of(context).textTheme.bodyText1),
                Divider(),
                Text('Birthday:'),
                Text('${child.birthday == null ? 'Not specified' : monthFromNumber(child.birthday)}', style: Theme.of(context).textTheme.bodyText1),
                ActionButtons(child: child)
              ],
            );
        },
      ),
    );
  }
}
