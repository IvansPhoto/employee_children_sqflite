import 'package:flutter/material.dart';
import 'package:employee_children_sqflite/Classes.dart';
import 'package:employee_children_sqflite/GlobalStore.dart';
import 'package:employee_children_sqflite/Support.dart';

class DeleteConfirmation extends StatelessWidget {
  final Employees employee;
  final Children child;

  DeleteConfirmation({this.employee, this.child});

  @override
  Widget build(BuildContext context) {
    return Dialog(
      //TODO: check with DartDevTools.
      insetPadding: EdgeInsets.all(25),
      elevation: 0,
      child: Padding(
        padding: const EdgeInsets.all(5.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text('Are you sure to delete'),
            if (employee != null) Text('${employee.name} ${employee.surName}'),
            if (child != null) Text('${child.name} ${child.surName}'),
            Divider(),
            // ButtonBar(
            //	 mainAxisSize: MainAxisSize.min,
            //	 buttonAlignedDropdown: true,
            //	 alignment: MainAxisAlignment.center,
            //	 overflowDirection: VerticalDirection.up,
            //	 children: [
            //		 FlatButton.icon(
            //			 label: Text('Stay'),
            //			 icon: Icon(Icons.arrow_back, color: Colors.red, size: iconSize),
            //			 onPressed: () => Navigator.pop(context),
            //		 ),
            //		 FlatButton.icon(
            //			 label: Text('Delete'),
            //			 icon: Icon(Icons.delete_forever, color: Colors.red, size: iconSize),
            //			 onPressed: () {
            //				 if (employee != null) gStore<GlobalStore>().deleteEmployee(employee);
            //				 if (child != null) gStore<GlobalStore>().deleteChild(child);
            //				 Navigator.pop(context);
            //				 Navigator.pop(context, 'deleted');
            //			 },
            //		 ),
            //	 ],
            // ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                FlatButton.icon(
                  label: Text('Stay'),
                  icon: Icon(Icons.arrow_back, color: Colors.red, size: iconSize),
                  onPressed: () => Navigator.pop(context),
                ),
                FlatButton.icon(
                  label: Text('Delete'),
                  icon: Icon(Icons.delete_forever, color: Colors.red, size: iconSize),
                  onPressed: () {
                    if (employee != null) gStore<GlobalStore>().deleteEmployee(employee);
                    if (child != null) gStore<GlobalStore>().deleteChild(child);
                    Navigator.of(context)..pop()..pop('deleted');
                  },
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
