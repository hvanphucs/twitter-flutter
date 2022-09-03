import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:twitter_flutter/helper/enum.dart';
import 'package:twitter_flutter/helper/utility.dart';
import 'package:twitter_flutter/models/user_model.dart';
import 'package:twitter_flutter/states/auth_state.dart';
import 'package:twitter_flutter/widgets/custom_widget.dart';

class SignUpPage extends StatefulWidget {
  final VoidCallback? loginCallback;

  const SignUpPage({Key? key, this.loginCallback}) : super(key: key);

  @override
  State<SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  late final TextEditingController _emailController;
  late final TextEditingController _passwordController;
  late final TextEditingController _confirmController;
  late final TextEditingController _nameController;
  late final TextEditingController _mobileController;

  @override
  void initState() {
    _emailController = TextEditingController();
    _passwordController = TextEditingController();
    _confirmController = TextEditingController();
    _nameController = TextEditingController();
    _mobileController = TextEditingController();

    _emailController.text = 'hvanphucs@gmail.com';
    _passwordController.text = '123456789';
    _confirmController.text = '123456789';
    _nameController.text = 'H Van Phuc';
    _mobileController.text = '097865432';
    super.initState();
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _confirmController.dispose();
    _nameController.dispose();
    _mobileController.dispose();
    super.dispose();
  }

  Widget _body(BuildContext context) {
    return SingleChildScrollView(
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 30),
        height: MediaQuery.of(context).size.height - 88,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            _entryField('Name', controller: _nameController),
            _entryField('Enter Email', controller: _emailController),
            _entryField('Mobile no', controller: _mobileController),
            _entryField('Enter password',
                controller: _passwordController, isPassword: true),
            _entryField('Confirm password',
                controller: _confirmController, isPassword: true),
            _submitButton(context),
            _labelButton('Sign In', onPressed: () {
              var state = Provider.of<AuthState>(context, listen: false);
              state.logoutCallback();
              Navigator.of(context).pushNamed('/SignIn/');
            }),
            _labelButton('Mock 10 Users', onPressed: () {
              var state = Provider.of<AuthState>(context, listen: false);
              state.createMockUser();
            }),
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
          backgroundColor: Colors.blueAccent,
        ),
        onPressed: _submitForm,
        child: const Text(
          'Sign Up',
          style: TextStyle(
            color: Colors.white,
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

  void _submitForm() {
    if (_emailController.text.isEmpty ||
        _passwordController.text.isEmpty ||
        _confirmController.text.isEmpty ||
        _nameController.text.isEmpty) {
      Utility.showCustomSnackBar('Please fill form carefully', context);
      return;
    }

    if (_passwordController.text != _confirmController.text) {
      Utility.showCustomSnackBar(
          'Password and confirm password did not match', context);
      return;
    }

    UserModel userModel = UserModel(
      email: _emailController.text,
      displayName: _nameController.text,
      contact: _mobileController.text,
    );

    var state = Provider.of<AuthState>(context, listen: false);
    state
        .signUp(
          userModel,
          password: _passwordController.text,
          context: context,
        )
        .then((status) => {})
        .whenComplete(
      () {
        if (state.authStatus == AuthStatus.loggedIn) {
          //Navigator.pop(context);
          // Navigator.of(context)
          //     .pushNamedAndRemoveUntil('/SignIn/', (route) => false);
          //widget.loginCallback!();
        }
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: customTitleText(
          'Sign Up',
          context: context,
          style: const TextStyle(fontSize: 20),
        ),
        centerTitle: true,
      ),
      body: _body(context),
    );
  }
}
