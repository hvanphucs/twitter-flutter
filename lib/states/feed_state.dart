import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:twitter_flutter/helper/utility.dart';
import 'package:twitter_flutter/models/comment_model.dart';
import 'package:twitter_flutter/models/feed_model.dart';
import 'package:twitter_flutter/models/user_model.dart';
import 'package:twitter_flutter/states/app_state.dart';
import 'package:uuid/uuid.dart';

class FeedState extends AppState {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseStorage _fireStorage = FirebaseStorage.instance;

  //bool isBusy = false;

  List<FeedModel>? _feedList;
  List<FeedModel>? get feedList => _feedList;

  FeedModel? _feedModel;
  FeedModel? get feedModel => _feedModel;

  set setFeedModel(FeedModel model) {
    _feedModel = model;
  }

  List<CommentModel>? _commentList;
  List<CommentModel>? get commentList => _commentList;
  set setCommentList(List<CommentModel>? list) {
    _commentList = list;
  }

  void getAllFeedFromDatabase() async {
    final feedSnap = await _firestore.collection('feeds').get();

    final feedData = feedSnap.docs.map((doc) => doc.data()).toList();

    _feedList = [];
    for (var feed in feedData) {
      _feedList!.add(FeedModel.setFeedModel(feed));
    }
  }

  Future<String?> createFeed(FeedModel model, File? image,
      {BuildContext? context}) async {
    String feedId = const Uuid().v1();
    String imageId = const Uuid().v1();
    model.key = feedId;
    try {
      if (image != null) {
        Reference storageRef =
            _fireStorage.ref().child('user/$feedId/pics/$imageId');
        UploadTask uploadTask = storageRef.putFile(image);
        await uploadTask.whenComplete(() => storageRef.getDownloadURL().then(
              (fileUrl) {
                model.imagePath = fileUrl;
              },
            ));
      }

      await _firestore.collection('feeds').doc(feedId).set(model.toJson());
      notifyListeners();
      return feedId;
    } catch (e) {
      Utility.cprint(e.toString());
    }
    return null;
  }

  void addLikeToPost(String? postId, String? userId) async {
    if (postId != null && userId != null) {
      try {
        final snap = await _firestore.collection('feeds').doc(postId).get();
        if (snap.data() != null) {
          final feedModel = FeedModel.setFeedModel(snap.data()!);

          if (feedModel.likeList!.any((x) => x.userId == userId)) {
            feedModel.likeList!.removeWhere((x) => x.userId == userId);
            feedModel.likeCount = feedModel.likeCount! - 1;
          } else {
            feedModel.likeList!.add(LikeList(key: postId, userId: userId));
            feedModel.likeCount = feedModel.likeCount! + 1;
          }
          await _firestore
              .collection('feeds')
              .doc(postId)
              .update(feedModel.toJson());
          _feedModel = feedModel;
        }
        notifyListeners();
      } catch (e) {
        Utility.cprint(e.toString());
      }
    } else {
      Utility.cprint("nothings");
    }
  }

  void getPostDetailFromDatabase(String? postId) async {
    if (postId != null) {
      try {
        final feedSnap = await _firestore.collection('feeds').doc(postId).get();

        final commentsSnap = await _firestore
            .collection('feeds')
            .doc(postId)
            .collection('comments')
            .get();

        final commentData = commentsSnap.docs.map((doc) => doc.data()).toList();

        _commentList = [];
        for (var comment in commentData) {
          _commentList!.add(CommentModel.fromJson(comment));
        }

        if (feedSnap.data() != null) {
          _feedModel = FeedModel.setFeedModel(feedSnap.data()!);
        }

        notifyListeners();
      } catch (e) {
        Utility.cprint(e.toString());
      }
    }
  }

  void addCommentToPost(String? postId, String? userId, String? comment) async {
    if (comment == null ||
        comment.isEmpty ||
        postId == null ||
        userId == null) {
      return;
    }
    try {
      UserModel? userTodo;
      FeedModel? feedTodo;
      final feedSnap = await _firestore.collection('feeds').doc(postId).get();
      if (feedSnap.data() != null) {
        feedTodo = FeedModel.setFeedModel(feedSnap.data()!);
      }

      final userSnap =
          await _firestore.collection('profiles').doc(userId).get();
      if (userSnap.data() != null) {
        userTodo = UserModel.fromJson(userSnap.data()!);
      }

      if (userTodo != null && feedTodo != null) {
        String commentKey = const Uuid().v1();
        CommentModel commentModel = CommentModel(
          key: commentKey,
          parentId: postId,
          description: comment,
          user: userTodo,
          createdAt: DateTime.now().toString(),
        );
        await _firestore
            .collection('feeds')
            .doc(postId)
            .collection('comments')
            .doc(commentKey)
            .set(commentModel.toJson());

        await _firestore
            .collection('feeds')
            .doc(postId)
            .update({'commentCount': FieldValue.increment(1)});

        notifyListeners();
      }
    } catch (e) {
      Utility.cprint(e.toString());
    }
  }
}
