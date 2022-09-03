import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:twitter_flutter/helper/constants.dart';
import 'package:twitter_flutter/helper/theme.dart';
import 'package:twitter_flutter/helper/utility.dart';
import 'package:twitter_flutter/models/feed_model.dart';
import 'package:twitter_flutter/states/auth_state.dart';
import 'package:twitter_flutter/widgets/custom_widget.dart';
import 'package:flutter_linkify/flutter_linkify.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../states/feed_state.dart';

class FeedPage extends StatefulWidget {
  final BuildContext? context;
  const FeedPage({Key? key, this.context}) : super(key: key);

  @override
  State<FeedPage> createState() => _FeedPageState();
}

class _FeedPageState extends State<FeedPage> {
  @override
  void initState() {
    var feedState = Provider.of<FeedState>(context, listen: false);
    feedState.getDataFromDatabase();
    super.initState();
  }

  Widget _floatingActionButton() {
    return FloatingActionButton(
      onPressed: () {
        Navigator.of(context).pushNamed('/CreateFeedPage');
      },
      child: const Icon(
        Icons.add,
      ),
    );
  }

  Widget _body() {
    var feedState = Provider.of<FeedState>(context, listen: false);

    return feedState.feedList == null
        ? loader()
        : ListView.builder(
            itemCount: feedState.feedList!.length,
            itemBuilder: (context, index) {
              return _postCard(feedState.feedList![index]);
            },
          );
  }

  Widget _postCard(FeedModel feedModel) {
    var authState = Provider.of<AuthState>(context, listen: false);
    var feedState = Provider.of<FeedState>(context, listen: false);
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.symmetric(vertical: 5),
          decoration: BoxDecoration(
            color: Theme.of(context).backgroundColor,
          ),
          child: Column(children: [
            customListTile(
              context,
              onTap: () {
                feedState.setFeedModel = feedModel;
                //feedState.setCommentList = [];
                Navigator.of(context)
                    .pushNamed('/FeedPostDetail/${feedModel.key}');
              },
              leading: customInkWell(
                context: context,
                function2: () {
                  Navigator.of(context)
                      .pushNamed('/Profiles/${feedModel.userId}');
                },
                child: customImage(
                    context, feedModel.profilePic ?? dummyProfilePic),
              ),
              title: Row(
                children: <Widget>[
                  customText(feedModel.displayName, style: titleStyle),
                  const SizedBox(
                    width: 5,
                  ),
                  customText(feedModel.username,
                      style: subtitleStyle.copyWith(fontSize: 15)),
                  const SizedBox(
                    width: 10,
                  ),
                  customText('- ${Utility.getChatTime(feedModel.createdAt)}',
                      style: subtitleStyle)
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
                text: feedModel.description ?? '',
                style: const TextStyle(color: Colors.black38),
                linkStyle: const TextStyle(color: Colors.blueAccent),
              ),
            ),
            _imageFeed(feedModel.imagePath, feedModel.key),
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                const SizedBox(
                  width: 80,
                ),
                IconButton(
                  onPressed: () {
                    feedState.setFeedModel = feedModel;
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
                  icon: feedModel.likeList!
                          .any((x) => x.userId == authState.userId)
                      ? const Icon(Icons.favorite, color: Colors.red)
                      : const Icon(Icons.favorite_border,
                          color: Colors.black38),
                ),
                customText(feedModel.likeCount.toString()),
                const SizedBox(
                  width: 20,
                ),
                IconButton(
                  onPressed: () {
                    Utility.share('social.flutter.dev/feed/${feedModel.key}');
                  },
                  icon: const Icon(
                    Icons.share,
                    color: Colors.black38,
                  ),
                ),
              ],
            ),
          ]),
        ),
        const Divider(height: 1),
      ],
    );
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
            ));
  }

  void likeToPost(String postId) {
    var feedState = Provider.of<FeedState>(context, listen: false);
    var authState = Provider.of<AuthState>(context, listen: false);
    feedState.addLikeToPost(postId, authState.userId);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Home'),
      ),
      floatingActionButton: _floatingActionButton(),
      body: SizedBox(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        child: RefreshIndicator(
          onRefresh: () async {},
          child: _body(),
        ),
      ),
    );
  }
}
