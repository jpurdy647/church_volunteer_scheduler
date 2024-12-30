import 'dart:async';

import 'package:church_volunteer_scheduler/data/data_source.dart';
import 'package:church_volunteer_scheduler/sched_sheet.dart';
import 'package:church_volunteer_scheduler/views/data_source.dart';
import 'package:church_volunteer_scheduler/views/stats.dart';
import 'package:church_volunteer_scheduler/views/configuration.dart';
import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Volunteer Scheduler',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
            seedColor: const Color.fromARGB(255, 42, 8, 100)),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});
  final String title;
  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

StreamController<bool> loadingController = StreamController<bool>();

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text("Volunteer Scheduler"),
        actions: [
          IconButton(
            icon: const Icon(Icons.storage_rounded),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => const DataSourceView(
                        title: "Data Source Passed Title")),
              );
            },
          ),
          IconButton(
            icon: const Icon(Icons.settings_rounded),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) =>
                        const ConfigView(title: "Data Source Passed Title")),
              );
            },
          ),
        ],
      ),
      bottomNavigationBar: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          IconButton(
            icon: const Icon(Icons.filter_alt_rounded),
            onPressed: () {
              print("TODO: Slide up filter options for spreadsheet view");
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
          PopupMenuButton<int>(
              icon: Icon(Icons.ac_unit),
              itemBuilder: (context) => [
                    const PopupMenuItem(
                      value: 1,
                      child: Row(
                        children: [
                          Icon(Icons.star),
                          //SizedBox(width: 10),
                          Text("Option 1"),
                        ],
                      ),
                    ),
                    const PopupMenuItem(
                      value: 2,
                      child: Row(
                        children: [
                          Icon(Icons.star),
                          SizedBox(width: 10),
                          Text('Option 2'),
                        ],
                      ),
                    ),
                  ]),
          IconButton(
            icon: const Icon(Icons.pie_chart_rounded),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) =>
                        const StatsView(title: "Stats Passed Title")),
              );
            },
          ),
        ],
      ),
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Icon(Icons.arrow_back_ios_rounded),
              ],
            ),
            Expanded(
              child: Scaffold(
                body: StreamBuilder(
                    stream: loadingController.stream,
                    builder:
                        (BuildContext context, AsyncSnapshot<bool> snapshot) {
                      return Stack(children: [
                        SfDataGrid(
                            source:
                                ActivitiesDataGridSource.getFalseDataSource(),
                            columnWidthMode: ColumnWidthMode.auto,//ColumnWidthMode.fill,
                            allowEditing: true,
                            gridLinesVisibility: GridLinesVisibility.both,
                            headerGridLinesVisibility: GridLinesVisibility.both,
                            navigationMode: GridNavigationMode.cell,
                            editingGestureType: EditingGestureType.doubleTap,
                            selectionMode: SelectionMode.single,
                            onCellTap: (DataGridCellTapDetails details) => print(details.rowColumnIndex.toString()),
                            columns: ActivityData.falseColumnNamesDefault
                                .map((s) => GridColumn(
                                    columnName: s,

                                    label: Container(child: Text(s), alignment: Alignment.center)))
                                .toList()),
                        if (snapshot.data == true)
                          const Center(
                            child: CircularProgressIndicator(),
                          ),
                      ]);
                    }),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
