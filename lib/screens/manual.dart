import 'package:flutter/material.dart';
import 'package:university_scheduler/constants.dart';
import 'package:university_scheduler/widgets/app_drawer.dart';
import 'package:university_scheduler/widgets/common_widgets.dart';

class ManualScreen extends StatelessWidget {
  const ManualScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: wGetAppBar(title: 'Manual'),
      drawer: const AppDrawer(),
      body: ListView(
        children: _tips,
      ),
    );
  }

  List<Widget> get _tips => [
        _TipContent(
          'The Home Screen',
          'The upcoming and current courses are calculated every 30 seconds. If you wish to refresh slide the screen down',
        ),
        _TipContent(
          'View the Details of a Course',
          'If you want to view the details of your course press the info button next to the course\'s name in the "My Courses" screen',
        ),
        _TipContent(
          'Adding a Course',
          'You can add a course by pressing on the floating add button in the "My Courses" screen, note that you must fill out all of the fields or else the app will give you a snack bar telling you what\'s missing. When you\'re finished press the upper right action button in the appbar of the screen',
        ),
        _TipContent(
          'Edit a Course',
          'If you want to edit the details of a course press the edit button next to the course\'s name in the "My Courses" screen.  When you\'re finished press the upper right action button in the appbar of the screen',
        ),
        _TipContent(
          'Removing a Course',
          'You can remove a course by a long press on the container of the course',
        ),
        _TipContent(
          'Removing All Courses',
          'You can remove all courses by pressing the upper right action button in the appbar of the "My Courses" screen',
        ),
        _TipContent(
          'Confirmation',
          'Any kind of adding, editing, or removal of any course is confirmed before completion',
        ),
        _TipContent(
          'Schedule',
          'The schedule screen contains your courses sorted according to their corresponding days and hours, where each day contains all of the courses it has sorted by time (some courses may be duplicated)',
        ),
        _TipContent(
          'Schedule Refresh',
          'If you find anything odd with the order of the courses in your schedule or the info in it after editing them in the "My Courses" screen please try to swap the screen down and refresh it',
        ),
        _TipContent(
          'Schedule Filtering',
          'If you don\'t want to see all the days in the schedule, you can pick which days by pressing on the filtering appbar button on the top left of the "My Schedule" screen',
        ),
        _TipContent(
          'Saving',
          'Courses are automatically saved so that you don\'t have to enter them every time you enter the app',
        ),
        _TipContent(
          'Actions Are Undoable',
          'Note that any kind of removal of any course (removing a single course or removing all courses) or editing a course are not undoable',
        ),
        _TipContent(
          'Notifications Before Each Course',
          'In the "Settings Screen", if you enable this option, the app will send a reminder notification before a certain duration (default 15 minutes), and you can set it by clicking on it and typing the duration you want',
        ),
        _TipContent(
          'Summary Notifications',
          'In the "Settings Screen", if you enable this option, the app will send a summary notification before each day having at least one course, which contains the information about all the courses you have in the next day',
        ),
      ]
          .map((e) => Padding(
                padding: const EdgeInsets.all(16.0),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '-',
                      style: kTextStyleMain.copyWith(fontSize: 20),
                    ),
                    const SizedBox(
                      width: 10,
                    ),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            '${e.title}:',
                            style: kTextStyleMain.copyWith(fontSize: 20),
                          ),
                          Text(
                            '${e.content}.',
                            style: kTextStyleMain.copyWith(color: kColorLightBlue),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ))
          .toList();
}

class _TipContent {
  String title, content;
  _TipContent(this.title, this.content);
}
