import 'dart:math';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:twitter_flutter/helper/constants.dart';
import 'dart:developer' as devtools show log;

class Utility {
  static void cprint(dynamic data) {
    devtools.log(data.toString());
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
}
