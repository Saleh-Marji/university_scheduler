import 'package:flutter/material.dart';
import 'package:university_scheduler/constants.dart';
import 'package:university_scheduler/modals/course.dart';
import 'package:university_scheduler/screens/input_course.dart';
import 'package:university_scheduler/screens/course_details.dart';
import 'package:university_scheduler/utils/utils.dart';
import 'package:university_scheduler/widgets/app_drawer.dart';
import 'package:university_scheduler/widgets/common_widgets.dart';

import '../utils/dialogs.dart';
import '../widgets/custom_material.dart';

class CoursesScreen extends StatefulWidget {
  const CoursesScreen({Key? key}) : super(key: key);

  @override
  State<CoursesScreen> createState() => _CoursesScreenState();
}

class _CoursesScreenState extends State<CoursesScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: wGetAppBar(
        title: 'My Courses',
        actions: [
          IconButton(
            onPressed: () async {
              bool? ok = await Dialogs.showConfirmationDialog(
                context: context,
                content: 'Are you sure you want to remove all your courses?',
                color: kColorLightBlue,
              );

              if (!(ok ?? false)) {
                return;
              }

              await Utils.clearCourses();
              setState(() {});
            },
            icon: Icon(Icons.delete_forever),
            tooltip: 'Delete All',
          )
        ],
      ),
      drawer: AppDrawer(),
      floatingActionButton: FloatingActionButton(
        backgroundColor: kColorLightBlue,
        onPressed: () async {
          await Navigator.push(context, MaterialPageRoute(builder: (context) => InputCourseScreen()));
          setState(() {});
        },
        child: Icon(Icons.add),
      ),
      body: Utils.courses.isEmpty
          ? kNoCoursesCenteredText
          : ListView.builder(
              itemCount: Utils.courses.length + 2,
              itemBuilder: (context, index) {
                List<Course> courses = Utils.courses;
                if (index == 0) {
                  return CustomMaterial(
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: const [
                        Expanded(
                          flex: 2,
                          child: Text(
                            'Code',
                            style: kTextStyleMain,
                          ),
                        ),
                        SizedBox(
                          width: 5,
                        ),
                        Expanded(
                          flex: 7,
                          child: Text(
                            'Name',
                            style: kTextStyleMain,
                            textAlign: TextAlign.start,
                          ),
                        ),
                      ],
                    ),
                  );
                } else if (index == courses.length + 1) {
                  return SizedBox(
                    height: 80,
                  );
                } else {
                  Course course = courses[index - 1];
                  return _CustomMaterialButton(
                    onLongPress: () async {
                      bool? ok = await Dialogs.showConfirmationDialog(
                        context: context,
                        content: 'Are you sure you want to remove the ${course.name} course?',
                        color: kColorLightBlue,
                      );

                      if (!(ok ?? false)) {
                        return;
                      }

                      await Utils.removeCourse(course);
                      setState(() {});
                    },
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          flex: 2,
                          child: Text(
                            course.code,
                            style: kTextStyleMain,
                            textAlign: TextAlign.start,
                          ),
                        ),
                        SizedBox(
                          width: 5,
                        ),
                        Expanded(
                          flex: 7,
                          child: Row(
                            children: [
                              Expanded(
                                flex: 2,
                                child: Text(
                                  course.name,
                                  style: kTextStyleMain,
                                  textAlign: TextAlign.start,
                                ),
                              ),
                              IconButton(
                                onPressed: () {
                                  Navigator.push(context,
                                      MaterialPageRoute(builder: (context) => CourseInfoScreen(course: course)));
                                },
                                icon: Icon(
                                  Icons.info,
                                  color: kColorBlue,
                                ),
                                tooltip: 'Course Details',
                              ),
                              IconButton(
                                onPressed: () async {
                                  bool? changed = await Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => InputCourseScreen(
                                        course: course,
                                        index: index - 1,
                                      ),
                                    ),
                                  );

                                  if (changed ?? false) {
                                    setState(() {});
                                  }
                                },
                                icon: Icon(
                                  Icons.edit,
                                  color: kColorBlue,
                                ),
                                tooltip: 'Edit Course',
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  );
                }
              },
            ),
    );
  }
}

class _CustomMaterialButton extends StatelessWidget {
  const _CustomMaterialButton({Key? key, required this.child, required this.onLongPress}) : super(key: key);

  final Widget child;
  final VoidCallback onLongPress;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        decoration: BoxDecoration(borderRadius: BorderRadius.circular(5), border: Border.all(color: kColorYellow)),
        child: Material(
          borderRadius: BorderRadius.circular(5),
          shadowColor: kColorYellow,
          elevation: 5,
          child: MaterialButton(
            padding: EdgeInsets.zero,
            onPressed: () {},
            onLongPress: onLongPress,
            focusElevation: 7,
            //color: kColorYellow,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(5),
            ),
            child: Padding(
              padding: const EdgeInsets.only(top: 8, bottom: 8, left: 8),
              child: child,
            ),
          ),
        ),
      ),
    );
  }
}
