import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:twitter_flutter/helper/enum.dart';
import 'package:twitter_flutter/pages/Auth/forget_password_page.dart';
import 'package:twitter_flutter/pages/home_page.dart';
import 'package:twitter_flutter/states/auth_state.dart';

import '../../widgets/custom_widget.dart';

class SignInPage extends StatefulWidget {
  final VoidCallback? loginCallback;
  const SignInPage({Key? key, this.loginCallback}) : super(key: key);

  @override
  State<SignInPage> createState() => _SignInPageState();
}

class _SignInPageState extends State<SignInPage> {
  late final TextEditingController _emailControler;
  late final TextEditingController _passwordControler;
  //final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  @override
  void initState() {
    _emailControler = TextEditingController();
    _passwordControler = TextEditingController();
    _emailControler.text = 'hvanphucs@gmail.com';
    _passwordControler.text = '123456789';
    super.initState();
  }

  Widget _body(BuildContext context) {
    return SingleChildScrollView(
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 30),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            const SizedBox(
              height: 150,
            ),
            _entryField('Enter Email', controller: _emailControler),
            _entryField('Enter Password',
                controller: _passwordControler, isPassword: true),
            //_submitButton(context),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                _emailLoginButton(context),
                _googleLoginButton(context)
              ],
            ),
            _labelButton('Forget password', onPressed: () {
              Navigator.of(context).pushNamed('/ForgetPasswordPage/');
            }),
            const SizedBox(
              height: 100,
            ),
            _labelButton('Create new account', onPressed: _createAccount),
          ],
        ),
      ),
    );
  }

  Widget _entryField(String hintText,
      {TextEditingController? controller, bool isPassword = false}) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 15),
      decoration: BoxDecoration(
        color: Colors.grey.shade200,
        borderRadius: BorderRadius.circular(30),
      ),
      child: TextField(
        controller: controller,
        keyboardType: TextInputType.emailAddress,
        style: const TextStyle(
          fontStyle: FontStyle.normal,
          fontWeight: FontWeight.normal,
        ),
        obscureText: isPassword,
        decoration: InputDecoration(
          hintText: hintText,
          border: InputBorder.none,
          focusedBorder: const OutlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(30)),
            borderSide: BorderSide(color: Colors.blue),
          ),
          contentPadding:
              const EdgeInsets.symmetric(vertical: 15, horizontal: 10),
        ),
      ),
    );
  }

  Widget _submitButton(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 15),
      width: MediaQuery.of(context).size.width,
      child: TextButton(
        style: TextButton.styleFrom(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(30),
          ),
        ),
        onPressed: () {},
        child: const Text(
          'Sign in',
          style: TextStyle(
            color: Colors.red,
          ),
        ),
      ),
    );
  }

  Widget _labelButton(String title, {Function? onPressed}) {
    return TextButton(
      onPressed: () {
        if (onPressed != null) {
          onPressed();
        }
      },
      child: Text(
        title,
        style: const TextStyle(
          color: Colors.black54,
        ),
      ),
    );
  }

  Widget _emailLoginButton(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 15),
      //width: MediaQuery.of(context).size.width,
      child: TextButton(
        style: TextButton.styleFrom(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(30),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 10),
          backgroundColor: Colors.blueAccent,
        ),
        onPressed: () {
          //loader(context);

          var state = Provider.of<AuthState>(context, listen: false);
          state
              .signIn(
                  email: _emailControler.text,
                  password: _passwordControler.text,
                  context: context)
              .then((value) => null)
              .whenComplete(() => {
                    if (state.authStatus == AuthStatus.loggedIn)
                      Navigator.of(context).pushNamedAndRemoveUntil(
                          '/HomePage/', (route) => false)
                  });
        },
        child: const Text(
          'Email Login',
          style: TextStyle(
            color: Colors.white,
          ),
        ),
      ),
    );
  }

  Widget _googleLoginButton(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 35),
      //width: MediaQuery.of(context).size.width,
      child: TextButton(
        style: TextButton.styleFrom(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(30),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 10),
          backgroundColor: Colors.blueAccent,
        ),
        onPressed: () {
          var state = Provider.of<AuthState>(context, listen: false);
          state
              .handleGoogleSignIn(context)
              .then((value) => {})
              .whenComplete(() => {});
        },
        child: const Text(
          'Google Login',
          style: TextStyle(
            color: Colors.white,
          ),
        ),
      ),
    );
  }

  void _createAccount() {
    var state = Provider.of<AuthState>(context, listen: false);
    state.openSignUpPage();
    Navigator.of(context).pushNamedAndRemoveUntil('/SignUp/', (route) => false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: customTileText(
          'Sign In',
          context: context,
          style: const TextStyle(fontSize: 20),
        ),
        centerTitle: true,
      ),
      body: _body(context),
    );
  }
}
