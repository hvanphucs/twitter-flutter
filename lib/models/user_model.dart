// ignore_for_file: unused_import

import 'package:cloud_firestore/cloud_firestore.dart';

class UserModel {
  String? key;
  String? email;
  String? userId;
  String? displayName;
  String? username;
  String? webSite;
  String? photoUrl;
  String? contact;
  String? bio;
  String? location;
  String? dob;
  String? createdAt;
  List? followers;
  List? following;
  bool? isVerified;

  UserModel({
    this.key,
    required this.email,
    this.userId,
    required this.displayName,
    this.username,
    this.webSite,
    this.photoUrl,
    this.contact,
    this.bio,
    this.location,
    this.dob,
    this.createdAt,
    this.followers,
    this.following,
    this.isVerified = false,
  });

  static UserModel fromJson(Map<dynamic, dynamic> map) {
    return UserModel(
      email: map['email'],
      userId: map['userId'],
      displayName: map['displayName'],
      photoUrl: map['photoUrl'],
      key: map['key'],
      dob: map['dob'],
      bio: map['bio'],
      location: map['location'],
      contact: map['contact'],
      createdAt: map['createdAt'],
      followers: map['followers'] ?? [],
      following: map['following'] ?? [],
      username: map['username'],
      webSite: map['webSite'],
    );
  }

  Map<String, dynamic> get getUser {
    return {
      'key': key,
      'email': email,
      'displayName': displayName,
      'userId': userId,
      'photoUrl': photoUrl,
      'contact': contact,
      'dob': dob,
      'bio': bio,
      'location': location,
      'createdAt': createdAt,
      'followers': followers ?? [],
      'following': following ?? [],
      'username': username,
      'webSite': webSite
    };
  }

  Map<String, dynamic> toJson() {
    return {
      'key': key,
      "userId": userId,
      "email": email,
      'displayName': displayName,
      'photoUrl': photoUrl,
      'contact': contact,
      'dob': dob,
      'bio': bio,
      'location': location,
      'createdAt': createdAt,
      'followers': followers ?? [],
      'following': following ?? [],
      'username': username,
      'webSite': webSite
    };
  }
}
