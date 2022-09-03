// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

ThemeData apptheme = ThemeData(
    primarySwatch: Colors.blue,
    fontFamily: GoogleFonts.openSans().toString(),
    backgroundColor: Colors.white,
    accentColor: TwitterColor.dodgetBlue.withAlpha(20),
    brightness: Brightness.light,
    primaryColor: TwitterColor.dodgetBlue,
    cardColor: Colors.white,
    unselectedWidgetColor: Colors.grey,
    bottomAppBarColor: Colors.white,
    textTheme: TextTheme(
      headline1: GoogleFonts.roboto(
          fontSize: 97, fontWeight: FontWeight.w300, letterSpacing: -1.5),
      headline2: GoogleFonts.roboto(
          fontSize: 61, fontWeight: FontWeight.w300, letterSpacing: -0.5),
      headline3: GoogleFonts.roboto(fontSize: 48, fontWeight: FontWeight.w400),
      headline4: GoogleFonts.roboto(
          fontSize: 34, fontWeight: FontWeight.w400, letterSpacing: 0.25),
      headline5: GoogleFonts.roboto(fontSize: 24, fontWeight: FontWeight.w400),
      headline6: GoogleFonts.roboto(
          fontSize: 20, fontWeight: FontWeight.w500, letterSpacing: 0.15),
      subtitle1: GoogleFonts.roboto(
          fontSize: 16, fontWeight: FontWeight.w400, letterSpacing: 0.15),
      subtitle2: GoogleFonts.roboto(
          fontSize: 14, fontWeight: FontWeight.w500, letterSpacing: 0.1),
      bodyText1: GoogleFonts.roboto(
          fontSize: 16, fontWeight: FontWeight.w400, letterSpacing: 0.5),
      bodyText2: GoogleFonts.roboto(
          fontSize: 14, fontWeight: FontWeight.w400, letterSpacing: 0.25),
      button: GoogleFonts.roboto(
          fontSize: 14, fontWeight: FontWeight.w500, letterSpacing: 1.25),
      caption: GoogleFonts.roboto(
          fontSize: 12, fontWeight: FontWeight.w400, letterSpacing: 0.4),
      overline: GoogleFonts.roboto(
          fontSize: 10, fontWeight: FontWeight.w400, letterSpacing: 1.5),
    ),

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

class AppColor {
  static const Color primary = Color(0xff1DA1F2);
  static const Color secondary = Color(0xff14171A);
  static const Color darkGrey = Color(0xFFffFFF);
  static const Color lightGrey = Color(0xffAAB8C2);
  static const Color extraLightGrey = Color(0xffE1E8ED);
  static const Color extraExtraLightGrey = Color(0x0ff5f8fa);
  static const Color white = Color(0xFFffffff);
}
