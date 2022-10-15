import 'package:flutter/material.dart';
import 'package:university_scheduler/widgets/common_widgets.dart';

class TestScreen extends StatelessWidget {
  const TestScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: wGetAppBar(title: 'Test'),
      body: Center(
        child: MaterialButton(
          onPressed: () {},
          child: Text('push notification'),
        ),
      ),
    );
  }
}
