import 'package:biomasse/TakePicture.dart';
import 'package:flutter/material.dart';
import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:intl/intl.dart';

import 'package:location/location.dart';

import 'package:biomasse/APIRequests.dart';

class ResultScreen extends StatefulWidget {
  ResultScreen({Key key, this.pathPicture, this.crop}) : super(key: key);

  final String pathPicture;
  final bool crop;

  @override
  ResultScreenState createState() => ResultScreenState();
}

class ResultScreenState extends State<ResultScreen> {

  String _message = "";
  int status = STATUS_DEFAULT;
  String biomass_name = "";
  double certitude = 0;

  void uploadCallback(){
    setState(() {
      status = STATUS_PENDING_CLASSIFICATION;
    });
  }

  @override
  void initState() {
    super.initState();
    sendImageToAPI(widget.pathPicture, widget.crop,uploadCallback).then((res){
      print(res);
      final json_response = json.decode(res);
      if(json_response['result'] == "OK"){
        setState(() {
          biomass_name = json_response['biomass_name'];
          certitude = json_response['certitude'];
          status = STATUS_RECOGNIZED;
        });
      }
      else if(json_response['result'] == "BAD_CERTITUDE"){
        var location = new Location();
        location.getLocation().then(onLocationFound);
      }
    });

    setState(() {
      status = STATUS_PENDING_UPLOAD_IMAGE;
    });
  }

  void onLocationFound(Map<String, double> location){
    sendLocationToAPI(widget.pathPicture,location).then((res){

      final json_response = json.decode(res);
      if(json_response['result'] == "OK"){
        setState(() {
          biomass_name = json_response['biomass_name'];
          certitude = json_response['certitude'];
          status = STATUS_RECOGNIZED;
        });
      }
      else if(json_response['result'] == "BAD_CERTITUDE"){
        setState(() {
          biomass_name = json_response['biomass_name'];
          certitude = json_response['certitude'];
          status = STATUS_UNRECOGNIZED;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {

    if(status == STATUS_PENDING_UPLOAD_IMAGE){
      return Scaffold(
        appBar: AppBar(
          title: Text("Reconnaissance ..."),
        ),
        body: Stack(
            children: <Widget>[
              Container(
                decoration: new BoxDecoration(
                  image: new DecorationImage(image: new AssetImage("images/background_1.png"), fit: BoxFit.cover,),
                ),
              ),
              Container(
                margin: EdgeInsets.only(top: 80,bottom: 80,left: 30,right: 30),
                color: Color.fromARGB(200, 255, 255, 255),
                alignment: Alignment(0.0, 0.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    CircularProgressIndicator(),
                    Text("L'image est en cours d'identification ... ")
                  ],
                )
              )
            ],
        ),
      );
    }
    else if(status == STATUS_PENDING_CLASSIFICATION){
      return Scaffold(
        appBar: AppBar(
          title: Text("Reconnaissance ..."),
        ),
        body: Stack(
          children: <Widget>[
            Container(
              decoration: new BoxDecoration(
                image: new DecorationImage(image: new AssetImage("images/background_1.png"), fit: BoxFit.cover,),
              ),
            ),
            Container(
              margin: EdgeInsets.only(top: 80,bottom: 80,left: 30,right: 30),
              color: Color.fromARGB(200, 255, 255, 255),
              alignment: Alignment(0.0, 0.0),
              child:Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  CircularProgressIndicator(),
                  Text("L'image est en cours d'identification ... ")
                ],
              ),
            )
          ],
        ),
      );
    }
    else if(status == STATUS_RECOGNIZED){ // OK
      return Scaffold(
        appBar: AppBar(
          title: Text(
              "Résultats"
          ),
        ),
        body: Stack(
          children: <Widget>[
            Container(
              decoration: new BoxDecoration(
                image: new DecorationImage(image: new AssetImage("images/background_1.png"), fit: BoxFit.cover,),
              ),
            ),
            Container(
              margin: EdgeInsets.only(top: 80,bottom: 80,left: 30,right: 30),
              color: Color.fromARGB(200, 255, 255, 255),
              alignment: Alignment(0.0, 0.0),
              child:Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Text(
                    biomass_name,
                    style: TextStyle(fontWeight: FontWeight.bold,fontSize: 30,color: Colors.black),
                  ),
                  Text(
                    "Certitude : " + new NumberFormat("#00.##").format(certitude * 100) + " %",
                    style: TextStyle(fontWeight: FontWeight.bold,fontSize:22,color: Colors.black),
                  ),
                  Container(
                    padding: const EdgeInsets.all(29.0),
                    child: Image.file(
                      File(widget.pathPicture),
                      fit: BoxFit.fitWidth,
                    ),
                  ),
                  RaisedButton(
                    onPressed: () {},
                    textColor: Colors.white,
                    color: Colors.green,
                    child: const Text('Valorisations'),
                  ),
                ],
              )
            )
          ],
        ),
      );
    }
    else if(status == STATUS_UNRECOGNIZED){ // No way

    }
  }

  static final int STATUS_DEFAULT = -1;
  static final int STATUS_UNRECOGNIZED = 1;
  static final int STATUS_NEED_GEOLOC = 2;
  static final int STATUS_RECOGNIZED = 3;
  static final int STATUS_PENDING_UPLOAD_IMAGE = 4;
  static final int STATUS_PENDING_CLASSIFICATION = 5;
}
