import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:stenofied/models/lesson_model.dart';
import 'package:stenofied/providers/loading_provider.dart';
import 'package:stenofied/providers/user_data_provider.dart';
import 'package:stenofied/utils/color_util.dart';
import 'package:stenofied/utils/future_util.dart';
import 'package:stenofied/utils/navigator_util.dart';
import 'package:stenofied/utils/string_util.dart';
import 'package:stenofied/widgets/app_bar_widget.dart';
import 'package:stenofied/widgets/app_bottom_nav_bar_widget.dart';
import 'package:stenofied/widgets/app_drawer_widget.dart';
import 'package:stenofied/widgets/custom_miscellaneous_widgets.dart';
import 'package:stenofied/widgets/custom_padding_widgets.dart';
import 'package:stenofied/widgets/custom_text_widgets.dart';

class StudentLessonsScreen extends ConsumerStatefulWidget {
  const StudentLessonsScreen({super.key});

  @override
  ConsumerState<StudentLessonsScreen> createState() =>
      _StudentLessonsScreenState();
}

class _StudentLessonsScreenState extends ConsumerState<StudentLessonsScreen> {
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
      appBar: appBarWidget(mayGoBack: true),
      drawer: appDrawer(context, ref, userType: UserTypes.student),
      bottomNavigationBar:
          studentBottomNavBar(context, path: NavigatorRoutes.studentLessons),
      body: switchedLoadingContainer(
          ref.read(loadingProvider).isLoading,
          SizedBox(
            width: double.infinity,
            child: SingleChildScrollView(
              child: all20Pix(
                  child: Column(
                children: [
                  blackInterBold('STENOGRAPHY LESSONS', fontSize: 26),
                  ListView.builder(
                      shrinkWrap: true,
                      physics: NeverScrollableScrollPhysics(),
                      itemCount: allLessonModels.length,
                      itemBuilder: (context, index) {
                        return vertical10Pix(
                            child: ElevatedButton(
                                onPressed: allLessonModels[index].lessonIndex <=
                                        ref.read(userDataProvider).lessonIndex
                                    ? () =>
                                        NavigatorRoutes.studentSelectedLesson(
                                            context,
                                            lessonModel: allLessonModels[index])
                                    : null,
                                style: ElevatedButton.styleFrom(
                                    disabledBackgroundColor:
                                        CustomColors.ketchup.withOpacity(0.5)),
                                child: whiteInterBold(
                                    'Lesson ${allLessonModels[index].lessonIndex}',
                                    fontSize: 16)));
                      })
                ],
              )),
            ),
          )),
    );
  }
}
