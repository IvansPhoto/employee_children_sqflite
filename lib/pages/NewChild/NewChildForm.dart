import 'package:employee_children_sqflite/Classes.dart';
import 'package:flutter/material.dart';
import 'package:employee_children_sqflite/Support.dart';

class NewChildForm extends StatefulWidget {
  final Box<Children> childrenBox = Hive.box<Children>(Boxes.childrenBox);
  final Children child;

  NewChildForm({this.child});

  final _formKey = GlobalKey<FormState>();

  @override
  _NewChildFormState createState() => _NewChildFormState();
}

class _NewChildFormState extends State<NewChildForm> {
  TextEditingController _nameTEC;
  TextEditingController _surnameTEC;
  TextEditingController _patronymicTEC;
  DateTime _birthday;
  String _birthdayText;

  @override
  void initState() {
    if (widget.child == null) {
      _nameTEC = TextEditingController();
      _surnameTEC = TextEditingController();
      _patronymicTEC = TextEditingController();
      _birthday = DateTime.now();
      _birthdayText = monthFromNumber(DateTime.now());
    } else {
      _nameTEC = TextEditingController(text: widget.child.name);
      _surnameTEC = TextEditingController(text: widget.child.surName);
      _patronymicTEC = TextEditingController(text: widget.child.patronymic);
      _birthday = widget.child.birthday;
      _birthdayText = monthFromNumber(widget.child.birthday);
    }
    super.initState();
  }

  @override
  void dispose() {
    _nameTEC.dispose();
    _surnameTEC.dispose();
    _patronymicTEC.dispose();
    super.dispose();
  }

  void _addChild() {
    widget.childrenBox.add(Children(
      name: _nameTEC.text,
      surName: _surnameTEC.text,
      patronymic: _patronymicTEC.text,
      birthday: _birthday,
    ));
    Navigator.of(context).pop();
    Scaffold.of(context).showSnackBar(SnackBar(
      content: Text('The child has been added.'),
      elevation: 0,
      duration: Duration(seconds: 5),
    ));
  }

  void _updateChild() async {
    widget.child.name = _nameTEC.text;
    widget.child.surName = _surnameTEC.text;
    widget.child.patronymic = _patronymicTEC.text;
    widget.child.birthday = _birthday;
    await widget.child.save();
    Navigator.of(context).pop();
    Scaffold.of(context).showSnackBar(SnackBar(
      content: Text('The employee has been updated.'),
      elevation: 0,
      duration: Duration(seconds: 5),
    ));
  }

  @override
  Widget build(BuildContext context) {
    return Form(
        key: widget._formKey,
        autovalidate: true,
        child: Column(
          children: <Widget>[
            TextFormField(
              autofocus: true,
              controller: _nameTEC,
              decoration: const InputDecoration(hintText: 'Name', labelText: "The name"),
              maxLength: 50,
              keyboardType: TextInputType.text,
              validator: (value) => value.isEmpty ? 'Enter the child name' : null,
            ),
            TextFormField(
              autofocus: true,
              controller: _surnameTEC,
              decoration: const InputDecoration(hintText: 'Surname', labelText: "The surname"),
              maxLength: 50,
              keyboardType: TextInputType.text,
              validator: (value) => value.isEmpty ? 'Enter the child surname' : null,
            ),
            TextFormField(
              autofocus: true,
              controller: _patronymicTEC,
              decoration: const InputDecoration(hintText: 'Patronymic', labelText: "The patronymic"),
              maxLength: 50,
              keyboardType: TextInputType.text,
              validator: (value) => value.isEmpty ? 'Enter the child patronymic' : null,
            ),
            TextField(
              readOnly: true,
              controller: TextEditingController(text: _birthdayText),
              onTap: () => showDatePicker(
                context: context,
                initialDate: widget.child == null ? DateTime.now() : widget.child.birthday,
                firstDate: DateTime(1960),
                lastDate: DateTime(2021),
              ).then((dateTime) => setState(() {
                    _birthday = dateTime;
                    _birthdayText = monthFromNumber(dateTime);
                  })),
              decoration: const InputDecoration(hintText: 'Birthday', labelText: "The birthday! "),
            ),
            RaisedButton(
              elevation: 0,
              onPressed: () => {if (widget._formKey.currentState.validate()) widget.child == null ? _addChild() : _updateChild()},
              child: widget.child == null ? const Text('Save the child') : const Text('Update'),
            ),
          ],
        ));
  }
}

