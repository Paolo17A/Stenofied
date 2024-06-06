import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';

import '../providers/loading_provider.dart';
import '../utils/navigator_util.dart';
import '../utils/string_util.dart';
import '../widgets/app_bar_widget.dart';
import '../widgets/custom_button_widgets.dart';
import '../widgets/custom_miscellaneous_widgets.dart';
import '../widgets/custom_padding_widgets.dart';
import '../widgets/custom_text_widgets.dart';

class StudentLoginScreen extends ConsumerStatefulWidget {
  const StudentLoginScreen({super.key});

  @override
  ConsumerState<StudentLoginScreen> createState() => _UserLoginScreenState();
}

class _UserLoginScreenState extends ConsumerState<StudentLoginScreen> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  @override
  void dispose() {
    super.dispose();
    emailController.dispose();
    passwordController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    ref.watch(loadingProvider);
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        appBar: appBarWidget(mayGoBack: true),
        body: stackedLoadingContainer(
            context,
            ref.read(loadingProvider).isLoading,
            SizedBox(
              width: MediaQuery.of(context).size.width,
              child: SingleChildScrollView(
                  child: all20Pix(
                      child: Column(
                children: [
                  blackJosefinSansBold('STUDENT LOG-IN', fontSize: 35),
                  authenticationIcon(context, iconData: Icons.person),
                  const Gap(20),
                  loginFieldsContainer(context, ref,
                      userType: UserTypes.student,
                      emailController: emailController,
                      passwordController: passwordController),
                  forgotPasswordButton(
                      onPress: () => Navigator.of(context)
                          .pushNamed(NavigatorRoutes.forgotPassword)),
                  dontHaveAccountButton(
                      onPress: () => Navigator.of(context).pushReplacementNamed(
                          NavigatorRoutes.studentRegister))
                ],
              ))),
            )),
      ),
    );
  }
}
