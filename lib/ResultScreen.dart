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
  String urlOldUpload;
  var valorizations;

  void uploadCallback(String url){
    setState(() {
      status = STATUS_PENDING_CLASSIFICATION;
      urlOldUpload = url;
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
          valorizations = json_response['valorizations'];
        });

        print(valorizations);
      }
      else if(json_response['result'] == "BAD_CERTITUDE"){
        setState(() {
          status = STATUS_NEED_GEOLOC;
        });
      }
    });

    setState(() {
      status = STATUS_PENDING_UPLOAD_IMAGE;
    });
  }

  void onLocationFound(Map<String, double> location){
    print("Location found");
    sendLocationToAPI(urlOldUpload,location).then((res){
      final json_response = json.decode(res);
      if(json_response['result'] == "OK"){
        print("Server said OK location found");
        setState(() {
          biomass_name = json_response['biomass_name'];
          certitude = json_response['certitude'];
          status = STATUS_RECOGNIZED;
        });
      }
      else if(json_response['result'] == "BAD_CERTITUDE"){
        print("Server said no way");
        setState(() {
          biomass_name = json_response['biomass_name'];
          certitude = json_response['certitude'];
          status = STATUS_UNRECOGNIZED;
        });
      }
    });

    setState(() {
      status = STATUS_PENDING_UPLOAD_IMAGE;
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
                    Text("L'image est envoyée au serveur ... ")
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
    else if(status == STATUS_RECOGNIZED){
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
    else if(status == STATUS_NEED_GEOLOC){
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
                  Text(
                    "L'image n'a pas pu être reconnue.",
                    textAlign: TextAlign.center,
                    style: TextStyle(fontWeight: FontWeight.bold,fontSize:18,color: Colors.black),
                  ),
                  Text(
                    "Si vous le souhaitez, vous pouvez préciser votre géolocalisation afin d'aider l'intelligence artificielle",
                    textAlign: TextAlign.center,
                    style: TextStyle(fontWeight: FontWeight.bold,fontSize:12,color: Colors.black),
                  ),
                  Padding(
                    padding: EdgeInsets.all(38.0),
                    child: RaisedButton(
                      onPressed: () {
                        // Location doesn't work with other dependencies .. Temporary faked data

                        var location = new Map<String,double>();
                        location.putIfAbsent("lat", () => 50);
                        location.putIfAbsent("lng", () => -70);
                        onLocationFound(location);
                      },
                      textColor: Colors.white,
                      color: Colors.green,
                      child: const Text('Géolocalisation'),
                    ),
                  ),
                ],
              ),
            )
          ],
        ),
      );
    }
    else if(status == STATUS_UNRECOGNIZED){
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
                  Text(
                    "L'image n'a toujours pas pu être reconnue.",
                    textAlign: TextAlign.center,
                    style: TextStyle(fontWeight: FontWeight.bold,fontSize:18,color: Colors.black),
                  ),
                  Text(
                    "Il semblerait que cette biomasse ne soit pas reconnue par le système. Si vous le souhaitez, vous pouvez soumettre un dossier aux chercheurs",
                    textAlign: TextAlign.center,
                    style: TextStyle(fontWeight: FontWeight.bold,fontSize:12,color: Colors.black),
                  ),
                  Padding(
                    padding: EdgeInsets.all(38.0),
                    child: RaisedButton(
                      onPressed: () {},
                      textColor: Colors.white,
                      color: Colors.green,
                      child: const Text('Soumettre'),
                    ),
                  ),
                ],
              ),
            )
          ],
        ),
      );
    }
  }

  static final int STATUS_DEFAULT = -1;
  static final int STATUS_UNRECOGNIZED = 1;
  static final int STATUS_NEED_GEOLOC = 2;
  static final int STATUS_RECOGNIZED = 3;
  static final int STATUS_PENDING_UPLOAD_IMAGE = 4;
  static final int STATUS_PENDING_CLASSIFICATION = 5;
}
