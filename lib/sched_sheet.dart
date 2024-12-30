import 'package:flutter/material.dart';
import 'package:flutter_spreadsheet_ui/flutter_spreadsheet_ui.dart';

enum SheetMode { select, edit }

class SheetPoint {
  int row, col;
  SheetPoint(this.row, this.col);
}

class SchedSheet extends StatefulWidget {
  const SchedSheet({super.key});

  @override
  State<SchedSheet> createState() => _SchedSheetState();
}

class _SchedSheetState extends State<SchedSheet> {
  SheetPoint? selectedRangeStart, selectedRangeEnd;
  late List<FlutterSpreadsheetUIColumn> columns;
  late List<FlutterSpreadsheetUIRow> rows;
  late FlutterSpreadsheetUIConfig tableConfig;

  @override
  Widget build(BuildContext context) {
    return FlutterSpreadsheetUI(
      columns: columns,
      rows: rows,
      config: tableConfig,
    );
  }

  Widget? schedCellBuilder(context, cellId) {
    return GestureDetector(
      child: Text("$cellId"),
      onTap: () => setState(() {
        
      }),
    );
  }

  _SchedSheetState() {
    columns = [
      FlutterSpreadsheetUIColumn(
        width: 50,
        contentAlignment: Alignment.center,
        cellBuilder: (context, cellId) => const Text("Date"),
      ),
      FlutterSpreadsheetUIColumn(
        contentAlignment: Alignment.center,
        cellBuilder: (context, cellId) => const Text("AM Prayer"),
      ),
      FlutterSpreadsheetUIColumn(
        cellBuilder: (context, cellId) => const Text("AM Announcememnts"),
      ),
      FlutterSpreadsheetUIColumn(
        cellBuilder: (context, cellId) => const Text("AM Communion"),
      ),
      FlutterSpreadsheetUIColumn(
        cellBuilder: (context, cellId) => const Text("AM Closing Prayer"),
      ),
      FlutterSpreadsheetUIColumn(
        cellBuilder: (context, cellId) => const Text("AM Prayer"),
      ),
      FlutterSpreadsheetUIColumn(
        cellBuilder: (context, cellId) => const Text("AM Announcememnts"),
      ),
      FlutterSpreadsheetUIColumn(
        cellBuilder: (context, cellId) => const Text("AM Communion"),
      ),
      FlutterSpreadsheetUIColumn(
        cellBuilder: (context, cellId) => const Text("AM Closing Prayer"),
      ),
    ];

    rows = List<FlutterSpreadsheetUIRow>.generate(
      20,
      (index) => FlutterSpreadsheetUIRow(
        cells: List<FlutterSpreadsheetUICell>.generate(
          9,
          (index) => FlutterSpreadsheetUICell(cellBuilder: schedCellBuilder),
        ),
      ),
    );

    tableConfig = const FlutterSpreadsheetUIConfig(
      enableColumnWidthDrag: false,
      enableRowHeightDrag: false,
      freezeFirstColumn: true,
      freezeFirstRow: true,
    );
  }
}
