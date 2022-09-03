import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';

import 'package:twitter_flutter/helper/utility.dart';
import 'package:twitter_flutter/models/user_model.dart';
import 'package:twitter_flutter/states/app_state.dart';
import 'package:twitter_flutter/states/auth_state.dart';
import 'package:uuid/uuid.dart';

class ProfileState extends AppState {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseStorage _fireStorage = FirebaseStorage.instance;

  String? get userId => _firebaseAuth.currentUser!.uid;
  String? _profileId;

  //String? get userId => _userId;
  String? get profileId => _profileId;

  bool get isMyProfile => _profileId == userId;

  UserModel? _profileUserModel;
  UserModel? get profileUserModel => _profileUserModel;

  UserModel? _userModel;
  UserModel? get userModel => _userModel;

  Future<UserModel?> getProfileUser(String? profileId) async {
    _profileId = profileId ?? userId;
    isBusy = true;

    try {
      DocumentSnapshot<Map<String, dynamic>> snap =
          await _firestore.collection('profiles').doc(_profileId).get();
      _profileUserModel = UserModel.fromJson((snap.data() as dynamic));
    } catch (_) {
      _profileUserModel = null;
      return null;
    }

    if (_profileId == userId) {
      _userModel = _profileUserModel;
    }
    notifyListeners();
    isBusy = false;
    return _profileUserModel;
  }

  void updateUserProfile(UserModel model, {File? image}) async {
    try {
      if (image == null) {
        storeUserFirebase(model);
      } else {
        String imageUid = const Uuid().v1();
        String? userUid = model.userId;
        Reference storageRef =
            _fireStorage.ref().child('user/$userUid/profile/$imageUid');
        UploadTask uploadTask = storageRef.putFile(image);
        await uploadTask
            .whenComplete(() => storageRef.getDownloadURL().then((fileUrl) {
                  model.photoUrl = fileUrl;
                  storeUserFirebase(model);

                  // update UserModel
                  _userModel?.photoUrl = fileUrl;
                  _profileUserModel?.photoUrl = fileUrl;
                }));
      }
    } catch (e) {
      Utility.cprint(e.toString());
    }
  }

  void storeUserFirebase(UserModel model) async {
    model.photoUrl = model.photoUrl ?? Utility.getDummyProfilePic();
    model.username = model.username ??
        Utility.getUserName(id: model.userId, name: model.displayName);

    model.bio = model.bio ?? 'Edit profile to update bio';
    model.location = model.location ?? 'Somewhere in universe';
    model.dob = model.dob ??
        DateTime(1950, DateTime.now().month, DateTime.now().day + 3).toString();
    model.createdAt = model.createdAt ?? DateTime.now().toString();

    await _firestore
        .collection('profiles')
        .doc(model.userId)
        .set(model.toJson());

    _userModel = model;
  }
}
