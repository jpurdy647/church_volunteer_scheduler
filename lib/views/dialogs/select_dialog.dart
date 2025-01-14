import 'dart:math';

import 'package:church_volunteer_scheduler/data/data_source.dart';
import 'package:church_volunteer_scheduler/data/struct/assignment.dart';
import 'package:church_volunteer_scheduler/views/sched_sheet.dart';
import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';

enum SchedFilterSelectMode {
  all(label: "Select All"),
  single(label: "Select Single"),
  multi(label: "Select Multi"),
  range(label: "Select Date Range"),
  occurances(label: "All Occurances"),
  none(label: "Select None");

  const SchedFilterSelectMode({required this.label});
  final String label;

  @override
  String toString() {
    return label;
  }
}

class SchedSelectItem {
  final SheetPoint location;
  final Assignment assignment;
  SchedSelectItem(this.location, this.assignment);
}

class SchedFilterSelection {
  static SchedFilterSelectMode _mode = SchedFilterSelectMode.single;
  static List<SchedSelectItem> selection = [];

  static void setMode(SchedFilterSelectMode mode) {
    _mode = mode;
    selection.clear();
  }

  static SchedFilterSelectMode get mode => _mode;

  static bool isSelected({Assignment? assignment, int? row, int? col}) {
    //provide either location or assignment but not both
    assert((assignment != null) != (row != null && col != null));

    switch (_mode) {
      case SchedFilterSelectMode.single:
      case SchedFilterSelectMode.multi:
        return selection.any((el) =>
            el.assignment == assignment ||
            el.location.row == row && el.location.col == col);
      case SchedFilterSelectMode.range:
        if (selection.isEmpty) {
          return false;
        } else if (selection.length == 1) {
          var testDate = assignment?.date ??
              DataSource().connector.getAssignmentAt(row: row, col: col).date;
          return testDate == selection[0].assignment.date;
        } else {
          var testDate = assignment?.date ??
              DataSource().connector.getAssignmentAt(row: row, col: col).date;
          //return true if testdate is between range dates
          if (selection[0]
              .assignment
              .date
              .isAfter(selection[1].assignment.date)) {
            var reversed = [selection[1], selection[0]];
            selection.clear();
            selection.addAll(reversed);
          }
          return testDate.millisecondsSinceEpoch >=
                  selection[0].assignment.date.millisecondsSinceEpoch &&
              testDate.millisecondsSinceEpoch <=
                  selection[1].assignment.date.millisecondsSinceEpoch;
        }
      case SchedFilterSelectMode.occurances:
        var cellAssignment = assignment ??
            DataSource().connector.getAssignmentAt(row: row, col: col);
        return selection.any(
            (el) => el.assignment.assigneeName == cellAssignment.assigneeName);
      case SchedFilterSelectMode.none:
        return false;
      case SchedFilterSelectMode.all:
        return true;
    }
  }

  static void onCellTapHandler(DataGridCellTapDetails details) {
    details = DataGridCellTapDetails(
        rowColumnIndex: RowColumnIndex(details.rowColumnIndex.rowIndex - 1,
            details.rowColumnIndex.columnIndex),
        column: details.column,
        globalPosition: details.globalPosition,
        localPosition: details.localPosition,
        kind: details.kind);

    if (details.rowColumnIndex.columnIndex == 0) {
      print(
          "Clicked date: ${DataSource().connector.getAssignmentAt(row: details.rowColumnIndex.rowIndex, col: details.rowColumnIndex.columnIndex + 1).date}");
      return;
    }

    var tappedAssignment =
        DataSource().connector.getAssignmentAt(rci: details.rowColumnIndex);

    print("`$tappedAssignment`` clicked at cell ${details.rowColumnIndex}");

    switch (_mode) {
      case SchedFilterSelectMode.single:
        selection = [
          SchedSelectItem(
              SheetPoint(details.rowColumnIndex.rowIndex,
                  details.rowColumnIndex.columnIndex),
              tappedAssignment)
        ];
        break;

      case SchedFilterSelectMode.multi:
        List<SchedSelectItem> selectedCellToDeselect = selection
            .where((el) =>
                el.location ==
                SheetPoint(details.rowColumnIndex.rowIndex,
                    details.rowColumnIndex.columnIndex))
            .toList();

        if (selectedCellToDeselect.isNotEmpty) {
          selection.remove(selectedCellToDeselect[0]);
        } else {
          selection.add(SchedSelectItem(
              SheetPoint(details.rowColumnIndex.rowIndex,
                  details.rowColumnIndex.columnIndex),
              tappedAssignment));
        }
        break;
      case SchedFilterSelectMode.range:
        if (selection.length < 2) {
          selection.add(SchedSelectItem(
              SheetPoint(details.rowColumnIndex.rowIndex, 0),
              tappedAssignment));
        } else {
          selection = [
            SchedSelectItem(SheetPoint(details.rowColumnIndex.rowIndex, 0),
                tappedAssignment)
          ];
        }
        break;
      case SchedFilterSelectMode.occurances:
        selection = [
          SchedSelectItem(
              SheetPoint(details.rowColumnIndex.rowIndex,
                  details.rowColumnIndex.columnIndex),
              tappedAssignment)
        ];
      case SchedFilterSelectMode.none:
        selection = [];
        break;
      case SchedFilterSelectMode.all:
      break;
    }
  }
}

class SelectDialog extends StatefulWidget {
  const SelectDialog({Key? key}) : super(key: key);

  @override
  State<SelectDialog> createState() => _SelectDialogState();
}

class _SelectDialogState extends State<SelectDialog> {
  SchedFilterSelectMode _selectedValue = SchedFilterSelectMode.single;

  @override
  Widget build(BuildContext context) {
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
              Text("Select an option"),
              DropdownButton<SchedFilterSelectMode>(
                value: _selectedValue,
                items: SchedFilterSelectMode.values
                    .map<DropdownMenuItem<SchedFilterSelectMode>>(
                        (SchedFilterSelectMode value) {
                  return DropdownMenuItem<SchedFilterSelectMode>(
                    value: value,
                    child: Text(value.label),
                  );
                }).toList(),
                onChanged: (SchedFilterSelectMode? value) {
                  setState(() {
                    if (value != null) _selectedValue = value;
                  });
                },
              ),
              ElevatedButton(
                onPressed: () {
                  Navigator.of(context).pop(_selectedValue);
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
