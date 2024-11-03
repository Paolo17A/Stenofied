import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:stenofied/widgets/custom_miscellaneous_widgets.dart';
import 'package:stenofied/widgets/custom_text_widgets.dart';
import 'package:stenofied/widgets/navigator_rail_widget.dart';

import '../../utils/navigator_util.dart';
import '../../widgets/app_drawer_widget.dart';

class TeacherFAQScreen extends ConsumerStatefulWidget {
  const TeacherFAQScreen({super.key});

  @override
  ConsumerState<TeacherFAQScreen> createState() => _TeacherFAQScreenState();
}

class _TeacherFAQScreenState extends ConsumerState<TeacherFAQScreen> {
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();

  int currentIndex = 1;
  final maxIndex = 5;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: scaffoldKey,
      drawer: teacherAppDrawer(context, ref,
          currentPath: NavigatorRoutes.teacherFAQ),
      body: safeAreaWithRail(context,
          railWidget: teacherRail(context, scaffoldKey,
              selectedIndex: 3, currentPath: NavigatorRoutes.teacherFAQ),
          mainWidget: Container(
            width: MediaQuery.of(context).size.width - 50,
            height: MediaQuery.of(context).size.height,
            decoration: BoxDecoration(
                image: DecorationImage(
                    fit: BoxFit.contain,
                    image: AssetImage(
                        'assets/images/faqs/teacher/teacher_${currentIndex}.png'))),
            child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(),
                  Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [_previousButton(), _nextButton()]),
                  sangriaInterBold(currentIndex.toString(), fontSize: 40)
                ]),
          )),
    );
  }

  Widget _previousButton() {
    return TextButton(
        onPressed: currentIndex == 1
            ? null
            : () {
                setState(() {
                  currentIndex--;
                });
              },
        child: currentIndex == 1
            ? greyInterBold('<', fontSize: 32)
            : sangriaInterBold('<', fontSize: 32));
  }

  Widget _nextButton() {
    return TextButton(
        onPressed: currentIndex == maxIndex
            ? null
            : () {
                setState(() {
                  currentIndex++;
                });
              },
        child: currentIndex == maxIndex
            ? greyInterBold('>', fontSize: 32)
            : sangriaInterBold('>', fontSize: 32));
  }
}
