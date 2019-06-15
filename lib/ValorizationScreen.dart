import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:biomasse/ValorizationUtils.dart';
import 'package:tuple/tuple.dart';

class ValorizationScreen extends StatefulWidget {
  ValorizationScreen({Key key, this.biomassName, this.valorisations}) : super(key: key);

  final String biomassName;
  final List<Tuple4<int,int,int,String>> valorisations;

  @override
  ValorizationScreenState createState() => ValorizationScreenState(biomassName,valorisations);
}

class ValorizationScreenState extends State<ValorizationScreen> {
  ValorizationScreenState(this.biomassName, this.valorizations);

  int celluloseValue = 10;
  int hemiCelluloseValue = 10;
  int ligninValue = 10;
  List<Tuple4<int,int,int,String>> valorizations;
  String currentValorization = "Pyrolyse";
  String biomassName;
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
                    biomassName,
                    style: TextStyle(fontWeight: FontWeight.bold,fontSize: 30,color: Colors.black),
                  ),
                ),
                Container(
                  margin: EdgeInsets.only(top: 15,bottom: 15),
                  color: Color.fromARGB(50, 3, 173, 60),
                  padding: EdgeInsets.only(right: 15),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Container(
                        padding: EdgeInsets.only(left: 15, top: 15),
                        child: Text(
                          "Cellulose",
                          style: TextStyle(fontWeight: FontWeight.bold,fontSize: 15,color: Colors.black),
                        ),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Expanded(
                            flex: 10,
                            child: Slider(
                              min: 0,
                              max: 100,
                              onChangeEnd: (newValue){
                                setState(() {
                                  currentValorization = getValorisationFromCharacteristics(valorizations, celluloseValue, hemiCelluloseValue, ligninValue);
                                });
                              },
                              onChanged: (newRating) {
                                setState(() => celluloseValue = newRating.toInt());
                              },
                              value: celluloseValue.toDouble(),
                            ),
                          ),
                          Expanded(
                           flex: 2,
                           child: Text(
                             nf.format(celluloseValue),
                             style: TextStyle(fontWeight: FontWeight.bold,fontSize: 15,color: Colors.black),
                           ),
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
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Container(
                        padding: EdgeInsets.only(left: 15, top: 15),
                        child: Text(
                          "Hémicellulose",
                          style: TextStyle(fontWeight: FontWeight.bold,fontSize: 15,color: Colors.black),
                        ),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Expanded(
                            flex: 10,
                            child: Slider(
                              min: 0,
                              max: 100,
                              onChangeEnd: (newValue){
                                setState(() {
                                  currentValorization = getValorisationFromCharacteristics(valorizations, celluloseValue, hemiCelluloseValue, ligninValue);
                                });
                              },
                              onChanged: (newRating) {
                                setState(() => hemiCelluloseValue = newRating .toInt());
                              },
                              value: hemiCelluloseValue.toDouble(),
                            ),
                          ),
                          Expanded(
                            flex: 2,
                            child: Text(
                              nf.format(hemiCelluloseValue),
                              style: TextStyle(fontWeight: FontWeight.bold,fontSize: 15,color: Colors.black),
                            ),
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
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Container(
                        padding: EdgeInsets.only(left: 15, top: 15),
                        child: Text(
                          "Lignine",
                          style: TextStyle(fontWeight: FontWeight.bold,fontSize: 15,color: Colors.black),
                        ),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Expanded(
                            flex: 10,
                            child: Slider(
                              onChangeEnd: (newValue){
                                  setState(() {
                                    currentValorization = getValorisationFromCharacteristics(valorizations, celluloseValue, hemiCelluloseValue, ligninValue);
                                  });
                                },
                              onChanged: (newRating) {
                                setState(() => ligninValue = newRating .toInt());
                              },
                              min: 0,
                              max: 100,
                              value: ligninValue.toDouble(),
                            ),
                          ),
                          Expanded(
                            flex: 2,
                            child: Text(
                              nf.format(ligninValue),
                              style: TextStyle(fontWeight: FontWeight.bold,fontSize: 15,color: Colors.black),
                            ),
                          )
                        ],
                      )
                    ],
                  ),
                ),
                Text("Valorisation conseillée : ",style: TextStyle(fontSize: 15,color: Colors.black),),
                Text(currentValorization.toUpperCase(), style: TextStyle(fontWeight: FontWeight.bold,fontSize: 15,color: Colors.black),),
              ],
            ),
          )
        ],
      )
    );
  }
}
