import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:multi_image_picker/multi_image_picker.dart';
import 'package:flutter/services.dart';
import 'package:biomasse/main.dart';
import 'package:biomasse/APIRequests.dart';

class SubmitReportScreen extends StatefulWidget {
  SubmitReportScreen({Key key, this.pathPicture, this.crop}) : super(key: key);

  final String pathPicture;
  final bool crop;

  @override
  SubmitRecordState createState() => SubmitRecordState();
}

class SubmitRecordState extends State<SubmitReportScreen> {

  TextEditingController _controller = new TextEditingController();
  String comment = "";
  List<Asset> assetsList = null;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _controller.addListener(onChange);
  }

  void onChange() {
    comment = _controller.text;
  }

  void _showToast(BuildContext context, String message) {
    final scaffold = Scaffold.of(context);
    scaffold.showSnackBar(
      SnackBar(
        content: Text(message),
        action: SnackBarAction(
            label: 'OK', onPressed: scaffold.hideCurrentSnackBar),
      ),
    );
  }

  void onReportSent(BuildContext ctx, String message){
    _showToast(ctx, message);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      appBar: AppBar(
        title: Text("Soumettre un rapport"),
      ),
      body: Builder(
        builder: (childContext) => Stack(
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
                    TextFormField(
                      controller: _controller,
                      decoration: InputDecoration(
                          labelText: 'Commentaire'
                      ),
                    ),
                    RaisedButton(
                      onPressed: () async {

                        try {
                          assetsList = await MultiImagePicker.pickImages(
                            maxImages: 20,
                          );

                        } on PlatformException catch (e) {
                          print("Error " + e.toString());
                        }

                      },
                      textColor: Colors.white,
                      padding: const EdgeInsets.all(0.0),
                      child: Container(
                        decoration: const BoxDecoration(
                            color: Colors.green
                        ),
                        padding: const EdgeInsets.all(10.0),
                        child: Text('Importer des images'),
                      ),
                    ),
                    RaisedButton(
                      onPressed: () {
                        sendReportToAPI(assetsList, comment).then((result) {
                          onReportSent(childContext,"Dossier envoyé !");
                        });

                        _showToast(childContext, "Dossier en cours d'envoi ...");
                      },
                      textColor: Colors.white,
                      padding: const EdgeInsets.all(0.0),
                      child: Container(
                        decoration: const BoxDecoration(
                            color: Colors.green
                        ),
                        padding: const EdgeInsets.all(10.0),
                        child: Text('Soumettre'),
                      ),
                    ),
                  ],
                )
            )
          ],
        ),
      )
    );
  }
}