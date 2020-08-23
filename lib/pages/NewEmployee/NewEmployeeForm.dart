import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:employee_children_sqflite/classes.dart';
import 'package:employee_children_sqflite/Support.dart';
import 'package:employee_children_sqflite/GlobalStore.dart';

class EmployeeForm extends StatefulWidget {
  final EmployeesData employee;
  final bool isNew; //Change form to add a new employee
  EmployeeForm({this.employee, this.isNew});

  final _formKey = GlobalKey<FormState>();
  final store = gStore.get<GlobalStore>();

  @override
  _EmployeeFormState createState() => _EmployeeFormState();
}

class _EmployeeFormState extends State<EmployeeForm> {
  TextEditingController _nameTEC;
  TextEditingController _surnameTEC;
  TextEditingController _positionTEC;

  DateTime _birthday;
  String _birthdayText;
  HiveList<ChildrenData> _childrenList;

  Box<EmployeesData> employeesBox = Hive.box<EmployeesData>(Boxes.employeesBox);
  Box<ChildrenData> childrenBox = Hive.box<ChildrenData>(Boxes.childrenBox);

  @override
  void initState() {
    if (widget.isNew == true) {
      _nameTEC = TextEditingController();
      _surnameTEC = TextEditingController();
      _positionTEC = TextEditingController();
      _birthday = DateTime.now();
      _birthdayText = monthFromNumber(DateTime.now());
      _childrenList = HiveList(childrenBox);
    } else {
      _nameTEC = TextEditingController(text: widget.employee.name);
      _surnameTEC = TextEditingController(text: widget.employee.surName);
      _positionTEC = TextEditingController(text: widget.employee.position);
      _birthday = widget.employee.birthday;
      _birthdayText = monthFromNumber(widget.employee.birthday);
      _childrenList = widget.employee.children;
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
    employeesBox.add(EmployeesData(
      name: _nameTEC.text,
      surName: _surnameTEC.text,
      birthday: _birthday,
      position: _positionTEC.text,
      children: HiveList(childrenBox), //Check output from ChildrenList
    ));
    Navigator.of(context).pop();
    Scaffold.of(context)
      ..removeCurrentSnackBar()
      ..showSnackBar(SnackBar(
        content: Text('The employee has been added.'),
        elevation: 0,
        duration: Duration(seconds: 5),
      ));
  }

  void _updateEmployee() async {
    widget.employee.name = _nameTEC.text;
    widget.employee.surName = _surnameTEC.text;
    widget.employee.position = _positionTEC.text;
    widget.employee.birthday = _birthday;
//    widget.employee.children = HiveList(childrenBox);
    await widget.employee.save();
    Navigator.of(context).pop();
    Scaffold.of(context)
      ..removeCurrentSnackBar()
      ..showSnackBar(SnackBar(
        content: Text('The employee has been updated.'),
        elevation: 0,
        duration: Duration(seconds: 5),
      ));
  }

  void _selectChildren(context) async {
    final isUpdated = await Navigator.pushNamed(context, RouteNames.selectChildren);
    Scaffold.of(context)
      ..removeCurrentSnackBar()
      ..showSnackBar(SnackBar(
        content: isUpdated == true ? Text('${widget.employee.name} has been updated!') : Text('Children of ${widget.employee.name} did not changed'),
        elevation: 0,
        duration: Duration(seconds: 5),
      ));
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
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
                  initialDate: widget.employee == null ? DateTime.now() : widget.employee.birthday,
                  firstDate: DateTime(1950),
                  lastDate: DateTime(2021),
                ).then((dateTime) => setState(() {
                      _birthday = dateTime;
                      _birthdayText = monthFromNumber(dateTime);
                    })),
                decoration: const InputDecoration(hintText: 'Birthday', labelText: "The birthday"),
              ),
              RaisedButton(
                elevation: 0,
                onPressed: () => {if (widget._formKey.currentState.validate()) widget.employee == null ? _addEmployee() : _updateEmployee()},
                child: widget.employee == null ? const Text('Save the employee') : const Text('Update the employee'),
              ),

              if (widget.employee != null)
                RaisedButton.icon(
                  onPressed: () => _selectChildren(context),
                  icon: Icon(Icons.person_add),
                  label: Text('Add a child'),
                ),

              _EmployeeChildrenList(childrenList: _childrenList, employee: widget.employee),
            ],
          )),
    );
  }
}

class _EmployeeChildrenList extends StatelessWidget {
  final HiveList<ChildrenData> childrenList;
  final EmployeesData employee;

  _EmployeeChildrenList({this.childrenList, this.employee});

  final Box<EmployeesData> employeesBox = Hive.box<EmployeesData>(Boxes.employeesBox);

  List<InlineSpan> _childrenListTextSpan(List<ChildrenData> _childrenList) {
    List<InlineSpan> _childrenWidgets = [];
    for (int i = 0; i < _childrenList.length; i++) {
      _childrenWidgets.add(TextSpan(text: '${i + 1}: ${_childrenList[i].surName} ${_childrenList[i].name} ${_childrenList[i].patronymic} \n'));
    }
    return _childrenWidgets;
  }

  @override
  Widget build(BuildContext context) {
    if (employee == null) return Text('Children can be added after saving the employee');
    return ValueListenableBuilder(
      valueListenable: employeesBox.listenable(),
      builder: (context, employeesBox, _) {
        if (childrenList == null || childrenList.length == 0)
          return Text('Without children');
        else
          return RichText(
            text: TextSpan(
              text: 'Children:\n',
              children: [..._childrenListTextSpan(childrenList)],
            ),
          );
      },
    );
  }
}
