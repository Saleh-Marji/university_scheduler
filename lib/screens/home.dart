import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:university_scheduler/constants.dart';
import 'package:university_scheduler/screens/course_details.dart';
import 'package:university_scheduler/utils/utils.dart';
import 'package:university_scheduler/widgets/common_widgets.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

import '../modals/course.dart';
import '../widgets/app_drawer.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: wGetAppBar(title: 'Welcome!'),
      drawer: AppDrawer(),
      body: _UpcomingCourseWidget(),
    );
  }
}

class _UpcomingCourseWidget extends StatefulWidget {
  const _UpcomingCourseWidget({Key? key}) : super(key: key);

  @override
  State<_UpcomingCourseWidget> createState() => _UpcomingCourseWidgetState();
}

class _UpcomingCourseWidgetState extends State<_UpcomingCourseWidget> {
  late Timer timer;

  late MapEntry<int, Course>? dayAndCourse;

  late Future<bool> coursesRetrieved = Utils.retrieveCourses();

  @override
  void initState() {
    super.initState();
    var flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
    flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>()
        ?.requestPermission();
    timer = Timer.periodic(Duration(seconds: 30), (timer) {
      setState(() {
        dayAndCourse = Utils.getCurrentCourse();
      });
    });
  }

  @override
  void dispose() {
    timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: coursesRetrieved,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        }
        dayAndCourse = Utils.getCurrentCourse();
        return RefreshIndicator(
          onRefresh: () async {
            await kRefreshIndicatorDelay;
            setState(() {
              coursesRetrieved = Utils.retrieveCourses();
            });
          },
          child: ListView(
            children: [
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    SizedBox(
                      width: double.infinity,
                      child: Material(
                        elevation: 3,
                        shadowColor: kColorBlue,
                        borderRadius: BorderRadius.circular(10),
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Upcoming course:',
                                style: kTextStyleMain,
                              ),
                              SizedBox(
                                height: 20,
                              ),
                              dayAndCourse != null
                                  ? Column(
                                      children: [
                                        _getDetail(Icons.schedule,
                                            'When: ${Course.courseDayToString(CourseDay.values[dayAndCourse!.key])} ${dayAndCourse!.value.startTime}'),
                                        _getDetail(Icons.numbers_rounded, 'Code: ${dayAndCourse!.value.code}'),
                                        _getDetail(Icons.text_snippet, 'Name: ${dayAndCourse!.value.name}'),
                                        _getDetail(
                                            CupertinoIcons.location_solid, 'Location: ${dayAndCourse!.value.location}'),
                                      ],
                                    )
                                  : Text(
                                      "You haven't added any courses!",
                                      style: kTextStyleMain,
                                    ),
                              ...(dayAndCourse != null
                                  ? [
                                      _HomeButton(
                                        label: 'View Full Course Details',
                                        icon: Icons.text_snippet_outlined,
                                        onPressed: () {
                                          Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                              builder: (context) => CourseInfoScreen(course: dayAndCourse!.value),
                                            ),
                                          );
                                        },
                                      ),
                                    ]
                                  : [])
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _getDetail(IconData icon, String content) => Container(
        margin: EdgeInsets.only(bottom: 5),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              margin: EdgeInsets.only(top: 4, right: 10),
              child: Icon(
                icon,
                color: kColorBlue,
              ),
            ),
            Expanded(
              child: Text(
                content,
                style: kTextStyleMain,
              ),
            )
          ],
        ),
      );
}

class _HomeButton extends StatelessWidget {
  const _HomeButton({Key? key, required this.label, required this.icon, required this.onPressed}) : super(key: key);

  final String label;
  final IconData icon;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.only(
        top: 20,
        bottom: 5,
      ),
      child: MaterialButton(
        padding: EdgeInsets.symmetric(vertical: 20, horizontal: 5),
        color: kColorYellow,
        onPressed: onPressed,
        elevation: 2,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(5),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Expanded(child: SizedBox()),
            Expanded(
              child: Icon(
                icon,
                color: kColorBlue,
              ),
            ),
            SizedBox(
              width: 10,
            ),
            Expanded(
              flex: 7,
              child: Text(
                label,
                style: kTextStyleMain,
              ),
            ),
            Expanded(child: SizedBox()),
          ],
        ),
      ),
    );
  }
}
