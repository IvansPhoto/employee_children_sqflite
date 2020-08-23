import 'package:employee_children_sqflite/classes.dart';
import 'package:employee_children_sqflite/pages/ShowChild/ActionButtonsChild.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:employee_children_sqflite/Support.dart';

class ShowChild extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final Children child = ModalRoute.of(context).settings.arguments;
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        title: Text('${child.name} ${child.surName}'),
      ),
      body: ValueListenableBuilder(
        valueListenable: Hive.box<Children>(Boxes.childrenBox).listenable(),
        builder: (context, box, _) {
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
              ActionButtonsChild(child: child)
            ],
          );
        },
      ),
    );
  }
}
