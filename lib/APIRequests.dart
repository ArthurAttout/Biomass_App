import 'dart:async';
import 'dart:io';
import 'dart:convert';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:path/path.dart' show join;
import 'package:random_string/random_string.dart' as random;

String uri_api = "http://192.168.1.85:5000";
int overlayWidth = 150;
int overlayHeight = 150;
double screenWidth = 0;
double screenHeight = 0;

Future<String> sendImageToAPI(String path, bool shouldCrop, Function uploadCallback) async {

  print("Sending original image");
  StorageReference firebaseStorageRef = FirebaseStorage.instance.ref().child(random.randomAlphaNumeric(10) + ".png");
  StorageUploadTask taskOriginal = firebaseStorageRef.putFile(new File(path));
  String url = await (await taskOriginal.onComplete).ref.getDownloadURL();
  uploadCallback(url);

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

Future<String> sendLocationToAPI(String oldUrl,Map<String, double> location) async {

  print("Sending image + geoloc");

  Map map = {
    'url': oldUrl,
    'latitude': location['lat'],
    'longitude': location['lng'],
    'crop': false
  };

  HttpClient httpClient = new HttpClient();
  HttpClientRequest request = await httpClient.postUrl(Uri.parse(uri_api + "/geolocation"));
  request.headers.set('content-type', 'application/json');
  request.add(utf8.encode(json.encode(map)));
  HttpClientResponse response = await request.close();

  String reply = await response.transform(utf8.decoder).join();
  httpClient.close();
  return reply;
}
