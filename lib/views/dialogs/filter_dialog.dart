import 'package:church_volunteer_scheduler/data/data_source.dart';
import 'package:church_volunteer_scheduler/data/struct/activity.dart';
import 'package:church_volunteer_scheduler/data/struct/filter.dart';
import 'package:church_volunteer_scheduler/data/struct/role.dart';
import 'package:church_volunteer_scheduler/views/dialogs/select_dialog.dart';
import 'package:collection/collection.dart';
import 'package:flutter/material.dart';

enum SchedFilterDateStart {
  today(label: "Today"),
  thisWeek(label: "This Week"),
  thisMonth(label: "This Month"),
  thisYear(label: "This Year"),
  lastWeek(label: "Last Week"),
  lastMonth(label: "Last Month"),
  lastYear(label: "Last Year"),
  allTime(label: "All Time");

  const SchedFilterDateStart({required this.label});
  final String label;

  @override
  String toString() {
    return label;
  }
}

enum SchedFilterDateEnd {
  thisWeek(label: "This Week"),
  thisMonth(label: "This Month"),
  thisYear(label: "This Year"),
  nextWeek(label: "Next Week"),
  nextMonth(label: "Next Month"),
  nextYear(label: "Next Year"),
  allTime(label: "All Time");

  const SchedFilterDateEnd({required this.label});
  final String label;

  @override
  String toString() {
    return label;
  }
}

class FilterDialog extends StatefulWidget {
  const FilterDialog({Key? key}) : super(key: key);

  @override
  State<FilterDialog> createState() => _FilterDialogState();
}

class _FilterDialogState extends State<FilterDialog> {
  Activity? expandedActivity;

  Map<dynamic, bool> activityRoleFilterStates = {};

  initActivityRoleFilterStates() {
    for (var act in DataSource().activities) {
      activityRoleFilterStates[act] ??=
          !DataSource().connector.columnFilter.isHidden(act: act);
      for (var role in act.roles) {
        activityRoleFilterStates[role] ??=
            !DataSource().connector.columnFilter.isHidden(rol: role);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    initActivityRoleFilterStates();
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      child: Container(
        width: 200,
        child: Padding(
          padding: EdgeInsets.all(15),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                "Choose what is displayed",
                style: DefaultTextStyle.of(context)
                    .style
                    .apply(fontSizeFactor: 1.3),
              ),
              Row(
                children: [
                  Text("Hide dates before:"),
                  Spacer(),
                  DropdownButton<RowFilterBeginType>(
                      value: DataSource().connector.rowFilter.beginType,
                      items: RowFilterBeginType.values
                          .map((sfds) => DropdownMenuItem<RowFilterBeginType>(
                              value: sfds, child: Text(sfds.name)))
                          .toList(),
                      onChanged: (sfds) {
                        setState(() {
                          if (sfds != null)
                            (DataSource().connector.rowFilter.beginType =
                                sfds!);
                        });
                      }),
                ],
              ),
              Row(
                children: [
                  Text("Schedule through:"),
                  Spacer(),
                  DropdownButton<RowFilterEndType>(
                      value: DataSource().connector.rowFilter.endType,
                      items: RowFilterEndType.values
                          .map((sfds) => DropdownMenuItem<RowFilterEndType>(
                              value: sfds, child: Text(sfds.name)))
                          .toList(),
                      onChanged: (sfde) {
                        setState(() {
                          if (sfde != null)
                            DataSource().connector.rowFilter.endType = sfde;
                        });
                      }),
                ],
              ),
              Text(
                "Choose visible activities/jobs",
                style: DefaultTextStyle.of(context)
                    .style
                    .apply(fontSizeFactor: 1.3),
              ),
              //TODO: For each activity, list jobs with check boxes or similar
              SingleChildScrollView(
                scrollDirection: Axis.vertical,
                child: Column(
                  children: DataSource()
                      .activities
                      .map<ExpansionTile>((Activity item) {
                    return ExpansionTile(
                      title: Text(item.name),
                      leading: Checkbox(
                          value: activityRoleFilterStates[item] ?? false,
                          onChanged: (newVal) {
                            setState(() {
                              activityRoleFilterStates[item] = newVal ?? false;
                            });
                          }),
                      children: item.roles.map<ListTile>((role) {
                        return ListTile(
                            title: Text(role.roleName),
                            leading: Checkbox(
                                value: activityRoleFilterStates[role] ?? false,
                                onChanged: (newVal) => setState(() {
                                      activityRoleFilterStates[role] =
                                          newVal ?? false;
                                    })));
                      }).toList(),
                    );
                  }).toList(),
                ),
              ),
              ElevatedButton(
                onPressed: () {
                  DataSource().connector.columnFilter.setActivitiesToHide(
                      DataSource()
                          .activities
                          .where(
                              (act) => activityRoleFilterStates[act] == false)
                          .toList());

                  var rolesToHide = <Role>[];
                  DataSource().connector.columnFilter.setRolesToHide(
                      DataSource()
                          .activities
                          .fold<List<Role>>(
                              rolesToHide, (rth, act) => rth..addAll(act.roles))
                          .where(
                              (role) => activityRoleFilterStates[role] == false)
                          .toList());
                  SchedFilterSelection.selection.clear();
                  Navigator.of(context).pop();
                },
                child: Text("Select"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
