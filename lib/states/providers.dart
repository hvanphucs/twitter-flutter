import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:twitter_flutter/states/app_state.dart';
import 'package:twitter_flutter/states/auth_state.dart';
import 'package:twitter_flutter/states/chat_state.dart';
import 'package:twitter_flutter/states/feed_state.dart';
import 'package:twitter_flutter/states/profile_state.dart';
import 'package:twitter_flutter/states/search_state.dart';

List<ChangeNotifierProvider> generateProviders(BuildContext context) {
  return [
    ChangeNotifierProvider<AppState>(create: (context) => AppState()),
    ChangeNotifierProvider<AuthState>(create: (context) => AuthState()),
    ChangeNotifierProvider<ProfileState>(create: (context) => ProfileState()),
    ChangeNotifierProvider<FeedState>(create: (context) => FeedState()),
    ChangeNotifierProvider<ChatState>(create: (context) => ChatState()),
    ChangeNotifierProvider<SearchState>(create: (context) => SearchState())
  ];
}
