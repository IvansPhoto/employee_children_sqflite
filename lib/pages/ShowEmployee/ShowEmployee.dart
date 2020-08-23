import 'package:employee_children_sqflite/classes.dart';
import 'package:employee_children_sqflite/pages/ShowEmployee/ActionButtonsEmployee.dart';
import 'package:flutter/material.dart';
import 'package:employee_children_sqflite/Support.dart';
import 'package:employee_children_sqflite/GlobalStore.dart';

class ShowEmployee extends StatelessWidget {
  final store = gStore.get<GlobalStore>();

  List<Widget> _showChildrenList(BuildContext context, List<ChildrenData> _childrenList) {
    List<Widget> _childrenWidgets = [];
    _childrenWidgets.add(Text('Children:'));
    if (_childrenList == null || _childrenList.length == 0) {
      _childrenWidgets.add(Text('Without children'));
      return _childrenWidgets;
    } else {
      for (int i = 0; i < _childrenList.length; i++) {
        _childrenWidgets.add(Text('${i + 1}:  ${_childrenList[i].surName} ${_childrenList[i].name} ${_childrenList[i].patronymic}', style: Theme.of(context).textTheme.bodyText1));
      }
    }
    return _childrenWidgets;
  }

  @override
  Widget build(BuildContext context) {
    final EmployeesData employee = store.theEmployee;
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        title: Text('${employee.name} ${employee.surName}'),
      ),
      body: ValueListenableBuilder(
          valueListenable: Hive.box<EmployeesData>(Boxes.employeesBox).listenable(),
          builder: (context, Box<EmployeesData> box, _) {
            return ListView(
              padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
              children: <Widget>[
                //Name
                RichText(
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
                    text: TextSpan(
                  style: DefaultTextStyle.of(context).style,
                  children: <TextSpan>[
                    const TextSpan(text: 'Position:\n'),
                    TextSpan(text: employee.position ?? 'Not specified', style: Theme.of(context).textTheme.bodyText1),
                  ],
                )),
                Divider(),
                //List of children
                ..._showChildrenList(context, employee.children),
                Divider(),
                //Buttons for edit and delete the employee
                ActionButtons(employee: employee),
              ],
            );
          }),
    );
  }
}
