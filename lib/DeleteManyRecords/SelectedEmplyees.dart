import 'package:flutter/material.dart';
import 'package:employee_children_sqflite/GlobalStore.dart';
import 'package:employee_children_sqflite/Classes.dart';
import 'package:employee_children_sqflite/Support.dart';
import 'package:employee_children_sqflite/DeleteManyRecords/EmployeeCard.dart';

class SelectedEmployees extends StatefulWidget {
  final List<Employees> employeeList;

  SelectedEmployees({this.employeeList});

  @override
  _SelectedEmployeesState createState() => _SelectedEmployeesState();
}

class _SelectedEmployeesState extends State<SelectedEmployees> {
  List<Employees> employeesList;

  @override
  void initState() {
    employeesList = widget.employeeList.toList();
    print('initState - SelectedEmployees');
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    print('Build SelectedEmployees');
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Expanded(
          child: ListView.builder(
            itemCount: employeesList.length,
            itemBuilder: (context, index) {
              Employees employee = employeesList.elementAt(index);
              return EmployeeCard(employee: employee);
            },
          ),
        ),
        Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Expanded(
              child: Padding(
                padding: EdgeInsets.fromLTRB(25, 0, 0, 0),
                child: TextFormField(
                  maxLength: 50,
                  decoration: const InputDecoration(hintText: 'Matches in name or surname', labelText: 'Searching', hintStyle: TextStyle(fontSize: 15)),
                  onChanged: (text) {
                    print('onChanged: ${employeesList.length}');
                    setState(() {
                      print('setState');
                      employeesList = widget.employeeList
                          .where((Employees employee) => employee.name.contains(text) || employee.surName.contains(text) || employee.patronymic.contains(text))
                          .toList();
                    });
                  },
                ),
              ),
            ),
            IconButton(
              icon: Icon(Icons.delete_forever),
              iconSize: iconSize,
              onPressed: () => showDialog(
                context: context,
                child: Dialog(
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
                              List<Employees> selectedEmployees = employeesList.where((employee) => employee.isSelected).toList();

                              final int number = await gStore<GlobalStore>().deleteSeveralEmployee(selectedEmployees);
                              gStore<GlobalStore>().getEmployeesToStream();

                              setState(() => employeesList = List.from(widget.employeeList));

                              Navigator.pop(context);
                              Navigator.of(context).pop('$number deleted');
                              // Navigator.pop(context, number);
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
          ],
        )
      ],
    );
  }
}
