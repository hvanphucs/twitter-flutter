import 'package:flutter/material.dart';
import 'package:flutter_linkify/flutter_linkify.dart';
import 'package:provider/provider.dart';
import 'package:twitter_flutter/helper/constants.dart';
import 'package:twitter_flutter/helper/theme.dart';
import 'package:twitter_flutter/helper/utility.dart';
import 'package:twitter_flutter/models/feed_model.dart';
import 'package:twitter_flutter/pages/Profile/edit_profile_page.dart';
import 'package:twitter_flutter/states/auth_state.dart';
import 'package:twitter_flutter/states/feed_state.dart';
import 'package:twitter_flutter/widgets/custom_widget.dart';
import 'package:url_launcher/url_launcher.dart';

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

  // Widget _body(BuildContext context) {
  //   var appState = Provider.of<AppState>(context, listen: false);
  //   return PageView(
  //     controller: _pageController,
  //     physics: const PageScrollPhysics(),
  //     dragStartBehavior: DragStartBehavior.start,
  //     onPageChanged: (index) {
  //       pageIndex = index;
  //       appState.setPageIndex = index;
  //     },
  //     children: const [
  //       FeedPage(),
  //     ],
  //   );
  // }

  Widget _listRow(FeedModel feedModel) {
    var authState = Provider.of<AuthState>(context, listen: false);
    return Column(
      children: [
        Container(
            padding: const EdgeInsets.symmetric(vertical: 5),
            decoration: const BoxDecoration(),
            child: customListTile(
              context,
              onTap: () {
                Navigator.of(context)
                    .pushNamed('/FeedPostDetail/${feedModel.key}');
              },
              leading: customImage(context, feedModel.profilePic!),
              title: Row(
                children: [
                  customText(feedModel.displayName, style: titleStyle),
                  const SizedBox(
                    width: 10,
                  ),
                  customText(
                    '- ${Utility.getChatTime(feedModel.createdAt)}',
                    style: subtitleStyle,
                  )
                ],
              ),
              subtitle: Linkify(
                onOpen: (link) async {
                  if (await canLaunchUrl(Uri.parse(link.url))) {
                    await launchUrl(Uri.parse(link.url));
                  } else {
                    throw 'Could not launch $link';
                  }
                },
                text: 'Replying  to ${feedModel.username}',
                style: TextStyle(
                    color: TwitterColor.paleSky,
                    fontSize: 13,
                    fontFamily: appFont),
                linkStyle: const TextStyle(color: Colors.blueAccent),
              ),
            )),
        _imageFeed(feedModel.imagePath, feedModel.key),
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            const SizedBox(
              width: 80,
            ),
            IconButton(
              onPressed: () {
                Navigator.of(context)
                    .pushNamed('/FeedReplyPage/${feedModel.key}');
              },
              icon: const Icon(
                Icons.message,
                color: Colors.black38,
              ),
            ),
            customText(feedModel.commentCount.toString()),
            const SizedBox(
              width: 20,
            ),
            IconButton(
              onPressed: () {
                likeToPost(feedModel.key!);
              },
              icon: feedModel.likeList!.any((x) => x.userId == authState.userId)
                  ? const Icon(
                      Icons.favorite,
                      color: TwitterColor.ceriseRed,
                    )
                  : const Icon(
                      Icons.favorite_border,
                      color: Colors.black54,
                    ),
            ),
            customText(feedModel.likeCount.toString()),
          ],
        ),
        const Divider()
      ],
    );
  }

  void likeToPost(String postId) {
    var feedState = Provider.of<FeedState>(context, listen: false);
    var authState = Provider.of<AuthState>(context, listen: false);
    feedState.addLikeToPost(postId, authState.userId);
    setState(() {});
  }

  Widget _imageFeed(String? image, String? key) {
    return image == null
        ? Container()
        : customInkWell(
            context: context,
            function2: () {
              var feedState = Provider.of<FeedState>(context, listen: false);
              feedState.getPostDetailFromDatabase(key);
              Navigator.of(context).pushNamed('/ImageViewPage/');
            },
            child: Container(
              alignment: Alignment.centerRight,
              padding: const EdgeInsets.only(right: 10, left: 10),
              child: Container(
                height: 190,
                width: MediaQuery.of(context).size.width * 0.8,
                decoration: BoxDecoration(
                    color: Theme.of(context).backgroundColor,
                    borderRadius: const BorderRadius.all(Radius.circular(20)),
                    image: DecorationImage(
                      image: NetworkImage(image),
                      fit: BoxFit.cover,
                    )),
              ),
            ),
          );
  }

  @override
  Widget build(BuildContext context) {
    var authState = Provider.of<AuthState>(context, listen: false);
    var feedState = Provider.of<FeedState>(context, listen: false);
    feedState.getAllFeedFromDatabase();

    List<FeedModel>? listFeed;

    String id = widget.profileId ?? authState.userModel!.userId!;
    if (feedState.feedList != null) {
      listFeed = feedState.feedList!.where((x) => x.userId == id).toList();
    }

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
                ),
                SliverList(
                  delegate: SliverChildListDelegate(
                    [
                      const SizedBox(height: 10),
                      Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 10,
                        ),
                        child: customText(
                            authState.profileUserModel!.displayName,
                            style: titleStyle),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 9),
                        child: customText(authState.profileUserModel!.username,
                            style: subtitleStyle.copyWith(fontSize: 13)),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 10, vertical: 10),
                        child: customText(
                          authState.profileUserModel!.bio,
                        ),
                      ),
                      Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 10, vertical: 5),
                          child: Row(
                            children: [
                              const Icon(Icons.location_city,
                                  size: 14, color: Colors.black54),
                              const SizedBox(
                                width: 10,
                              ),
                              customText(authState.profileUserModel!.location,
                                  style:
                                      const TextStyle(color: Colors.black54)),
                            ],
                          )),
                      Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 10, vertical: 5),
                          child: Row(
                            children: [
                              const Icon(Icons.calendar_today,
                                  size: 14, color: Colors.black54),
                              const SizedBox(
                                width: 10,
                              ),
                              customText(
                                  Utility.getdob(
                                      authState.profileUserModel!.dob),
                                  style:
                                      const TextStyle(color: Colors.black54)),
                            ],
                          )),
                      Container(
                        alignment: Alignment.center,
                        child: Row(
                          children: [
                            const SizedBox(
                              width: 10,
                              height: 30,
                            ),
                            customText(
                                authState.profileUserModel!.followers != null
                                    ? '${authState.profileUserModel!.followers!.length}'
                                    : '0',
                                style: const TextStyle(
                                    fontWeight: FontWeight.bold, fontSize: 17)),
                            const SizedBox(
                              width: 10,
                            ),
                            customText('Followers',
                                style: const TextStyle(
                                    color: Colors.black54, fontSize: 17)),
                            const SizedBox(
                              width: 40,
                            ),
                            customText(
                                authState.profileUserModel!.followers != null
                                    ? '${authState.profileUserModel!.following!.length}'
                                    : '0',
                                style: const TextStyle(
                                    fontWeight: FontWeight.bold, fontSize: 17)),
                            const SizedBox(
                              width: 10,
                            ),
                            customText('Following',
                                style: const TextStyle(
                                    color: Colors.black54, fontSize: 17)),
                          ],
                        ),
                      ),
                      const Divider(),
                    ],
                  ),
                ),
                SliverList(
                  delegate: SliverChildListDelegate(
                    listFeed == null || listFeed.isEmpty
                        ? [
                            Center(
                                child: Text(
                              'No post created yet',
                              style: subtitleStyle,
                            ))
                          ]
                        : listFeed.map((x) => _listRow(x)).toList(),
                  ),
                ),
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
