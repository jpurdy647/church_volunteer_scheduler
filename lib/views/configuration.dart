import 'package:flutter/material.dart';

class ConfigView extends StatefulWidget {
  const ConfigView({super.key, required this.title});
  final String title;
  @override
  State<ConfigView> createState() => _ConfigViewState();
}

class _ConfigViewState extends State<ConfigView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Configuration"),
      ),
      body: SafeArea(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Text("Configuration View"),
            ],
          ),
        ),
      ),
    );
  }
}
