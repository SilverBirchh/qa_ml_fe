import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'package:qa_ml_fe/camera.dart';

List<CameraDescription> cameras;

void main() {
  runApp(MainApp());
}

class MainApp extends StatefulWidget {
  @override
  State createState() {
    return MainAppState();
  }
}

class MainAppState extends State<MainApp> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'QA ML',
      home: CameraApp(),
    );
  }
}