import 'package:flutter/material.dart';
import 'package:employee_children_sqflite/Classes.dart';
import 'package:employee_children_sqflite/Support.dart';
import 'package:employee_children_sqflite/GlobalStore.dart';
import 'package:employee_children_sqflite/SupportWidgets/ActionButtons.dart';
import 'package:employee_children_sqflite/pages/NewEmployee/EmployeeChildrenList.dart';

class ShowEmployee extends StatelessWidget {
  final store = gStore.get<GlobalStore>();
  //To increase font size.

  List<Widget> _showChildrenList(BuildContext context, List<Children> _childrenList) {
    List<Widget> _childrenWidgets = [];
    _childrenWidgets.add(Text('Children:', textScaleFactor: textScaleFactor));
    if (_childrenList == null || _childrenList.length == 0) {
      _childrenWidgets.add(Text('Without children', textScaleFactor: textScaleFactor,));
      return _childrenWidgets;
    } else {
      for (int i = 0; i < _childrenList.length; i++) {
        _childrenWidgets.add(Text(
          '${i + 1}:  ${_childrenList[i].surName} ${_childrenList[i].name} ${_childrenList[i].patronymic}',
          style: Theme.of(context).textTheme.bodyText1,
          textScaleFactor: textScaleFactor,
        ));
      }
    }
    return _childrenWidgets;
  }

  @override
  Widget build(BuildContext context) {
    final Employees employee = gStore.get<GlobalStore>().theEmployee;
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        title: StreamBuilder<Employees>(
            stream: gStore<GlobalStore>().streamTheEmployee$,
            builder: (BuildContext context, AsyncSnapshot snapshot) {
              if (!snapshot.hasData)
                return Text('Employee profile.');
              else
                return Text('${employee.name} ${employee.surName}');
            }),
      ),
      body: StreamBuilder(
          stream: gStore<GlobalStore>().streamTheEmployee$, //For editing the employee
          builder: (BuildContext context, AsyncSnapshot snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting || snapshot.connectionState == ConnectionState.none)
              return Center(child: Text('Loading'));
            else
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
                          TextSpan(text: employee.name ?? 'Not specified', style: Theme.of(context).textTheme.bodyText1),
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
                          TextSpan(text: employee.surName ?? 'Not specified', style: Theme.of(context).textTheme.bodyText1),
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
                            text: employee.birthday == null ? 'Not specified' : monthFromNumber(employee.birthday),
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
                          TextSpan(text: employee.position ?? 'Not specified', style: Theme.of(context).textTheme.bodyText1),
                        ],
                      )),
                  Divider(),
                  //List of children
	                EmployeeChildrenList(employee),
	                Divider(),
                  //Buttons for edit and delete the employee
                  ActionButtons(employee: employee),
                ],
              );
          }),
    );
  }
}
