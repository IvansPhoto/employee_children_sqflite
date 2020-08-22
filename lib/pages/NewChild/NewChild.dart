import 'package:flutter/material.dart';
import 'package:employee_children_sqflite/classes.dart';
import 'package:employee_children_sqflite/pages/NewChild/NewChildForm.dart';

class NewChild extends StatelessWidget {

	@override
	Widget build(BuildContext context) {
		final ChildrenData child = ModalRoute.of(context).settings.arguments;
		return Scaffold(
			appBar: AppBar(
				elevation: 0,
				title: const Text('The list of children'),
			),
			body: NewChildForm(child: child,),
		);
	}
}



