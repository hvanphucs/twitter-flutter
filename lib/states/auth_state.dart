import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:twitter_flutter/helper/enum.dart';
import 'package:twitter_flutter/helper/utility.dart';
import 'package:twitter_flutter/states/app_state.dart';
import 'package:uuid/uuid.dart';
import '../models/user_model.dart';

class AuthState extends AppState {
  AuthStatus authStatus = AuthStatus.notDetermined;
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseStorage _fireStorage = FirebaseStorage.instance;

  final GoogleSignIn _googleSignIn = GoogleSignIn();

  String? userId;
  String? profileId;

  bool? isSignInWithGoogle;
  UserModel? _userModel;
  UserModel? _profileUserModel;

  UserModel? get userModel => _userModel;
  UserModel? get profileUserModel => _profileUserModel;

  Future<String?> signIn(
      {required String email,
      required String password,
      required BuildContext context}) async {
    String res = 'Some error ocurred when logging';
    try {
      // login
      UserCredential cred = await _firebaseAuth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      authStatus = AuthStatus.loggedIn;
      notifyListeners();
      res = 'success';

      userId = cred.user!.uid;
      _userModel = await getProfileUser(userId!);
    } catch (e) {
      res = e.toString();
      Utility.showCustomSnackBar(res, context);
      authStatus = AuthStatus.notLoggedIn;
    }

    return userId;
  }

  void logoutCallback() {
    authStatus = AuthStatus.notDetermined;
    userId = '';
    _userModel = null;
    if (isSignInWithGoogle == true) {
      _googleSignIn.signOut();
    } else {
      _firebaseAuth.signOut();
    }
    notifyListeners();
  }

  Future<String?> handleGoogleSignIn(BuildContext? context) async {
    String res = 'Some error ocurred when logging';
    try {
      final GoogleSignInAccount? googleSignInAccount =
          await _googleSignIn.signIn();

      if (googleSignInAccount != null) {
        final GoogleSignInAuthentication googleSignInAuthentication =
            await googleSignInAccount.authentication;

        final AuthCredential cred = GoogleAuthProvider.credential(
          accessToken: googleSignInAuthentication.accessToken,
          idToken: googleSignInAuthentication.idToken,
        );
        User? user = (await _firebaseAuth.signInWithCredential(cred)).user;

        authStatus = AuthStatus.loggedIn;
        notifyListeners();

        isSignInWithGoogle = true;
        createUserFromGoogleSignIn(user!);
        res = 'success';
        userId = user.uid;
      }
    } catch (e) {
      res = e.toString();
      Utility.showCustomSnackBar(res, context!);
      authStatus = AuthStatus.notLoggedIn;
    }

    return userId;
  }

  Future<String?> signUp(UserModel userModel,
      {String? password, BuildContext? context}) async {
    String res = 'Some error ocurred when registering';

    try {
      // login
      UserCredential cred = await _firebaseAuth.createUserWithEmailAndPassword(
        email: userModel.email!,
        password: password!,
      );

      userModel.key = cred.user!.uid;
      userModel.userId = cred.user!.uid;

      storeUserFirebase(userModel);

      authStatus = AuthStatus.loggedIn;
      notifyListeners();
      res = 'success';
      userId = userModel.userId;
    } catch (e) {
      res = e.toString();
      Utility.showCustomSnackBar(res, context!);
      authStatus = AuthStatus.notLoggedIn;
    }
    return userId;
  }

  void createUserFromGoogleSignIn(User user) {
    UserModel userModel = UserModel(
      email: user.email,
      displayName: user.displayName,
      contact: user.phoneNumber,
      photoUrl: user.photoURL,
      key: user.uid,
      userId: user.uid,
    );

    storeUserFirebase(userModel);
  }

  void storeUserFirebase(UserModel userModel) async {
    userModel.photoUrl = userModel.photoUrl ?? Utility.getDummyProfilePic();
    userModel.username = userModel.username ??
        Utility.getUserName(id: userModel.userId, name: userModel.displayName);

    userModel.bio = userModel.bio ?? 'Edit profile to update bio';
    userModel.location = userModel.location ?? 'Somewhere in universe';
    userModel.dob = userModel.dob ??
        DateTime(1950, DateTime.now().month, DateTime.now().day + 3).toString();

    await _firestore
        .collection('profiles')
        .doc(userModel.userId)
        .set(userModel.toJson());

    _userModel = userModel;
  }

  void openSignUpPage() {
    authStatus = AuthStatus.notLoggedIn;
    userId = null;
    notifyListeners();
  }

  Future<UserModel?> getProfileUser(String? userProfileId) async {
    userProfileId = userProfileId ?? userId;

    try {
      DocumentSnapshot<Map<String, dynamic>> snap =
          await _firestore.collection('profiles').doc(userProfileId).get();
      _profileUserModel = UserModel.fromJson((snap.data() as dynamic));

      if (userProfileId == userId) {
        _userModel = _profileUserModel;
      }
      return profileUserModel;
    } catch (_) {
      return null;
    }
  }

  Future<User?> getCurrentUser() async {
    try {
      User? user = _firebaseAuth.currentUser;
      if (user != null) {
        authStatus = AuthStatus.loggedIn;
      } else {
        authStatus = AuthStatus.notDetermined;
      }
      notifyListeners();
      return user;
    } catch (e) {
      authStatus = AuthStatus.notDetermined;
    }

    return null;
  }

  Future<void> forgetPassword(String email, BuildContext context) async {
    try {
      await _firebaseAuth.sendPasswordResetEmail(email: email).then((value) {
        Utility.showCustomSnackBar(
            'A reset password link is sent yo your mail.You can reset your password from there',
            context);
      }).catchError((e) {
        Utility.showCustomSnackBar(e.message, context);
        return;
      });
    } catch (e) {
      Utility.showCustomSnackBar(e.toString(), context);
      return;
    }
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
}
