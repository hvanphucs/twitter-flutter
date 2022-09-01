import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:twitter_flutter/helper/utility.dart';
import 'package:twitter_flutter/models/message_model.dart';
import 'package:twitter_flutter/models/user_model.dart';
import 'package:twitter_flutter/states/app_state.dart';
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

  List<UserModel>? _chatUserList;
  String? _channelName;
  UserModel? _chatUser;
  UserModel? get chatUser => _chatUser;

  void databaseInit(UserModel myUser, UserModel chatUser) {
    _channelName ??= getChannelName(myUser.userId!, myUser.userId!);
    _chatUser = chatUser;
    _messageList = null;
  }

  void onMessageSubmitted(MessageModel messageModel,
      {UserModel? myUser, UserModel? secondUser}) async {
    if (myUser == null || secondUser == null) {
      return;
    }

    messageModel.key = const Uuid().v1();
    try {
      await _firestore
          .collection('chats')
          .doc(_channelName!)
          .collection('messages')
          .doc(messageModel.key)
          .set(messageModel.toJson());

      _messageList ??= [];
      _messageList!.add(messageModel);

      if (_messageList == null || _messageList!.isEmpty) {
        await _firestore
            .collection('chatUsers')
            .doc(myUser.userId!)
            .collection(secondUser.userId!)
            .doc('profile')
            .set(secondUser.toJson());

        await _firestore
            .collection('chatUsers')
            .doc(secondUser.userId!)
            .collection(myUser.userId!)
            .doc('profile')
            .set(myUser.toJson());
      }

      notifyListeners();
      Utility.cprint('Done');
    } catch (e) {
      Utility.cprint(e.toString());
    }
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
    try {
      if (_messageList == null) {
        final snap = await _firestore
            .collection('chats')
            .doc(_channelName!)
            .collection('messages')
            .get();
        final messageData = snap.docs.map((doc) => doc.data()).toList();

        _messageList = [];
        for (var message in messageData) {
          _messageList!.add(MessageModel.fromJson(message));
        }

        notifyListeners();
        Utility.cprint('Done');
      }
    } catch (e) {
      Utility.cprint(e.toString());
    }
  }
}
