import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';

class DisplayPictureScreen extends StatefulWidget {
  final File imagePath;
  final Function onClose;
  const DisplayPictureScreen({required this.onClose, required this.imagePath});

  @override
  _DisplayPictureScreenState createState() => _DisplayPictureScreenState(onClose);
}

class _DisplayPictureScreenState extends State<DisplayPictureScreen> {
  var  finalImage ;
  Function onClose;
  _DisplayPictureScreenState(this.onClose);
  @override
  void initState() {
    super.initState();

    croppingImage();
  }

  Future<Null> croppingImage() async {
    File croppedFile = (await ImageCropper().cropImage(
        sourcePath: widget.imagePath.path,
        aspectRatioPresets: Platform.isAndroid
            ? [
          CropAspectRatioPreset.square
        ]
            : [
          CropAspectRatioPreset.original
        ],
        )) as File;
    if(croppedFile!=null){
      setState(() {
        finalImage = croppedFile;
        onClose();
        Navigator.pop(context);
      });
    }else{
      setState(() {
        finalImage = File(widget.imagePath.path);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: Text('Display the Picture')),
        // The image is stored as a file on the device. Use the `Image.file`
        // constructor with the given path to display the image.
        body: Center(
            child:
            finalImage !=null ?
            Container(
              height: MediaQuery.of(context).size.height/2, //400
              //  width: MediaQuery.of(context).size.width/1.2,//400
              decoration: BoxDecoration(
                  border: Border.all(color: Colors.red),
                  image: DecorationImage(
                      image: FileImage(finalImage),
                      fit: BoxFit.cover
                  )
              ),
            )
                :Container()
        )
    );
  }
}
