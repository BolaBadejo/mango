import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mango/Screens/Episodes/episodes_widget.dart';

import '../../utils.dart';

class EpisodeHelper {
  final picker = ImagePicker();
  late File episodeMeta;

  File get getEpisodeMeta => episodeMeta;
  final UtilsService _utilsService = UtilsService();

  final EpisodeWidgets episodeWidgets = EpisodeWidgets();

  Future selectEpisodeMeta(BuildContext context, ImageSource fileSource) async {
    final pickedEpisodeImage = await picker.pickImage(source: fileSource);
    pickedEpisodeImage == null ? print("Error Message") : episodeMeta =
        File(pickedEpisodeImage.path);
    episodeMeta != null ? episodeWidgets.previewEpisodeMeta(
        context, episodeMeta) : print("Error Message");
  }

  Future saveEpisodeImage(context) async {
    var imageFile = await _utilsService.uploadFile(getEpisodeMeta,
        "episodes/image/${FirebaseAuth.instance.currentUser!.uid}/${Timestamp
            .now()}/image");
    await FirebaseFirestore.instance.collection("playlists").add({
      'image': imageFile,
      'postCreator': FirebaseAuth.instance.currentUser!.uid,
      'timeStamp': Timestamp.now(),
    });
  }
}