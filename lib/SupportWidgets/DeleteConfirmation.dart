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
//              insetPadding: EdgeInsets.all(18),
			elevation: 0,
			child: Padding(
				padding: const EdgeInsets.all(18.0),
				child: Column(
					mainAxisAlignment: MainAxisAlignment.center,
					crossAxisAlignment: CrossAxisAlignment.center,
					mainAxisSize: MainAxisSize.min,
					children: [
						Text('Are you sure to delete of'),
						if (employee != null) Text('${employee.name} ${employee.surName}'),
						if (child != null) Text('${child.name} ${child.surName}'),
						Divider(),
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
										Navigator.pop(context);
										Navigator.pop(context, 'deleted');
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


//class DeleteConfirmation extends StatelessWidget {
//  final Employees employee;
//  final Children child;
//
//  DeleteConfirmation({this.employee, this.child});
//
//  @override
//  Widget build(BuildContext context) {
//    return Scaffold(
//      backgroundColor: Color.fromRGBO(128, 128, 128, 0.25),
//        appBar: AppBar(
//          elevation: 0,
//          centerTitle: true,
//          title: const Text('Confirmation'),
//        ),
//        body: Center(
//          child: Column(
//            mainAxisAlignment: MainAxisAlignment.center,
//            crossAxisAlignment: CrossAxisAlignment.center,
//            children: <Widget>[
//              Text('Are you sure to delete of:'),
//              if (employee != null) Text('${employee.name} ${employee.surName}'),
//              if (child != null) Text('${child.name} ${child.surName}'),
//              FlatButton.icon(
//                icon: const Icon(Icons.restore),
//                label: const Text('Stay in the list!'),
//                onPressed: () => Navigator.pop(context),
//              ),
//              FlatButton.icon(
//                icon: Icon(Icons.delete_forever),
//                label: const Text('Remove from the list!'),
//                onPressed: () async {
//                  if (employee != null) gStore<GlobalStore>().deleteEmployee(employee);
//                  if (child != null) gStore<GlobalStore>().deleteChild(child);
//                  Navigator.pop(context);
//                  Navigator.pop(context, 'deleted');
//                },
//              )
//            ],
//          ),
//        ));
//  }
//}
