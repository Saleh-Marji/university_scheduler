import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../constants.dart';
import '../modals/course.dart';

class Dialogs {
  static Future<List<bool>?> showChooseDaysDialog({
    required BuildContext context,
    required String title,
    required Color color,
    List<int>? initialIndicesToCheck,
  }) async {
    return await showDialog(
      context: context,
      builder: (context) => ChangeNotifierProvider(
        create: (_) => CourseDaysInputProvider(
          indicesToCheck: initialIndicesToCheck,
        ),
        child: Consumer<CourseDaysInputProvider>(
          builder: (context, provider, child) => AlertDialog(
            title: Text(
              title,
              style: kTextStyleMain.copyWith(color: color, fontSize: 20),
            ),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: CourseDay.values
                  .map(
                    (e) => Theme(
                      data: Theme.of(context).copyWith(
                        unselectedWidgetColor: color,
                      ),
                      child: CheckboxListTile(
                        selectedTileColor: color,
                        activeColor: color,
                        controlAffinity: ListTileControlAffinity.leading,
                        title: Text(
                          Course.courseDayToString(e),
                          style: kTextStyleMain.copyWith(color: color),
                        ),
                        value: provider.values[e.index],
                        onChanged: (value) {
                          provider.setValueAt(index: e.index, value: value ?? false);
                        },
                      ),
                    ),
                  )
                  .toList(),
            ),
            actions: [
              DialogActionButton(
                color: color,
                labelText: 'Cancel',
                onPressed: () {
                  Navigator.pop(context);
                },
              ),
              DialogActionButton(
                color: color,
                labelText: 'Ok',
                onPressed: () {
                  Navigator.pop(
                    context,
                    provider.values,
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  static Future<bool?> showConfirmationDialog({
    required BuildContext context,
    required String content,
    required Color? color,
  }) async {
    return await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(
          'Confirmation',
          style: kTextStyleMain.copyWith(fontSize: 25, color: color),
        ),
        content: Text(
          content,
          style: kTextStyleMain.copyWith(color: color),
        ),
        actions: [
          DialogActionButton(
            labelText: 'Yes',
            color: color ?? kColorLightBlue,
            onPressed: () => Navigator.pop(context, true),
          ),
          DialogActionButton(
            labelText: 'Cancel',
            color: color ?? kColorLightBlue,
            onPressed: () => Navigator.pop(context),
          ),
        ],
      ),
    );
  }
}

class CourseDaysInputProvider extends ChangeNotifier {
  List<bool> _values = [false, false, false, false, false];

  CourseDaysInputProvider({List<int>? indicesToCheck}) {
    if (indicesToCheck != null) {
      for (var element in indicesToCheck) {
        _values[element] = true;
      }
    }
  }

  List<bool> get values => _values;

  void setValueAt({required int index, required bool value}) {
    _values[index] = value;
    notifyListeners();
  }

  set values(List<bool> values) {
    _values = values;
    notifyListeners();
  }
}

class DialogActionButton extends StatelessWidget {
  const DialogActionButton({
    Key? key,
    required this.labelText,
    required this.onPressed,
    this.color = kColorLightBlue,
  }) : super(key: key);

  final String labelText;
  final VoidCallback onPressed;
  final Color? color;

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: onPressed,
      style: ButtonStyle(
        backgroundColor: MaterialStateProperty.all(color),
      ),
      child: Text(
        labelText,
        style: const TextStyle(
          color: Colors.white,
          fontFamily: kFontPrimary,
        ),
      ),
    );
  }
}
