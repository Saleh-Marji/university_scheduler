import 'dart:convert';
import 'dart:io';
import 'package:path_provider/path_provider.dart';

import '../modals/course.dart';

class Utils {
  static List<Course> _courses = [];

  static List<Course> get courses => [..._courses];

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
        print(result);
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

  static MapEntry<int, Course>? getCurrentCourse() {
    if (_courses.isEmpty) {
      return null;
    }

    DateTime now = DateTime.now();

    now = DateTime(2023, 5, now.weekday, now.hour, now.minute);

    if (_courses.length == 1) {
      int resultDay = 1;
      for (CourseDay day in _courses[0].courseDays) {
        if ((day.index + 1) >= now.day) {
          resultDay = day.index + 1;
        }
      }
      return MapEntry(resultDay - 1, _courses[0]);
    }

    MapEntry<int, Course>? result;

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
        result = MapEntry(value.dateTime.day - 1, _courses[value.index]);
        break;
      }
    }
    result ??= MapEntry(dateTimes[0].dateTime.day - 1, _courses[dateTimes[0].index]);

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
