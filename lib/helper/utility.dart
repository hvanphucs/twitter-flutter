import 'dart:math';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:twitter_flutter/helper/constants.dart';
import 'package:share_plus/share_plus.dart';
import 'dart:developer' as devtools show log;

import 'package:url_launcher/url_launcher.dart';

class Utility {
  static void cprint(dynamic data, {String? info}) {
    devtools.log(info == null ? data.toString() : '[$info] data.toString()');
  }

  static void showCustomSnackBar(String text, BuildContext context,
      {Color textColor = Colors.white, Color backgroundColor = Colors.black}) {
    cprint(text);
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      backgroundColor: backgroundColor,
      content: Text(
        text,
        style: TextStyle(
          color: textColor,
        ),
      ),
      duration: const Duration(seconds: 2),
    ));
  }

  static String getPostTime2(String? date) {
    if (date == null || date.isEmpty) {
      return '';
    }
    var dt = DateTime.parse(date);
    var dat =
        '${DateFormat.jm().format(dt)} - ${DateFormat("dd MMM yy").format(dt)}';
    return dat;
  }

  static String getUserName({required String? name, required String? id}) {
    String userName = '';
    name = name!.split(' ')[0];
    id = id!.substring(0, 4);
    userName = '@$name$id';
    return userName.toLowerCase();
  }

  static String getDummyProfilePic() {
    Random random = Random();
    int ran = random.nextInt(8);
    return dummyProfilePicList[ran];
  }

  static String getdob(String? date) {
    if (date == null || date.isEmpty) {
      return '';
    }
    var dt = DateTime.parse(date);
    var dat = DateFormat.yMMMd().format(dt);
    return dat;
  }

  static List<String> getHashTags(String text) {
    RegExp reg = RegExp(
        r"([#])\w+|(https?|ftp|file|#)://[-A-Za-z0-9+&@#/%?=~_|!:,.;]+[-A-Za-z0-9+&@#/%=~_|]*");
    Iterable<Match> matches = reg.allMatches(text);
    List<String> resultMatches = [];
    for (Match match in matches) {
      if (match.group(0)!.isNotEmpty) {
        var tag = match.group(0);
        resultMatches.add(tag!);
      }
    }
    return resultMatches;
  }

  static String getChatTime(String? date) {
    if (date == null || date.isEmpty) {
      return '';
    }
    String msg = '';
    var dt = DateTime.parse(date);

    if (DateTime.now().isBefore(dt)) {
      return DateFormat.jm().format(DateTime.parse(date)).toString();
    }

    var dur = DateTime.now().difference(dt);
    if (dur.inDays > 0) {
      msg = '${dur.inDays} d';
      return dur.inDays == 1 ? 'yesterday' : DateFormat("dd MMM").format(dt);
    } else if (dur.inHours > 0) {
      msg = '${dur.inHours} h';
    } else if (dur.inMinutes > 0) {
      msg = '${dur.inMinutes} m';
    } else if (dur.inSeconds > 0) {
      msg = '${dur.inSeconds} s';
    } else {
      msg = 'now';
    }
    return msg;
  }

  static share(String message, {String? subject}) {
    Share.share(message, subject: subject);
  }

  static openLink(link) async {
    if (await canLaunchUrl(Uri.parse(link.url))) {
      await launchUrl(Uri.parse(link.url));
    } else {
      throw 'Could not launch $link';
    }
  }
}
