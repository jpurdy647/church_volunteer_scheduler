import 'package:church_volunteer_scheduler/data/data_source.dart';
import 'package:church_volunteer_scheduler/views/sched_sheet.dart';
import 'package:church_volunteer_scheduler/views/data_source.dart';
import 'package:church_volunteer_scheduler/views/stats.dart';
import 'package:church_volunteer_scheduler/views/configuration.dart';
import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';

void main() {
  //Set up data source
  
  DataSource().generatePlaceholderActivities();
  DataSource().connector.generateAssignmentsGrid();
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

class _MyHomePageState extends State<MyHomePage> {
  int _page = 1;
  final List<Widget> _pages = [
    DataSourceView(title: "Data Source"),
    SchedSheet(),
    ConfigView(title: "Configuration"),
    StatsView(title: "Stats")
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Theme.of(context).colorScheme.inversePrimary,
          title: Text("Volunteer Scheduler"),
        ),
        bottomNavigationBar: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            IconButton(
              icon: const Icon(Icons.storage_rounded),
              onPressed: () {
                setState(() {
                  _page = 0;
                });
              },
            ),
            IconButton(
              icon: const Icon(Icons.table_chart),
              onPressed: () {
                setState(() {
                  _page = 1;
                });
              },
            ),
            IconButton(
              icon: const Icon(Icons.settings_rounded),
              onPressed: () {
                setState(() {
                  _page = 2;
                });
              },
            ),
            IconButton(
              icon: const Icon(Icons.pie_chart_rounded),
              onPressed: () {
                setState(() {
                  _page = 3;
                });
              },
            ),
          ],
        ),
        body: _pages[_page]);
  }
}
