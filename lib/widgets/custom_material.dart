import 'package:flutter/material.dart';

import '../constants.dart';

class CustomMaterial extends StatelessWidget {
  const CustomMaterial({Key? key, required this.child}) : super(key: key);

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8),
      child: Container(
        decoration: BoxDecoration(borderRadius: BorderRadius.circular(5), border: Border.all(color: kColorYellow)),
        child: Material(
          elevation: 5,
          shadowColor: kColorYellow,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(5),
          ),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: child,
          ),
        ),
      ),
    );
  }
}
