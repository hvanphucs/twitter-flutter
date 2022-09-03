import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_linkify/flutter_linkify.dart';
import 'package:provider/provider.dart';
import 'package:twitter_flutter/helper/constants.dart';
import 'package:twitter_flutter/helper/utility.dart';
import 'package:twitter_flutter/states/auth_state.dart';
import 'package:twitter_flutter/states/feed_state.dart';
import 'package:twitter_flutter/widgets/custom_appbar.dart';
import 'package:twitter_flutter/widgets/custom_widget.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../helper/theme.dart';

class FeedReplyPage extends StatefulWidget {
  final String? postId;
  const FeedReplyPage({Key? key, this.postId}) : super(key: key);

  @override
  State<FeedReplyPage> createState() => _FeedReplyPageState();
}

class _FeedReplyPageState extends State<FeedReplyPage> {
  late final TextEditingController _textEditingController;
  late final ScrollController _scrollController;
  bool isScrollingDown = false;

  @override
  void initState() {
    _textEditingController = TextEditingController();
    _scrollController = ScrollController();
    _scrollController.addListener(_scrollListener);
    super.initState();
  }

  @override
  void dispose() {
    //_scrollController.dispose();
    _scrollController.removeListener(_scrollListener);
    super.dispose();
  }

  _scrollListener() {
    if (_scrollController.position.userScrollDirection ==
        ScrollDirection.reverse) {
      if (!isScrollingDown) {
        setState(() {
          isScrollingDown = true;
        });
      }
    }

    if (_scrollController.position.userScrollDirection ==
        ScrollDirection.forward) {
      setState(() {
        isScrollingDown = false;
        _scrollController.animateTo(
          _scrollController.position.minScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.ease,
        );
      });
    }
  }

  Widget _postCard() {
    var feedState = Provider.of<FeedState>(context, listen: false);
    var feedModel = feedState.feedModel;
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Stack(
          children: [
            Container(
              padding: const EdgeInsets.only(left: 40),
              margin: const EdgeInsets.only(left: 20, top: 20, bottom: 3),
              decoration: BoxDecoration(
                border: Border(
                  left: BorderSide(
                    width: 2.0,
                    color: Colors.grey.shade400,
                  ),
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    width: MediaQuery.of(context).size.width - 82,
                    child: Linkify(
                      onOpen: (link) async {
                        if (await canLaunchUrl(Uri.parse(link.url))) {
                          await launchUrl(Uri.parse(link.url));
                        } else {
                          throw 'Could not launch $link';
                        }
                      },
                      text: feedModel?.description ?? '',
                      style: const TextStyle(color: Colors.black38),
                      linkStyle: const TextStyle(color: Colors.blueAccent),
                    ),
                  ),
                  const SizedBox(
                    height: 30,
                  ),
                  Linkify(
                    onOpen: (link) async {
                      if (await canLaunchUrl(Uri.parse(link.url))) {
                        await launchUrl(Uri.parse(link.url));
                      } else {
                        throw 'Could not launch $link';
                      }
                    },
                    text: 'Replying  to ${feedModel!.username}',
                    style: TextStyle(
                        color: TwitterColor.paleSky,
                        fontSize: 13,
                        fontFamily: appFont),
                    linkStyle: const TextStyle(color: Colors.blueAccent),
                  )
                ],
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                customImage(context, feedModel.profilePic!),
                const SizedBox(
                  width: 10,
                ),
                customText(feedModel.username, style: titleStyle),
                const SizedBox(
                  width: 10,
                ),
                // customText(feedModel.username,
                //     style: TextStyle(
                //         color: TwitterColor.paleSky,
                //         fontSize: 17,
                //         fontWeight: FontWeight.w500,
                //         fontFamily: appFont)),
                // const SizedBox(
                //   width: 10,
                // ),
                customText('- ${Utility.getChatTime(feedModel.createdAt)}',
                    style: subtitleStyle)
              ],
            )
          ],
        )
      ],
    );
  }

  Widget _descriptionEntry() {
    return TextField(
      controller: _textEditingController,
      onChanged: (text) {
        setState(() {});
      },
      maxLines: null,
      decoration: const InputDecoration(
        border: InputBorder.none,
        hintText: 'Tweet your reply',
        hintStyle: TextStyle(fontSize: 18),
      ),
    );
  }

  void _submitButton() {
    var authState = Provider.of<AuthState>(context, listen: false);
    var feedState = Provider.of<FeedState>(context, listen: false);

    feedState.addCommentToPost(
      widget.postId,
      authState.userId,
      _textEditingController.text,
    );

    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    var authState = Provider.of<AuthState>(context, listen: false);
    return Scaffold(
      appBar: CustomAppBar(
        title: customTitleText(''),
        onActionPressed: _submitButton,
        isCrossButton: true,
        submitButtonText: 'Reply',
        isSubmitDisable: _textEditingController.text.isEmpty,
        isBottomLine: isScrollingDown,
      ),
      backgroundColor: Theme.of(context).backgroundColor,
      body: SingleChildScrollView(
          controller: _scrollController,
          child: Container(
            padding: const EdgeInsets.only(
              left: 10,
              right: 10,
              bottom: 10,
            ),
            height: MediaQuery.of(context).size.height,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _postCard(),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    customImage(
                      context,
                      authState.userModel!.photoUrl!,
                      height: 40,
                    ),
                    const SizedBox(
                      width: 20,
                    ),
                    Expanded(
                      child: _descriptionEntry(),
                    ),
                  ],
                ),
                Expanded(child: Container()),
              ],
            ),
          )),
    );
  }
}
