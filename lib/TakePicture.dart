import 'dart:async';
import 'dart:io';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'package:path/path.dart' show join;
import 'package:path_provider/path_provider.dart';

import 'package:biomasse/ResultScreen.dart';

List<CameraDescription> cameras;


class TakePicture extends StatefulWidget {
  @override
  _CameraAppState createState() => _CameraAppState();
}

class _CameraAppState extends State<TakePicture> {
  CameraController controller;

  void initialize(){
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
    availableCameras().then((List<CameraDescription> resCameras) {
      cameras = resCameras;
      initialize();
    });
  }

  @override
  void dispose() {
    controller?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (controller == null || !controller.value.isInitialized) {
      return Container();
    }
    return Scaffold(
      body :Center(
        child: new Stack(
          alignment: FractionalOffset.center,
          children: <Widget>[
            new Positioned.fill(
              child: new AspectRatio(
                  aspectRatio: controller.value.aspectRatio,
                  child: new CameraPreview(controller)),
            ),
            new Positioned.fill(
              child: new Image.asset(
                'images/overlay_picture.png',
                fit: BoxFit.none,
              ),
            ),
          ],
        )
      ),
      floatingActionButton: FloatingActionButton(
          onPressed: () {handlePressed(context);},
          child: Icon(Icons.camera_alt),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }

  void handlePressed(BuildContext context) async {
    try {
      if(controller != null && controller.value.isInitialized){
        final path = join(
          (await getTemporaryDirectory()).path, '${DateTime.now()}.png',
        );

        await controller.takePicture(path);
        print("Done taking picture");
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => ResultScreen(pathPicture: path, crop: true)),
        );
      }
    } catch (e) {
      print(e);
    }
  }
}