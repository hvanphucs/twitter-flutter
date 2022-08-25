// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';

ThemeData apptheme = ThemeData(
    primarySwatch: Colors.blue,
    fontFamily: 'HelveticaNeue',
    backgroundColor: Colors.white,
    accentColor: TwitterColor.dodgetBlue.withAlpha(20),
    brightness: Brightness.light,
    primaryColor: TwitterColor.dodgetBlue,
    cardColor: Colors.white,
    unselectedWidgetColor: Colors.grey,
    bottomAppBarColor: Colors.white,

    // textTheme:  TextTheme(
    //   title:    TextStyle(color: Colors.black,  fontSize: 20),
    //   body1:    TextStyle(color: Colors.black87,fontSize: 14),
    //   body2:    TextStyle(color: Colors.black87,fontSize: 18),
    //   button:   TextStyle(color: Colors.white,  fontSize: 20),
    //   caption:  TextStyle(color: Colors.black45,fontSize: 16),
    //   headline: TextStyle(color: Colors.black87,fontSize: 26),
    //   subhead:  TextStyle(color: Colors.black,  fontSize: 12,fontWeight: FontWeight.w600,fontFamily: 'Opensans-Bold'),
    //   subtitle: TextStyle(color: Colors.black54,fontSize: 12,fontWeight: FontWeight.w600,fontFamily: 'Opensans-Bold'),
    //   display1: TextStyle(color: Colors.black87,fontSize: 14),
    //   display2: TextStyle(color: Colors.black87,fontSize: 18),
    //   display3: TextStyle(color: Colors.black87,fontSize: 22),
    //   display4: TextStyle(color: Colors.black87,fontSize: 24),
    //   overline: TextStyle(color: Colors.black87,fontSize: 10),
    //   ),

    // typography: Typography(
    //   dense: TextTheme(
    //     title:    TextStyle(color: Colors.black,  fontSize: 16,fontWeight: FontWeight.w600,fontFamily: 'Opensans-SemiBold'),
    //     body1:    TextStyle(color: Colors.black87,fontSize: 8,fontWeight: FontWeight.w600,fontFamily: 'Opensans-SemiBold'),
    //     body2:    TextStyle(color: Colors.black87,fontSize: 10,fontWeight: FontWeight.w600,fontFamily: 'Opensans-SemiBold'),
    //     button:   TextStyle(color: Colors.black,  fontSize: 12,fontWeight: FontWeight.w600,fontFamily: 'Opensans-SemiBold'),
    //     caption:  TextStyle(color: Colors.black45,fontSize: 14,fontWeight: FontWeight.w600,fontFamily: 'Opensans-SemiBold'),
    //     headline: TextStyle(color: Colors.black87,fontSize: 16,fontWeight: FontWeight.w600,fontFamily: 'Opensans-SemiBold'),
    //     subhead:  TextStyle(color: Colors.black,  fontSize: 20,fontWeight: FontWeight.w600,fontFamily: 'Opensans-SemiBold'),
    //     subtitle: TextStyle(color: Colors.black54,fontSize: 22,fontWeight: FontWeight.w600,fontFamily: 'Opensans-SemiBold'),
    //     display1: TextStyle(color: Colors.black87,fontSize: 14,fontWeight: FontWeight.w600,fontFamily: 'Opensans-SemiBold'),
    //     display2: TextStyle(color: Colors.black87,fontSize: 16,fontWeight: FontWeight.w600,fontFamily: 'Opensans-SemiBold'),
    //     display3: TextStyle(color: Colors.black87,fontSize: 20,fontWeight: FontWeight.w600,fontFamily: 'Opensans-SemiBold'),
    //     display4: TextStyle(color: Colors.black87,fontSize: 22,fontWeight: FontWeight.w600,fontFamily: 'Opensans-SemiBold'),
    //     overline: TextStyle(color: Colors.black87,fontSize: 8,fontWeight: FontWeight.w600,fontFamily: 'Opensans-SemiBold'),
    //   )
    // ),
    // buttonTheme: ButtonThemeData(
    //   buttonColor: Colors.white,
    //   textTheme: ButtonTextTheme.normal,
    //   disabledColor: Colors.grey,
    //   height: 40,
    //   highlightColor: Colors.yellow.shade300,
    //   splashColor: Colors.purpleAccent,
    // ),
    floatingActionButtonTheme: const FloatingActionButtonThemeData(
      backgroundColor: TwitterColor.dodgetBlue,
    ),
    colorScheme: const ColorScheme(
        background: Colors.white,
        onPrimary: Colors.white,
        onBackground: Colors.black,
        onError: Colors.white,
        onSecondary: Colors.white,
        onSurface: Colors.black,
        error: Colors.red,
        primary: Colors.blue,
        primaryVariant: Colors.blue,
        secondary: Colors.black,
        secondaryVariant: Colors.black,
        surface: Colors.white,
        brightness: Brightness.light));
List<BoxShadow> shadow = <BoxShadow>[
  const BoxShadow(blurRadius: 10, offset: Offset(5, 5), spreadRadius: 1)
];
String get description {
  return '';
}

TextStyle get onPrimaryTitleText {
  return const TextStyle(color: Colors.red, fontWeight: FontWeight.w600);
}

TextStyle get onPrimarySubTitleText {
  return const TextStyle(
    color: Colors.red,
  );
}

BoxDecoration softDecoration = const BoxDecoration(boxShadow: <BoxShadow>[
  BoxShadow(
      blurRadius: 8,
      offset: Offset(5, 5),
      color: Color(0xffe2e5ed),
      spreadRadius: 5),
  BoxShadow(
      blurRadius: 8,
      offset: Offset(-5, -5),
      color: Color(0xffffffff),
      spreadRadius: 5)
], color: Color(0xfff1f3f6));
TextStyle get titleStyle {
  return const TextStyle(
      color: Colors.black, fontSize: 18, fontWeight: FontWeight.bold);
}

TextStyle get subtitleStyle {
  return const TextStyle(
      color: Colors.black54, fontSize: 15, fontWeight: FontWeight.bold);
}

class TwitterColor {
  static const Color bondiBlue = Color.fromRGBO(0, 132, 180, 1.0);
  static const Color cerulean = Color.fromRGBO(0, 172, 237, 1.0);
  static const Color spindle = Color.fromRGBO(192, 222, 237, 1.0);
  static const Color white = Color.fromRGBO(255, 255, 255, 1.0);
  static const Color black = Color.fromRGBO(0, 0, 0, 1.0);
  static const Color woodsmoke = Color.fromRGBO(20, 23, 2, 1.0);
  static const Color woodsmoke_50 = Color.fromRGBO(20, 23, 2, 0.5);
  static const Color mystic = Color.fromRGBO(230, 236, 240, 1.0);
  static const Color dodgetBlue = Color.fromRGBO(29, 162, 240, 1.0);
  static const Color dodgetBlue_50 = Color.fromRGBO(29, 162, 240, 0.5);
  static const Color paleSky = Color.fromRGBO(101, 118, 133, 1.0);
  static const Color ceriseRed = Color.fromRGBO(224, 36, 94, 1.0);
  static const Color paleSky50 = Color.fromRGBO(101, 118, 133, 0.5);
}
