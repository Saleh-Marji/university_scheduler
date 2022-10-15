import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:university_scheduler/constants.dart';
import 'package:university_scheduler/screens/contact_info.dart';
import 'package:university_scheduler/screens/courses.dart';
import 'package:university_scheduler/screens/home.dart';
import 'package:university_scheduler/screens/manual.dart';
import 'package:university_scheduler/screens/schedule.dart';
import 'package:university_scheduler/screens/settings.dart';
import 'package:university_scheduler/test_screen.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      home: TestScreen(),
      //initialRoute: kHomeRoute,
      theme: ThemeData.light().copyWith(
        scaffoldBackgroundColor: Colors.white,
      ),
      debugShowCheckedModeBanner: false,
      routes: {
        kHomeRoute: (context) => HomeScreen(),
        kCoursesRoute: (context) => CoursesScreen(),
        kManualRoute: (context) => ManualScreen(),
        kScheduleRoute: (context) => ScheduleScreen(),
        kContactInfoRoute: (context) => ContactInfoScreen(),
        kSettingsRoute: (context) => SettingsScreen(),
      },
    );
  }
}
