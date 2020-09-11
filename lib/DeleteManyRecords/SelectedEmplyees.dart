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

  void _filtering(String searchString) {
    setState(() => employeesList = widget.employeeList
        .where((Employees employee) => employee.name.contains(searchString) || employee.surName.contains(searchString) || employee.patronymic.contains(searchString))
        .toList());
  }

  void _deleteConfirmation() async {
    /// Set selected employees to a new list.
    List<Employees> selectedEmployees = employeesList.where((employee) => employee.isSelected).toList();

    /// Delete these records.
    final int number = await gStore<GlobalStore>().deleteSeveralEmployee(selectedEmployees);

    /// Update this widget.
    setState(() => employeesList = List.from(widget.employeeList));

    /// Update stream of all employees.
    gStore<GlobalStore>().getEmployeesToStream();

    Navigator.of(context)..pop()..pop('$number deleted');
  }

  @override
  void initState() {
    /// Copy the list of employees form GlobalStore to a new local list.
    employeesList = widget.employeeList.toList();
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
            itemExtent: 65,
            itemCount: employeesList.length,
            itemBuilder: (context, index) {
              Employees employee = employeesList.elementAt(index);
              return Center(child: EmployeeCard(employee: employee));
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
                  onChanged: _filtering,
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
                            onPressed: _deleteConfirmation,
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
