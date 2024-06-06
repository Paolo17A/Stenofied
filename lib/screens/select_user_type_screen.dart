import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:stenofied/widgets/app_bar_widget.dart';
import 'package:stenofied/widgets/custom_padding_widgets.dart';
import 'package:stenofied/widgets/custom_text_widgets.dart';

import '../utils/navigator_util.dart';
import '../utils/string_util.dart';
import '../widgets/custom_button_widgets.dart';

class SelectUserTypeScreen extends ConsumerWidget {
  const SelectUserTypeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
        appBar: appBarWidget(mayGoBack: true),
        body: SizedBox(
          width: MediaQuery.of(context).size.width,
          child: Column(
            children: [
              blackJosefinSansBold('SELECT USER TYPE', fontSize: 36),
              vertical20Pix(
                child: Column(
                  children: [
                    selectUserTypeButton(context,
                        label: 'STUDENT',
                        imagePath: ImagePaths.studentUser,
                        scale: 1,
                        onPress: () => Navigator.of(context)
                            .pushReplacementNamed(
                                NavigatorRoutes.studentRegister)),
                    selectUserTypeButton(context,
                        label: 'TEACHER',
                        imagePath: ImagePaths.teacherUser,
                        scale: 7,
                        onPress: () => Navigator.of(context)
                            .pushReplacementNamed(
                                NavigatorRoutes.teacherRegister)),
                  ],
                ),
              )
            ],
          ),
        ));
  }
}
