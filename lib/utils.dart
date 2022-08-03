import  'dart:io';
import 'dart:typed_data';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';

class UtilsService{
  Future<String> uploadFile(File _image, String path) async {
    firebase_storage.Reference storageReference = firebase_storage.FirebaseStorage.instance.ref(path);

    firebase_storage.UploadTask uploadTask = storageReference.putFile(_image);

    await uploadTask.whenComplete(() => null);
    String returnURL = '';
    await storageReference.getDownloadURL().then((fileURL){
      returnURL = fileURL;
    });
    return returnURL;
  }

Future<String> uploadImage(Uint8List _image, String path) async {
    firebase_storage.Reference storageReference = firebase_storage.FirebaseStorage.instance.ref(path);
    String tempPath = (await getTemporaryDirectory()).path;
    File file = File('$tempPath/profile.png');
    await file.writeAsBytes(_image.buffer.asUint8List(_image.offsetInBytes, _image.lengthInBytes));


    firebase_storage.UploadTask uploadTask = storageReference.putFile(file);

    await uploadTask.whenComplete(() => null);
    String returnURL = '';
    await storageReference.getDownloadURL().then((fileURL){
      returnURL = fileURL;
    });
    return returnURL;
  }
}