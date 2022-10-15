import 'package:flutter/material.dart';
import 'package:university_scheduler/constants.dart';
import 'package:university_scheduler/utils/dialogs.dart';

class AppDrawer extends StatelessWidget {
  const AppDrawer({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Container(
        width: 220,
        decoration: BoxDecoration(
          color: kColorYellow,
          borderRadius: BorderRadius.horizontal(
            right: Radius.circular(10),
          ),
        ),
        child: ListView(
          children: [
            Container(
              height: 210,
              padding: EdgeInsets.all(30),
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  shape: BoxShape.circle,
                ),
                child: CircleAvatar(
                  radius: 70,
                  backgroundColor: Colors.white,
                  child: Image.asset('assets/images/logo.png'),
                ),
              ),
            ),
            DrawerDivider(
              margins: EdgeInsets.zero,
            ),
            ..._getActions(),
            //Expanded(child: SizedBox()),
            DrawerDivider(),
            Text(
              'Made By\nSaleh Marji',
              textAlign: TextAlign.center,
              style: kTextStyleMain,
            ),
            SizedBox(
              height: 10,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    DialogActionButton(
                      labelText: 'Contact Info',
                      onPressed: () {
                        Navigator.pushNamed(context, kContactInfoRoute);
                      },
                    ),
                  ],
                ),
              ],
            ),
            SizedBox(
              height: 15,
            ),
          ],
        ),
      ),
    );
  }

  List<Widget> _getActions() => [
        OptionsButtonContent(
          label: 'Home',
          icon: Icons.home,
          destinationRoute: kHomeRoute,
        ),
        OptionsButtonContent(
          label: 'My Courses',
          icon: Icons.book,
          destinationRoute: kCoursesRoute,
        ),
        OptionsButtonContent(
          label: 'My Schedule',
          icon: Icons.calendar_month,
          destinationRoute: kScheduleRoute,
        ),
        OptionsButtonContent(
          label: 'Manual',
          icon: Icons.perm_device_info_rounded,
          destinationRoute: kManualRoute,
        ),
        OptionsButtonContent(
          label: 'Settings',
          icon: Icons.settings,
          destinationRoute: kSettingsRoute,
        ),
      ].map((e) => DrawerTile(content: e)).toList();
}

class DrawerTile extends StatelessWidget {
  const DrawerTile({
    Key? key,
    required this.content,
    this.removeUntil = true,
  }) : super(key: key);

  final OptionsButtonContent content;
  final bool removeUntil;

  @override
  Widget build(BuildContext context) {
    return MaterialButton(
      padding: EdgeInsets.zero,
      onPressed: () async {
        Navigator.pop(context);
        await Future.delayed(const Duration(milliseconds: 250));
        if (content.onPressed == null) {
          if (ModalRoute.of(context)?.settings.name != content.destinationRoute) {
            Navigator.pushNamedAndRemoveUntil(
              context,
              content.destinationRoute!,
              (route) => removeUntil,
            );
          }
        } else {
          content.onPressed!.call();
        }
      },
      child: Container(
        padding: const EdgeInsets.only(
          top: 15,
          bottom: 15,
          left: 20,
          right: 10,
        ),
        child: Row(
          children: [
            Icon(
              content.icon,
              color: kColorBlue,
            ),
            const SizedBox(
              width: 10,
            ),
            Text(
              content.label,
              style: kTextStyleMain,
            ),
          ],
        ),
      ),
    );
  }
}

class OptionsButtonContent {
  final String label;
  final IconData icon;
  final VoidCallback? onPressed;
  final String? destinationRoute;

  OptionsButtonContent({
    required this.label,
    required this.icon,
    this.destinationRoute,
    this.onPressed,
  });
}

class DrawerDivider extends StatelessWidget {
  const DrawerDivider({Key? key, this.margins = const EdgeInsets.symmetric(vertical: 10)}) : super(key: key);

  final EdgeInsets margins;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: margins,
      height: 1,
      width: double.infinity,
      color: kColorBlue,
    );
  }
}
