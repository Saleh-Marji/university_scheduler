import 'package:flutter/material.dart';
import 'package:university_scheduler/constants.dart';
import 'package:university_scheduler/widgets/app_drawer.dart';
import 'package:university_scheduler/widgets/common_widgets.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: wGetAppBar(title: 'Settings'),
      drawer: AppDrawer(),
      body: ListView(
        children: [
          CheckboxListTile(
            value: true,
            onChanged: (value) {},
            title: Text('hello'),
          ),
        ],
      ),
    );
  }
}
