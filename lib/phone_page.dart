import 'package:flutter/material.dart';

void main() => runApp(PhonePage());

class PhonePage extends StatelessWidget {
  const PhonePage({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Phone',
      home: Scaffold(
        appBar: AppBar(
          title: Text('Phone List'),
        ),
        body: Center(
          child: Text('This is where the phone calls will take place'),
        ),
      ),
    );
  }
}
