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
  int status = -1;
  String biomass_name = "";
  double certitude = 0;

  @override
  void initState() {
    super.initState();
    sendImageToAPI(widget.pathPicture, widget.crop).then((res){
      print(res);
      final json_response = json.decode(res);
      if(json_response['result'] == "OK"){
        setState(() {
          biomass_name = json_response['biomass_name'];
          certitude = json_response['certitude'];
          status = 0;
        });
      }
      else if(json_response['result'] == "BAD_CERTITUDE"){
        var location = new Location();
        location.getLocation().then(onLocationFound);
      }
    });
  }

  void onLocationFound(Map<String, double> location){
    sendLocationToAPI(widget.pathPicture,location).then((res){

      final json_response = json.decode(res);
      if(json_response['result'] == "OK"){
        setState(() {
          biomass_name = json_response['biomass_name'];
          certitude = json_response['certitude'];
          status = 0;
        });
      }
      else if(json_response['result'] == "BAD_CERTITUDE"){
        setState(() {
          biomass_name = json_response['biomass_name'];
          certitude = json_response['certitude'];
          status = 1;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {

    if(status == -1){
      return Scaffold(
        appBar: AppBar(
          title: Text("Reconnaissance ..."),
        ),
        body: Center(
            child: CircularProgressIndicator()
        ),
      );
    }
    else if(status == 0){ // OK
      return Scaffold(
        appBar: AppBar(
          title: Text(
              "Résultats"),
        ),
        body: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
                biomass_name,
                style: TextStyle(fontWeight: FontWeight.bold,fontSize: 30),
            ),
            Text(
                "Certitude : " + new NumberFormat("#00.##").format(certitude * 100) + " %",
                style: TextStyle(fontWeight: FontWeight.bold,fontSize:22),
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
        ),
      );
    }
    else if(status == 1){ // No way

    }

  }
}
