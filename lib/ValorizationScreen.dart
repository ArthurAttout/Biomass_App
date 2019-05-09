import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class ValorizationScreen extends StatefulWidget {
  ValorizationScreen({Key key, this.pathPicture, this.crop}) : super(key: key);

  final String pathPicture;
  final bool crop;

  @override
  ValorizationScreenState createState() => ValorizationScreenState();
}

class ValorizationScreenState extends State<ValorizationScreen> {

  double _celluloseValue = 10.0;
  double _hemiCelluloseValue = 10.0;
  double _ligninValue = 10.0;
  String _valorization = "Pyrolyse";
  String _biomassName = "Herbes séchées";
  NumberFormat nf = new NumberFormat("###");

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Valorisations"),
      ),
      body:Stack(
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
              children: <Widget>[
                Container(
                  margin:EdgeInsets.only(top: 15),
                  child: Text(
                    _biomassName,
                    style: TextStyle(fontWeight: FontWeight.bold,fontSize: 30,color: Colors.black),
                  ),
                ),
                Container(
                  margin: EdgeInsets.only(top: 15,bottom: 15),
                  color: Color.fromARGB(50, 3, 173, 60),
                  padding: EdgeInsets.only(right: 15),
                  child: Column(
                    children: <Widget>[
                      Text(
                        "Cellulose",
                        style: TextStyle(fontWeight: FontWeight.bold,fontSize: 15,color: Colors.black),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Slider(
                            min: 0,
                            max: 100,
                            onChanged: (newRating) {
                              setState(() => _celluloseValue = newRating);
                            },
                            value: _celluloseValue,
                          ),
                          Text(
                            nf.format(_celluloseValue),
                            style: TextStyle(fontWeight: FontWeight.bold,fontSize: 15,color: Colors.black),
                          )
                        ],
                      ),
                    ],
                  )
                ),
                Container(
                  margin: EdgeInsets.only(top: 15,bottom: 15),
                  color: Color.fromARGB(50, 3, 173, 60),
                  padding: EdgeInsets.only(right: 15),
                  child: Column(
                    children: <Widget>[
                      Text(
                        "Hémicellulose",
                        style: TextStyle(fontWeight: FontWeight.bold,fontSize: 15,color: Colors.black),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Slider(
                            min: 0,
                            max: 100,
                            onChanged: (newRating) {
                              setState(() => _hemiCelluloseValue = newRating);
                            },
                            value: _hemiCelluloseValue,
                          ),
                          Text(
                            nf.format(_hemiCelluloseValue),
                            style: TextStyle(fontWeight: FontWeight.bold,fontSize: 15,color: Colors.black),
                          )
                        ],
                      ),
                    ],
                  )
                ),
                Container(
                  margin: EdgeInsets.only(top: 15,bottom: 15),
                  color: Color.fromARGB(50, 3, 173, 60),
                  padding: EdgeInsets.only(right: 15),
                  child: Column(
                    children: <Widget>[
                      Text(
                        "Lignine",
                        style: TextStyle(fontWeight: FontWeight.bold,fontSize: 15,color: Colors.black),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Slider(
                            min: 0,
                            max: 100,
                            onChanged: (newRating) {
                              setState(() => _ligninValue = newRating);
                            },
                            value: _ligninValue,
                          ),
                          Text(
                            nf.format(_ligninValue),
                            style: TextStyle(fontWeight: FontWeight.bold,fontSize: 15,color: Colors.black),
                          )
                        ],
                      )
                    ],
                  ),
                ),
                Text("Valorisation conseillée : "),
                Text(_valorization.toUpperCase()),
              ],
            ),
          )
        ],
      )
    );
  }
}
