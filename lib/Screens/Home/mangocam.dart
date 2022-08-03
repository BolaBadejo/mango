import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class MangoCam extends StatefulWidget {
  const MangoCam({Key? key}) : super(key: key);

  @override
  _MangoCamState createState() => _MangoCamState();
}

class _MangoCamState extends State<MangoCam> {
  late File _image;
  final imagePicker = ImagePicker();
  PickedFile? pickedImage;
  bool _load = false;

  // PickedFile? pickedImage;
  // File? imageFile;
  // bool _load = false;

  Future getImage() async {
    final image = await ImagePicker.platform.pickImage(source: ImageSource.gallery);
    setState(() {
       _image = File(image!.path);
       _load = false;
    });
  }
  // Future chooseImage() async {
  //   final pickedFile = await imagePicker.pickImage(source: ImageSource.gallery);
  //   setState(() {
  //     imageFile = File(pickedFile!.path);
  //     _load = false;
  //   });
  // }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Image.file(_image),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: getImage,
        backgroundColor: Colors.orange,
        child: const Icon(Icons.camera),

      ),
    );
  }
}
