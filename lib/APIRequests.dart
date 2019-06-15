import 'dart:async';
import 'dart:io';
import 'dart:convert';
import 'dart:typed_data';

import 'package:multi_image_picker/multi_image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:path/path.dart' show join;
import 'package:random_string/random_string.dart' as random;
import 'package:intl/intl.dart';

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

Future<String> sendReportToAPI(List<Asset> assets, String comment) async {

  print("Sending all images");
  var listUrls = List<String>();

  for(var asset in assets){

    ByteData byteData = await asset.requestOriginal();
    List<int> imageData = byteData.buffer.asUint8List();

    StorageReference firebaseStorageRef = FirebaseStorage.instance.ref().child(random.randomAlphaNumeric(10) + ".png");
    StorageUploadTask taskOriginal = firebaseStorageRef.putData(imageData);
    String url = await (await taskOriginal.onComplete).ref.getDownloadURL();
    listUrls.add(url);
  }

  var formatter = new DateFormat('yyyy-MM-dd');


  Map map = {
    'submission_date':formatter.format(new DateTime.now()),
    'latitude':49,
    'longitude':-71,
    'comment':comment,
    'images': listUrls
  };

  HttpClient httpClient = new HttpClient();
  HttpClientRequest request = await httpClient.postUrl(Uri.parse(uri_api + "/new_report"));
  request.headers.set('content-type', 'application/json');
  request.add(utf8.encode(json.encode(map)));
  HttpClientResponse response = await request.close();

  String reply = await response.transform(utf8.decoder).join();
  httpClient.close();
  return reply;
}

Future<String> sendLocationToAPI(String oldUrl,Map<String, double> location,[String debugModelID]) async {

  print("Sending image + geoloc");
  Map map = null;

  if(debugModelID == null){
    map = {
      'url': oldUrl,
      'latitude': location['lat'],
      'longitude': location['lng'],
      'crop': false,
      'debug_model_target':debugModelID
    };
  }
  else
  {
    map = {
      'url': oldUrl,
      'latitude': 50,
      'longitude': -70,
      'crop': false,
      'debug_model_target':debugModelID
    };
  }

  HttpClient httpClient = new HttpClient();
  HttpClientRequest request = await httpClient.postUrl(Uri.parse(uri_api + "/geolocation"));
  request.headers.set('content-type', 'application/json');
  request.add(utf8.encode(json.encode(map)));
  HttpClientResponse response = await request.close();

  String reply = await response.transform(utf8.decoder).join();
  httpClient.close();

  print("Server said " + reply);
  return reply;
}
