import 'package:flutter/material.dart';
import 'package:flutter_spreadsheet_ui/flutter_spreadsheet_ui.dart';


void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Church Volunteer Scheduler',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: const Color.fromARGB(255, 42, 8, 100)),
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
  int _counter = 0;

  void _incrementCounter() {
    setState(() {
      _counter++;
    });
  }

  @override
  Widget build(BuildContext context) {
      final List<FlutterSpreadsheetUIColumn> columns = [
        FlutterSpreadsheetUIColumn(
            contentAlignment: Alignment.center,
            cellBuilder: (context, cellId) => const Text("Task 2"),
        ),
        FlutterSpreadsheetUIColumn(
            width: 200,
            contentAlignment: Alignment.center,
            cellBuilder: (context, cellId) => const Text("Assigned Date"),
        ),
        FlutterSpreadsheetUIColumn(
            width: 110,
            cellBuilder: (context, cellId) => const Text("Permissions"),
        ),
        FlutterSpreadsheetUIColumn(
            width: 110,
            cellBuilder: (context, cellId) => const Text("more1"),
        ),
        FlutterSpreadsheetUIColumn(
            width: 110,
            cellBuilder: (context, cellId) => const Text("more2"),
        ),
      ];

      final List<FlutterSpreadsheetUIRow> rows = [
          FlutterSpreadsheetUIRow(
              cells: [
                  FlutterSpreadsheetUICell(
                      cellBuilder: (context, cellId) => TextField(
                          textAlign: TextAlign.center,
                        ),
                  ),
                  FlutterSpreadsheetUICell(
                      cellBuilder: (context, cellId) => TextField(
                          textAlign: TextAlign.center,
                        ),
                  ),
                  FlutterSpreadsheetUICell(
                      cellBuilder: (context, cellId) => TextField(
                          textAlign: TextAlign.center,
                        ),
                  ),
                  FlutterSpreadsheetUICell(
                      cellBuilder: (context, cellId) => TextField(
                          textAlign: TextAlign.center,
                        ),
                  ),
                  FlutterSpreadsheetUICell(
                      cellBuilder: (context, cellId) => TextField(
                          textAlign: TextAlign.center,
                        ),
                  ),
              ],
          ),
          FlutterSpreadsheetUIRow(
              cells: [
                  FlutterSpreadsheetUICell(
                      cellBuilder: (context, cellId) => TextField(
                          textAlign: TextAlign.center,
                        ),
                  ),
                  FlutterSpreadsheetUICell(
                      cellBuilder: (context, cellId) => TextField(
                          textAlign: TextAlign.center,
                        ),
                  ),
                  FlutterSpreadsheetUICell(
                      cellBuilder: (context, cellId) => TextField(
                          textAlign: TextAlign.center,
                        ),
                  ),
                  FlutterSpreadsheetUICell(
                      cellBuilder: (context, cellId) => TextField(
                          textAlign: TextAlign.center,
                        ),
                  ),
                  FlutterSpreadsheetUICell(
                      cellBuilder: (context, cellId) => TextField(
                          textAlign: TextAlign.center,
                        ),
                  ),
              ],
          ),
          FlutterSpreadsheetUIRow(
              cells: [
                  FlutterSpreadsheetUICell(
                      cellBuilder: (context, cellId) => TextField(
                          textAlign: TextAlign.center,
                        ),
                  ),
                  FlutterSpreadsheetUICell(
                      cellBuilder: (context, cellId) => TextField(
                          textAlign: TextAlign.center,
                        ),
                  ),
                  FlutterSpreadsheetUICell(
                      cellBuilder: (context, cellId) => TextField(
                          textAlign: TextAlign.center,
                        ),
                  ),
                  FlutterSpreadsheetUICell(
                      cellBuilder: (context, cellId) => TextField(
                          textAlign: TextAlign.center,
                        ),
                  ),
                  FlutterSpreadsheetUICell(
                      cellBuilder: (context, cellId) => TextField(
                          textAlign: TextAlign.center,
                        ),
                  ),
              ],
          ),
          FlutterSpreadsheetUIRow(
              cells: [
                  FlutterSpreadsheetUICell(
                      cellBuilder: (context, cellId) => TextField(
                          textAlign: TextAlign.center,
                        ),
                  ),
                  FlutterSpreadsheetUICell(
                      cellBuilder: (context, cellId) => TextField(
                          textAlign: TextAlign.center,
                        ),
                  ),
                  FlutterSpreadsheetUICell(
                      cellBuilder: (context, cellId) => TextField(
                          textAlign: TextAlign.center,
                        ),
                  ),
                  FlutterSpreadsheetUICell(
                      cellBuilder: (context, cellId) => TextField(
                          textAlign: TextAlign.center,
                        ),
                  ),
                  FlutterSpreadsheetUICell(
                      cellBuilder: (context, cellId) => TextField(
                          textAlign: TextAlign.center,
                        ),
                  ),
              ],
          ),
      ];

      FlutterSpreadsheetUIConfig tableConfig = const FlutterSpreadsheetUIConfig(
          enableColumnWidthDrag: true,
          enableRowHeightDrag: true,
          firstColumnWidth: 150,
          freezeFirstColumn: true,
          freezeFirstRow: true,
      );

      

      return Scaffold(
        appBar: AppBar(
          backgroundColor: Theme.of(context).colorScheme.inversePrimary,
          title: Text(widget.title),
          actions: [
            IconButton(
              icon: const Icon(Icons.data_array),
              onPressed: () {
                print("TODO: Open Data View on action bar button click");
              },
            ),
          ],
        ),
        body: SafeArea(
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                FlutterSpreadsheetUI(
                    config: tableConfig,
                    columns: columns,
                    rows: rows,
                ),
                // TextField(
                //   decoration: InputDecoration(
                //     border: OutlineInputBorder(),
                //     labelText: 'Enter your username',
                //   ),
                // ),
                const Text(
                  'You have pushed the button this many times:',
                ),
                Text(
                  '$_counter',
                  style: Theme.of(context).textTheme.headlineMedium,
                ),
              ],
            ),
          ),
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: _incrementCounter,
          tooltip: 'Increment',
          child: const Icon(Icons.add),
        ),
        drawer: Drawer(
          elevation: 20.0,
          child: ListView(
            padding: EdgeInsets.zero,          
            children: <Widget>[
              const DrawerHeader(
                decoration: BoxDecoration(
                  color: Color.fromARGB(255, 10, 57, 126),
                ),
                child: Text('Drawer Header', style: TextStyle(color: Colors.white)),
              ),
              ListTile(
                title: const Text('Item 1'),
                onTap: () {
                  Navigator.pop(context);
                },
              ),
              ListTile(
                title: const Text('Item 2'),
                onTap: () {
                  Navigator.pop(context);
                },
              ),
            ],
          ),
        ),
      );
  }
}
