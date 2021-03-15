import 'package:flutter/material.dart';
import 'package:network_status_bar/network_status_bar.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Network Statusbar Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: NetworkStatusbarPage(),
    );
  }
}

class NetworkStatusbarPage extends StatelessWidget {
  NetworkStatusbarPage({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Network Status Bar',
        ),
      ),
      body: NetworkStatusBar(
        child: Container(
          height: 300,
          color: Colors.yellow,
        ),
      ),
    );
  }
}
