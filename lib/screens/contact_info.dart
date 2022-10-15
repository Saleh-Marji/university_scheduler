import 'package:flutter/material.dart';
import 'package:university_scheduler/constants.dart';
import 'package:university_scheduler/widgets/common_widgets.dart';

class ContactInfoScreen extends StatelessWidget {
  const ContactInfoScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: wGetAppBar(title: 'Contact Info'),
      body: SizedBox(
        width: MediaQuery.of(context).size.width,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                'Emails:\nhbye58587@gmail.com\n10221003@mu.edu.lb',
                style: kTextStyleMain,
                textAlign: TextAlign.center,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
