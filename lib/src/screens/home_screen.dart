import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:tflite/tflite.dart';
import 'dart:io';

class HomeScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return HomeScreenState();
  }
}

class HomeScreenState extends State<HomeScreen> {
  bool _loading = true;
  late File _image;
  late List _output;
  final picker = ImagePicker();

  @override
  void initState() {
    super.initState();
    loadModel().then((value) {
      setState(() {});
    });
  }

  detectImage(File _image) async {
    var output = await Tflite.runModelOnImage(
      path: _image.path,
      numResults: 2,
      threshold: 0.6,
      imageMean: 127.5,
      imageStd: 127.5,
    );

    setState(() {
      _output = output!;
      _loading = false;
    });
  }

  loadModel() async {
    await Tflite.loadModel(
        model: 'assets/model_unquant.tflite', labels: 'assets/labels.txt');
  }

  @override
  void dispose() {
    super.dispose();
  }

  captureImage() async {
    var image = await picker.pickImage(source: ImageSource.camera);
    if (image == null) return null;
    setState(() {
      _image = File(image.path);
    });

    detectImage(_image);
  }

  galleryImage() async {
    var image = await picker.pickImage(source: ImageSource.gallery);
    if (image == null) return null;
    setState(() {
      _image = File(image.path);
    });

    detectImage(_image);
  }

  Widget build(context) {
    return Scaffold(
        backgroundColor: Colors.brown,
        body: Container(
          alignment: Alignment.center,
          //decoration: BoxDecoration(border: Border.all(color: Colors.blue)),
          margin: EdgeInsets.all(25),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              SizedBox(height: 20),
              Text(
                'Animal Identifier',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 40,
                ),
              ),
              SizedBox(height: 20),

              //Selected image preview section
              Center(
                  child: _loading
                      ?
                      //If loading is true
                      Container(
                          width: 250,
                          child: Column(
                            children: <Widget>[
                              Image.asset('assets/logo.png'),
                              SizedBox(height: 20),
                            ],
                          ),
                        )

                      //If loading is false
                      : Container(
                          child: Column(
                            children: <Widget>[
                              Container(
                                height: 250,
                                child: Image.file(_image),
                              ),
                              SizedBox(height: 20),
                              _output != null
                                  ? Text('${_output[0]['label']}',
                                      style: TextStyle(
                                          color: Colors.white, fontSize: 20))
                                  : Container(),
                            ],
                          ),
                        )),

              //Image selecting container
              Container(
                width: MediaQuery.of(context).size.width,
                child: Column(
                  children: <Widget>[
                    //Use camera to capture picture
                    GestureDetector(
                      onTap: () {
                        captureImage();
                      },
                      child: Container(
                        width: MediaQuery.of(context).size.width - 250,
                        alignment: Alignment.center,
                        padding:
                            EdgeInsets.symmetric(horizontal: 25, vertical: 18),
                        decoration: BoxDecoration(
                            color: Colors.yellow,
                            borderRadius: BorderRadius.circular(5)),
                        child: Text('Capture a picture'),
                      ),
                    ),
                    SizedBox(height: 10),

                    //Select a picture from galary
                    GestureDetector(
                      onTap: () {
                        galleryImage();
                      },
                      child: Container(
                        width: MediaQuery.of(context).size.width - 250,
                        alignment: Alignment.center,
                        padding:
                            EdgeInsets.symmetric(horizontal: 25, vertical: 18),
                        decoration: BoxDecoration(
                            color: Colors.yellow,
                            borderRadius: BorderRadius.circular(5)),
                        child: Text('Select a picture'),
                      ),
                    )
                  ],
                ),
              ),
            ],
          ),
        ));
  }
}
