import 'package:flutter/material.dart';
import 'package:relu_consultancy_test/ui/music_list_view.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Music App',
      home: GetMusicList(),
    );
  }
}
