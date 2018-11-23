import 'dart:async';
import 'dart:io';
import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'data.dart';
import 'network.dart';
import 'history.dart';

class CameraApp extends StatefulWidget {
  @override
  _CameraAppState createState() => _CameraAppState();
}

class _CameraAppState extends State<CameraApp> {
  CameraController controller;
  List<CameraDescription> cameras;

  bool loading = false;

  final _scaffoldKey = GlobalKey<ScaffoldState>();

  Future<void> getCameras() async {
    cameras = await availableCameras();
    controller = CameraController(cameras[0], ResolutionPreset.medium);
    controller.initialize().then((_) {
      if (!mounted) {
        return;
      }
      setState(() {});
    });
  }

  @override
  void initState() {
    super.initState();
    this.getCameras();
  }

  @override
  void dispose() {
    controller?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    bool doNotshowCamera =
        loading || controller == null || !controller.value.isInitialized;

    return Scaffold(
      key: _scaffoldKey,
      body: doNotshowCamera
          ? Container(
              child: Center(child: CircularProgressIndicator()),
            )
          : Column(
              children: <Widget>[
                Stack(
                  children: <Widget>[
                    Container(
                      height: MediaQuery.of(context).size.height,
                      width: MediaQuery.of(context).size.width,
                      child: CameraPreview(controller),
                    ),
                    Positioned(
                      bottom: 0.0,
                      left: 0.0,
                      right: 0.0,
                      child: Center(
                        child: GestureDetector(
                          onTap: () {
                            setState(() {
                              loading = true;
                            });
                            this.handlePhoto();
                          },
                          child: Card(
                            shape: CircleBorder(),
                            elevation: 10.0,
                            child: Container(
                              child: Icon(
                                Icons.brightness_1,
                                color: Colors.blueAccent,
                                size: 100.0,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
    );
  }

  void handlePhoto() {
    if (controller.value.isTakingPicture) {
      // A capture is already pending, do nothing.
      return null;
    }
    this.takePhoto().then((streamedResponse) {
      streamedResponse.stream.transform(utf8.decoder).listen((value) {
        Map results = json.decode(value);
        print(results);
        String store = results['store'];
        Data.stores.add(store);

        String date = results['date'];
        Data.dates.add(date);

        String total = results['total'].toString();
        if (results['total'] is double) {
          Data.totals.add(results['total']);
        }

        String entireTotal = Data.totals
            .reduce((value, element) => value + element)
            .toStringAsFixed(2);
        _scaffoldKey.currentState.showBottomSheet(
          (context) {
            return Container(
              color: Colors.white70,
              height: MediaQuery.of(context).size.height,
              width: MediaQuery.of(context).size.width,
              margin: EdgeInsets.only(top: 50.0),
              padding: EdgeInsets.only(top: 30.0, left: 10.0, right: 10.0),
              child: Container(
                child: Column(
                  children: <Widget>[
                    Container(
                      child: Row(
                        mainAxisSize: MainAxisSize.max,
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: <Widget>[
                          Text(
                            "Store:",
                            style:
                                TextStyle(fontSize: 30.0, color: Colors.black),
                          ),
                          Spacer(),
                          Text(
                            store,
                            style:
                                TextStyle(fontSize: 30.0, color: Colors.black),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      child: Row(
                        mainAxisSize: MainAxisSize.max,
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: <Widget>[
                          Text(
                            "Total:",
                            style:
                                TextStyle(fontSize: 30.0, color: Colors.black),
                          ),
                          Spacer(),
                          Text(
                            '£$total',
                            style:
                                TextStyle(fontSize: 30.0, color: Colors.black),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      child: Row(
                        mainAxisSize: MainAxisSize.max,
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: <Widget>[
                          Text(
                            "Date:",
                            style:
                                TextStyle(fontSize: 30.0, color: Colors.black),
                          ),
                          Spacer(),
                          Text(
                            date,
                            style:
                                TextStyle(fontSize: 30.0, color: Colors.black),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      padding: EdgeInsets.only(top: 30.0),
                      child: Row(
                        mainAxisSize: MainAxisSize.max,
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: <Widget>[
                          Text(
                            "Entire Total:",
                            style:
                                TextStyle(fontSize: 40.0, color: Colors.black),
                          ),
                          Spacer(),
                          Text(
                            '£$entireTotal',
                            style:
                                TextStyle(fontSize: 40.0, color: Colors.black),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.only(top: 50.0),
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.grey),
                        borderRadius: BorderRadius.all(
                          Radius.circular(5.0),
                        ),
                      ),
                      child: RaisedButton(
                        color: Colors.blue,
                        padding: EdgeInsets.all(10.0),
                        onPressed: () {
                          print('clicked history');
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => HistoryScreen(),
                            ),
                          );
                        },
                        child: Text(
                          'View History',
                          style: TextStyle(fontSize: 30.0, color: Colors.white),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        );

        setState(() {
          loading = false;
        });
      });
    });
  }

  Future<http.StreamedResponse> takePhoto() async {
    if (!controller.value.isInitialized) {
      return null;
    }
    String timestamp() => DateTime.now().millisecondsSinceEpoch.toString();
    final Directory extDir = await getApplicationDocumentsDirectory();
    final String dirPath = '${extDir.path}/Pictures/flutter_test';
    await Directory(dirPath).create(recursive: true);
    final String filePath = '$dirPath/${timestamp()}.jpg';

    try {
      await controller.takePicture(filePath);
    } on CameraException catch (e) {
      print('---------Error----------');
      print(e);
      print('---------Error----------');
      setState(() {
        loading = false;
      });
      return null;
    }
    File file = File(filePath);
    return Network().post(file);
  }
}
