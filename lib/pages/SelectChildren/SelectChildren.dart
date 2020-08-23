import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:employee_children_sqflite/classes.dart';
import 'package:employee_children_sqflite/GlobalStore.dart';
import 'package:employee_children_sqflite/Support.dart';

class SelectChildren extends StatefulWidget {
  @override
  _SelectChildrenState createState() => _SelectChildrenState();
}

class _SelectChildrenState extends State<SelectChildren> {
  final childrenBox = Hive.box<Children>(Boxes.childrenBox);
  final store = gStore.get<GlobalStore>();
  List<SelectedChildren> selectedChildren;

  List<SelectedChildren> makeChildrenList({List<Children> employeeChildren, List<Children> allChildren}) {
    List<SelectedChildren> finalList = [];
    allChildren.forEach((theChild) {
      finalList.add(SelectedChildren(
        child: theChild,
        selected: employeeChildren.contains(theChild),
      ));
    });
    return finalList;
  }

  void updateChildren({Employees employee, List<SelectedChildren> selectedChildren}) async {
    employee.children.clear();
    selectedChildren.forEach((selectedChild) {
      if (selectedChild.selected) employee.children.add(selectedChild.child);
    });
    await employee.save();
  }

  @override
  void initState() {
    selectedChildren = makeChildrenList(allChildren: childrenBox.values.toList(), employeeChildren: store.theEmployee.children);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        title: Text('Select children for ${store.theEmployee.name ??= 'New employee'}'),
      ),
      body: ValueListenableBuilder(
        valueListenable: childrenBox.listenable(),
        builder: (context, Box<Children> childrenBox, _) {
          if (childrenBox.values.length == 0)
            return Center(child: const Text('No children in the list'));
          else
            return ListView.builder(
                itemCount: selectedChildren.length,
                itemBuilder: (context, index) {
                  return Card(
                    elevation: 0,
                    child: ChooseChildrenListTitle(
                      selectedChild: selectedChildren.elementAt(index),
                    ),
                  );
                });
//            return ListView.builder(
//              itemCount: childrenBox.values.length,
//              itemBuilder: (context, index) {
//                ChildrenData child = childrenBox.getAt(index);
//                return Card(
//                  elevation: 0,
//                  child: SelectChildrenListTitle(theChild: child, theEmployee: employee),
//                );
//              },
//            );
        },
      ),
      floatingActionButton: IconButton(
        icon: const Icon(Icons.add_circle_outline),
        onPressed: () => Navigator.pushNamed(context, RouteNames.newChildren),
      ),
      bottomNavigationBar: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          FlatButton(
              onPressed: () {
                updateChildren(employee: store.theEmployee, selectedChildren: selectedChildren);
                Navigator.pop(context, true);
              },
              child: Text('Update')),
          FlatButton(
              onPressed: () {
                Navigator.pop(context, false);
              },
              child: Text('Cancel')),
        ],
      ),
    );
  }
}

class ChooseChildrenListTitle extends StatefulWidget {
  final SelectedChildren selectedChild;

  ChooseChildrenListTitle({this.selectedChild});

  @override
  _ChooseChildrenListTitleState createState() => _ChooseChildrenListTitleState();
}

class _ChooseChildrenListTitleState extends State<ChooseChildrenListTitle> {
  void _select() {
    setState(() => widget.selectedChild.unSelect());
  }

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text('${widget.selectedChild.child.surName}-${widget.selectedChild.child.name} ${widget.selectedChild.child.patronymic}'),
      selected: widget.selectedChild.selected,
      onTap: () => _select(),
      trailing: widget.selectedChild.selected ? Icon(Icons.check_circle) : Icon(Icons.radio_button_unchecked),
    );
  }
}
