import 'dart:io';

import 'package:biomasse/TakePicture.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter/material.dart';
import 'package:biomasse/APIRequests.dart';
import 'package:biomasse/ResultScreen.dart';
import 'package:biomasse/ValorizationScreen.dart';
import 'package:biomasse/ValorizationUtils.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Biomasse',
      theme: ThemeData(
        primarySwatch: Colors.green,
      ),
      home: Container(
        decoration: BoxDecoration(
            image: DecorationImage(
                image: AssetImage("images/background_1.png"), fit: BoxFit.cover)),
        child: MyHomePage(title: 'Biomasse prise photo')
      ),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _counter = 0;
  File _image;

  void _incrementCounter() {
    setState(() {
      _counter++;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Container(
        margin: EdgeInsets.only(top: 105,bottom: 105,left: 50,right: 50),
        color: Color.fromARGB(200, 255, 255, 255),
        alignment: Alignment(0.0, 0.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            RaisedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => TakePicture()),
                );
              },
              textColor: Colors.white,
              color: Colors.green,
              child: const Text('Camera'),
              padding: const EdgeInsets.all(0.0),
            ),
            RaisedButton(
              onPressed: () async {
                var image = await ImagePicker.pickImage(source: ImageSource.gallery);

                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => ResultScreen(pathPicture: image.path, crop : false)),
                );
              },
              textColor: Colors.white,
              padding: const EdgeInsets.all(0.0),
              child: Container(
                decoration: const BoxDecoration(
                    color: Colors.green
                ),
                padding: const EdgeInsets.all(10.0),
                child: Text('Upload picture'),
              ),
            ),
            RaisedButton(
              onPressed: ()  {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => ValorizationScreen(biomassName: "Biomasse", valorisations: getDummyValorizations(),)),
                );
              },
              textColor: Colors.white,
              padding: const EdgeInsets.all(0.0),
              child: Container(
                decoration: const BoxDecoration(
                    color: Colors.green
                ),
                padding: const EdgeInsets.all(10.0),
                child: Text('Valorization'),
              ),
            )
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _incrementCounter,
        tooltip: 'Increment',
        child: Icon(Icons.add),
      ),
    );
  }
}
