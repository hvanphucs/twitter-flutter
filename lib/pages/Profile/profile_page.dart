import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:twitter_flutter/helper/constants.dart';
import 'package:twitter_flutter/pages/Feed/feed_page.dart';
import 'package:twitter_flutter/pages/Profile/edit_profile_page.dart';
import 'package:twitter_flutter/states/auth_state.dart';
import 'package:twitter_flutter/widgets/custom_widget.dart';

import '../../states/app_state.dart';

class ProfilePage extends StatefulWidget {
  final String? profileId;
  const ProfilePage({Key? key, this.profileId}) : super(key: key);

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  bool isMyProfile = false;
  late final PageController _pageController;
  int pageIndex = 0;

  @override
  void initState() {
    _pageController = PageController();

    var authState = Provider.of<AuthState>(context, listen: false);
    authState.getProfileUser(widget.profileId);
    isMyProfile =
        widget.profileId == null || widget.profileId == authState.userId;
    super.initState();
  }

  Widget _body(BuildContext context) {
    var appState = Provider.of<AppState>(context, listen: false);
    return PageView(
      controller: _pageController,
      physics: const PageScrollPhysics(),
      dragStartBehavior: DragStartBehavior.start,
      onPageChanged: (index) {
        pageIndex = index;
        appState.setPageIndex = index;
      },
      children: const [
        FeedPage(),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    var authState = Provider.of<AuthState>(context, listen: false);
    return Scaffold(
      body: authState.profileUserModel == null
          ? loader()
          : CustomScrollView(
              slivers: [
                SliverAppBar(
                  expandedHeight: 180,
                  elevation: 0,
                  iconTheme: const IconThemeData(color: Colors.white),
                  backgroundColor: Colors.transparent,
                  actions: [
                    PopupMenuButton(itemBuilder: (context) {
                      return choices.map((Choice choice) {
                        return PopupMenuItem<Choice>(
                          value: choice,
                          child: Text(choice.title),
                        );
                      }).toList();
                    }),
                  ],
                  flexibleSpace: FlexibleSpaceBar(
                    background: Stack(
                      children: <Widget>[
                        Container(height: 30, color: Colors.black),
                        //
                        Padding(
                          padding: const EdgeInsets.only(top: 30),
                          child: customNetworkImage(
                              'https://pbs.twimg.com/profile_banners/457684585/1510495215/1500x500',
                              fit: BoxFit.fill),
                        ),
                        //
                        Container(
                          alignment: Alignment.bottomLeft,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: <Widget>[
                              //
                              Container(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 10),
                                decoration: BoxDecoration(
                                    border: Border.all(
                                        color: Colors.white, width: 5),
                                    shape: BoxShape.circle),
                                child: customImage(
                                  context,
                                  authState.profileUserModel!.photoUrl!,
                                  height: 80,
                                ),
                              ),
                              //
                              Container(
                                margin:
                                    const EdgeInsets.only(top: 60, right: 30),
                                child: Row(
                                  children: <Widget>[
                                    isMyProfile
                                        ? Container(
                                            height: 40,
                                          )
                                        : InkWell(
                                            borderRadius:
                                                const BorderRadius.all(
                                                    Radius.circular(20)),
                                            onTap: () {},
                                            child: Container(
                                              padding: const EdgeInsets.all(8),
                                              decoration: BoxDecoration(
                                                  border: Border.all(
                                                      color: !isMyProfile
                                                          ? Colors.black87
                                                              .withAlpha(180)
                                                          : Colors.blue,
                                                      width: 1),
                                                  shape: BoxShape.circle),
                                              child: const Icon(
                                                Icons.mail_outline,
                                                color: Colors.blue,
                                                size: 15,
                                              ),
                                            ),
                                          ),
                                    const SizedBox(
                                      width: 20,
                                    ),
                                    InkWell(
                                      borderRadius: const BorderRadius.all(
                                          Radius.circular(20)),
                                      onTap: () {
                                        Navigator.of(context).push(
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  const EditProfilePage()),
                                        );
                                      },
                                      child: Container(
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 10, vertical: 5),
                                          decoration: BoxDecoration(
                                              border: Border.all(
                                                  color: isMyProfile
                                                      ? Colors.black87
                                                          .withAlpha(180)
                                                      : Colors.blue,
                                                  width: 1),
                                              borderRadius:
                                                  BorderRadius.circular(20)),
                                          child: Text(
                                              isMyProfile
                                                  ? 'Edit Profile'
                                                  : 'Follow',
                                              style: TextStyle(
                                                  color: isMyProfile
                                                      ? Colors.black87
                                                          .withAlpha(180)
                                                      : Colors.blue,
                                                  fontSize: 17,
                                                  fontWeight:
                                                      FontWeight.bold))),
                                    ),
                                  ],
                                ),
                              )
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                )
              ],
            ),
    );
  }
}

class Choice {
  const Choice({required this.title, required this.icon});

  final String title;
  final IconData icon;
}

// ignore: unnecessary_const
const List<Choice> choices = const <Choice>[
  Choice(title: 'Share', icon: Icons.directions_car),
  Choice(title: 'Draft', icon: Icons.directions_bike),
  Choice(title: 'View Lists', icon: Icons.directions_boat),
  Choice(title: 'View Moments', icon: Icons.directions_bus),
  Choice(title: 'QR code', icon: Icons.directions_railway),
];
