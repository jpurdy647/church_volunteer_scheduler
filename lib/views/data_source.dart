import 'package:flutter/material.dart';

class DataSourceView extends StatefulWidget {
  const DataSourceView({super.key, required this.title});
  final String title;
  @override
  State<DataSourceView> createState() => _DataSourceViewState();
}

class _DataSourceViewState extends State<DataSourceView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Data Source"),
      ),
      body: SafeArea(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Text("Data Source View"),
            ],
          ),
        ),
      ),
    );
  }
}