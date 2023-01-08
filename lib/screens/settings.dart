import 'package:flutter/material.dart';
import 'package:university_scheduler/constants.dart';
import 'package:university_scheduler/modals/course.dart';
import 'package:university_scheduler/utils/utils.dart';
import 'package:university_scheduler/widgets/app_drawer.dart';
import 'package:university_scheduler/widgets/common_widgets.dart';

import '../utils/settings.dart';

class SettingsScreen extends StatelessWidget {
  SettingsScreen({Key? key}) : super(key: key);

  final Future<NotificationSettings> notificationSettingsFuture = Settings.getSettings();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: wGetAppBar(title: 'Settings'),
      drawer: const AppDrawer(),
      body: FutureBuilder<NotificationSettings>(
        future: notificationSettingsFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            print(snapshot.error);
            print(snapshot.stackTrace);
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Text(
                  snapshot.error.toString(),
                  style: kTextStyleMain,
                  textAlign: TextAlign.center,
                ),
              ),
            );
          }
          NotificationSettings settings = snapshot.data!;
          return _Body(settings);
        },
      ),
    );
  }
}

class _Body extends StatefulWidget {
  const _Body(this.settings, {Key? key}) : super(key: key);

  final NotificationSettings settings;

  @override
  State<_Body> createState() => _BodyState();
}

class _BodyState extends State<_Body> {
  late TextEditingController minutesController;

  @override
  void initState() {
    super.initState();
    minutesController = TextEditingController(text: widget.settings.minutesBeforeCourse?.toString());
  }

  @override
  void dispose() {
    minutesController.dispose();
    super.dispose();
  }

  final shape = RoundedRectangleBorder(
    borderRadius: BorderRadius.circular(10),
    side: const BorderSide(),
  );

  @override
  Widget build(BuildContext context) {
    return ListView(
      children: [
        _getMyColumnContainer([
          _minutesCheckBoxTile,
          if (widget.settings.minutesBeforeCourse != null) _minutesField,
        ]),
        _getMyColumnContainer([
          _timeCheckBoxTile,
          if (widget.settings.timeAtNextDayOverview != null) _timeField,
        ]),
      ],
    );
  }

  Widget _getMyColumnContainer(List<Widget> children) => Container(
        margin: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          border: Border.all(),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Column(
            children: children,
          ),
        ),
      );

  Widget get _minutesCheckBoxTile => getCheckBoxTile(
        value: widget.settings.minutesBeforeCourse != null,
        title: 'Show notification before course:',
        subtitle: 'Show a notification before a specific duration before each course',
        onChanged: (value) {
          if (value ?? false) {
            widget.settings.minutesBeforeCourse = 15;
            minutesController.text = widget.settings.minutesBeforeCourse!.toString();
            Settings.saveSettings(widget.settings);
          } else {
            widget.settings.minutesBeforeCourse = null;
            Settings.saveSettings(widget.settings);
          }
          setState(() {});
        },
      );

  Widget get _minutesField => ListTile(
        title: const Text(
          'Before how much:',
        ),
        subtitle: const Text('0 - 60 mins'),
        trailing: SizedBox(
          width: 100,
          child: TextFormField(
            controller: minutesController,
            decoration: const InputDecoration(
              suffix: Text('Minutes'),
            ),
            style: const TextStyle(),
            keyboardType: TextInputType.number,
            onChanged: (input) {
              if (input.isEmpty) {
                Utils.setTextForController(
                  minutesController,
                  0.toString(),
                );
                input = 0.toString();
              }
              if (int.tryParse(input) == null) {
                Utils.setTextForController(
                  minutesController,
                  widget.settings.minutesBeforeCourse!.toString(),
                );
                return;
              }
              if (input.length == 2 && input[0] == '0') {
                minutesController.text = input[1];
                Utils.setTextForController(
                  minutesController,
                  input[1],
                );
                input = input[1];
              }
              int value = int.parse(input);
              if (value < 0) {
                Utils.setTextForController(
                  minutesController,
                  0.toString(),
                );
              } else if (value > 60) {
                Utils.setTextForController(
                  minutesController,
                  60.toString(),
                );
              }
              widget.settings.minutesBeforeCourse = int.parse(minutesController.text);
              Settings.saveSettings(widget.settings);
            },
          ),
        ),
      );

  Widget get _timeCheckBoxTile => getCheckBoxTile(
        value: widget.settings.timeAtNextDayOverview != null,
        title: 'Show summary notification:',
        subtitle: 'Show a notification at a specific time containing the summary for the next day',
        onChanged: (value) {
          if (value ?? false) {
            widget.settings.timeAtNextDayOverview = Time(9, 00, TimeType.pm);
            Settings.saveSettings(widget.settings);
          } else {
            widget.settings.timeAtNextDayOverview = null;
            Settings.saveSettings(widget.settings);
          }
          setState(() {});
        },
      );

  Widget get _timeField => ListTile(
        title: const Text(
          'At Which Time:',
        ),
        subtitle: const Text('Any time'),
        trailing: GestureDetector(
          onTap: () async {
            TimeOfDay? input = await showDialog(
              context: context,
              builder: (context) => Theme(
                data: Theme.of(context).copyWith(
                  colorScheme: const ColorScheme.light(
                    primary: kColorBlue,
                  ),
                ),
                child: TimePickerDialog(
                  initialTime: widget.settings.timeAtNextDayOverview!.toTimeOfDay(),
                ),
              ),
            );

            if (input == null) {
              return;
            }

            Time timeInput = Time.fromTimeOfDay(input);

            widget.settings.timeAtNextDayOverview = timeInput;
            setState(() {});
            Settings.saveSettings(widget.settings);
          },
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(widget.settings.timeAtNextDayOverview!.toString()),
              const SizedBox(
                width: 10,
              ),
              const Icon(Icons.edit),
            ],
          ),
        ),
      );

  Widget getCheckBoxTile({
    required bool value,
    required ValueChanged onChanged,
    required String title,
    required String subtitle,
  }) {
    return CheckboxListTile(
      value: value,
      contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      title: Text(
        title,
      ),
      subtitle: Padding(
        padding: const EdgeInsets.only(top: 8.0),
        child: Text(subtitle),
      ),
      activeColor: kColorLightBlue,
      onChanged: onChanged,
    );
  }
}
