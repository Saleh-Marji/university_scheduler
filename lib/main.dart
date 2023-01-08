import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:university_scheduler/constants.dart';
import 'package:university_scheduler/screens/contact_info.dart';
import 'package:university_scheduler/screens/courses.dart';
import 'package:university_scheduler/screens/home.dart';
import 'package:university_scheduler/screens/manual.dart';
import 'package:university_scheduler/screens/schedule.dart';
import 'package:university_scheduler/screens/settings.dart';
import 'package:timezone/data/latest.dart' as tz;

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);
  tz.initializeTimeZones();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      initialRoute: kHomeRoute,
      // home: TestScreen(),
      theme: ThemeData.light().copyWith(
        scaffoldBackgroundColor: Colors.white,
      ),
      debugShowCheckedModeBanner: false,
      routes: {
        kHomeRoute: (context) => const HomeScreen(),
        kCoursesRoute: (context) => const CoursesScreen(),
        kManualRoute: (context) => const ManualScreen(),
        kScheduleRoute: (context) => const ScheduleScreen(),
        kContactInfoRoute: (context) => const ContactInfoScreen(),
        kSettingsRoute: (context) => SettingsScreen(),
      },
    );
  }
}
