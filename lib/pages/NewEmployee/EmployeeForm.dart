import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:employee_children_sqflite/Classes.dart';
import 'package:employee_children_sqflite/Support.dart';
import 'package:employee_children_sqflite/GlobalStore.dart';

class EmployeeForm extends StatefulWidget {
  //Init the state of this form to add a new employee
  final bool isNew;

  EmployeeForm({this.isNew});

  final _formKey = GlobalKey<FormState>();

  @override
  _EmployeeFormState createState() => _EmployeeFormState();
}

class _EmployeeFormState extends State<EmployeeForm> {
  Employees _employee = gStore<GlobalStore>().theEmployee;
  GlobalStore _store = gStore<GlobalStore>();

  TextEditingController _nameTEC;
  TextEditingController _surnameTEC;
  TextEditingController _patronymicTEC;
  TextEditingController _positionTEC;
  DateTime _birthday;
  String _birthdayText;

  @override
  void initState() {
    if (widget.isNew) {
      _nameTEC = TextEditingController();
      _surnameTEC = TextEditingController();
      _positionTEC = TextEditingController();
      _patronymicTEC = TextEditingController(text: 'SQFlite');
      _birthday = DateTime.now();
      _birthdayText = monthFromNumber(DateTime.now());
    } else {
      _nameTEC = TextEditingController(text: _employee.name);
      _surnameTEC = TextEditingController(text: _employee.surName);
      _positionTEC = TextEditingController(text: _employee.position);
      _patronymicTEC = TextEditingController(text: _employee.patronymic);
      _birthday = _employee.birthday;
      _birthdayText = monthFromNumber(_employee.birthday);
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
    Employees newEmployee = Employees(
      name: _nameTEC.text,
      surName: _surnameTEC.text,
      patronymic: _patronymicTEC.text,
      birthday: _birthday,
      position: _positionTEC.text,
    );
    gStore<GlobalStore>()
      ..insertEmployee(newEmployee)
      ..getEmployeesToStream();

    Navigator.of(context).pop('added');
  }

  void _updateEmployee() {
    _employee.name = _nameTEC.text;
    _employee.surName = _surnameTEC.text;
    _employee.patronymic = _patronymicTEC.text;
    _employee.position = _positionTEC.text;
    _employee.birthday = _birthday;
    gStore<GlobalStore>()
      ..updateEmployee(_employee)
      ..getTheEmployee(_employee)
      // ..setTheEmployee = employee
      ..getEmployeesToStream();
    Navigator.of(context).pop('updated');
  }

  void _selectChildren(context) {
    gStore<GlobalStore>().setTheEmployee = _employee;
    Navigator.pushNamed(context, RouteNames.selectChildren);
  }

  void setBirthday(DateTime dateTime) => setState(() {
        if (dateTime != null) {
          _birthday = dateTime;
          _birthdayText = monthFromNumber(dateTime);
        }
      });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: widget.isNew ? const Text('Enter data of new employees') : Text('Edit: ${_employee.name} ${_employee.surName}')),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Form(
          key: widget._formKey,
          autovalidate: true,
          child: ListView(
            // itemExtent: 95,
            children: <Widget>[
              //Name
              TextFormField(
                // buildCounter: (BuildContext context, {int currentLength, int maxLength, bool isFocused}) => currentLength >= maxLength ? Text('$currentLength / $maxLength') : null,
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
              //patronymic
              TextFormField(
                controller: _patronymicTEC,
                decoration: const InputDecoration(hintText: 'Patronymic', labelText: "The patronymic"),
                maxLength: 50,
                keyboardType: TextInputType.text,
                validator: (value) => value.isEmpty ? 'Enter the employee patronymic' : null,
              ),
              //Birthday
              TextField(
                readOnly: true,
                controller: TextEditingController(text: _birthdayText),
                onTap: () => showDatePicker(
                  context: context,
                  initialDate: _employee == null ? DateTime.now() : _employee.birthday,
                  firstDate: DateTime(1950),
                  lastDate: DateTime(2021),
                ).then(setBirthday),
                decoration: const InputDecoration(hintText: 'Birthday', labelText: "The birthday"),
              ),
              ButtonBar(
                alignment: MainAxisAlignment.spaceEvenly,
                children: [
                  RaisedButton(
                    elevation: 0,
                    child: widget.isNew ? const Text('Add') : const Text('Update'),
                    onPressed: () => {
                      if (widget._formKey.currentState.validate()) widget.isNew ? _addEmployee() : _updateEmployee(),
                    },
                  ),
                  OutlineButton(
                    child: const Text('Cancel'),
                    onPressed: () => Navigator.of(context).pop(),
                  ),
                  // IconButton(
                  //   iconSize: iconSize,
                  //   onPressed: widget.isNew ? null : () => _selectChildren(context),
                  //   icon: Icon(Icons.person_add),
                  // ),
                ],
              ),
              Divider(color: Colors.blue, thickness: 0.5),
              //Children list
              StreamBuilder<Employees>(
                stream: gStore<GlobalStore>().streamTheEmployee$,
                builder: (BuildContext context, AsyncSnapshot<Employees> snapshot) {
                  if (!snapshot.hasData) return Text('Children can be added after saving the record.');
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      if (widget.isNew) Text('Children can be added after saving the record.'),
                      if (!widget.isNew && (snapshot.data.children?.isNotEmpty ?? false))
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            Text('Children:', textScaleFactor: textScaleFactor,),
                            RaisedButton.icon(
                              onPressed: widget.isNew ? null : () => _selectChildren(context),
                              icon: Icon(Icons.person_add),
                              label: Text('Add child.'),
                            )
                          ],
                        ),
                      if (!widget.isNew && (snapshot.data.children?.isEmpty ?? false))
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text('${snapshot.data.name} ${snapshot.data.surName} has not children', style: Theme.of(context).textTheme.bodyText1),
                            RaisedButton.icon(
                              onPressed: widget.isNew ? null : () => _selectChildren(context),
                              icon: Icon(Icons.person_add),
                              label: Text('Add child.'),
                            )
                          ],
                        ),
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
