import 'package:flutter/material.dart';
import 'package:employee_children_sqflite/Classes.dart';
import 'package:employee_children_sqflite/GlobalStore.dart';
import 'package:employee_children_sqflite/Support.dart';

class SelectChildren extends StatefulWidget {
  @override
  _SelectChildrenState createState() => _SelectChildrenState();
}

class _SelectChildrenState extends State<SelectChildren> {
  final store = gStore.get<GlobalStore>();
  final Employees employee = gStore.get<GlobalStore>().theEmployee;
  List<int> updatedChildren = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        title: Text('Select children for ${employee.name ??= 'New employee'}'),
      ),
      body: FutureBuilder<List<Children>>(
        future: store.dbProvider.getAllChildren(),
        builder: (BuildContext context, AsyncSnapshot<List<Children>> snapshot) {
          if (snapshot.hasError) return Center(child: Text('Error ${snapshot.data}'));
          if (!snapshot.hasData || snapshot.data.length == null)
            return Center(child: const Text('No children in the list'));
          else
            return ListView.builder(
                itemCount: snapshot.data.length,
                itemBuilder: (context, index) {
                  Children theChild = snapshot.data.elementAt(index);
                  return ChooseChildrenListTitle(child: theChild, employee: employee);
                });
        },
      ),
    );
  }
}

class ChooseChildrenListTitle extends StatefulWidget {
  final Children child;
  final Employees employee;

  ChooseChildrenListTitle({this.employee, this.child});

  @override
  _ChooseChildrenListTitleState createState() => _ChooseChildrenListTitleState();
}

class _ChooseChildrenListTitleState extends State<ChooseChildrenListTitle> {
  void _select() {
    showDialog(
        context: context,
        child: Dialog(
          //TODO: check with DartDevTools.
//              insetPadding: EdgeInsets.all(18),
          elevation: 0,
          child: Padding(
            padding: const EdgeInsets.all(10.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: [
                RichText(
                  textScaleFactor: textScaleFactor,
                  text: TextSpan(
                    style: DefaultTextStyle.of(context).style,
                    children: <TextSpan>[
                      TextSpan(text: 'Are you sure to\n'),
                      if (widget.child.parentId == widget.employee.id) TextSpan(text: 'remove ', style: TextStyle(color: Colors.red)),
                      if (widget.child.parentId != widget.employee.id) TextSpan(text: 'add ', style: TextStyle(color: Colors.red)),
                      TextSpan(text: '${widget.child.name} ${widget.child.surName}\n'),
                      if (widget.child.parentId != widget.employee.id) TextSpan(text: 'to ', style: TextStyle(color: Colors.red)),
                      if (widget.child.parentId == widget.employee.id) TextSpan(text: 'from ', style: TextStyle(color: Colors.red)),
                      TextSpan(text: '${widget.employee.name} ${widget.employee.surName}'),
                    ],
                  ),
                ),
                Divider(),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    IconButton(
                      icon: Icon(Icons.arrow_back, color: Colors.red, size: iconSize),
                      onPressed: () {
                        Navigator.pop(context);
                        print('initial ${widget.child.parentId} ${widget.employee.id}');
                      },
                    ),
                    IconButton(
                      icon: widget.child.parentId == widget.employee.id
                          ? Icon(Icons.delete_forever, color: Colors.red, size: iconSize)
                          : Icon(Icons.person_add, color: Colors.red, size: iconSize),
                      onPressed: () {
                        print('initial: ${widget.child.parentId} ${widget.employee.id}');

                        if (widget.child.parentId == widget.employee.id) {
                          widget.child.parentId = null;
                          gStore<GlobalStore>().updateChild(widget.child);
                        } else if (widget.child.parentId != widget.employee.id) {
                          widget.child.parentId = widget.employee.id;
                          gStore<GlobalStore>().updateChild(widget.child);
                        }

                        print('after: ${widget.child.parentId} ${widget.employee.id}');

                        setState(() {});
                        Navigator.pop(context);
                      },
                    ),
                  ],
                ),
              ],
            ),
          ),
        ));
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 0,
      child: ListTile(
        title: Text('${widget.child.name}'),
        trailing: widget.child.parentId == null ? Icon(Icons.radio_button_unchecked) : widget.child.parentId == widget.employee.id ? Icon(Icons.check_circle) : Icon(Icons.block),
        onTap: _select,
        enabled: widget.child.parentId == null || widget.child.parentId == widget.employee.id,
      ),
    );
  }
}
