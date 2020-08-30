import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:employee_children_sqflite/Classes.dart';
import 'package:employee_children_sqflite/Support.dart';
import 'package:employee_children_sqflite/GlobalStore.dart';
import 'package:employee_children_sqflite/pages/NewEmployee/EmployeeChildrenList.dart';

class EmployeeForm extends StatefulWidget {
  //Init the state of this form to add a new employee
  final bool isNew;

  EmployeeForm(this.isNew);

  final _formKey = GlobalKey<FormState>();

  @override
  _EmployeeFormState createState() => _EmployeeFormState();
}

class _EmployeeFormState extends State<EmployeeForm> {
  Employees employee = gStore<GlobalStore>().theEmployee;

  TextEditingController _nameTEC;
  TextEditingController _surnameTEC;
  TextEditingController _positionTEC;

  DateTime _birthday;
  String _birthdayText;

//  List<Children> _childrenList;

  @override
  void initState() {
    if (widget.isNew) {
      _nameTEC = TextEditingController();
      _surnameTEC = TextEditingController();
      _positionTEC = TextEditingController();
      _birthday = DateTime.now();
      _birthdayText = monthFromNumber(DateTime.now());
//      _childrenList = [];
    } else {
      _nameTEC = TextEditingController(text: employee.name);
      _surnameTEC = TextEditingController(text: employee.surName);
      _positionTEC = TextEditingController(text: employee.position);
      _birthday = employee.birthday;
      _birthdayText = monthFromNumber(employee.birthday);
//      _childrenList = employee.children;
    }
    super.initState();
  }

  @override
  void dispose() {
    _nameTEC.dispose();
    _surnameTEC.dispose();
    _positionTEC.dispose();
    super.dispose();
  }

  void _addEmployee() {
    gStore<GlobalStore>().insertEmployee(Employees(
      name: _nameTEC.text,
      surName: _surnameTEC.text,
      birthday: _birthday,
      position: _positionTEC.text,
    ));
    Navigator.of(context).pop();

    //Check for SnackBar in the List page.
    Scaffold.of(context)
      ..removeCurrentSnackBar()
      ..showSnackBar(SnackBar(
        content: Text('The employee has been added.'),
        elevation: 0,
        duration: Duration(seconds: 5),
      ));
  }

  void _updateEmployee() async {
    employee.name = _nameTEC.text;
    employee.surName = _surnameTEC.text;
    employee.position = _positionTEC.text;
    employee.birthday = _birthday;
    gStore<GlobalStore>().updateEmployee(employee);
    Navigator.of(context).pop('updated');
  }

  void _selectChildren(context) {
    Navigator.pushNamed(context, RouteNames.selectChildren);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        title: widget.isNew ? const Text('Enter data of new employees') : Text('Edit: ${employee.name} ${employee.surName}'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Form(
            key: widget._formKey,
            autovalidate: true,
            child: ListView(
              children: <Widget>[
                //Name
                TextFormField(
                  controller: _nameTEC,
                  decoration: const InputDecoration(hintText: 'Name', labelText: "The name"),
                  maxLength: 50,
                  keyboardType: TextInputType.text,
                  validator: (value) => value.isEmpty ? 'Enter the employee name' : null,
                ),
                //Surname
                TextFormField(
                  controller: _surnameTEC,
                  decoration: const InputDecoration(hintText: 'Surname', labelText: "The surname"),
                  maxLength: 50,
                  keyboardType: TextInputType.text,
                  validator: (value) => value.isEmpty ? 'Enter the employee surname' : null,
                ),
                //Position
                TextFormField(
                  controller: _positionTEC,
                  decoration: const InputDecoration(hintText: 'Position', labelText: "The position"),
                  maxLength: 50,
                  keyboardType: TextInputType.text,
                  validator: (value) => value.isEmpty ? 'Enter the employee position' : null,
                ),
                //Birthday
                TextField(
                  readOnly: true,
                  controller: TextEditingController(text: _birthdayText),
                  onTap: () => showDatePicker(
                    context: context,
                    initialDate: employee == null ? DateTime.now() : employee.birthday,
                    firstDate: DateTime(1950),
                    lastDate: DateTime(2021),
                  ).then((dateTime) => setState(() {
                        _birthday = dateTime;
                        _birthdayText = monthFromNumber(dateTime);
                      })),
                  decoration: const InputDecoration(hintText: 'Birthday', labelText: "The birthday"),
                ),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    IconButton(
                      icon: employee == null ? Icon(Icons.update) : Icon(Icons.update),
                      onPressed: () => {
                        if (widget._formKey.currentState.validate()) employee == null ? _addEmployee() : _updateEmployee(),
                      },
                      iconSize: iconSize,
                    ),
                    if (employee != null)
                      IconButton(
                        onPressed: () => _selectChildren(context),
                        icon: Icon(Icons.person_add),
                        iconSize: iconSize,
                      ),
                  ],
                ),
                Divider(
                  color: Colors.blue,
                  thickness: 0.5,
                ),
                EmployeeChildrenList(employee),
              ],
            )),
      ),
    );
  }
}
