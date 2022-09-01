import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_linkify/flutter_linkify.dart';
import 'package:provider/provider.dart';
import 'package:twitter_flutter/helper/constants.dart';
import 'package:twitter_flutter/helper/theme.dart';
import 'package:twitter_flutter/helper/utility.dart';
import 'package:twitter_flutter/models/message_model.dart';
import 'package:twitter_flutter/models/user_model.dart';
import 'package:twitter_flutter/states/auth_state.dart';
import 'package:twitter_flutter/states/chat_state.dart';
import 'package:twitter_flutter/widgets/bottomMenuBar/tab_item.dart';
import 'package:twitter_flutter/widgets/custom_widget.dart';
import 'package:url_launcher/url_launcher.dart';

class MessagePage extends StatefulWidget {
  final BuildContext? context;
  const MessagePage({Key? key, this.context}) : super(key: key);

  @override
  State<MessagePage> createState() => _MessagePageState();
}

class _MessagePageState extends State<MessagePage> {
  late final ScrollController _scrollController;
  late final TextEditingController _textEditingController;
  String? senderId;
  UserModel? chatUser;
  @override
  void initState() {
    _scrollController = ScrollController();
    _textEditingController = TextEditingController();

    var chatState = Provider.of<ChatState>(context, listen: false);
    var authState = Provider.of<AuthState>(context, listen: false);
    senderId = authState.userModel!.userId;

    chatState.setIsChatScreenOpen = true;
    senderId = authState.userModel!.userId;
    chatUser = authState.userModel!;
    chatState.databaseInit(authState.profileUserModel!, chatUser!);
    chatState.getchatDetailAsync();
    super.initState();
  }

  @override
  void dispose() {
    _scrollController.dispose();
    _textEditingController.dispose();
    super.dispose();
  }

  Widget _chatScreenBody() {
    var chatState = Provider.of<ChatState>(context, listen: true);
    if (chatState.messageList == null || chatState.messageList!.isEmpty) {
      return const Center(
        child: Text(
          'No message found',
          style: TextStyle(color: Colors.grey, fontWeight: FontWeight.bold),
        ),
      );
    }
    return ListView.builder(
        controller: _scrollController,
        shrinkWrap: true,
        reverse: true,
        physics: const BouncingScrollPhysics(),
        itemCount: chatState.messageList!.length,
        itemBuilder: (context, index) {
          return chatMessage(chatState.messageList![index]);
        });
  }

  Widget chatMessage(MessageModel messageModel) {
    if (senderId == null) {
      return Container();
    }
    if (messageModel.senderId == senderId) {
      return _message(messageModel, true);
    } else {
      return _message(messageModel, false);
    }
  }

