// ignore_for_file: unused_import

import 'package:twitter_flutter/models/comment_model.dart';

class FeedModel {
  String? key;
  String? description;
  String? userId;
  String? displayName;
  String? username;
  String? profilePic;
  int? likeCount;
  List<LikeList>? likeList;
  int? commentCount;
  String? createdAt;
  String? imagePath;
  List<dynamic>? tags;

  FeedModel({
    this.key,
    this.description,
    this.userId,
    this.displayName,
    this.username,
    this.profilePic,
    this.likeCount,
    this.likeList,
    this.commentCount,
    this.createdAt,
    this.imagePath,
    this.tags,
  });

  Map<String, dynamic> toJson() {
    Map<dynamic, dynamic>? likeMap;

    if (likeList != null && likeList!.isNotEmpty) {
      likeMap = Map.fromIterable(likeList!,
          key: (v) => v.key,
          value: (v) {
            var list = LikeList(key: v.key, userId: v.userId);
            return list.toJson();
          });
    }

    return {
      "key": key,
      "description": description,
      "likeCount": likeCount,
      "commentCount": commentCount ?? 0,
      "createdAt": createdAt,
      "imagePath": imagePath,
      "likeList": likeMap,
      "tags": tags,
      "userId": userId,
      "displayName": displayName,
      "username": username,
      "profilePic": profilePic,
    };
  }

  FeedModel.setFeedModel(Map<String, dynamic> map) {
    key = map['key'];
    description = map['description'];
    likeCount = map['likeCount'] ?? 0;
    commentCount = map['commentCount'] ?? 0;
    imagePath = map['imagePath'];
    createdAt = map['createdAt'];
    imagePath = map['imagePath'];
    tags = map['tags'];
    displayName = map['displayName'];
    username = map['username'];
    userId = map['userId'];
    profilePic = map['profilePic'];

    likeList = [];

    if (map['likeList'] != null) {
      map['likeList'].forEach((key, value) {
        if (value.containsKey('userId')) {
          LikeList list = LikeList(key: key, userId: value['userId']);
          likeList!.add(list);
        }
      });
      likeCount = likeList!.length;
    }
  }
}

class LikeList {
  String key;
  String userId;

  LikeList({required this.key, required this.userId});

  toJson() {
    return {'userId': userId};
  }
}
