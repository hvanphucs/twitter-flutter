import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:twitter_flutter/helper/utility.dart';
import 'package:twitter_flutter/models/message_model.dart';
import 'package:twitter_flutter/models/user_model.dart';
import 'package:twitter_flutter/states/app_state.dart';
import 'package:twitter_flutter/states/profile_state.dart';
import 'package:uuid/uuid.dart';

class ChatState extends AppState {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseStorage _fireStorage = FirebaseStorage.instance;

  bool setIsChatScreenOpen = false;
  List<MessageModel>? _messageList;
  List<MessageModel>? get messageList {
    if (_messageList != null) {
      _messageList!.sort((x, y) =>
          DateTime.parse(x.createdAt!).compareTo(DateTime.parse(y.createdAt!)));
      _messageList = _messageList!.reversed.toList();
      return _messageList;
    }

    return _messageList;
  }

  List<MessageModel>? _chatUserList;
  List<MessageModel>? get chatUserList {
    _chatUserList!.sort((a, b) => b.createdAt!.compareTo(a.createdAt!));
    return _chatUserList;
  }

  String? _channelName;
  UserModel? _myUser;
  UserModel? get myUser => _myUser;
  UserModel? _chatUser;
  UserModel? get chatUser => _chatUser;

  void databaseInit(String myUserId, String chatUserId) async {
    _channelName = getChannelName(myUserId, chatUserId);

    Utility.cprint(
        'await get Profile user: $myUserId, $chatUserId on channelName: $_channelName',
        info: 'chatState.databaseInit');

    _myUser = await ProfileState().getProfileUser(myUserId);
    _chatUser = await ProfileState().getProfileUser(chatUserId);

    notifyListeners();
  }

  void onMessageSubmitted(
    MessageModel messageModel, {
    UserModel? myUser,
    UserModel? secondUser,
    File? file,
    String? fileType,
  }) async {
    isBusy = true;

    if (myUser == null || secondUser == null) {
      return;
    }
    Utility.cprint('0: ${_messageList?.length}');
    messageModel.key = const Uuid().v1();

    try {
      if (file != null && fileType == 'image') {
        String fileId = const Uuid().v1();
        Reference storageRef =
            _fireStorage.ref().child('chats/$_channelName/media/$fileId');
        UploadTask uploadTask = storageRef.putFile(file);
        await uploadTask.whenComplete(() => storageRef.getDownloadURL().then(
              (fileUrl) {
                messageModel.fileUrl = fileUrl;
                messageModel.fileType = fileType;
              },
            ));
      }

      await _firestore
          .collection('chats')
          .doc(_channelName!)
          .collection('messages')
          .doc(messageModel.key)
          .set(messageModel.toJson())
          .whenComplete(() {
        Utility.cprint('await add new message on channelName: $_channelName',
            info: 'chatState.onMessageSubmitted');
        _messageList ??= [];
        _messageList!.add(messageModel);
      });

      await _firestore
          .collection('chatUsers')
          .doc(myUser.userId!)
          .collection('lastMessage')
          .doc(secondUser.userId!)
          .set(messageModel.toJson())
          .whenComplete(() {
        Utility.cprint('Update lastmessage');
      });

      await _firestore
          .collection('chatUsers')
          .doc(secondUser.userId!)
          .collection('lastMessage')
          .doc(myUser.userId!)
          .set(messageModel.toJson());

      Utility.cprint('1: ${_messageList?.length}');
      notifyListeners();
    } catch (e) {
      Utility.cprint(e.toString());
    }
    isBusy = false;
  }

  String getChannelName(String user1, String user2) {
    user1 = user1.substring(0, 5);
    user2 = user2.substring(0, 5);
    List<String> list = [user1, user2];
    list.sort();
    _channelName = '${list[0]}-${list[1]}';
    Utility.cprint(_channelName);
    return _channelName!;
  }

  void getchatDetailAsync() async {
    Utility.cprint('await get data on channelName: $_channelName',
        info: 'chatState.getchatDetailAsync');
    try {
      if (_messageList == null) {
        final snap = await _firestore
            .collection('chats')
            .doc(_channelName!)
            .collection('messages')
            .get()
            .whenComplete(() {
          Utility.cprint(
              'await get data [Completed] on channelName: $_channelName',
              info: 'chatState.getchatDetailAsync');
        });
        final messageData = snap.docs.map((doc) => doc.data()).toList();

        _messageList = [];
        for (var message in messageData) {
          _messageList!.add(MessageModel.fromJson(message));
        }

        notifyListeners();
      }
    } catch (e) {
      Utility.cprint(e.toString());
    }
  }

  void getUsersChatList(String? userId) async {
    Utility.cprint(userId);
    final snap = await _firestore
        .collection('chatUsers')
        .doc(userId)
        .collection('lastMessage')
        .get();
    final snapData = snap.docs.map((doc) => doc.data()).toList();
    _chatUserList = [];
    for (var data in snapData) {
      _chatUserList!.add(MessageModel.fromJson(data));
    }
    Utility.cprint('await get data ${_chatUserList?.length}',
        info: 'chatState.getUsersChatList');
    notifyListeners();
  }

  void onChatScreenClosed() {
    Utility.cprint('Chat screen close: _messageList = null',
        info: 'chatState.onChatScreenClosed');

    if (_chatUserList != null &&
        _chatUserList!.isNotEmpty &&
        _chatUserList!.any((x) => x.receiverId == chatUser!.userId)) {
      var user =
          _chatUserList!.firstWhere((x) => x.receiverId == chatUser!.userId);

      if (_messageList != null) {
        user.message = _messageList!.first.message;
        user.createdAt = _messageList!.first.createdAt;
        _messageList = null;
        notifyListeners();
      }
    }
  }
}
