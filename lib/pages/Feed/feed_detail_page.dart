import 'package:flutter/material.dart';
import 'package:flutter_linkify/flutter_linkify.dart';
import 'package:provider/provider.dart';
import 'package:twitter_flutter/helper/theme.dart';
import 'package:twitter_flutter/helper/utility.dart';
import 'package:twitter_flutter/models/comment_model.dart';
import 'package:twitter_flutter/models/feed_model.dart';
import 'package:twitter_flutter/states/feed_state.dart';
import 'package:twitter_flutter/widgets/custom_widget.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../states/auth_state.dart';

class FeedPostDetail extends StatefulWidget {
  final String? postId;
  const FeedPostDetail({Key? key, this.postId}) : super(key: key);

  @override
  State<FeedPostDetail> createState() => _FeedPostDetailState();
}

class _FeedPostDetailState extends State<FeedPostDetail> {
  @override
  void initState() {
    //final feedState = Provider.of<FeedState>(context, listen: false);

    super.initState();
  }

  //
  Widget _floatingActionButton() {
    return FloatingActionButton(
      onPressed: () {
        Navigator.of(context).pushNamed('/FeedReplyPage/${widget.postId}');
      },
      child: const Icon(Icons.add),
    );
  }

  //
  Widget _postBody(FeedModel? feedModel) {
    return feedModel == null
        ? Container()
        : Column(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(vertical: 5),
                decoration: const BoxDecoration(),
                child: ListTile(
                  leading: customImage(context, feedModel.profilePic!),
                  title: customText(feedModel.displayName, style: titleStyle),
                  subtitle:
                      customText(feedModel.username, style: subtitleStyle),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 15,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Linkify(
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
                    customInkWell(
                      context: context,
                      function2: () {
                        openImage();
                      },
                      child: _imageFeed(feedModel.imagePath),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    Row(
                      children: <Widget>[
                        customText(Utility.getPostTime2(feedModel.createdAt),
                            style: const TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w500,
                                color: Colors.black54)),
                        const SizedBox(
                          width: 10,
                        ),
                        customText(
                          'Twitter for Android',
                          style:
                              TextStyle(color: Theme.of(context).primaryColor),
                        )
                      ],
                    ),
                  ],
                ),
              ),
              const Divider(),
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  const SizedBox(
                    width: 10,
                  ),
                  customText(
                    feedModel.commentCount.toString(),
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(
                    width: 5,
                  ),
                  customText(
                    'comments',
                    style: const TextStyle(color: Colors.black54),
                  ),
                  const SizedBox(
                    width: 10,
                  ),
                  customText(
                    feedModel.likeCount.toString(),
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(
                    width: 5,
                  ),
                  customText(
                    'likes',
                    style: const TextStyle(color: Colors.black54),
                  ),
                ],
              ),
              const SizedBox(
                height: 10,
              ),
              const Divider(
                height: 0,
              ),
              _likeCommentsIcon(feedModel),
              const Divider(
                height: 0,
              ),
              Container(
                height: 6,
                width: MediaQuery.of(context).size.width,
                color: TwitterColor.mystic,
              )
            ],
          );
  }

  Widget _imageFeed(String? image) {
    return image == null
        ? Container()
        : Padding(
            padding: const EdgeInsets.only(top: 10),
            child: Container(
                alignment: Alignment.centerRight,
                child: Container(
                  height: 250,
                  width: MediaQuery.of(context).size.width * .95,
                  decoration: BoxDecoration(
                    borderRadius: const BorderRadius.all(Radius.circular(10)),
                    image: DecorationImage(
                        image: NetworkImage(image), fit: BoxFit.cover),
                  ),
                )),
          );
  }

  void openImage() {
    Navigator.of(context).pushNamed('/ImageViewPage');
  }

  Widget _likeCommentsIcon(FeedModel feedModel) {
    var authState = Provider.of<AuthState>(context, listen: false);
    var feedState = Provider.of<FeedState>(context, listen: false);
    return Container(
      padding: const EdgeInsets.only(
        bottom: 0,
        top: 0,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const SizedBox(
            width: 0,
          ),
          IconButton(
            onPressed: () {
              feedState.setFeedModel = feedModel;
              Navigator.of(context)
                  .pushNamed('/FeedReplyPage/${widget.postId}');
            },
            icon: const Icon(
              Icons.message,
              color: Colors.black54,
              size: 20,
            ),
          ),
          const SizedBox(
            width: 10,
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
          const SizedBox(
            width: 10,
          ),
          IconButton(
            onPressed: () {
              Utility.share('social.flutter.dev/feed/${feedModel.key}');
            },
            icon: const Icon(
              Icons.share,
              color: Colors.black54,
              size: 20,
            ),
          ),
        ],
      ),
    );
  }

  void likeToPost(String postId) {
    var feedState = Provider.of<FeedState>(context, listen: false);
    var authState = Provider.of<AuthState>(context, listen: false);
    feedState.addLikeToPost(postId, authState.userId);
    setState(() {});
  }

  Widget _commentRow(CommentModel commentModel) {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.symmetric(vertical: 5),
          decoration: const BoxDecoration(),
          child: customListTile(
            context,
            leading: customImage(context, commentModel.user.photoUrl!),
            title: Row(
              children: [
                customText(
                  commentModel.user.displayName,
                  style: titleStyle.copyWith(fontSize: 15),
                ),
                const SizedBox(
                  width: 5,
                ),
                Expanded(
                  child: customText('${commentModel.user.username}',
                      style: subtitleStyle, overflow: TextOverflow.ellipsis),
                ),
                const SizedBox(
                  width: 10,
                ),
              ],
            ),
            trailing: customText(
              '-${Utility.getChatTime(commentModel.createdAt)}',
              style: const TextStyle(fontSize: 12),
            ),
            subtitle: customText(commentModel.description),
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final feedState = Provider.of<FeedState>(context, listen: true);
    feedState.getPostDetailFromDatabase(widget.postId);

    return Scaffold(
      floatingActionButton: _floatingActionButton(),
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            title: const Text(
              'Threads',
              style: TextStyle(color: Colors.blueAccent),
            ),
            iconTheme: IconThemeData(color: Theme.of(context).primaryColor),
            backgroundColor: Colors.transparent,
          ),
          SliverList(
            delegate: SliverChildListDelegate(
              [
                _postBody(feedState.feedModel),
              ],
            ),
          ),
          SliverList(
            delegate: SliverChildListDelegate(
              feedState.commentList != null || feedState.commentList!.isNotEmpty
                  ? feedState.commentList!.map((x) => _commentRow(x)).toList()
                  : [
                      const Center(
                        child: Text('No comments'),
                      )
                    ],
            ),
          ),
        ],
      ),
    );
  }
}
