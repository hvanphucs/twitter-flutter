import 'dart:convert';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:twitter_flutter/helper/enum.dart';
import 'package:twitter_flutter/helper/utility.dart';
import 'package:twitter_flutter/states/app_state.dart';
import 'package:twitter_flutter/states/profile_state.dart';
import '../models/user_model.dart';
import 'package:http/http.dart' as http;

class AuthState extends AppState {
  AuthStatus authStatus = AuthStatus.notDetermined;
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  final GoogleSignIn _googleSignIn = GoogleSignIn();

  String? userId;
  bool? isSignInWithGoogle;

  UserModel? _userModel;
  UserModel? get userModel => _userModel;

  set setUserModel(UserModel? model) {
    _userModel = model;
  }

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
      userId = cred.user!.uid;
      _userModel = await ProfileState().getProfileUser(userId!);

      res = 'success';
      notifyListeners();
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
      //Utility.showCustomSnackBar(res, context!);
      authStatus = AuthStatus.notLoggedIn;
    }

    return res;
  }

  Future<String?> signUp(UserModel userModel,
      {String? password, BuildContext? context}) async {
    String res = 'Some error ocurred when registering';

    try {
      UserCredential cred = await _firebaseAuth.createUserWithEmailAndPassword(
        email: userModel.email!,
        password: password!,
      );

      userModel.userId = cred.user!.uid;

      ProfileState().storeUserFirebase(userModel);

      authStatus = AuthStatus.loggedIn;
      notifyListeners();
      res = 'success';
      userId = userModel.userId;
    } catch (e) {
      res = e.toString();
      //Utility.showCustomSnackBar(res, context!);
      authStatus = AuthStatus.notLoggedIn;
    }
    return res;
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

    ProfileState().storeUserFirebase(userModel);
  }

  void openSignUpPage() {
    authStatus = AuthStatus.notLoggedIn;
    userId = null;
    notifyListeners();
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
            'A reset password link was sent to your mail.You can reset your password from there',
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

  // mock
  void createMockUser() async {
    final response =
        await http.get(Uri.parse('https://jsonplaceholder.typicode.com/users'));
    if (response.statusCode != 200) {
      throw Exception('Failed to fetch data');
    }

    final jsonData = jsonDecode(response.body);
    int count = 0;
    for (var data in jsonData) {
      ++count;
      UserModel mockUser = UserModel(
        email: 'hvanphucs$count@gmail.com',
        displayName: data['name'],
        username: data['username'],
        webSite: data['website'],
        contact: data['phone'],
        bio: data['company']['bs'],
        location: data['address']['Douglas Extension'],
        dob: DateTime(1950, DateTime.now().month, DateTime.now().day + 3)
            .toString(),
      );

      String? res = await signUp(mockUser, password: '123456789');
      Utility.cprint('res: $res');
    }
  }
}
