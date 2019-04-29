import 'dart:convert';

import 'package:image_picker/image_picker.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:io';

import 'package:path/path.dart';
import 'package:async/async.dart';

String txt = "";

void main() {
  runApp(new MaterialApp(
    title: "Age_Detector",
    home: new MyApp(),
  ));
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  File img;
  Upload(File imageFile) async {
    var stream =
        new http.ByteStream(DelegatingStream.typed(imageFile.openRead()));
    var length = await imageFile.length();

    String base = "https://www.floydlabs.com/serve/q2mAd7RMCjVgmt5T8nED7e";

    var uri = Uri.parse(base + '/image');

    var request = new http.MultipartRequest("POST", uri);
    var multipartFile = new http.MultipartFile('file', stream, length,
        filename: basename(imageFile.path));
    //contentType: new MediaType('image', 'png'));

    request.files.add(multipartFile);
    var response = await request.send();
    print(response.statusCode);
    response.stream.transform(utf8.decoder).listen((value) {
      print(value);
      txt = value;
      setState(() {
        
      });
    });
  }

  void lol() async {
    debugPrint("Lol Activated");
    img = await ImagePicker.pickImage(source: ImageSource.camera);
    debugPrint(img.toString());
    Upload(img);
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: new AppBar(
        title: new Text("AgeDetector"),
      ),
      body: new Container(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            img == null ? new Text("No Image To Show") : new Image.file(img),
            new Text(txt)
          ],
        ),
      ),
      floatingActionButton: new FloatingActionButton(
        onPressed: lol,
        child: new Icon(Icons.camera),
      ),
    );
  }
}

Future<void> sendImg(File img) async {
  print(img);
  var bytes = img.readAsBytesSync();
  String base = "https://www.floydlabs.com/serve/q2mAd7RMCjVgmt5T8nED7e";
  var s = await http.post(Uri.parse(base + "/image"),
      headers: {"Content-Type": "multipart/form-data"},
      body: {"file": bytes},
      encoding: Encoding.getByName("utf-8"));
  print(s.body);
}
