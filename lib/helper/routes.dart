import 'package:flutter/material.dart';
import 'package:twitter_flutter/helper/custom_route.dart';
import 'package:twitter_flutter/pages/Auth/forget_password_page.dart';
import 'package:twitter_flutter/pages/Auth/signin_page.dart';
import 'package:twitter_flutter/pages/Auth/signup_page.dart';
import 'package:twitter_flutter/pages/Feed/create_feed_page.dart';
import 'package:twitter_flutter/pages/Feed/feed_detail_page.dart';
import 'package:twitter_flutter/pages/Feed/feed_reply_page.dart';
import 'package:twitter_flutter/pages/Feed/image_view_page.dart';
import 'package:twitter_flutter/pages/Message/message_page.dart';
import 'package:twitter_flutter/pages/Profile/edit_profile_page.dart';
import 'package:twitter_flutter/pages/Profile/profile_page.dart';
import 'package:twitter_flutter/pages/home_page.dart';
import 'package:twitter_flutter/widgets/custom_widget.dart';

class Routes {
  static Route? onGenerateRoute(RouteSettings settings) {
    final List<String> pathElements = settings.name!.split('/');

    if (pathElements[0] != '' || pathElements.length == 1) {
      return null;
    }

    if (pathElements[1].contains('SignIn')) {
      return CustomRoute<bool>(
        builder: (context) => const SignInPage(),
        settings: settings,
      );
    }

    if (pathElements[1].contains('SignUp')) {
      return CustomRoute<bool>(
        builder: (context) => const SignUpPage(),
        settings: settings,
      );
    }

    if (pathElements[1].contains('ForgetPasswordPage')) {
      return CustomRoute<bool>(
        builder: (context) => const ForgetPasswordPage(),
        settings: settings,
      );
    }

    if (pathElements[1].contains('HomePage')) {
      return CustomRoute<bool>(
        builder: (context) => const HomePage(),
        settings: settings,
      );
    }

    if (pathElements[1].contains('CreateFeedPage')) {
      return CustomRoute<bool>(
        builder: (context) => const CreateFeedPage(),
        settings: settings,
      );
    }

    if (pathElements[1].contains('Profile')) {
      String profileId = pathElements[2];
      return CustomRoute<bool>(
        builder: (context) => ProfilePage(profileId: profileId),
        settings: settings,
      );
    }

    if (pathElements[1].contains('EditProfile')) {
      return CustomRoute<bool>(
        builder: (context) => const EditProfilePage(),
        settings: settings,
      );
    }

    if (pathElements[1].contains('FeedPostDetail')) {
      String postId = pathElements[2];
      return CustomRoute<bool>(
        builder: (context) => FeedPostDetail(
          postId: postId,
        ),
        settings: settings,
      );
    }

    if (pathElements[1].contains('FeedReplyPage')) {
      String postId = pathElements[2];
      return CustomRoute<bool>(
        builder: (context) => FeedReplyPage(
          postId: postId,
        ),
        settings: settings,
      );
    }

    if (pathElements[1].contains('ImageViewPage')) {
      return CustomRoute<bool>(
        builder: (context) => const ImageViewPage(),
        settings: settings,
      );
    }

    if (pathElements[1].contains('MessagePage')) {
      String chatUserId = pathElements[2];
      return CustomRoute<bool>(
        builder: (context) => MessagePage(chatUserId: chatUserId),
        settings: settings,
      );
    }
    return null;
  }

  static Route onUnknownRoute(RouteSettings settings) {
    return MaterialPageRoute(builder: (context) {
      final String unknownRoute = settings.name!.split('/')[1];
      return Scaffold(
        appBar: AppBar(
          title: customTitleText(unknownRoute),
        ),
        body: Center(child: Text('$unknownRoute Comming soon...')),
      );
    });
  }
}
