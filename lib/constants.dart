import 'package:flutter/material.dart';

const kFontPrimary = 'QuickSand';

Future get kRefreshIndicatorDelay => Future.delayed(const Duration(milliseconds: 300));

Widget get kNoCoursesCenteredText => const Padding(
      padding: EdgeInsets.all(16.0),
      child: Center(
        child: Text(
          'You haven\'t added any courses!',
          style: kTextStyleMain,
          textAlign: TextAlign.center,
        ),
      ),
    );

const TextStyle //textStyles
    kTextStyleMain = TextStyle(
  fontFamily: kFontPrimary,
  fontWeight: FontWeight.w600,
  color: kColorBlue,
  height: 1.5,
  fontSize: 18,
);

const Color //colors
    kColorLightBlue = Color(0xff295abd),
    kColorBlue = Color(0xff1e3669),
    kColorYellow = Color(0xfff2d944);

const String //routes
    kHomeRoute = 'home',
    kCoursesRoute = 'courses',
    kManualRoute = 'manual',
    kScheduleRoute = 'schedule',
    kContactInfoRoute = 'contact_info',
    kSettingsRoute = 'settings';
