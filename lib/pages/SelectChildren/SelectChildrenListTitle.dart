import 'package:flutter/material.dart';
import 'package:employee_children_sqflite/Classes.dart';

class SelectChildrenListTitle extends StatefulWidget {
  final Children theChild;
  final Employees theEmployee;

  SelectChildrenListTitle({this.theChild, this.theEmployee});

  @override
  _SelectChildrenListTitleState createState() => _SelectChildrenListTitleState();
}

class _SelectChildrenListTitleState extends State<SelectChildrenListTitle> {
  bool _selected = false;

  @override
  void initState() {
    widget.theEmployee.children.forEach((employeeChild) {
      if (identical(employeeChild, widget.theChild)) _selected = true;
    });

    super.initState();
  }

  void _select() {
    setState(() {
      _selected = !_selected;
      if (!widget.theEmployee.children.contains(widget.theChild) && _selected) widget.theEmployee.children.add(widget.theChild);
      if (widget.theEmployee.children.contains(widget.theChild) && !_selected) widget.theEmployee.children.remove(widget.theChild);
    });

  }

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text('${widget.theChild.surName} ${widget.theChild.name} ${widget.theChild.patronymic}'),
      selected: _selected,
      onTap: () => _select(),
      trailing: _selected ? Icon(Icons.check_circle) : Icon(Icons.radio_button_unchecked),
    );
  }
}
