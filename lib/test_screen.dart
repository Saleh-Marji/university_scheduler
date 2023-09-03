import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:university_scheduler/utils/settings.dart';
import 'package:university_scheduler/widgets/common_widgets.dart';
import 'modals/course.dart' as c;
import 'package:timezone/timezone.dart' as tz;

class TestScreen extends StatelessWidget {
  const TestScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: wGetAppBar(title: 'Test'),
      body: Center(
        child: MaterialButton(
          onPressed: () async {
            FlutterLocalNotificationsPlugin plugin = FlutterLocalNotificationsPlugin();

            await plugin.initialize(const InitializationSettings(
              android: AndroidInitializationSettings('splash'),
            ));

            await plugin.cancelAll();

            var now = DateTime.now();

            Settings.showNotification(
              title: 'title',
              body: 'body',
              time: c.Time(now.hour, now.minute, c.TimeType.am),
              daysOfTheWeek: [7],
              plugin: plugin,
            );

            // await plugin.zonedSchedule(
            //   1,
            //   'title',
            //   'body',
            //   tz.TZDateTime.from(DateTime.now().add(const Duration(seconds: 3)), tz.local),
            //   const NotificationDetails(android: AndroidNotificationDetails('hello', 'bello')),
            //   uiLocalNotificationDateInterpretation: UILocalNotificationDateInterpretation.absoluteTime,
            //   androidAllowWhileIdle: true,
            //   matchDateTimeComponents: DateTimeComponents.dayOfWeekAndTime,
            // );
          },
          child: const Text('push notification'),
        ),
      ),
    );
  }
}
