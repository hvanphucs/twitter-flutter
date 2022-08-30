import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:twitter_flutter/helper/constants.dart';

import '../../helper/theme.dart';
import '../../states/auth_state.dart';
import '../../widgets/custom_widget.dart';

class SilderBar extends StatefulWidget {
  final BuildContext? context;

  const SilderBar({Key? key, this.context}) : super(key: key);

  @override
  State<SilderBar> createState() => _SilderBarState();
}

class _SilderBarState extends State<SilderBar> {
  int? myId;

  @override
  void initState() {
    super.initState();
  }

  Widget _menuHeader() {
    final state = Provider.of<AuthState>(context);

    if (state.userModel == null) {
      return customInkWell(
        context: context,
        function2: () {},
        child: ConstrainedBox(
          constraints: const BoxConstraints(
            minHeight: 100,
            minWidth: 200,
          ),
          child: Center(
              child: Text(
            'Login to continue',
            style: onPrimaryTitleText,
          )),
        ),
      );
    } else {
      final photoUrl = state.userModel!.photoUrl ?? dummyProfilePicList[5];
      final displayName = state.userModel!.displayName ?? 'Display Name';
      final username = state.userModel!.username ?? 'username';
      final numFollowers = state.userModel!.followers!.length;
      final numFollowing = state.userModel!.following!.length;

      return Center(
          child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          ListTile(
            onTap: () {
              Navigator.of(context).pushNamed('/ProfilePage');
            },
            leading: Container(
              height: 56,
              width: 56,
              decoration: BoxDecoration(
                border: Border.all(color: Colors.white, width: 2),
                borderRadius: BorderRadius.circular(28),
                image: DecorationImage(
                  image: NetworkImage(photoUrl),
                  fit: BoxFit.cover,
                ),
              ),
            ),
            title: Text(
              displayName,
              style: onPrimaryTitleText.copyWith(color: Colors.black),
            ),
            subtitle: Text(
              username,
              style: onPrimarySubTitleText.copyWith(color: Colors.black54),
            ),
          ),
          //
          const SizedBox(
            height: 20,
          ),
          //
          Container(
              alignment: Alignment.center,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  const SizedBox(
                    width: 40,
                  ),
                  customText(
                    numFollowers.toString(),
                    style: const TextStyle(
                        fontWeight: FontWeight.bold, fontSize: 17),
                  ),
                  customText(
                    'Followers',
                    style: const TextStyle(color: Colors.black54, fontSize: 17),
                  ),
                  customText(
                    numFollowing.toString(),
                    style: const TextStyle(
                        fontWeight: FontWeight.bold, fontSize: 17),
                  ),
                  customText(
                    'Following',
                    style: const TextStyle(color: Colors.black54, fontSize: 17),
                  ),
                  const SizedBox(
                    width: 10,
                  ),
                ],
              ))
        ],
      ));
    }
  }

  ListTile _menuListRowButton(String title,
      {Function? onPressed, IconData? icon}) {
    return ListTile(
      onTap: () {
        if (onPressed != null) {
          onPressed();
        }
      },
      leading: Padding(
        padding: const EdgeInsets.only(top: 5),
        child: Icon(icon),
      ),
      title: customText(title),
    );
  }

  void _logOut() {
    final state = Provider.of<AuthState>(context, listen: false);
    state.logoutCallback();
    Navigator.of(context).pushNamedAndRemoveUntil('/SignIn/', (route) => false);
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: SafeArea(
          child: Column(
        children: [
          SizedBox(
            height: 150,
            child: _menuHeader(),
          ),
          const Divider(),
          _menuListRowButton('Profile', icon: Icons.verified_user,
              onPressed: () {
            var userId = Provider.of<AuthState>(context, listen: false).userId;
            Navigator.of(context).pushNamed('/ProfilePage/$userId');
          }),
          _menuListRowButton('Lists', icon: Icons.list),
          _menuListRowButton('Settings', icon: Icons.settings),
          _menuListRowButton('Help Center', icon: Icons.help),
          const Divider(),
          _menuListRowButton(
            'Logout',
            onPressed: _logOut,
            icon: Icons.block,
          )
        ],
      )),
    );
  }
}
