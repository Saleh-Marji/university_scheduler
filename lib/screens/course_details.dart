import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:university_scheduler/constants.dart';
import 'package:university_scheduler/modals/course.dart';
import 'package:university_scheduler/widgets/common_widgets.dart';

class CourseInfoScreen extends StatelessWidget {
  const CourseInfoScreen({required this.course, Key? key}) : super(key: key);

  final Course course;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: wGetAppBar(title: '${course.code} info'),
      body: ListView(
          children: [
        _InfoItem(
          icon: Icons.numbers,
          label: 'Code',
          content: course.code,
        ),
        _InfoItem(
          icon: Icons.text_snippet,
          label: 'Name',
          content: course.name,
        ),
        _InfoItem(
          icon: Icons.video_label,
          label: 'Section',
          content: course.section,
        ),
        _InfoItem(
          icon: CupertinoIcons.location_solid,
          label: 'Location',
          content: course.location,
        ),
        _InfoItem(
          icon: Icons.face,
          label: 'Instructor',
          content: course.instructor,
        ),
        _InfoItem(
          icon: Icons.calendar_month,
          label: 'Course Days',
          content: Course.courseDaysToString(course.courseDays),
        ),
        _InfoItem(
          icon: Icons.timelapse_outlined,
          label: 'Time',
          content: '${course.startTime.toString()} - ${course.endTime.toString()}',
        ),
      ].map((item) => _detailContainer(item)).toList()),
    );
  }

  Widget _detailContainer(_InfoItem item) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: 20.0,
        vertical: 15,
      ),
      child: Row(
        mainAxisSize: MainAxisSize.max,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  margin: EdgeInsets.only(top: 2),
                  child: Icon(
                    item.icon,
                    color: kColorBlue,
                    size: 30,
                  ),
                ),
                SizedBox(
                  width: 8,
                ),
                Expanded(
                  child: Text(
                    '${item.label}:',
                    style: kTextStyleMain,
                  ),
                ),
              ],
            ),
          ),
          SizedBox(
            width: 10,
          ),
          Expanded(
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    item.content,
                    style: kTextStyleMain.copyWith(color: kColorLightBlue),
                  ),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}

class _InfoItem {
  IconData icon;
  String label;
  String content;

  _InfoItem({
    required this.icon,
    required this.label,
    required this.content,
  });
}
