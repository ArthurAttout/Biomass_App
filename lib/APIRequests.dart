import 'dart:async';
import 'dart:io';
import 'dart:convert';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:path/path.dart' show join;

String uri_api = "http://192.168.1.85:5000";
int overlayWidth = 150;
int overlayHeight = 150;
double screenWidth = 0;
double screenHeight = 0;


Future<String> sendImageToAPI(String path, bool shouldCrop) async {

  print("Sending original image");
  StorageReference firebaseStorageRef = FirebaseStorage.instance.ref().child('myimage_original.png');
  StorageUploadTask taskOriginal = firebaseStorageRef.putFile(new File(path));
  String url = await (await taskOriginal.onComplete).ref.getDownloadURL();

  Map map = {
    'url': url,
    'crop': shouldCrop
  };

  HttpClient httpClient = new HttpClient();
  HttpClientRequest request = await httpClient.postUrl(Uri.parse(uri_api + "/identify"));
  request.headers.set('content-type', 'application/json');
  request.add(utf8.encode(json.encode(map)));
  HttpClientResponse response = await request.close();

  String reply = await response.transform(utf8.decoder).join();
  httpClient.close();
  return reply;
}

Future<String> sendLocationToAPI(String path,Map<String, double> location) async {

}
