import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:twitter_flutter/helper/enum.dart';
import 'package:twitter_flutter/pages/Auth/signin_page.dart';
import 'package:twitter_flutter/pages/Auth/signup_page.dart';
import 'package:twitter_flutter/states/auth_state.dart';

import '../home_page.dart';

class SelectAuthMethods extends StatefulWidget {
  const SelectAuthMethods({Key? key}) : super(key: key);

  @override
  State<SelectAuthMethods> createState() => _SelectAuthMethodsState();
}

class _SelectAuthMethodsState extends State<SelectAuthMethods> {
  @override
  void initState() {
    var state = Provider.of<AuthState>(context, listen: false);
    state.authStatus = AuthStatus.notDetermined;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var state = Provider.of<AuthState>(context);

    return Scaffold(
      body: state.authStatus == AuthStatus.notDetermined
          ? SignInPage(
              loginCallback: state.getCurrentUser,
            )
          : state.authStatus == AuthStatus.notLoggedIn
              ? SignUpPage(
                  loginCallback: state.getCurrentUser,
                )
              : const HomePage(),
    );
  }
}
