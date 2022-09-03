import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:twitter_flutter/helper/constants.dart';
import 'package:twitter_flutter/helper/theme.dart';
import 'package:twitter_flutter/helper/utility.dart';
import 'package:twitter_flutter/models/message_model.dart';
import 'package:twitter_flutter/models/user_model.dart';
import 'package:twitter_flutter/states/auth_state.dart';
import 'package:twitter_flutter/states/chat_state.dart';
import 'package:twitter_flutter/states/search_state.dart';
import 'package:twitter_flutter/widgets/custom_appbar.dart';
import 'package:twitter_flutter/widgets/custom_widget.dart';

class MessageUsersList extends StatefulWidget {
  final BuildContext? context;
  const MessageUsersList({Key? key, this.context}) : super(key: key);

  @override
  State<MessageUsersList> createState() => _MessageUsersListState();
}

class _MessageUsersListState extends State<MessageUsersList> {
  @override
  void initState() {
    var chatState = Provider.of<ChatState>(context, listen: false);
    var authState = Provider.of<AuthState>(context, listen: false);
    var searchState = Provider.of<SearchState>(context, listen: false);
    searchState.getDataFromDatabase();
    chatState.getUsersChatList(authState.userId);

    super.initState();
  }

  void onSettingIconPressed() {}

  Widget _body() {
    final chatState = Provider.of<ChatState>(context, listen: true);
    final searchState = Provider.of<SearchState>(context, listen: false);

    if (chatState.chatUserList == null || chatState.chatUserList!.isEmpty) {
      return const Center(
        child: Text(
          'No chat available!!',
          style: TextStyle(color: Colors.grey, fontWeight: FontWeight.bold),
        ),
      );
    } else {
      return ListView.builder(
          itemCount: chatState.chatUserList!.length,
          itemBuilder: (context, index) {
            MessageModel lastMessageModel = chatState.chatUserList![index];

            String? receiverId = lastMessageModel.receiverId;

            UserModel receiverModel =
                searchState.userList!.firstWhere((x) => x.userId == receiverId,
                    orElse: () => UserModel(
                          email: 'null',
                          displayName: 'Unknown User',
                          username: 'null',
                          userId: receiverId,
                        ));
            return _userCard(
              receiverModel,
              lastMessageModel,
            );
          });
    }
  }

  Widget _userCard(UserModel userModel, MessageModel messageModel) {
    return Column(
      children: <Widget>[
        ListTile(
          onTap: () {
            Navigator.of(context).pushNamed('/MessagePage/${userModel.userId}');
          },
          leading: GestureDetector(
            onTap: () {
              Navigator.of(context)
                  .pushNamed('/ProfilePage/${userModel.userId}');
            },
            child: Container(
              height: 40,
              width: 40,
              decoration: BoxDecoration(
                border: Border.all(color: Colors.white, width: 2),
                borderRadius: BorderRadius.circular(28),
                image: DecorationImage(
                    image: NetworkImage(userModel.photoUrl ?? dummyProfilePic),
                    fit: BoxFit.cover),
              ),
            ),
          ),
          title: RichText(
            text: TextSpan(
              children: [
                TextSpan(
                  text: userModel.displayName ?? '',
                  style: onPrimaryTitleText.copyWith(
                      color: Colors.black, fontSize: 12),
                ),
                TextSpan(
                  text: ' @${userModel.username} ',
                  style: onPrimaryTitleText.copyWith(
                      color: Colors.black54,
                      fontSize: 12,
                      fontWeight: FontWeight.normal),
                ),
                TextSpan(
                  text: ' · ${Utility.getChatTime(messageModel.createdAt)}',
                  style: onPrimaryTitleText.copyWith(
                      color: Colors.black54,
                      fontSize: 12,
                      fontWeight: FontWeight.normal),
                )
              ],
            ),
          ),
          subtitle: _getShortLastMessage(messageModel),
        ),
        const Divider()
      ],
    );
  }

  Widget _getShortLastMessage(MessageModel messageModel) {
    String shortMessage = messageModel.message ?? '';

    if (messageModel.fileType == 'image') {
      shortMessage = 'You send a picture: $shortMessage';
    }

    if (shortMessage.length > 100) {
      shortMessage = 'You: ${shortMessage.trim().substring(0, 80)}  ...';
    }
    shortMessage = shortMessage.trim();

    return Text('You: $shortMessage',
        style: onPrimaryTitleText.copyWith(
            color: Colors.black54,
            fontSize: 12,
            fontWeight: FontWeight.normal));
  }

  @override
  Widget build(BuildContext context) {
    final chatState = Provider.of<ChatState>(context, listen: true);

    Utility.cprint('Draw again', info: 'message user!');

    return Scaffold(
      appBar: CustomAppBar(
        title: customTitleText(
          'Messages',
        ),
        icon: Icons.settings,
        onActionPressed: onSettingIconPressed,
      ),
      backgroundColor: TwitterColor.mystic,
      body: chatState.isBusy ? loader() : _body(),
    );
  }
}
