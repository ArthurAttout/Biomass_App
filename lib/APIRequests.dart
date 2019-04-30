import 'dart:async';
import 'dart:io';
import 'dart:convert';

import 'package:image/image.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:path/path.dart' show join;
import 'package:path_provider/path_provider.dart';

String uri_api = "http://192.168.1.85:5000";
int overlayWidth = 150;
int overlayHeight = 150;
double screenWidth = 0;
double screenHeight = 0;


Future<String> sendImageToAPI(String path) async {

  int x = ((screenWidth/2)+(overlayWidth/2)).toInt();
  int y = ((screenHeight/2)+(overlayHeight/2)).toInt();
  int w = overlayWidth;
  int h = overlayHeight;

  var image = decodeImage(new File(path).readAsBytesSync());
  var imageCropped = copyCrop(image, x, y, w, h);

  final pathTemp = join(
    (await getTemporaryDirectory()).path, '${DateTime.now()}-crop.png',
  );

  new File(pathTemp).writeAsBytesSync(imageCropped.getBytes());

  final StorageReference firebaseStorageRef = FirebaseStorage.instance.ref().child('myimage.jpg');
  final StorageUploadTask task = firebaseStorageRef.putFile(new File(path));
  String url = await (await task.onComplete).ref.getDownloadURL();
  print(url);
  return "OK";

  /*Map map = {
    'url': url,
  };

  HttpClient httpClient = new HttpClient();
  HttpClientRequest request = await httpClient.postUrl(Uri.parse(uri_api + "/identify"));
  request.headers.set('content-type', 'application/json');
  request.add(utf8.encode(json.encode(map)));
  HttpClientResponse response = await request.close();

  String reply = await response.transform(utf8.decoder).join();
  httpClient.close();
  return reply;*/
}
