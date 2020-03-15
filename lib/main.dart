
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_ml_vision/firebase_ml_vision.dart';

//has to add dependencies for firebase ml and import them
void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // Try running your application with "flutter run". You'll see the
        // application has a blue toolbar. Then, without quitting the app, try
        // changing the primarySwatch below to Colors.green and then invoke
        // "hot reload" (press "r" in the console where you ran "flutter run",
        // or simply save your changes to "hot reload" in a Flutter IDE).
        // Notice that the counter didn't reset back to zero; the application
        // is not restarted.
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);


  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {

File pickedImage;

bool isImageLoaded = false;

Future pickImage() async {
var tempStore = await ImagePicker.pickImage(source: ImageSource.gallery);

setState((){
  pickedImage = tempStore;
  isImageLoaded = true;
});

}

Future readText() async{
  FirebaseVisionImage ourImage = FirebaseVisionImage.fromFile(pickedImage);
  TextRecognizer recognizeText = FirebaseVision.instance.textRecognizer();
  VisionText readText = await recognizeText.processImage(ourImage);

  for(TextBlock block in readText.blocks)
 // for(TextLine line in block.lines)
  //for(TextElement word in line.elements)
  print(block.text);

}

  @override
  Widget build(BuildContext context) {
   
    return Scaffold(
   
      body: Column(
        children: <Widget>[
         Center(
           child: isImageLoaded? Container(
             height: 200.0,
             width: 200.0,
             decoration: BoxDecoration(
               image: DecorationImage(
                 image: FileImage(pickedImage), fit: BoxFit.cover
               ),
             ),
           ):Container( height: 200.0,
             width: 200.0,)), 
       SizedBox(height: 10.0),
        RaisedButton(
          child: Text('Pick an Image'),
          onPressed: pickImage,
        ),
        SizedBox(height: 10.0),
        RaisedButton(child: Text('Read Text'),
        onPressed: readText,
        )
      ],),
    );//Scaffold
  }
}
