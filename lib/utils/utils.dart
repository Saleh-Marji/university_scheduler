import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:university_scheduler/modals/start_and_end_time.dart';
import 'package:university_scheduler/utils/settings.dart';

import '../modals/course.dart';
import '../modals/course_and_day.dart';

class Utils {
  static final List<Course> _courses = [];

  static List<Course> get courses => [..._courses];

  static void setTextForController(TextEditingController controller, String text) {
    controller.text = text;
    controller.selection = TextSelection.fromPosition(TextPosition(offset: controller.text.length));
  }

  static List<Course> get coursesForSchedule {
    List<Course> result = [];
    for (Course course in _courses) {
      for (CourseDay day in course.courseDays) {
        result.add(Course(
          code: course.code,
          name: course.name,
          section: course.section,
          location: course.location,
          instructor: course.instructor,
          startTime: course.startTime,
          endTime: course.endTime,
          courseDays: [day],
        ));
      }
    }
    sortCoursesByDate(result);
    return result;
  }

  static Future<void> addCourse(Course course) async {
    _courses.add(course);
    sortCoursesByDate();
    await saveCourses();
  }

  static void sortCoursesByDate([List<Course>? courses]) {
    (courses ?? _courses).sort((a, b) {
      CourseDay aDay = a.courseDays[0];
      CourseDay bDay = b.courseDays[0];

      int result = 0;

      if (aDay != bDay) {
        result = aDay.index.compareTo(bDay.index);
      } else {
        result = a.startTime.compareTo(b.startTime);
      }
      return result;
    });
  }

  static Future<void> removeCourse(Course course) async {
    _courses.remove(course);
    await saveCourses();
  }

  static Future<void> editCourse(int index, Course newCourse) async {
    _courses[index] = newCourse;
    await saveCourses();
  }

  static Future<void> clearCourses() async {
    _courses.clear();
    await saveCourses();
  }

  static CourseAndDay? _getUpcomingCourse() {
    if (_courses.isEmpty) {
      return null;
    }

    DateTime now = DateTime.now();

    now = DateTime(2023, 5, now.weekday, now.hour, now.minute);

    CourseAndDay? result;

    List<CourseDateTime> dateTimes = [];

    for (int i = 0; i < _courses.length; i++) {
      Course course = _courses[i];
      List<int> daysToAdd = course.courseDays.map((e) => (e.index + 1)).toList();
      for (int day in daysToAdd) {
        dateTimes.add(
          CourseDateTime(
            i,
            DateTime(2023, 5, day, course.startTime.getRealHour(), course.startTime.minute),
          ),
        );
      }
    }
    dateTimes.sort((a, b) => a.dateTime.compareTo(b.dateTime));
    for (CourseDateTime value in dateTimes) {
      if (value.dateTime.isAfter(now)) {
        result = CourseAndDay(day: value.dateTime.day - 1, course: _courses[value.index]);
        break;
      }
    }
    result ??= CourseAndDay(day: dateTimes[0].dateTime.day - 1, course: _courses[dateTimes[0].index]);

    return result;
  }

  static CourseAndDay? _getCurrentCourse() {
    if (_courses.isEmpty) {
      return null;
    }

    DateTime now = DateTime.now();

    now = DateTime(2023, 5, now.weekday, now.hour, now.minute);

    CourseAndDay? result;

    List<CourseStartAndEndTime> times = [];

    for (int i = 0; i < _courses.length; i++) {
      Course course = _courses[i];
      List<int> daysToAdd = course.courseDays.map((e) => (e.index + 1)).toList();
      for (int day in daysToAdd) {
        times.add(
          CourseStartAndEndTime(
            i,
            StartAndEndTime(
              startTime: DateTime(2023, 5, day, course.startTime.getRealHour(), course.startTime.minute),
              endTime: DateTime(2023, 5, day, course.endTime.getRealHour(), course.endTime.minute + 1),
            ),
          ),
        );
      }

      times.sort((a, b) => a.time.startTime.compareTo(b.time.startTime));
      for (CourseStartAndEndTime value in times) {
        if (now.isAfter(value.time.startTime) && value.time.endTime.isAfter(now)) {
          result = CourseAndDay(day: value.time.startTime.day - 1, course: _courses[value.index]);
          break;
        }
      }
    }

    return result;
  }

  static Map<String, CourseAndDay> getToPresentCourses() {
    Map<String, CourseAndDay> result = <String, CourseAndDay>{};
    CourseAndDay? upcomingCourse = _getUpcomingCourse();
    if (upcomingCourse != null) {
      result['upcomingCourse'] = upcomingCourse;
    }
    CourseAndDay? currentCourse = _getCurrentCourse();
    if (currentCourse != null) {
      result['currentCourse'] = currentCourse;
    }
    return result;
  }

  static Future<String> getFilePath() async {
    Directory appDocumentsDirectory = await getApplicationDocumentsDirectory();
    String appDocumentsPath = appDocumentsDirectory.path;
    String filePath = '$appDocumentsPath/courses.json';

    return filePath;
  }

  static Future<bool> saveCourses() async {
    File file = File(await getFilePath());
    if (!(await file.exists())) {
      file = await file.create();
    }
    Map<String, String> map = {};
    for (int i = 0; i < _courses.length; i++) {
      map[i.toString()] = jsonEncode(_courses[i], toEncodable: (course) {
        return (course as Course).toJson();
      });
    }
    await file.writeAsString(jsonEncode(map));
    await Settings.saveSettingsDefault();
    return true;
  }

  static Future<bool> retrieveCourses() async {
    File file = File(await getFilePath());
    if (!(await file.exists())) {
      file = await file.create();
      return true;
    }
    String fileContent = await File(await getFilePath()).readAsString();
    Map<String, dynamic> map = jsonDecode(fileContent);

    _courses.clear();

    for (int i = 0; i < map.keys.length; i++) {
      _courses.add(Course.fromJson(jsonDecode(map[i.toString()] ?? '')));
    }

    sortCoursesByDate();

    return true;
  }
}

class CourseDateTime {
  int index;
  DateTime dateTime;

  CourseDateTime(this.index, this.dateTime);
}

class CourseStartAndEndTime {
  int index;
  StartAndEndTime time;

  CourseStartAndEndTime(this.index, this.time);
}
