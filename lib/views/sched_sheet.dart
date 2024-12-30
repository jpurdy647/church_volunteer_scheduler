import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';
import 'package:church_volunteer_scheduler/data/data_source.dart';

class SheetPoint {
  int row, col;
  SheetPoint(this.row, this.col);
}

class schedSheet extends StatefulWidget {
  const schedSheet({super.key});

  @override
  State<schedSheet> createState() => _schedSheetState();
}

class _schedSheetState extends State<schedSheet> {
  @override
  Widget build(BuildContext context) {
    return SfDataGrid(
        source: ActivitiesDataGridSource.getFalseDataSource(),
        columns: ActivityData.falseRoleNamesDefault
            .map((s) =>
                GridColumn(columnName: s, label: Container(child: Text(s))))
            .toList());
  }
}
