import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:employee_children_sqflite/Classes.dart';
import 'package:employee_children_sqflite/Support.dart';
import 'package:employee_children_sqflite/GlobalStore.dart';

class NewChildForm extends StatefulWidget {
  //Init the state of this form to add a new employee
  final bool isNew;
  NewChildForm(this.isNew);

  final _formKey = GlobalKey<FormState>();

  @override
  _NewChildFormState createState() => _NewChildFormState();
}

class _NewChildFormState extends State<NewChildForm> {
  Children child = gStore<GlobalStore>().theChild;

  TextEditingController _nameTEC;
  TextEditingController _surnameTEC;
  TextEditingController _patronymicTEC;
  DateTime _birthday;
  String _birthdayText;

  @override
  void initState() {
    if (widget.isNew) {
      _nameTEC = TextEditingController();
      _surnameTEC = TextEditingController();
      _patronymicTEC = TextEditingController();
      _birthday = DateTime.now();
      _birthdayText = monthFromNumber(DateTime.now());
    } else {
      _nameTEC = TextEditingController(text: child.name);
      _surnameTEC = TextEditingController(text: child.surName);
      _patronymicTEC = TextEditingController(text: child.patronymic);
      _birthday = child.birthday;
      _birthdayText = monthFromNumber(child.birthday);
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
    gStore<GlobalStore>().insertChild(Children(
      name: _nameTEC.text,
      surName: _surnameTEC.text,
      patronymic: _patronymicTEC.text,
      birthday: _birthday,
    ));
    Navigator.of(context).pop();

    //Check for SnackBar in the List page.
    Scaffold.of(context).showSnackBar(SnackBar(
      content: Text('The child has been added.'),
      elevation: 0,
      duration: Duration(seconds: 5),
    ));
  }

  void _updateChild() async {
    child.name = _nameTEC.text;
    child.surName = _surnameTEC.text;
    child.patronymic = _patronymicTEC.text;
    child.birthday = _birthday;
    gStore<GlobalStore>().updateChild(child);
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        title: const Text('The list of children'),
      ),
      body: Form(
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
                  initialDate: child == null ? DateTime.now() : child.birthday,
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
                onPressed: () => {if (widget._formKey.currentState.validate()) child == null ? _addChild() : _updateChild()},
                child: child == null ? const Text('Save the child') : const Text('Update'),
              ),
            ],
          )),
    );
  }
}

