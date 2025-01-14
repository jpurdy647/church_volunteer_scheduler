import 'package:church_volunteer_scheduler/data/grid_to_data_connector.dart';
import 'package:church_volunteer_scheduler/data/data_source.dart';
import 'package:church_volunteer_scheduler/data/struct/assignment.dart';
import 'package:church_volunteer_scheduler/data/struct/role.dart';
import 'package:church_volunteer_scheduler/views/dialogs/select_dialog.dart';
import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';

class ActivitiesDataGridSource extends DataGridSource {
  dynamic newCellValue;
  TextEditingController editingController = TextEditingController();

  ActivitiesDataGridSource() {
    updateDataGridRows();
    DataSource().connector.refreshDataGridCallbacks = [updateDataGridRows];
  }

  @override
  Future<void> onCellSubmit(DataGridRow dataGridRow,
      RowColumnIndex rowColumnIndex, GridColumn column) async {
    final dynamic oldRawValue = dataGridRow
            .getCells()
            .firstWhereOrNull((DataGridCell dataGridCell) =>
                dataGridCell.columnName == column.columnName)
            ?.value ??
        '';

    final Assignment oldValue;
    if (oldRawValue is! Assignment) {
      throw Exception("Cell value is not an Assignment");
    } else {
      oldValue = oldRawValue;
    }
    if (newCellValue == null ||
        oldValue == newCellValue ||
        newCellValue == "") {
      return;
    }

    var newAssignment = Assignment(oldValue.date, oldValue.role, newCellValue);

    DataSource().connector.setAssignmentAt(
        rowColumnIndex.rowIndex + 1, //add 1 to skip the date column
        rowColumnIndex.columnIndex,
        newAssignment);

    dataGridRow.getCells()[rowColumnIndex.columnIndex - 1] =
        DataGridCell<Assignment>(
            columnName: column.columnName, value: newAssignment);

    super.onCellSubmit(dataGridRow, rowColumnIndex, column);
  }

  @override
  Future<bool> canSubmitCell(DataGridRow dataGridRow,
      RowColumnIndex rowColumnIndex, GridColumn column) async {
    return true;
  }

  List<DataGridRow> dataGridRows = [];

  @override
  List<DataGridRow> get rows => dataGridRows;

  @override
  DataGridRowAdapter? buildRow(DataGridRow row) {
    return DataGridRowAdapter(cells: [
      Container(
          padding: EdgeInsets.symmetric(horizontal: 16.0),
          alignment: Alignment.center,
          child: Text(row.getCells().isEmpty ? "NO DATA" : 
              DateFormat.yMMMEd().format((row.getCells().first.value as Assignment).date).toString(),
              //overflow: TextOverflow.ellipsis,
              )),
      ...row.getCells().map<Widget>((dataGridCell) {
        Color? cellBGC;
        if (dataGridCell is DataGridCell<Assignment> && SchedFilterSelection.isSelected(assignment: dataGridCell.value)) {
          cellBGC = Colors.yellow;
        }

        return Container(
            padding: EdgeInsets.symmetric(horizontal: 16.0),
            alignment: Alignment.center,
            color: cellBGC,
            child: Text(
              dataGridCell.value.toString(),
              overflow: TextOverflow.ellipsis,
            ));

      }).toList()
    ]);
  }

  MapEntry<DateTime, DataGridRow> _mapActivitiesDataToGridRow(
      DateTime d, Map<Role, Assignment> assignments) {
    List<DataGridCell<dynamic>> cells = [];
    /*cells.add(DataGridCell<String>(
        columnName: "Date", value: DateFormat.yMd().format(activityDataItem.activityDate)));
    cells.addAll(activityDataItem.roles.map(
        (e) => DataGridCell<String>(columnName: e.role.name, value: e.assigneeName)));
        */
    //TODO: Implement this

    assert(assignments.values.length ==
        DataSource().connector.filteredColumns.length);

    for (var role in DataSource().connector.filteredColumns) {
      cells.add(DataGridCell<Assignment>(
          columnName: role.toString(),
          value: assignments[role] ?? Assignment(d, role, "EMPTY ASSIGNMENT")));
    }
    return MapEntry<DateTime, DataGridRow>(d, DataGridRow(cells: cells));
  }

  @override
  Widget? buildEditWidget(DataGridRow dataGridRow,
      RowColumnIndex rowColumnIndex, GridColumn column, CellSubmit submitCell) {
    // Text going to display on editable widget
    final String displayText = dataGridRow
            .getCells()
            .firstWhereOrNull((DataGridCell dataGridCell) =>
                dataGridCell.columnName == column.columnName)
            ?.value
            ?.toString() ??
        '';

    // The new cell value must be reset.
    // To avoid committing the [DataGridCell] value that was previously edited
    // into the current non-modified [DataGridCell].
    newCellValue = null;

    return Container(
      padding: const EdgeInsets.all(8.0),
      alignment: Alignment.centerLeft,
      child: TextField(
        autofocus: true,
        controller: editingController..text = displayText,
        textAlign: TextAlign.left,
        decoration: InputDecoration(
          contentPadding: const EdgeInsets.fromLTRB(0, 0, 0, 16.0),
        ),
        keyboardType: TextInputType.text,
        onChanged: (String value) {
          if (value.isNotEmpty) {
            newCellValue = value;
          } else {
            newCellValue = null;
          }
        },
        onSubmitted: (String value) {
          // In Mobile Platform.
          // Call [CellSubmit] callback to fire the canSubmitCell and
          // onCellSubmit to commit the new value in single place.
          submitCell();
        },
      ),
    );
  }
  
  void updateDataGridRows() {
    dataGridRows = DataSource().connector
        .getAssignmentsGrid()
        .map<DateTime, DataGridRow>(_mapActivitiesDataToGridRow)
        .values
        .toList();
  }
}
