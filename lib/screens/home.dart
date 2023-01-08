import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:university_scheduler/constants.dart';
import 'package:university_scheduler/modals/course_and_day.dart';
import 'package:university_scheduler/screens/course_details.dart';
import 'package:university_scheduler/utils/utils.dart';
import 'package:university_scheduler/widgets/common_widgets.dart';

import '../modals/course.dart';
import '../widgets/app_drawer.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: wGetAppBar(
        title: 'Welcome!',
        actions: [
          IconButton(
            onPressed: () {
              Navigator.pushNamed(context, kSettingsRoute);
            },
            icon: const Icon(Icons.settings),
          )
        ],
      ),
      drawer: const AppDrawer(),
      body: const _UpcomingCourseWidget(),
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

  late Map<String, CourseAndDay> courses;

  late Future<bool> coursesRetrieved = Utils.retrieveCourses();

  @override
  void initState() {
    super.initState();
    timer = Timer.periodic(const Duration(seconds: 30), (timer) {
      setState(() {
        courses = Utils.getToPresentCourses();
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
          return const Center(child: CircularProgressIndicator());
        }
        courses = Utils.getToPresentCourses();
        return RefreshIndicator(
          onRefresh: () async {
            await kRefreshIndicatorDelay;
            setState(() {
              coursesRetrieved = Utils.retrieveCourses();
            });
          },
          child: courses.isEmpty
              ? Stack(
                  children: [
                    ListView(),
                    const Center(
                      child: Padding(
                        padding: EdgeInsets.all(20.0),
                        child: Text(
                          'You haven\'t added any courses yet!',
                          style: kTextStyleMain,
                          textAlign: TextAlign.center,
                        ),
                      ),
                    )
                  ],
                )
              : ListView(
                  children: _getCourses(),
                ),
        );
      },
    );
  }

  List<Widget> _getCourses() {
    List<Widget> result = [];

    CourseAndDay? currentCourse = courses['currentCourse'];
    if (currentCourse != null) {
      result.add(CourseContainer(
        courseAndDay: currentCourse,
        label: 'Current course:',
        timeLabel: '${currentCourse.course.startTime} - ${currentCourse.course.endTime}',
      ));
    }

    CourseAndDay? upcomingCourse = courses['upcomingCourse'];
    if (upcomingCourse != null) {
      result.add(
        CourseContainer(
          courseAndDay: upcomingCourse,
          label: 'Upcoming course:',
          timeLabel:
              'When: ${Course.courseDayToString(CourseDay.values[upcomingCourse.day])} ${upcomingCourse.course.startTime}',
        ),
      );
    }
    return result;
  }
}

class CourseContainer extends StatelessWidget {
  const CourseContainer({required this.courseAndDay, required this.label, Key? key, required this.timeLabel})
      : super(key: key);

  final CourseAndDay courseAndDay;
  final String label;
  final String timeLabel;

  @override
  Widget build(BuildContext context) {
    return Padding(
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
                      label,
                      style: kTextStyleMain,
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    Column(
                      children: [
                        _getDetail(Icons.schedule, timeLabel),
                        _getDetail(Icons.numbers_rounded, 'Code: ${courseAndDay.course.code}'),
                        _getDetail(Icons.text_snippet, 'Name: ${courseAndDay.course.name}'),
                        _getDetail(CupertinoIcons.location_solid, 'Location: ${courseAndDay.course.location}'),
                      ],
                    ),
                    _HomeButton(
                      label: 'View Full Course Details',
                      icon: Icons.text_snippet_outlined,
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => CourseInfoScreen(course: courseAndDay.course),
                          ),
                        );
                      },
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _getDetail(IconData icon, String content) => Container(
        margin: const EdgeInsets.only(bottom: 5),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              margin: const EdgeInsets.only(top: 4, right: 10),
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
      padding: const EdgeInsets.only(
        top: 20,
        bottom: 5,
      ),
      child: MaterialButton(
        padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 5),
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
            const Expanded(child: SizedBox()),
            Expanded(
              child: Icon(
                icon,
                color: kColorBlue,
              ),
            ),
            const SizedBox(
              width: 10,
            ),
            Expanded(
              flex: 7,
              child: Text(
                label,
                style: kTextStyleMain,
              ),
            ),
            const Expanded(child: SizedBox()),
          ],
        ),
      ),
    );
  }
}
