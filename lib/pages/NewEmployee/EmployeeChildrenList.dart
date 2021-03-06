import 'package:flutter/material.dart';
import 'package:employee_children_sqflite/Classes.dart';
import 'package:employee_children_sqflite/Support.dart';
import 'package:employee_children_sqflite/GlobalStore.dart';

class EmployeeChildrenList extends StatelessWidget {
  final Employees employee;
  final bool isNew;

  EmployeeChildrenList({this.employee, this.isNew});

  List<InlineSpan> _childrenListTextSpan(List<Children> _childrenList) {
    List<InlineSpan> _childrenWidgets = [];
    for (int i = 0; i < _childrenList.length; i++) {
      _childrenWidgets
          .add(TextSpan(text: '${i + 1}: ${_childrenList[i].surName} ${_childrenList[i].name} ${_childrenList[i].patronymic} \n', style: TextStyle(color: Colors.blue[100])));
    }
    return _childrenWidgets;
  }

  @override
  Widget build(BuildContext context) {
    if (employee == null || isNew)
      return Text('Children can be added after saving the employee');
    else
      return StreamBuilder<Object>(
          stream: gStore<GlobalStore>().streamChildrenList$,
          builder: (context, snapshot) {
            if (!snapshot.hasData) Text('No children in the list');
            return FutureBuilder(
              future: gStore<GlobalStore>().dbProvider.getChildrenOfEmployee(employee.id),
              builder: (context, AsyncSnapshot<List<Children>> snapshot) {
                if (!snapshot.hasData)
                  return Text('${employee.name} ${employee.surName} has no children');
                else
                  return RichText(
                    textScaleFactor: textScaleFactor,
                    text: TextSpan(
                      style: DefaultTextStyle.of(context).style,
                      text: 'Children:\n',
                      children: [..._childrenListTextSpan(snapshot.data)],
                    ),
                  );
              },
            );
          });
  }
}
