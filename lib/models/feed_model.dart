import 'package:flutter/material.dart';

class FeedModel {
  String? key;
  String? description;
  String? userId;
  String? name;
  String? username;
  String? profilePic;
  int? likeCount;
  List<LikeList>? likeList;
  int? commentCount;
  String? createdAt;
  String? imagePath;
  List<String>? tags;

  FeedModel({
    this.key,
    this.description,
    this.userId,
    this.name,
    this.username,
    this.profilePic,
    this.likeCount,
    //this.likeList,
    this.commentCount,
    this.createdAt,
    this.imagePath,
    //this.tags,
  });

  Map<String, dynamic> toJson() {
    return {
      "userId": userId,
      "description": description,
      "name": name,
      "profilePic": profilePic,
      "likeCount": likeCount,
      "commentCount": commentCount ?? 0,
      "createdAt": createdAt,
      "imagePath": imagePath,
      "likeList": likeList,
      "tags": tags,
      "username": username
    };
  }

  FeedModel.setFeedModel(Map<String, dynamic> map) {
    key = map['key'];
    key = map['key'];
    description = map['description'];
    userId = map['userId'];
    name = map['name'];
    profilePic = map['profilePic'];
    likeCount = map['likeCount'];
    commentCount = map['commentCount'];
    imagePath = map['imagePath'];
    createdAt = map['createdAt'];
    imagePath = map['imagePath'];
    username = map['username'];
    tags = map['tags'];
  }
}

class LikeList {}
