import 'package:flutter/material.dart';

void main() => runApp(VideoPage());

class VideoPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Video',
      home: Scaffold(
        appBar: AppBar(
          title: Text('Video List'),
        ),
        body: Center(
          child: Text('This is where the Video calls will take place'),
        ),
      ),
    );
  }
}