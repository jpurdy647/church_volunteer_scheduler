import 'package:flutter/material.dart';

class StatsView extends StatefulWidget {
  const StatsView({super.key, required this.title});
  final String title;
  @override
  State<StatsView> createState() => _StatsViewState();
}

class _StatsViewState extends State<StatsView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Stats"),
      ),
      body: SafeArea(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Text("Stats View"),
            ],
          ),
        ),
      ),
    );
  }
}
