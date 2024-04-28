import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';
import 'package:stenofied/utils/future_util.dart';

import '../providers/loading_provider.dart';
import '../utils/color_util.dart';
import '../widgets/app_bar_widget.dart';
import '../widgets/custom_button_widgets.dart';
import '../widgets/custom_miscellaneous_widgets.dart';
import '../widgets/custom_text_widgets.dart';

class ForgotPasswordScreen extends ConsumerStatefulWidget {
  const ForgotPasswordScreen({super.key});

  @override
  ConsumerState<ForgotPasswordScreen> createState() =>
      _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends ConsumerState<ForgotPasswordScreen> {
  final emailController = TextEditingController();

  @override
  void dispose() {
    super.dispose();
    emailController.dispose();
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
                  child: Column(
                children: [
                  blackInterBold('RESET PASSWORD', fontSize: 35),
                  const Gap(20),
                  Container(
                      width: MediaQuery.of(context).size.width,
                      decoration: BoxDecoration(
                          color: CustomColors.ketchup,
                          borderRadius: BorderRadius.circular(10)),
                      padding: const EdgeInsets.all(10),
                      child: Column(
                        children: [
                          emailAddressTextField(
                              emailController: emailController),
                          sendPasswordResetEmailButton(
                              onPress: () => sendResetPasswordEmail(
                                  context, ref,
                                  emailController: emailController)),
                        ],
                      ))
                ],
              )),
            ),
          )),
    );
  }
}
