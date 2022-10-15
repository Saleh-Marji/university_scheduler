import 'package:flutter/material.dart';

import '../constants.dart';

AppBar wGetAppBar({required String title, List<Widget>? actions}) => AppBar(
      title: Text(
        title,
        style: kTextStyleMain.copyWith(
          color: Colors.white,
        ),
      ),
      backgroundColor: kColorLightBlue,
      actions: actions,
    );
