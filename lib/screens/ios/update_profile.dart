import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'dart:io';
import 'dart:convert' as convert;
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'package:NSCE/services/request.dart';
class UpdateProfile extends StatefulWidget {
  UpdateProfile() : super();
  @override
  UpdateProfileState createState() => UpdateProfileState();
}

class UpdateProfileState extends State<UpdateProfile> {
  //
  static final String uploadEndPoint =
      'http://localhost/flutter_test/upload_image.php';
  Future<File> file;
  String status = '';
  String base64Image;
  File tmpFile;
  String errMessage = 'Error Uploading Image';

  chooseImage() {
    setState(() {
      file = ImagePicker.pickImage(source: ImageSource.gallery);
    });
    setStatus('');
  }

  setStatus(String message) {
    setState(() {
      status = message;
    });
  }

  startUpload() {
    setStatus('Uploading Image...');
    if (null == tmpFile) {
      setStatus(errMessage);
      return;
    }
    updateAccountProfilePicture(tmpFile).then((res){
      if(res is Map){
        setStatus('Upload Sucessful');
        imageCache.clear();
        f(){
          Navigator.of(context).pop(true);
        }
        Future.delayed(Duration(seconds: 1),f);
      }
//      print(res);
    });
  }
  cancelUpload(){
    Navigator.of(context).pop(false);
  }

  Widget showImage() {
    return FutureBuilder<File>(
      future: file,
      builder: (BuildContext context, AsyncSnapshot<File> snapshot) {
        if (snapshot.connectionState == ConnectionState.done &&
            null != snapshot.data) {
          tmpFile = snapshot.data;
          base64Image = convert.base64Encode(snapshot.data.readAsBytesSync());
          return Flexible(
            child: Image.file(
              snapshot.data,
              fit: BoxFit.fill,
            ),
          );
        } else if (null != snapshot.error) {
          return const Text(
            'Error Picking Image',
            textAlign: TextAlign.center,
          );
        } else {
          return Flexible(
            child: Image.asset(
             'images/placeholder.png',
              fit: BoxFit.fill,
            ),
          );
        }
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return  Container(
      padding: EdgeInsets.all(30.0),
      color: Colors.white,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          OutlineButton(
            onPressed: chooseImage,
            child: Text('Choose Image'),
          ),
          SizedBox(
            height: 20.0,
          ),
          showImage(),
          SizedBox(
            height: 20.0,
          ),
          LinearProgressIndicator(value: 10,),
          ButtonBar(
            alignment:MainAxisAlignment.center,
            children: <Widget>[
             OutlineButton(
                  onPressed: startUpload,
                  child: Text('Upload Image'),
                ) ,
              OutlineButton(
                  onPressed: cancelUpload,
                  child: Text('Cancel'),
                ),
            ],
          ),
          SizedBox(
            height: 20.0,
          ),
          Text(
            status,
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Colors.green,
              fontWeight: FontWeight.w500,
              fontSize: 20.0,
            ),
          ),
          SizedBox(
            height: 20.0,
          ),
        ],
      ),
    );
  }
}