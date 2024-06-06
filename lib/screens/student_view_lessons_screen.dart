import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';
import 'package:stenofied/models/lesson_model.dart';
import 'package:stenofied/providers/loading_provider.dart';
import 'package:stenofied/providers/user_data_provider.dart';
import 'package:stenofied/utils/color_util.dart';
import 'package:stenofied/utils/future_util.dart';
import 'package:stenofied/utils/navigator_util.dart';
import 'package:stenofied/utils/string_util.dart';
import 'package:stenofied/widgets/app_drawer_widget.dart';
import 'package:stenofied/widgets/custom_miscellaneous_widgets.dart';
import 'package:stenofied/widgets/custom_padding_widgets.dart';
import 'package:stenofied/widgets/custom_text_widgets.dart';
import 'package:stenofied/widgets/navigator_rail_widget.dart';

class StudentLessonsScreen extends ConsumerStatefulWidget {
  const StudentLessonsScreen({super.key});

  @override
  ConsumerState<StudentLessonsScreen> createState() =>
      _StudentLessonsScreenState();
}

class _StudentLessonsScreenState extends ConsumerState<StudentLessonsScreen> {
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      try {
        ref.read(loadingProvider).toggleLoading(true);
        final user = await getCurrentUserDoc();
        final userData = user.data() as Map<dynamic, dynamic>;
        ref
            .read(userDataProvider)
            .setLessonIndex(userData[UserFields.currentLessonIndex]);
        ref.read(loadingProvider).toggleLoading(false);
      } catch (error) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Text('Error getting student lesson index: $error')));
        ref.read(loadingProvider).toggleLoading(false);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    ref.watch(loadingProvider);
    ref.watch(userDataProvider);
    return Scaffold(
      key: scaffoldKey,
      drawer: studentAppDrawer(context, ref,
          currentPath: NavigatorRoutes.studentLessons),
      body: switchedLoadingContainer(
          ref.read(loadingProvider).isLoading,
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              studentRail(context, scaffoldKey,
                  selectedIndex: 1,
                  currentPath: NavigatorRoutes.studentExercises),
              SizedBox(
                width: MediaQuery.of(context).size.width - 50,
                child: SingleChildScrollView(
                  child: all20Pix(
                      child: Column(
                    children: [
                      blackCinzelBold('STENOGRAPHY LESSONS', fontSize: 32),
                      Gap(40),
                      Wrap(
                          spacing: 10,
                          runSpacing: 10,
                          children: allLessonModels.map((lesson) {
                            return SizedBox(
                              width: MediaQuery.of(context).size.width * 0.35,
                              height: MediaQuery.of(context).size.width * 0.2,
                              child: ElevatedButton(
                                  onPressed: lesson.lessonIndex <=
                                          ref.read(userDataProvider).lessonIndex
                                      ? () =>
                                          NavigatorRoutes.studentSelectedLesson(
                                              context,
                                              lessonModel: lesson)
                                      : null,
                                  style: ElevatedButton.styleFrom(
                                      disabledBackgroundColor: CustomColors
                                          .ketchup
                                          .withOpacity(0.5)),
                                  child: whiteAndadaProBold(
                                      'Lesson ${lesson.lessonIndex}',
                                      fontSize: 16)),
                            );
                          }).toList())
                    ],
                  )),
                ),
              ),
            ],
          )),
    );
  }
}
