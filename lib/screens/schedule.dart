import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:university_scheduler/constants.dart';
import 'package:university_scheduler/modals/course.dart';
import 'package:university_scheduler/utils/dialogs.dart';
import 'package:university_scheduler/utils/utils.dart';
import 'package:university_scheduler/widgets/app_drawer.dart';
import 'package:university_scheduler/widgets/common_widgets.dart';
import 'package:university_scheduler/widgets/custom_material.dart';

import 'course_details.dart';

class ScheduleScreen extends StatefulWidget {
  const ScheduleScreen({Key? key}) : super(key: key);

  @override
  State<ScheduleScreen> createState() => _ScheduleScreenState();
}

class _ScheduleScreenState extends State<ScheduleScreen> {
  List<Course> courses = Utils.coursesForSchedule;

  late Future<void> dataGotten;

  List<bool> daysToPresent = [
    false,
    false,
    false,
    false,
    false,
  ];

  @override
  void initState() {
    super.initState();
    dataGotten = getData();
  }

  @override
  void dispose() {
    saveData();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: wGetAppBar(
        title: 'My Schedule',
        actions: [
          IconButton(
              onPressed: () async {
                List<int> initialIndices = [];
                for (int i = 0; i < daysToPresent.length; i++) {
                  if (daysToPresent[i]) {
                    initialIndices.add(i);
                  }
                }
                List<bool>? resultFromFiltering = await Dialogs.showChooseDaysDialog(
                  context: context,
                  title: 'Pick Days to Present',
                  color: kColorLightBlue,
                  initialIndicesToCheck: initialIndices,
                );
                if (resultFromFiltering != null) {
                  setState(() {
                    daysToPresent = resultFromFiltering;
                    dataGotten = saveData();
                  });
                }
              },
              icon: const Icon(Icons.filter_alt)),
        ],
      ),
      drawer: const AppDrawer(),
      body: FutureBuilder(
        future: dataGotten,
        builder: (data, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(
                color: kColorLightBlue,
              ),
            );
          }
          return RefreshIndicator(
            onRefresh: () async {
              await kRefreshIndicatorDelay;
              setState(() {
                courses = Utils.coursesForSchedule;
              });
            },
            child: courses.isEmpty
                ? kNoCoursesCenteredText
                : ListView.builder(
                    itemCount: courses.length + 1, //+ 1,
                    itemBuilder: (context, index) {
                      if (index == courses.length) {
                        return const SizedBox(
                          height: 24,
                        );
                      }
                      // if (index == 0) {
                      //   return CustomMaterial(
                      //     child: Row(
                      //       mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      //       children: [
                      //         Expanded(
                      //           flex: 3,
                      //           child: Text(
                      //             'Time',
                      //             style: kTextStyleMain,
                      //             textAlign: TextAlign.start,
                      //           ),
                      //         ),
                      //         SizedBox(
                      //           width: 5,
                      //         ),
                      //         Expanded(
                      //           flex: 7,
                      //           child: Text(
                      //             'Name',
                      //             style: kTextStyleMain,
                      //             textAlign: TextAlign.start,
                      //           ),
                      //         ),
                      //       ],
                      //     ),
                      //   );
                      // }
                      Course course = courses[index];

                      if (!daysToPresent[course.courseDays[0].index]) {
                        return const SizedBox();
                      }

                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          ...((index == 0 || course.courseDays[0] != courses[index - 1].courseDays[0])
                              ? [
                                  Container(
                                    margin: const EdgeInsets.only(top: 20, left: 10),
                                    child: Text(
                                      '${Course.courseDayToFullString(course.courseDays[0])}:',
                                      style: kTextStyleMain.copyWith(
                                        fontSize: 22,
                                      ),
                                    ),
                                  )
                                ]
                              : []),
                          CustomMaterial(
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Expanded(
                                  flex: 3,
                                  child: Text(
                                    course.startTime.toString(),
                                    style: kTextStyleMain,
                                    textAlign: TextAlign.start,
                                  ),
                                ),
                                const SizedBox(
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
                                          Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                  builder: (context) => CourseInfoScreen(course: course)));
                                        },
                                        icon: const Icon(
                                          Icons.info,
                                          color: kColorBlue,
                                        ),
                                        tooltip: 'Course Details',
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      );
                    },
                  ),
          );
        },
      ),
    );
  }

  Future<void> getData() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    daysToPresent = [
      preferences.getBool('Mon') ?? true,
      preferences.getBool('Tues') ?? true,
      preferences.getBool('Wed') ?? true,
      preferences.getBool('Thurs') ?? true,
      preferences.getBool('Fri') ?? true,
    ];
  }

  Future<void> saveData() async {
    List<bool> b = [...daysToPresent];

    SharedPreferences preferences = await SharedPreferences.getInstance();

    await preferences.setBool('Mon', b[0]);
    await preferences.setBool('Tues', b[1]);
    await preferences.setBool('Wed', b[2]);
    await preferences.setBool('Thurs', b[3]);
    await preferences.setBool('Fri', b[4]);
  }
}

/*

 */
