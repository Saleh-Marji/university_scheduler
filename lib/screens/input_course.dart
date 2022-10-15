import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:university_scheduler/constants.dart';
import 'package:university_scheduler/modals/course.dart';
import 'package:university_scheduler/utils/dialogs.dart';
import 'package:university_scheduler/utils/utils.dart';
import 'package:university_scheduler/widgets/common_widgets.dart';

const _colorOfScreenContent = kColorBlue;

class InputCourseScreen extends StatefulWidget {
  const InputCourseScreen({
    Key? key,
    this.course,
    this.index,
  })  : assert((course == null && index == null) || (course != null && index != null)),
        super(key: key);

  final Course? course;
  final int? index;

  @override
  State<InputCourseScreen> createState() => _InputCourseScreenState();
}

class _InputCourseScreenState extends State<InputCourseScreen> {
  List<CourseDay> courseDays = [];

  Time startTime = Time(0, 0, TimeType.am), endTime = Time(0, 0, TimeType.am);

  late TextEditingController codeController,
      nameController,
      sectionController,
      locationController,
      instructorController;

  @override
  void initState() {
    super.initState();

    codeController = TextEditingController();
    nameController = TextEditingController();
    sectionController = TextEditingController();
    locationController = TextEditingController();
    instructorController = TextEditingController();

    if (widget.course != null) {
      codeController.text = widget.course!.code;
      nameController.text = widget.course!.name;
      sectionController.text = widget.course!.section;
      locationController.text = widget.course!.location;
      instructorController.text = widget.course!.instructor;
      courseDays = widget.course!.courseDays;
      startTime = widget.course!.startTime;
      endTime = widget.course!.endTime;
    }
  }

  @override
  void dispose() {
    codeController.dispose();
    nameController.dispose();
    sectionController.dispose();
    locationController.dispose();
    instructorController.dispose();
    super.dispose();
  }

