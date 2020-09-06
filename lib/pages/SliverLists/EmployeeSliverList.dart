import 'package:flutter/material.dart';
import 'dart:math' as math;
import 'package:employee_children_sqflite/Classes.dart';
import 'package:employee_children_sqflite/GlobalStore.dart';
import 'package:employee_children_sqflite/Support.dart';

class EmployeeSliverList extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<List<Employees>>(
        stream: gStore<GlobalStore>().streamEmployeesList$,
        builder: (BuildContext context, AsyncSnapshot<List<Employees>> snapshot) {
          if (!snapshot.hasData)
            return Text('Loading');
          else
            return CustomScrollView(
              slivers: [
                SliverAppBar(
                  elevation: 0,
                  title: Text('Employee List'),
                  expandedHeight: 100,
                  flexibleSpace: Padding(
                    padding: filterPadding,
                    child: TextFormField(
                      maxLength: 50,
                      decoration: const InputDecoration(hintText: 'Matches in name or surname', labelText: 'Searching', hintStyle: TextStyle(fontSize: 15)),
                      onChanged: (text) => text == null || text.length == 0 ? gStore<GlobalStore>().getEmployeesToStream() : gStore<GlobalStore>().filterEmployeesToStream(text),
                    ),
                  ),
                ),

                SliverPersistentHeader(
                  delegate: _SliverAppBarDelegate(
                      child: Card(
                        child: Row(
                          children: [
                            Text('data'),
                          ],
                        ),
                      ),
                      minHeight: 50,
                      maxHeight: 150
                  ),
                ),

                SliverList(
                  delegate: SliverChildBuilderDelegate(
                    (BuildContext context, int index) {
                      Employees employee = snapshot.data.elementAt(index);

                      return Card(
                        elevation: 0,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Text('${employee.name} ${employee.surName}'),
                            Text(employee.position),
                          ],
                        ),
                      );
                    },

                    childCount: snapshot.data.length,
                  ),
                ),
              ],
            );
        });
  }
}

class _SliverAppBarDelegate extends SliverPersistentHeaderDelegate {
  _SliverAppBarDelegate({
    @required this.minHeight,
    @required this.maxHeight,
    @required this.child,
  });

  final double minHeight;
  final double maxHeight;
  final Widget child;

  @override
  double get minExtent => minHeight;

  @override
  double get maxExtent => math.max(maxHeight, minHeight);

  @override
  Widget build(BuildContext context, double shrinkOffset, bool overlapsContent) {
    return new SizedBox.expand(child: child);
  }

  @override
  bool shouldRebuild(_SliverAppBarDelegate oldDelegate) {
    return maxHeight != oldDelegate.maxHeight || minHeight != oldDelegate.minHeight || child != oldDelegate.child;
  }
}
