import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:employee_children_sqflite/Classes.dart';
import 'package:employee_children_sqflite/Support.dart';
import 'package:employee_children_sqflite/GlobalStore.dart';

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

  @override
  void initState() {
    if (widget.isNew) {
      _nameTEC = TextEditingController();
      _surnameTEC = TextEditingController();
      _positionTEC = TextEditingController();
      _birthday = DateTime.now();
      _birthdayText = monthFromNumber(DateTime.now());
    } else {
      _nameTEC = TextEditingController(text: employee.name);
      _surnameTEC = TextEditingController(text: employee.surName);
      _positionTEC = TextEditingController(text: employee.position);
      _birthday = employee.birthday;
      _birthdayText = monthFromNumber(employee.birthday);
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
    print('${_nameTEC.text}');
    Navigator.of(context).pop('added');

    //Check for SnackBar in the List page.
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
                  RaisedButton(
                    elevation: 0,
                    child: widget.isNew ? const Text('Add') : const Text('Update'),
                    onPressed: () => {
                      if (widget._formKey.currentState.validate()) widget.isNew ? _addEmployee() : _updateEmployee(),
                    },
                  ),
                  RaisedButton(
                    elevation: 0,
                    child: const Text('Cancel'),
                    onPressed: () => Navigator.of(context).pop(),
                  ),
                  IconButton(
                    iconSize: iconSize,
                    onPressed: widget.isNew ? null : () => _selectChildren(context),
                    icon: Icon(Icons.person_add),
                  ),
                ],
              ),
              Divider(color: Colors.blue, thickness: 0.5),
              //Children list
              StreamBuilder<Employees>(
                stream: gStore<GlobalStore>().streamTheEmployee$,
                builder: (BuildContext context, AsyncSnapshot<Employees> snapshot) {
                  if (!snapshot.hasData) return Text('loading...');
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      if (widget.isNew) Text('Children can be added after saving the record.'),
                      if (!widget.isNew && (snapshot.data.children.isNotEmpty ?? false)) Text('Children:'),
                      if (!widget.isNew && (snapshot.data.children.isEmpty ?? false))
                        Text('${snapshot.data.name} ${snapshot.data.surName} has not children', style: Theme.of(context).textTheme.bodyText1),
                      if (!widget.isNew) ...[for (var child in snapshot.data.children) Text('${child.name} ${child.surName}', style: Theme.of(context).textTheme.bodyText1)],
                    ],
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
