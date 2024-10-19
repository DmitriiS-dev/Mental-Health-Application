import 'package:flutter/material.dart';

void main() => runApp(WeedPage());

class WeedPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Weed',
      home: Scaffold(
        appBar: AppBar(
          title: Text('Weed List'),
        ),
        body: Center(
          child: Text('420 Baby'),
        ),
      ),
    );
  }
}