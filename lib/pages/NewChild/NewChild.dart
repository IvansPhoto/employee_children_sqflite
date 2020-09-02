import 'package:flutter/material.dart';
import 'package:employee_children_sqflite/pages/NewChild/NewChildForm.dart';

class NewChild extends StatelessWidget {
	@override
	Widget build(BuildContext context) {
		final isNew = ModalRoute.of(context).settings.arguments;
		return  NewChildForm(isNew);
	}
}



