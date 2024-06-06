import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';
import 'package:stenofied/utils/future_util.dart';

import '../providers/loading_provider.dart';
import '../utils/color_util.dart';
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
          appBar: AppBar(backgroundColor: Colors.transparent),
          backgroundColor: CustomColors.ketchup,
          body: stackedLoadingContainer(
            context,
            ref.read(loadingProvider).isLoading,
            Stack(
              children: [
                Positioned(
                    bottom: 0,
                    child: Container(
                      height: MediaQuery.of(context).size.height * 0.5,
                      width: MediaQuery.of(context).size.width,
                      decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.only(
                              topLeft: Radius.elliptical(300, 100),
                              topRight: Radius.elliptical(300, 100))),
                    )),
                Positioned(
                    top: 0,
                    child: SizedBox(
                        width: MediaQuery.of(context).size.width,
                        child: whiteAndadaProBold('RESET PASSWORD',
                            fontSize: 35))),
                SizedBox(
                  width: MediaQuery.of(context).size.width,
                  child: Center(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Gap(20),
                        Container(
                            width: MediaQuery.of(context).size.width * 0.9,
                            decoration: BoxDecoration(
                                color: Colors.white,
                                border: Border.all(width: 2),
                                borderRadius: BorderRadius.circular(30)),
                            padding: const EdgeInsets.all(10),
                            child: Column(
                              children: [
                                emailAddressTextField(
                                    emailController: emailController),
                              ],
                            )),
                        sendPasswordResetEmailButton(
                            onPress: () => sendResetPasswordEmail(context, ref,
                                emailController: emailController)),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          )),
    );
  }
}
