import 'package:flutter/material.dart';
import 'package:employee_children_sqflite/Classes.dart';
import 'package:employee_children_sqflite/GlobalStore.dart';
import 'package:employee_children_sqflite/pages/SelectChildren/SelectChildrenListTitle.dart';

class SelectChildren extends StatefulWidget {
	@override
	_SelectChildrenState createState() => _SelectChildrenState();
}

class _SelectChildrenState extends State<SelectChildren> {
	final store = gStore.get<GlobalStore>();
	final Employees employee = gStore.get<GlobalStore>().theEmployee;

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