  Widget _message(MessageModel messageModel, bool myMessage) {
    return Column(
      crossAxisAlignment:
          myMessage ? CrossAxisAlignment.end : CrossAxisAlignment.start,
      mainAxisAlignment:
          myMessage ? MainAxisAlignment.end : MainAxisAlignment.start,
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            const SizedBox(
              width: 15,
            ),
            myMessage
                ? const SizedBox()
                : CircleAvatar(
                    backgroundColor: Colors.transparent,
                    backgroundImage: NetworkImage(dummyProfilePic),
                  ),
            Expanded(
              child: Container(
                alignment:
                    myMessage ? Alignment.centerRight : Alignment.centerLeft,
                margin: EdgeInsets.only(
                  right:
                      myMessage ? 10 : (MediaQuery.of(context).size.width / 4),
                  top: 20,
                  left:
                      myMessage ? (MediaQuery.of(context).size.width / 4) : 10,
                ),
                child: Stack(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.only(
                          topLeft: const Radius.circular(20),
                          topRight: const Radius.circular(20),
                          bottomRight: myMessage
                              ? const Radius.circular(0)
                              : const Radius.circular(20),
                          bottomLeft: myMessage
                              ? const Radius.circular(20)
                              : const Radius.circular(0),
                        ),
                        color: myMessage ? Colors.blueAccent : Colors.black12,
                      ),
                      child: Column(
                        children: [
                          Linkify(
                            onOpen: Utility.openLink,
                            text: messageModel.message ?? '',
                            style: TextStyle(
                                color:
                                    myMessage ? Colors.white : Colors.black87),
                            linkStyle: TextStyle(
                              color:
                                  myMessage ? Colors.white : Colors.blueAccent,
                              decoration: TextDecoration.underline,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
        Padding(
          padding: EdgeInsets.only(
            left: myMessage ? 14 : 65,
          ),
          child: Row(
            mainAxisAlignment:
                myMessage ? MainAxisAlignment.end : MainAxisAlignment.start,
            children: [
              Text(
                Utility.getChatTime(messageModel.createdAt),
                style:
                    Theme.of(context).textTheme.caption!.copyWith(fontSize: 12),
              ),
              myMessage
                  ? const Icon(
                      Icons.check_outlined,
                      color: Colors.black54,
                      size: 15,
                    )
                  : Container(),
            ],
          ),
        )
      ],
    );
  }

  Widget _bottomEntryField() {
    return Align(
      alignment: Alignment.bottomLeft,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          const Divider(
            thickness: 0,
            height: 1,
          ),
          TextField(
            onSubmitted: (value) => submitMessage(),
            controller: _textEditingController,
            decoration: InputDecoration(
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 10,
                vertical: 13,
              ),
              alignLabelWithHint: true,
              hintText: 'Start with a message...',
              suffixIcon: IconButton(
                icon: const Icon(Icons.send),
                onPressed: submitMessage,
              ),
            ),
          ),
        ],
      ),
    );
  }

  void submitMessage() {
    var chatState = Provider.of<ChatState>(context, listen: false);
    var authState = Provider.of<AuthState>(context, listen: false);

    if (_textEditingController.text.isEmpty) {
      return;
    }

    UserModel chatUser = authState.userModel!;
    UserModel myUser = authState.userModel!;

    MessageModel messageModel = MessageModel(
      message: _textEditingController.text,
      createdAt: DateTime.now().toString(),
      senderId: myUser.userId,
      receiverId: chatUser.userId,
      seen: false,
      timeStamp: DateTime.now().millisecondsSinceEpoch.toString(),
      senderName: authState.userModel!.displayName,
    );

    chatState.onMessageSubmitted(messageModel,
        myUser: myUser, secondUser: chatUser);

    Future.delayed(const Duration(milliseconds: 50)).then((_) {
      _textEditingController.clear();
    });
    try {
      if (chatState.messageList != null &&
          chatState.messageList!.length > 1 &&
          _scrollController.offset > 0) {
        _scrollController.animateTo(
          0.0,
          curve: Curves.easeOut,
          duration: const Duration(milliseconds: 300),
        );
      }
    } catch (e) {
      Utility.cprint("[Error] $e");
    }
  }

  Future<bool> _onWillPop() async {
    final chatState = Provider.of<ChatState>(context, listen: false);
    chatState.setIsChatScreenOpen = false;
    //chatState.dispose();
    return true;
  }

  @override
  Widget build(BuildContext context) {
    //var chatState = Provider.of<ChatState>(context, listen: false);
    return WillPopScope(
      onWillPop: _onWillPop,
      child: Scaffold(
        appBar: AppBar(
          title: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                chatUser?.displayName ?? 'Chat ...',
                style: const TextStyle(color: Colors.black12),
              )
            ],
          ),
          iconTheme: const IconThemeData(color: Colors.blue),
          backgroundColor: Colors.white,
          actions: <Widget>[
            IconButton(
                icon: const Icon(Icons.info, color: Colors.blueAccent),
                onPressed: () {
                  Navigator.pushNamed(context, '/ConversationInformation');
                })
          ],
        ),
        body: SafeArea(
          child: Stack(
            children: [
              Align(
                alignment: Alignment.topRight,
                child: Padding(
                  padding: const EdgeInsets.only(bottom: 50),
                  child: _chatScreenBody(),
                ),
              ),
              _bottomEntryField(),
            ],
          ),
        ),
      ),
    );
  }
}
