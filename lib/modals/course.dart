import 'package:flutter/material.dart';

class Course {
  String code;
  String name;
  String section;
  String location;
  String instructor;
  List<CourseDay> courseDays;
  Time startTime;
  Time endTime;

  Course({
    required this.code,
    required this.name,
    required this.section,
    required this.location,
    required this.instructor,
    required this.courseDays,
    required this.startTime,
    required this.endTime,
  });

  Course.fromJson(Map<String, dynamic> json)
      : code = json['code'],
        name = json['name'],
        section = json['section'],
        location = json['location'],
        instructor = json['instructor'],
        courseDays = _jsonStringToCourseDays(json['courseDays']),
        startTime = Time.fromString(json['startTime']),
        endTime = Time.fromString(json['endTime']);

  Map<String, String> toJson() {
    Map<String, String> map = {
      "code": code,
      "name": name,
      "section": section,
      "location": location,
      "instructor": instructor,
      "courseDays": _getDaysJsonString(),
      "startTime": startTime.toString(),
      "endTime": endTime.toString(),
    };
    return map;
  }

  @override
  String toString() {
    return '''
Code: $code
Name: $name
Location: $location
Section: $section
Instructor: $instructor
Time: $startTime to $endTime
Course Days: ${courseDaysToString(courseDays)}''';
  }

  static String courseDaysToString(List<CourseDay> courseDays) {
    String result = '';
    for (int i = 0; i < courseDays.length; i++) {
      if (i != 0) {
        result += ', ';
      }
      result += courseDayToString(courseDays[i]);
    }
    return result;
  }

  static String courseDayToString(CourseDay courseDay) {
    switch (courseDay) {
      case CourseDay.mon:
        return 'Mon';
      case CourseDay.tues:
        return 'Tues';
      case CourseDay.wed:
        return 'Wed';
      case CourseDay.thurs:
        return 'Thurs';
      case CourseDay.fri:
        return 'Fri';
    }
  }

  static String courseDayToFullString(CourseDay courseDay) {
    switch (courseDay) {
      case CourseDay.mon:
        return 'Monday';
      case CourseDay.tues:
        return 'Tuesday';
      case CourseDay.wed:
        return 'Wednesday';
      case CourseDay.thurs:
        return 'Thursday';
      case CourseDay.fri:
        return 'Friday';
    }
  }

  static CourseDay stringToCourseDay(String string) {
    switch (string) {
      case 'Mon':
        return CourseDay.mon;
      case 'Tues':
        return CourseDay.tues;
      case 'Wed':
        return CourseDay.wed;
      case 'Thurs':
        return CourseDay.thurs;
      case 'Fri':
        return CourseDay.fri;
    }
    return CourseDay.mon;
  }

  String toSimpleString() {
    return '''
🕛  At: $startTime
#️⃣  Code: $code
🔡  Name: $name
📍  Location: $location''';
  }

  String _getDaysJsonString() {
    String result = "";
    for (int i = 0; i < courseDays.length; i++) {
      result += courseDays[i].index.toString();
    }

    return result;
  }

  static List<CourseDay> _jsonStringToCourseDays(String json) {
    List<CourseDay> result = [];
    for (int i = 0; i < json.length; i++) {
      result.add(CourseDay.values[int.parse(json[i])]);
    }

    return result;
  }
}

class Time {
  int hour;
  int minute;
  TimeType type;

  Time(this.hour, this.minute, this.type);

  factory Time.fromString(String string) {
    return Time(
        int.parse(string.substring(0, 2)), int.parse(string.substring(3, 5)), _stringToType(string.substring(6)));
  }

  factory Time.fromTimeOfDay(TimeOfDay timeOfDay) {
    return Time(getUnRealHour(timeOfDay.hour), timeOfDay.minute, getType(timeOfDay.hour));
  }

  int compareTo(Time other) {
    int hour = getRealHour();
    int otherHour = getRealHour(other.hour, other.type);
    if (hour != otherHour) {
      return hour.compareTo(otherHour);
    } else {
      return minute.compareTo(other.minute);
    }
  }

  @override
  String toString() {
    return '${_intToString(hour)}:${_intToString(minute)} ${_typeToString()}';
  }

  String _intToString(int time) {
    if (time < 10) {
      return '0$time';
    } else {
      return time.toString();
    }
  }

  String _typeToString() {
    switch (type) {
      case TimeType.am:
        return 'AM';
      case TimeType.pm:
        return 'PM';
    }
  }

  static TimeType _stringToType(String string) {
    switch (string) {
      case 'AM':
        return TimeType.am;
      case 'PM':
        return TimeType.pm;
    }
    return TimeType.am;
  }

  int getRealHour([int? hour, TimeType? timeType]) {
    hour ??= this.hour;
    if (hour == 12) {
      if ((timeType ?? type) == TimeType.pm) {
        return 12;
      } else {
        return 0;
      }
    }

    if ((timeType ?? type) == TimeType.am) {
      return hour;
    } else {
      return hour + 12;
    }
  }

  TimeOfDay toTimeOfDay() {
    return TimeOfDay(hour: getRealHour(), minute: minute);
  }

  static int getUnRealHour(int hour) {
    if (hour == 0) {
      return 12;
    } else if (hour < 13) {
      return hour;
    } else {
      return hour % 12;
    }
  }

  static TimeType getType(int hour) {
    if (hour < 12) {
      return TimeType.am;
    } else {
      return TimeType.pm;
    }
  }
}

enum TimeType { am, pm }

enum CourseDay { mon, tues, wed, thurs, fri }