  bool validate() {
    try {
      if (codeController.text.isEmpty) {
        throw _InputException('code');
      }
      if (nameController.text.isEmpty) {
        throw _InputException('name');
      }
      if (sectionController.text.isEmpty) {
        throw _InputException('section');
      }
      if (locationController.text.isEmpty) {
        throw _InputException('location');
      }
      if (instructorController.text.isEmpty) {
        throw _InputException('instructor');
      }
      if (courseDays.isEmpty) {
        throw _CourseDaysEmptyException();
      }
      return true;
    } on _InputException catch (e) {
      String missing = e.message;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Kindly add a${['a', 'i', 'o', 'u', 'e'].contains(missing[0]) ? 'n' : ''} $missing',
          ),
        ),
      );
    } on _CourseDaysEmptyException catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(e.message)));
    }
    return false;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: wGetAppBar(
        title: widget.course != null ? 'Edit Course ${widget.course!.code}' : 'Add Course',
        actions: [
          IconButton(
            onPressed: widget.course == null
                ? () async {
                    ///add
                    if (validate()) {
                      bool? ok = await Dialogs.showConfirmationDialog(
                        context: context,
                        content: 'Are you sure you want to add this course?',
                        color: _colorOfScreenContent,
                      );

                      if (!(ok ?? false)) {
                        return;
                      }

                      await Utils.addCourse(
                        Course(
                          code: codeController.text,
                          name: nameController.text,
                          section: sectionController.text,
                          location: locationController.text,
                          instructor: instructorController.text,
                          courseDays: courseDays,
                          startTime: startTime,
                          endTime: endTime,
                        ),
                      );
                      Navigator.pop(context, true);
                    }
                  }
                : () async {
                    if (validate()) {
                      bool? ok = await Dialogs.showConfirmationDialog(
                        context: context,
                        content: 'Are you sure you want to edit this course?',
                        color: _colorOfScreenContent,
                      );

                      if (!(ok ?? false)) {
                        return;
                      }

                      await Utils.editCourse(
                        widget.index!,
                        Course(
                          code: codeController.text,
                          name: nameController.text,
                          section: sectionController.text,
                          location: locationController.text,
                          instructor: instructorController.text,
                          courseDays: courseDays,
                          startTime: startTime,
                          endTime: endTime,
                        ),
                      );
                      Navigator.pop(context, true);
                    }
                  },
            icon: Icon(Icons.check),
          ),
        ],
      ),
      body: Form(
        child: ListView(
          children: [
            SizedBox(
              height: 10,
            ),
            ...([
              InputTextFieldContent(codeController, 'Code (eg: MAT213)'),
              InputTextFieldContent(nameController, 'Name (eg: Calculus III)'),
              InputTextFieldContent(sectionController, 'Section'),
              InputTextFieldContent(locationController, 'Location (eg: A-201)'),
              InputTextFieldContent(instructorController, 'Instructor'),
            ].map(
              (e) => InputTextField(
                controller: e.controller,
                labelText: e.label,
              ),
            )),
            StaticTextFormField(
              content: courseDays.isEmpty ? 'Click to Select Days' : Course.courseDaysToString(courseDays),
              label: 'Course Days',
              trailing: Icon(
                Icons.calendar_month,
                color: _colorOfScreenContent,
              ),
              onPressed: () async {
                List<bool>? result = await Dialogs.showChooseDaysDialog(
                  context: context,
                  title: 'Pick Course Days',
                  color: _colorOfScreenContent,
                  initialIndicesToCheck: courseDays.map((e) => e.index).toList(),
                );

                if (result != null) {
                  courseDays.clear();
                  for (int i = 0; i < CourseDay.values.length; i++) {
                    if (result[i]) {
                      courseDays.add(CourseDay.values[i]);
                    }
                  }
                  setState(() {});
                }
              },
            ),
            StaticTextFormField(
              content: startTime.toString(),
              label: 'Start Time',
              trailing: Icon(
                Icons.schedule,
                color: _colorOfScreenContent,
              ),
              onPressed: () async {
                TimeOfDay? result = await _showTimePickerDialog(context, startTime);
                if (result != null) {
                  setState(() {
                    startTime = Time.fromTimeOfDay(result);
                  });
                }
              },
            ),
            StaticTextFormField(
              content: endTime.toString(),
              label: 'End Time',
              trailing: Icon(
                Icons.schedule,
                color: _colorOfScreenContent,
              ),
              onPressed: () async {
                TimeOfDay? result = await _showTimePickerDialog(context, endTime);
                if (result != null) {
                  setState(() {
                    endTime = Time.fromTimeOfDay(result);
                  });
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}

Future<TimeOfDay?> _showTimePickerDialog(BuildContext context, Time initialTime) async {
  return showDialog<TimeOfDay?>(
    context: context,
    builder: (context) => Theme(
      data: ThemeData.light().copyWith(
        colorScheme: ColorScheme.light(
          primary: _colorOfScreenContent,
        ),
      ),
      child: TimePickerDialog(
        initialTime: initialTime.toTimeOfDay(),
      ),
    ),
  );
}

class _InputException implements Exception {
  String message;

  _InputException(this.message);
}

class _CourseDaysEmptyException implements Exception {
  String message = 'Kindly add at least one course day';

  _CourseDaysEmptyException();
}

class InputTextFieldContent {
  TextEditingController controller;
  String label;

  InputTextFieldContent(this.controller, this.label);
}

class InputTextField extends StatelessWidget {
  const InputTextField({
    Key? key,
    this.margins = const EdgeInsets.symmetric(vertical: 10),
    this.colorOfBorder = _colorOfScreenContent,
    this.colorOfText = _colorOfScreenContent,
    this.horizontalPadding,
    this.controller,
    this.onTap,
    this.labelText,
  }) : super(key: key);

  final EdgeInsets margins;
  final Color colorOfBorder, colorOfText;
  final TextEditingController? controller;
  final String? labelText;
  final double? horizontalPadding;
  final VoidCallback? onTap;

  static const double _fontSize = 18;

  OutlineInputBorder _getBorderStyle() => OutlineInputBorder(
        borderRadius: BorderRadius.circular(10.0),
        borderSide: BorderSide(
          width: 1,
          color: colorOfBorder,
        ),
      );

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: margins,
      padding: EdgeInsets.symmetric(horizontal: horizontalPadding ?? 20),
      child: TextFormField(
        key: key,
        textAlign: TextAlign.left,
        controller: controller,
        cursorColor: colorOfBorder,
        onTap: onTap,
        style: TextStyle(
          fontSize: _fontSize,
          fontFamily: kFontPrimary,
          color: colorOfText,
        ),
        decoration: InputDecoration(
          contentPadding: const EdgeInsets.symmetric(horizontal: 30, vertical: 15),
          labelText: labelText,
          labelStyle: TextStyle(fontSize: _fontSize, color: colorOfText, fontFamily: kFontPrimary),
          enabledBorder: _getBorderStyle(),
          border: _getBorderStyle(),
          focusedBorder: _getBorderStyle().copyWith(
            borderSide: const BorderSide(
              color: Colors.blue,
              width: 2,
            ),
          ),
          disabledBorder: _getBorderStyle().copyWith(
            borderSide: BorderSide(
              color: colorOfBorder,
              width: 0.4,
            ),
          ),
          filled: true,
          fillColor: Colors.white,
        ),
      ),
    );
  }
}

class StaticTextFormField extends StatelessWidget {
  const StaticTextFormField({
    Key? key,
    this.onPressed,
    this.trailing,
    this.color = _colorOfScreenContent,
    this.widthOfBorder = 1,
    required this.content,
    required this.label,
  }) : super(key: key);

  final String content, label;
  final Color color;
  final VoidCallback? onPressed;
  final Widget? trailing;
  final double? widthOfBorder;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Positioned(
          left: 45,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 5),
            color: Colors.white,
            child: Text(
              label,
              style: TextStyle(
                color: color,
                fontSize: 12.5,
                fontFamily: kFontPrimary,
              ),
            ),
          ),
        ),
        Container(
          margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          child: GestureDetector(
            onTap: onPressed,
            child: ListTile(
              trailing: trailing,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
                side: BorderSide(color: color, width: widthOfBorder ?? 0.4),
              ),
              contentPadding: const EdgeInsets.only(left: 28, right: 15),
              title: Padding(
                padding: const EdgeInsets.symmetric(vertical: 10.0),
                child: Text(
                  content,
                  style: TextStyle(
                    color: color,
                    fontSize: 18,
                    fontFamily: kFontPrimary,
                  ),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
