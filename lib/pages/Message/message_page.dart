import 'dart:io';

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
import 'package:twitter_flutter/states/profile_state.dart';
import 'package:twitter_flutter/widgets/custom_widget.dart';
import 'package:sizer/sizer.dart';

class MessagePage extends StatefulWidget {
  final BuildContext? context;

  String? chatUserId;

  MessagePage({Key? key, this.context, this.chatUserId}) : super(key: key);

  @override
  State<MessagePage> createState() => _MessagePageState();
}

class _MessagePageState extends State<MessagePage> {
  late final ScrollController _scrollController;
  late final TextEditingController _textEditingController;

  String? senderId;
  String? chatUserId;

  File? _file;
  String? _fileType;

  @override
  void initState() {
    _scrollController = ScrollController();
    _textEditingController = TextEditingController();

    var chatState = Provider.of<ChatState>(context, listen: false);
    var profileState = Provider.of<ProfileState>(context, listen: false);
    senderId = profileState.userId;
    chatUserId = widget.chatUserId ?? senderId;

    chatState.setIsChatScreenOpen = true;

    chatState.databaseInit(senderId!, chatUserId!);
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
    var chatState = Provider.of<ChatState>(context, listen: false);
    if (chatState.messageList == null || chatState.messageList!.isEmpty) {
      return const Center(
        child: Text(
          'No message found',
          style: TextStyle(color: Colors.grey, fontWeight: FontWeight.bold),
        ),
      );
    } else {
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
    var chatState = Provider.of<ChatState>(context, listen: false);

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
                    backgroundImage: NetworkImage(
                        chatState.chatUser?.photoUrl ?? dummyProfilePic),
                  ),
            Expanded(
              child: Container(
                alignment:
                    myMessage ? Alignment.centerRight : Alignment.centerLeft,
                margin: EdgeInsets.only(
                  right: myMessage ? 10 : 25.w,
                  top: 20,
                  left: myMessage ? 25.w : 10,
                ),
                child: Column(
                  children: [
                    Stack(
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
                            color:
                                myMessage ? Colors.blueAccent : Colors.black12,
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              messageModel.fileUrl != null &&
                                      messageModel.fileType == 'image'
                                  ? InkWell(
                                      onTap: () {},
                                      child: Image(
                                        image:
                                            NetworkImage(messageModel.fileUrl!),
                                        fit: BoxFit.cover,
                                      ),
                                    )
                                  : const SizedBox(),
                              Linkify(
                                onOpen: Utility.openLink,
                                text: messageModel.message ?? '',
                                style: TextStyle(
                                    color: myMessage
                                        ? Colors.white
                                        : Colors.black87),
                                linkStyle: TextStyle(
                                  color: myMessage
                                      ? Colors.white
                                      : Colors.blueAccent,
                                  decoration: TextDecoration.underline,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
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

  Widget _fileFeed() {
    return _file == null
        ? Container()
        : Stack(
            children: [
              Container(
                alignment: Alignment.topLeft,
                height: 300,
                width: 80.w,
                decoration: BoxDecoration(
                    borderRadius: const BorderRadius.all(Radius.circular(10)),
                    image: DecorationImage(
                      image: FileImage(_file!),
                      fit: BoxFit.cover,
                    )),
              ),
              Align(
                alignment: Alignment.topLeft,
                child: Container(
                  padding: const EdgeInsets.all(0),
                  decoration: const BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.black26,
                  ),
                  child: IconButton(
                      onPressed: () {
                        setState(() {
                          _file = null;
                        });
                      },
                      padding: const EdgeInsets.all(0),
                      iconSize: 20,
                      icon: Icon(
                        Icons.close,
                        color: Theme.of(context).colorScheme.onPrimary,
                      )),
                ),
              ),
            ],
          );
  }

  Widget _bottomEntryField() {
    return Align(
      alignment: Alignment.bottomLeft,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          _file != null
              ? const Divider(
                  height: 1,
                  thickness: 2,
                )
              : const SizedBox(),
          _file != null
              ? Container(
                  color: Colors.transparent,
                  alignment: Alignment.bottomLeft,
                  padding: const EdgeInsets.all(10),
                  child: _fileFeed(),
                )
              : const SizedBox(),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const SizedBox(
                width: 5,
              ),
              InkWell(
                child: const Icon(
                  Icons.image_outlined,
                  color: Colors.blueAccent,
                ),
                onTap: () {
                  _selectImageBottom(context);
                },
              ),
              InkWell(
                child: const Icon(
                  Icons.gif_box_outlined,
                  color: Colors.blueAccent,
                ),
                onTap: () {},
              ),
              SizedBox(
                width: 70.w,
                child: Container(
                  constraints: const BoxConstraints(maxHeight: 50),
                  child: Scrollbar(
                    child: TextField(
                      onSubmitted: (value) => submitMessage(),
                      controller: _textEditingController,
                      maxLines: null,
                      decoration: const InputDecoration(
                        contentPadding: EdgeInsets.symmetric(
                          horizontal: 10,
                          vertical: 13,
                        ),
                        alignLabelWithHint: true,
                        hintText: 'Start with a message...',
                      ),
                    ),
                  ),
                ),
              ),
              Container(
                height: 25,
                width: 30,
                padding: const EdgeInsets.only(right: 10, left: 5),
                margin: const EdgeInsets.symmetric(horizontal: 5),
                decoration: const BoxDecoration(
                  border:
                      Border(left: BorderSide(width: 2, color: Colors.black45)),
                ),
                child: InkWell(
                  child: const Icon(
                    Icons.send_outlined,
                    color: Colors.blueAccent,
                  ),
                  onTap: () {
                    submitMessage();
                  },
                ),
              )
            ],
          ),
        ],
      ),
    );
  }

  void _selectImageBottom(context) {
    openImagePicker(context, (file) {
      setState(() {
        _file = File(file.path);
        _fileType = 'image';
      });
    });
  }

  void submitMessage() {
    var chatState = Provider.of<ChatState>(context, listen: false);

    if (_textEditingController.text.isEmpty && _file == null) {
      return;
    } else if (_textEditingController.text.isEmpty && _file != null) {
      _textEditingController.text = '';
    }

    UserModel chatUser = chatState.chatUser!;
    UserModel myUser = chatState.myUser!;

    MessageModel messageModel = MessageModel(
      message: _textEditingController.text,
      createdAt: DateTime.now().toString(),
      senderId: myUser.userId,
      receiverId: chatUser.userId,
      seen: false,
      timeStamp: DateTime.now().millisecondsSinceEpoch.toString(),
      senderName: myUser.displayName,
    );

    chatState.onMessageSubmitted(messageModel,
        myUser: myUser, secondUser: chatUser, file: _file, fileType: _fileType);

    Future.delayed(const Duration(milliseconds: 50)).then((_) {
      _textEditingController.clear();
      _file = null;
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
    var chatState = Provider.of<ChatState>(context, listen: false);
    chatState.setIsChatScreenOpen = false;
    chatState.onChatScreenClosed();
    return true;
  }

  @override
  Widget build(BuildContext context) {
    var chatState = Provider.of<ChatState>(context, listen: true);
    //getLastMessage();
    return WillPopScope(
      onWillPop: _onWillPop,
      child: Scaffold(
        appBar: AppBar(
          title: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                chatState.chatUser?.userId != chatState.myUser?.userId
                    ? chatState.chatUser?.displayName ?? 'Chat...'
                    : 'Yours',
                style: const TextStyle(
                  color: Colors.black87,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                chatState.chatUser?.userId != chatState.myUser?.userId
                    ? chatState.chatUser?.username != null
                        ? '@${chatState.chatUser?.username}'
                        : ''
                    : '',
                style: const TextStyle(
                  color: Colors.red, // AppColor.darkGrey,
                  fontSize: 15,
                ),
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
                  padding: EdgeInsets.only(bottom: _file != null ? 400 : 50),
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
