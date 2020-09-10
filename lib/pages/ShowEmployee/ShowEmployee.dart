import 'package:flutter/material.dart';
import 'package:employee_children_sqflite/Classes.dart';
import 'package:employee_children_sqflite/Support.dart';
import 'package:employee_children_sqflite/GlobalStore.dart';
import 'package:employee_children_sqflite/SupportWidgets/ActionButtons.dart';

class ShowEmployee extends StatelessWidget {
  final store = gStore.get<GlobalStore>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: StreamBuilder<Employees>(
              stream: gStore<GlobalStore>().streamTheEmployee$,
              builder: (BuildContext context, AsyncSnapshot snapshot) {
                if (!snapshot.hasData)
                  return Text('Employee profile.');
                else
                  return Text('${snapshot.data.name} ${snapshot.data.surName}');
              })),
      body: StreamBuilder<Employees>(
          stream: gStore<GlobalStore>().streamTheEmployee$,
          builder: (BuildContext context, AsyncSnapshot<Employees> snapshot) {
            if (!snapshot.hasData)
              return Center(child: Text('Loading ${snapshot.hasData}'));
            else if (snapshot.hasError)
              return Text('${snapshot.error}');
            else {
              print('ShowEmployee, snapshot.hasData ${snapshot.hasData}. Employee id: ${snapshot.data.id}, name: ${snapshot.data.name}, ${snapshot.data.children.length}');
              return ListView(
                padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                children: <Widget>[
                  //Name
                  RichText(
                      textScaleFactor: textScaleFactor,
                      text: TextSpan(
                        style: DefaultTextStyle.of(context).style,
                        children: <TextSpan>[
                          const TextSpan(text: 'Name:\n'),
                          TextSpan(text: snapshot.data.name ?? 'Not specified', style: Theme.of(context).textTheme.bodyText1),
                        ],
                      )),
                  Divider(),
                  //Surname
                  RichText(
                      textScaleFactor: textScaleFactor,
                      text: TextSpan(
                        style: DefaultTextStyle.of(context).style,
                        children: <TextSpan>[
                          const TextSpan(text: 'Surname:\n'),
                          TextSpan(text: snapshot.data.surName ?? 'Not specified', style: Theme.of(context).textTheme.bodyText1),
                        ],
                      )),
                  Divider(),
                  //patronymic
                  RichText(
                      textScaleFactor: textScaleFactor,
                      text: TextSpan(
                        style: DefaultTextStyle.of(context).style,
                        children: <TextSpan>[
                          const TextSpan(text: 'Patronymic:\n'),
                          TextSpan(text: snapshot.data.patronymic ?? 'Not specified', style: Theme.of(context).textTheme.bodyText1),
                        ],
                      )),
                  Divider(),
                  //Birthday
                  RichText(
                      textScaleFactor: textScaleFactor,
                      text: TextSpan(
                        style: DefaultTextStyle.of(context).style,
                        children: <TextSpan>[
                          const TextSpan(text: 'Birthday:\n'),
                          TextSpan(
                            text: snapshot.data.birthday == null ? 'Not specified' : monthFromNumber(snapshot.data.birthday),
                            style: Theme.of(context).textTheme.bodyText1,
                          ),
                        ],
                      )),
                  Divider(),
                  //Position
                  RichText(
                      textScaleFactor: textScaleFactor,
                      text: TextSpan(
                        style: DefaultTextStyle.of(context).style,
                        children: <TextSpan>[
                          const TextSpan(text: 'Position:\n'),
                          TextSpan(text: snapshot.data.position ?? 'Not specified', style: Theme.of(context).textTheme.bodyText1),
                        ],
                      )),
                  Divider(),
                  //List of children
                  Text('Children:', style: DefaultTextStyle.of(context).style, textScaleFactor: textScaleFactor),
                  if (snapshot.data.children.isEmpty) Text('Without children', textScaleFactor: textScaleFactor, style: Theme.of(context).textTheme.bodyText1),
                  ...[
                    for (var child in snapshot.data.children) Text('${child.name} ${child.surName}', style: Theme.of(context).textTheme.bodyText1, textScaleFactor: textScaleFactor)
                  ],
                  Divider(),
                  //Buttons for edit and delete the snapshot.data
                  ActionButtons(employee: snapshot.data),
                ],
              );
            }
          }),
    );
  }
}
