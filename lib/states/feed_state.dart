import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:twitter_flutter/helper/utility.dart';
import 'package:twitter_flutter/models/feed_model.dart';
import 'package:twitter_flutter/states/app_state.dart';
import 'package:uuid/uuid.dart';

class FeedState extends AppState {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseStorage _fireStorage = FirebaseStorage.instance;

  //bool isBusy = false;

  List<FeedModel>? _feedList;
  List<FeedModel>? get feedList => _feedList;

  Future<String?> createFeed(FeedModel model, File? image,
      {BuildContext? context}) async {
    String feedId = const Uuid().v1();
    String imageId = const Uuid().v1();
    model.key = feedId;
    try {
      if (image != null) {
        Reference storageRef =
            _fireStorage.ref().child('user/$feedId/pics/$imageId');
        UploadTask uploadTask = storageRef.putFile(image);
        await uploadTask.whenComplete(() => storageRef.getDownloadURL().then(
              (fileUrl) {
                model.imagePath = fileUrl;
              },
            ));
      }

      await _firestore.collection('feeds').doc(feedId).set(model.toJson());
      notifyListeners();
      return feedId;
    } catch (e) {
      Utility.cprint(e.toString());
    }
    return null;
  }

  void getDataFromDatabase() {
    isBusy = true;
    try {
      _firestore.collection('feeds').get().then(
        (querySnapshot) {
          for (var map in querySnapshot.docs) {
            FeedModel model = FeedModel.setFeedModel(map.data() as dynamic);
            if (_feedList == null) {
              _feedList = [model];
            } else {
              _feedList!.add(model);
            }
          }
          notifyListeners();
        },
      );
    } catch (e) {
      Utility.cprint(e);
    }
    print(_feedList);
    isBusy = false;
  }
}
