import 'dart:math';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';
import 'package:flutter/material.dart';
import 'package:church_volunteer_scheduler/main.dart';
import 'package:collection/collection.dart';
import 'package:intl/intl.dart';


class DataSource {
  static List<ActivityData>? falseSched;
  static List<ActivityData> getFalseSchedule(int rowCount){
    falseSched ??= List<ActivityData>.generate(rowCount, (i) => ActivityData.generateFalseData(DateTime.now().add(Duration(days: i*7))));
    return falseSched!;
  }

  /*

  */
}

class ActivityData {
  DateTime activityDate;
  List<AssignedRole> roles;
  ActivityData(this.activityDate, this.roles);

  static const falseColumnNamesDefault = ["Date", "Song Leader", "Announcements", "Opening Prayer", "Communion Lead", "Comm Side", "Comm Side", "Sermon", "Closing Prayer"];
  static const falseRoleNamesDefault = ["Song Leader", "Announcements", "Opening Prayer", "Communion Lead", "Comm Side", "Comm Side", "Sermon", "Closing Prayer"];
  static const falsePeopleNamesDefult = ["Josh", "Matt", "Quinn", "Nate", "Micah", "Scott S", "Bud", "Robert", "Dave J", "Lane", "Will", "Eric"];
  
  static ActivityData generateFalseData([activityDate = DateTime.now, List<String>? falseRoleNamesPref, List<String>? falsePeopleNamesPref]){
    var falseRoleNames = falseRoleNamesPref ?? falseRoleNamesDefault;
    var falsePeopleNames = falsePeopleNamesPref ?? falsePeopleNamesDefult;
    var assignedRoles = List<AssignedRole>.generate(falseRoleNames.length, (i) => AssignedRole(Role(falseRoleNames[i]), falsePeopleNames[Random().nextInt(falsePeopleNames.length)]));
    return ActivityData(activityDate, assignedRoles);
  }

}

class AssignedRole {
  Role role;
  String name;
  AssignedRole(this.role, this.name);
}

class Role {
  String name;
  Role(this.name);
}



class ActivitiesDataGridSource extends DataGridSource {

  dynamic newCellValue;
  TextEditingController editingController = TextEditingController();


  @override
  Future<void> onCellSubmit(DataGridRow dataGridRow,
      RowColumnIndex rowColumnIndex, GridColumn column) async {
      loadingController.add(true);
      //await Future<void>.delayed(const Duration(seconds: 2));
      loadingController.add(false);
      final dynamic oldValue = dataGridRow
            .getCells()
            .firstWhereOrNull((DataGridCell dataGridCell) =>
                dataGridCell.columnName == column.columnName)
            ?.value ??
        '';

    final int dataRowIndex = dataGridRows.indexOf(dataGridRow);

    if (newCellValue == null || oldValue == newCellValue) {
      return;
    }

    DataSource.falseSched?[rowColumnIndex.rowIndex].roles[rowColumnIndex.columnIndex-1].name = newCellValue.toString();

    super.onCellSubmit(dataGridRow,rowColumnIndex, column);
    /*
    if (column.columnName == 'id') {
      dataGridRows[dataRowIndex].getCells()[rowColumnIndex.columnIndex] =
          DataGridCell<int>(columnName: 'id', value: newCellValue);
      employees[dataRowIndex].id = newCellValue as int;
    } else if (column.columnName == 'name') {
        dataGridRows[dataRowIndex].getCells()[rowColumnIndex.columnIndex] =
            DataGridCell<String>(columnName: 'name', value: newCellValue);
        employees[dataRowIndex].name = newCellValue.toString();
    
    } else if (column.columnName == 'designation') {
      dataGridRows[dataRowIndex].getCells()[rowColumnIndex.columnIndex] =
          DataGridCell<String>(columnName: 'designation', value: newCellValue);
      employees[dataRowIndex].designation = newCellValue.toString();
    } else {
      dataGridRows[dataRowIndex].getCells()[rowColumnIndex.columnIndex] =
          DataGridCell<int>(columnName: 'salary', value: newCellValue);
      employees[dataRowIndex].salary = newCellValue as int;
    }
    */
  }
  @override
  Future<bool> canSubmitCell(DataGridRow dataGridRow,
      RowColumnIndex rowColumnIndex, GridColumn column) async {
    if (column.columnName == 'id' && newCellValue == 104) {
      loadingController.add(true);
      await Future<void>.delayed(const Duration(seconds: 2));
      loadingController.add(false);
      return false;
    } else {
      return true;
    }
  }

  List<DataGridRow> dataGridRows = [];

  @override
  List<DataGridRow> get rows => dataGridRows;

  ActivitiesDataGridSource({required List<ActivityData> activityData}) {
    dataGridRows =
        activityData.map<DataGridRow>(_mapActivitiesDataToGridRow).toList();
  }

  static ActivitiesDataGridSource getFalseDataSource(){
    return ActivitiesDataGridSource(activityData: DataSource.getFalseSchedule(60));
  }

  @override
  DataGridRowAdapter? buildRow(DataGridRow row) {
    return DataGridRowAdapter(
        cells: row.getCells().map<Widget>((dataGridCell) {
      return Container(
          padding: EdgeInsets.symmetric(horizontal: 16.0),
          alignment: Alignment.center,
          color: dataGridCell.value.toString() == "Micah" ? Colors.yellow : null,
          child: Text(
            dataGridCell.value.toString(),
            style: dataGridCell.value.toString() == "Josh" ? TextStyle(backgroundColor: Colors.yellow): null,
            overflow: TextOverflow.ellipsis,
          ));
    }).toList());
  }

  DataGridRow _mapActivitiesDataToGridRow(ActivityData activityDataItem) {
    List<DataGridCell<dynamic>> cells = [];
    cells.add(DataGridCell<String>(
        columnName: "Date", value: DateFormat.yMd().format(activityDataItem.activityDate)));
    cells.addAll(activityDataItem.roles.map(
        (e) => DataGridCell<String>(columnName: e.role.name, value: e.name)));
    return DataGridRow(cells: cells);
  }  @override
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

    final bool isNumericType =
        column.columnName == 'id' || column.columnName == 'salary';

    return Container(
      padding: const EdgeInsets.all(8.0),
      alignment: isNumericType ? Alignment.centerRight : Alignment.centerLeft,
      child: TextField(
        autofocus: true,
        controller: editingController..text = displayText,
        textAlign: isNumericType ? TextAlign.right : TextAlign.left,
        decoration: InputDecoration(
          contentPadding: const EdgeInsets.fromLTRB(0, 0, 0, 16.0),
        ),
        keyboardType: isNumericType ? TextInputType.number : TextInputType.text,
        onChanged: (String value) {
          if (value.isNotEmpty) {
            if (isNumericType) {
              newCellValue = int.parse(value);
            } else {
              newCellValue = value;
            }
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
}