import 'package:flutter_local_notifications/flutter_local_notifications.dart' as n;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:university_scheduler/modals/course.dart' as c;
import 'package:university_scheduler/utils/utils.dart';
import 'package:timezone/timezone.dart' as tz;

import '../modals/course.dart';

class Settings {
  static Future<bool> saveSettings(NotificationSettings settings) async {
    n.FlutterLocalNotificationsPlugin plugin = n.FlutterLocalNotificationsPlugin();
    await plugin.cancelAll();
    await plugin.initialize(
      const n.InitializationSettings(
        android: n.AndroidInitializationSettings('splash'),
      ),
    );
    incrementId = 0;

    if (settings.minutesBeforeCourse != null || settings.timeAtNextDayOverview != null) {
      await Utils.retrieveCourses();
      List<Course> courses = Utils.courses;
      if (settings.minutesBeforeCourse != null) {
        for (Course course in courses) {
          await showNotification(
            title: '${course.name} Course Reminder',
            body:
                'You have ${course.code} / ${course.name} in ${course.location} after ${settings.minutesBeforeCourse} minutes',
            time: course.startTime.subtract(settings.minutesBeforeCourse!),
            daysOfTheWeek: course.courseDays.map((e) => e.index + 1).toList(),
            plugin: plugin,
          );
        }
      }

      if (settings.timeAtNextDayOverview != null) {
        Map<int, String> map = {};
        for (Course course in courses) {
          for (CourseDay courseDay in course.courseDays) {
            if (map[courseDay.index + 1] == null) {
              map[courseDay.index + 1] = '';
            }
            map[courseDay.index + 1] = '${map[courseDay.index + 1]!}\n${course.toNotificationString()}';
          }
        }
        for (MapEntry mapEntry in map.entries) {
          await showNotification(
            title: 'Summary for Tomorrow',
            body: mapEntry.value,
            time: settings.timeAtNextDayOverview!,
            daysOfTheWeek: [_getDayBefore(mapEntry.key)],
            plugin: plugin,
          );
        }
      }
    }

    SharedPreferences prefs = await SharedPreferences.getInstance();
    if (settings.minutesBeforeCourse != null) {
      await prefs.setInt('befMins', settings.minutesBeforeCourse!);
    } else {
      await prefs.remove('befMins');
    }
    if (settings.timeAtNextDayOverview != null) {
      await prefs.setString('atNext', settings.timeAtNextDayOverview!.toFormattedString());
    } else {
      await prefs.remove('atNext');
    }
    return true;
  }

  static int incrementId = 0;

  static Future<void> showNotification({
    required String title,
    required String body,
    required c.Time time,
    required List<int> daysOfTheWeek,
    required n.FlutterLocalNotificationsPlugin plugin,
  }) async {
    for (int day in daysOfTheWeek) {
      tz.TZDateTime dateTime = _getDateTime(time, day);

      await plugin.zonedSchedule(
        incrementId,
        title,
        body,
        dateTime,
        n.NotificationDetails(
          android: n.AndroidNotificationDetails(
            'University Scheduler',
            'University Scheduler',
            styleInformation: n.BigTextStyleInformation(body),
          ),
        ),
        uiLocalNotificationDateInterpretation: n.UILocalNotificationDateInterpretation.wallClockTime,
        androidAllowWhileIdle: true,
        matchDateTimeComponents: n.DateTimeComponents.dayOfWeekAndTime,
      );

      incrementId++;
    }
  }

  static Future<NotificationSettings> getSettings() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    int? befMins = prefs.getInt('befMins');
    String? atNextString = prefs.getString('atNext');
    c.Time? timeAtNext;
    if (atNextString != null) {
      timeAtNext = c.Time.fromStringWithoutType(atNextString);
    }
    return NotificationSettings(
      minutesBeforeCourse: befMins,
      timeAtNextDayOverview: timeAtNext,
    );
  }

  static _getDayBefore(int day) {
    if (day == 1) {
      return 7;
    } else {
      return day - 1;
    }
  }

  static tz.TZDateTime _getDateTime(c.Time time, int day) {
    final tz.TZDateTime now = tz.TZDateTime.now(tz.local);

    tz.TZDateTime firstDayOfMonth = tz.TZDateTime(now.location, now.year - 1, now.month, 1, time.getRealHour(), time.minute, 1);

    int dayDifference = (day - firstDayOfMonth.weekday + 8) % 7;
    DateTime finalDate = DateTime(now.year - 1, now.month, dayDifference, time.getRealHour(), time.minute, 1);
    return tz.TZDateTime.from(finalDate, tz.local);
  }

  static Future<void> saveSettingsDefault() async {
    await saveSettings(await getSettings());
  }
}

class NotificationSettings {
  int? minutesBeforeCourse;
  c.Time? timeAtNextDayOverview;

  NotificationSettings({
    this.minutesBeforeCourse,
    this.timeAtNextDayOverview,
  });
}
