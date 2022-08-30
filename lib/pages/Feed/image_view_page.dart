import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:twitter_flutter/helper/theme.dart';
import 'package:twitter_flutter/helper/utility.dart';
import 'package:twitter_flutter/models/feed_model.dart';
import 'package:twitter_flutter/states/auth_state.dart';
import 'package:twitter_flutter/states/feed_state.dart';
import 'package:twitter_flutter/widgets/custom_widget.dart';

class ImageViewPage extends StatefulWidget {
  const ImageViewPage({Key? key}) : super(key: key);

  @override
  State<ImageViewPage> createState() => _ImageViewPageState();
}

class _ImageViewPageState extends State<ImageViewPage> {
  late final TextEditingController _textEditingController;
  late FocusNode _focusNode;

  bool isToolAvailable = true;

  @override
  void initState() {
    _textEditingController = TextEditingController();
    _focusNode = FocusNode();
    super.initState();
  }

  @override
  void dispose() {
    _textEditingController.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  Widget _body() {
    var feedState = Provider.of<FeedState>(context, listen: false);

    return Stack(
      children: [
        SingleChildScrollView(
          child: Container(
            color: Colors.brown.shade700,
            constraints:
                BoxConstraints(maxHeight: MediaQuery.of(context).size.height),
            child: InkWell(
              onTap: () {
                setState(() {
                  isToolAvailable = !isToolAvailable;
                });
              },
              child: _imageFeed(feedState.feedModel!.imagePath),
            ),
          ),
        ),
        !isToolAvailable
            ? Container()
            : Align(
                alignment: Alignment.topLeft,
                child: SafeArea(
                  child: Container(
                    width: 50,
                    height: 50,
                    alignment: Alignment.topLeft,
                    decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.brown.shade700.withAlpha(200)),
                    child: Wrap(
                      children: const [
                        BackButton(
                          color: Colors.white,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
        !isToolAvailable
            ? Container()
            : Align(
                alignment: Alignment.bottomCenter,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: <Widget>[
                    _likeCommentsIcons(feedState.feedModel!),
                    Container(
                      color: Colors.brown.shade700.withAlpha(200),
                      padding: const EdgeInsets.only(
                          right: 10, left: 10, bottom: 10),
                      child: TextField(
                        controller: _textEditingController,
                        maxLines: null,
                        style: const TextStyle(color: Colors.white),
                        decoration: InputDecoration(
                          fillColor: Colors.blue,
                          border: const OutlineInputBorder(
                            borderRadius:
                                BorderRadius.all(Radius.circular(30.0)),
                            borderSide: BorderSide(
                              color: Colors.white,
                            ),
                          ),
                          focusedBorder: const OutlineInputBorder(
                            borderRadius:
                                BorderRadius.all(Radius.circular(30.0)),
                            borderSide: BorderSide(
                              color: Colors.white,
                            ),
                          ),
                          suffixIcon: IconButton(
                            onPressed: () {
                              _submitButton();
                            },
                            icon: const Icon(Icons.send, color: Colors.white),
                          ),
                          focusColor: Colors.black,
                          contentPadding: const EdgeInsets.symmetric(
                              horizontal: 10, vertical: 10),
                          hintText: 'Comment here..',
                          hintStyle: const TextStyle(color: Colors.white),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
      ],
    );
  }

  Widget _imageFeed(String? image) {
    return image == null
        ? Container()
        : Container(
            alignment: Alignment.center,
            child: Image(
              image: NetworkImage(image),
              fit: BoxFit.fitWidth,
            ));
  }

  Widget _likeCommentsIcons(FeedModel feedModel) {
    var feedState = Provider.of<FeedState>(context, listen: false);
    var authState = Provider.of<AuthState>(context, listen: false);
    return Container(
        color: Colors.brown.shade700.withAlpha(200),
        padding: const EdgeInsets.only(bottom: 10, top: 10),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            const SizedBox(
              width: 20,
            ),
            customText(feedModel.commentCount.toString(),
                style: const TextStyle(
                    fontWeight: FontWeight.bold, color: Colors.white)),
            IconButton(
              onPressed: () {
                feedState.setFeedModel = feedModel;
                Navigator.of(context)
                    .pushNamed('/FeedReplyPage/${feedModel.key}');
              },
              icon: const Icon(
                Icons.message,
                color: Colors.white,
                size: 20,
              ),
            ),
            const SizedBox(
              width: 10,
            ),
            customText(feedModel.likeCount.toString(),
                style: const TextStyle(
                    fontWeight: FontWeight.bold, color: Colors.white)),
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
            IconButton(
              onPressed: () {
                Utility.share('social.flutter.dev/feed/${feedModel.key}',
                    subject: '${feedModel.displayName}\'s post');
              },
              icon: const Icon(
                Icons.share,
                color: Colors.white,
              ),
            ),
          ],
        ));
  }

  void likeToPost(String postId) {
    var feedState = Provider.of<FeedState>(context, listen: false);
    var authState = Provider.of<AuthState>(context, listen: false);
    feedState.addLikeToPost(postId, authState.userId);
    setState(() {});
  }

  void _submitButton() {
    var authState = Provider.of<AuthState>(context, listen: false);
    var feedState = Provider.of<FeedState>(context, listen: false);

    feedState.addCommentToPost(
      feedState.feedModel!.key,
      authState.userId,
      _textEditingController.text,
    );

    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _body(),
    );
  }
}
