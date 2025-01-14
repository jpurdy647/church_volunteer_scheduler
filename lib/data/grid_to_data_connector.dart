import 'dart:collection';
import 'dart:core';

import 'package:church_volunteer_scheduler/data/struct/activity.dart';
import 'package:church_volunteer_scheduler/data/struct/assignment.dart';
import 'package:church_volunteer_scheduler/data/struct/filter.dart';
import 'package:church_volunteer_scheduler/data/struct/role.dart';
import 'package:sorted_list/sorted_list.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';

class GridToDataConnector {
  List<Activity> _activities = [];

  RowFilter rowFilter = RowFilter();
  ColumnFilter columnFilter = ColumnFilter();

  final Map<DateTime, Map<Role, Assignment>> _assignmentsGrid = {};
  final List<Role> _filteredColumns = [];
  List<Role> get filteredColumns => _filteredColumns;
  final SortedList<DateTime> _dates = SortedList<DateTime>();

  List<Function> refreshDataGridCallbacks = [];

  GridToDataConnector(this._activities) {
    loadActivities(_activities);
  }

  void loadActivities(List<Activity> activities) {
    _activities = activities;
    generateAssignmentsGrid();
  }

  void generateAssignmentsGrid() {
    _assignmentsGrid.clear();

    // generate list of all dates from all activities that pass RowFilter.test
    //for each date do:
    //for each activity in listed order do:
    //add assignments for date to grid row

    //This will be the grid rows first cells

    _dates.clear();
    for (var activity in _activities) {
      activity.getAssignments().keys.forEach((date) {
        if (rowFilter.test(date) && !_dates.contains(date)) {
          _dates.add(date);
        }
      });
    }

    //Create list of columns (Roles)
    _filteredColumns.clear();
    for (var activity in _activities) {
      for (var role in activity.roles) {
        if (columnFilter.test(role: role)) {
          _filteredColumns.add(role);
        }
      }
    }

    //Create grid rows
    for (var date in _dates) {
      Map<Role, Assignment> row = {};
      var emptyRow = true;
      for (var columnRole in _filteredColumns) {
        row[columnRole] = columnRole.activity.getAssignment(date, columnRole);
        if (row[columnRole]!.assigneeName != Assignment.NA) {
          emptyRow = false;
        }
      }
      if (!emptyRow){
        _assignmentsGrid[date] = row;
      }
    }

    for (Function f in refreshDataGridCallbacks) {
      f();
    }
  }

  Map<DateTime, Map<Role, Assignment>> getAssignmentsGrid() {
    return _assignmentsGrid;
  }

  Assignment getAssignmentAt({int? row, int? col, RowColumnIndex? rci}) {
    int r,c;
    if (row != null && col != null) {
      r=row-1;
      c = col-1;
    } else if (rci != null) {
      r = rci.rowIndex - 1;
      c = rci.columnIndex - 1;
    } else {
      throw Exception("Must provide either row and col or rowColumnIndex");
    } 
    return _assignmentsGrid.values
        .elementAt(r)
        .values
        .elementAt(c);
  }

  void setAssignmentAt(int row, int col, Assignment assignment) {
    //update actual data source data
    assignment.role.activity
        .addAssignment(assignment.date, assignment, overwrite: true);

    //update grid data
    var dateKey = _assignmentsGrid.keys.elementAt(row - 1);
    var roleKey = _assignmentsGrid[dateKey]!.keys.elementAt(col - 1);

    _assignmentsGrid[dateKey]![roleKey] = assignment;
  }
}
