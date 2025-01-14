import 'dart:math';

import 'package:church_volunteer_scheduler/data/activities_data_grid_source.dart';
import 'package:church_volunteer_scheduler/views/dialogs/filter_dialog.dart';
import 'package:church_volunteer_scheduler/views/dialogs/select_dialog.dart';
import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';
import 'package:church_volunteer_scheduler/data/data_source.dart';

class SheetPoint {
  int row, col;
  SheetPoint(this.row, this.col);
  bool operator ==(Object sp) {
    return sp is SheetPoint && sp.col == col && sp.row == row;
  }

  @override
  int get hashCode => Object.hash(row, col);
}

class SchedSheet extends StatefulWidget {
  const SchedSheet({super.key});

  @override
  State<SchedSheet> createState() => SchedSheetState();
}

class SchedSheetState extends State<SchedSheet> {
  var rand = Random().nextInt(999999999);
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              IconButton(
                icon: const Icon(Icons.filter_alt_rounded),
                onPressed: () async {
                  await showDialog(
                          context: context,
                          builder: (builder) => FilterDialog())
                      .then((val) => setState(() {
                        DataSource().connector.generateAssignmentsGrid();
                        rand = Random().nextInt(999999999);
                          }));
                },
              ),
              DropdownButton<SchedFilterSelectMode>(
                value: SchedFilterSelection.mode,
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
                    if (value != null) SchedFilterSelection.setMode(value);
                  });
                },
              ),
              IconButton(
                icon: const Icon(Icons.auto_awesome_rounded),
                onPressed: () {
                  print("TODO: Fill in schedule");
                },
              ),
              IconButton(
                icon: const Icon(Icons.share_rounded),
                onPressed: () {
                  print("TODO: Slide up share/export options");
                },
              ),
            ],
          ),
          Expanded(
              child: Scaffold(
            body: SfDataGrid(
              source: ActivitiesDataGridSource(),
              columnWidthMode: ColumnWidthMode.auto, //ColumnWidthMode.fill,
              frozenColumnsCount: 1,
              allowEditing: true,
              gridLinesVisibility: GridLinesVisibility.both,
              headerGridLinesVisibility: GridLinesVisibility.both,
              navigationMode: GridNavigationMode.cell,
              editingGestureType: EditingGestureType.doubleTap,
              selectionMode: SelectionMode.single,
              onCellTap: (DataGridCellTapDetails details) {
                setState(() {
                  SchedFilterSelection.onCellTapHandler(details);
                });
              },
              columns: [
                GridColumn(
                    columnName: 'date',
                    allowEditing: false,
                    width: 100,
                    label: Container(
                        alignment: Alignment.center,
                        child: const Text('Date'))),
                ...DataSource()
                    .connector
                    .filteredColumns
                    .map<GridColumn>((role) => GridColumn(
                        columnName: role.toString(),
                        width: 100,
                        label: Container(
                            alignment: Alignment.center,
                            child: Text(
                              role.roleName,
                              overflow: TextOverflow.ellipsis,
                            ))))
                    .toList()
              ],
              stackedHeaderRows: createStackedHeader(),
            ),
          )),
        ],
      ),
    );
  }

  List<StackedHeaderRow> createStackedHeader() {
    List<StackedHeaderCell> cells = [];
    cells.add(StackedHeaderCell(
        columnNames: ['date'],
        child: Container(alignment: Alignment.center, child: Text(""))));
    for (var act in DataSource().activities) {
      cells.add(StackedHeaderCell(
          columnNames: act.roles.map((e) => e.toString()).toList(),
          child: Container(
              color: Colors.blue,
              alignment: Alignment.center,
              child: Text(act.name))));
    }
    return [StackedHeaderRow(cells: cells)];
  }
}
