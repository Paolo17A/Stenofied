import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';

import '../utils/navigator_util.dart';
import '../widgets/app_bar_widget.dart';
import '../widgets/custom_button_widgets.dart';
import '../widgets/custom_text_widgets.dart';

class WelcomeScreen extends ConsumerStatefulWidget {
  const WelcomeScreen({super.key});

  @override
  ConsumerState<WelcomeScreen> createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends ConsumerState<WelcomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBarWidget(),
      body: SizedBox(
        width: MediaQuery.of(context).size.width,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Gap(10),
            //Image.asset(ImagePaths.logo, scale: 3),
            interText('Please select your user type...',
                fontWeight: FontWeight.bold, fontSize: 18),
            const Gap(10),
            welcomeButton(context,
                onPress: () => Navigator.of(context)
                    .pushNamed(NavigatorRoutes.studentLogin),
                iconData: Icons.person,
                label: 'STUDENT'),
            welcomeButton(context,
                onPress: () => Navigator.of(context)
                    .pushNamed(NavigatorRoutes.teacherLogin),
                iconData: Icons.people,
                label: 'TEACHER'),
            welcomeButton(context,
                onPress: () =>
                    Navigator.of(context).pushNamed(NavigatorRoutes.adminLogin),
                iconData: Icons.book,
                label: 'ADMIN')
          ],
        ),
      ),
    );
  }
}
