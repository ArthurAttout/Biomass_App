import 'package:biomasse/TakePicture.dart';
import 'package:flutter/material.dart';
import 'dart:async';
import 'dart:isolate';

import 'package:biomasse/APIRequests.dart';

class ResultScreen extends StatefulWidget {
  ResultScreen({Key key, this.pathPicture}) : super(key: key);

  final String pathPicture;

  @override
  ResultScreenState createState() => ResultScreenState();
}

class ResultScreenState extends State<ResultScreen> {

  ReceivePort _receivePort;
  Isolate _isolate;

  @override
  void initState() async {
    super.initState();
    _receivePort = ReceivePort();
    _isolate = await Isolate.spawn(sendImage, _receivePort.sendPort);
    _receivePort.listen(_handleMessage);
  }

  void sendImage(SendPort sendPort) async {
    sendImageToAPI(widget.pathPicture).then((res) {
        sendPort.send(res);
    });
  }

  void _handleMessage(dynamic data) {
    print('RECEIVED: ' + data);
  }


  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        title: Text("Reconnaissance ..."),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              'Result goes here',
            )
          ],
        ),
      ),
    );
  }
}
