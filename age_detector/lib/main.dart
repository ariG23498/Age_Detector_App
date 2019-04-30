import 'dart:convert';

import 'package:image_picker/image_picker.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:io';

import 'package:path/path.dart';
import 'package:async/async.dart';

String txt = "";
String txt1 = "No Image :(";
void main() {
  runApp(new MaterialApp(
    debugShowCheckedModeBanner: false,
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

  // The fuction which will upload the image as a file
  void upload(File imageFile) async {
    var stream =
        new http.ByteStream(DelegatingStream.typed(imageFile.openRead()));
    var length = await imageFile.length();

    String base =
        "https://www.floydlabs.com/serve/spsayak/projects/age-detector";

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
      int l = value.length;
      txt = value.substring(8, (l - 3));
      setState(() {});
    });
  }

  void lol() async {
    txt1 = "";
    setState(() {
      
    });
    debugPrint("Lol Activated");
    img = await ImagePicker.pickImage(source: ImageSource.camera);
    
    txt = "Analysing...";
    debugPrint(img.toString());
    upload(img);
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: new AppBar(
        centerTitle: true,
        title: new Text("AgeDetector"),
      ),
      body: new Container(
        child: Center(
          child: Column(
            children: <Widget>[
              img == null
                  ? new Text(
                      txt1,
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 32.0,
                      ),
                    )
                  : new Image.file(img,
                      height: MediaQuery.of(context).size.height * 0.6,
                      width: MediaQuery.of(context).size.width * 0.8),
              new Text(
                txt,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 32.0,
                ),
              )
            ],
          ),
        ),
      ),
      floatingActionButton: new FloatingActionButton(
        onPressed: lol,
        child: new Icon(Icons.camera_alt),
      ),
    );
  }
}
