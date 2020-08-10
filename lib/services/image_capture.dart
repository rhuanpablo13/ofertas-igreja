import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';


class ImageCapture extends StatefulWidget {
  @override
  _ImageCaptureState createState() => _ImageCaptureState();
}

class _ImageCaptureState extends State<ImageCapture> {
   File _image;
   final picker = ImagePicker();

   Future getImage() async {
      final pickedFile = await picker.getImage(source: ImageSource.camera);

      setState(() {
         _image = File(pickedFile.path);
      });
   }

   @override
   Widget build(BuildContext context) {
      return Scaffold(
         appBar: AppBar(
            title: Text('Image Picker Example'),
         ),
         body: Center(
            child: _image == null
               ? Text('No image selected.')
               : Image.file(_image),
         ),
         floatingActionButton: FloatingActionButton(
            onPressed: getImage,
            tooltip: 'Pick Image',
            child: Icon(Icons.add_a_photo),
         ),
      );
   }
}
