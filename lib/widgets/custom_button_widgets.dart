import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

import '../utils/color_util.dart';
import 'custom_padding_widgets.dart';
import 'custom_text_widgets.dart';

Widget welcomeButton(BuildContext context,
    {required Function onPress,
    required IconData iconData,
    required String label}) {
  return all20Pix(
    child: Container(
      width: MediaQuery.of(context).size.width * 0.5,
      height: 120,
      decoration: BoxDecoration(borderRadius: BorderRadius.circular(20)),
      child: ElevatedButton(
        onPressed: () => onPress(),
        style: ElevatedButton.styleFrom(
            backgroundColor: CustomColors.ketchup,
            shadowColor: CustomColors.bermuda,
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20))),
        child: Column(
          children: [
            Expanded(
                child: Transform.scale(
                    scale: 4, child: Icon(iconData, color: Colors.white))),
            interText(label,
                fontWeight: FontWeight.bold, color: Colors.white, fontSize: 15)
          ],
        ),
      ),
    ),
  );
}

Widget loginButton({required Function onPress}) {
  return all10Pix(
      child: ElevatedButton(
          onPressed: () => onPress(), child: whiteInterBold('LOG-IN')));
}

Widget registerButton({required Function onPress}) {
  return all10Pix(
      child: ElevatedButton(
          onPressed: () => onPress(), child: whiteInterBold('REGISTER')));
}

Widget sendPasswordResetEmailButton({required Function onPress}) {
  return all10Pix(
      child: ElevatedButton(
          onPressed: () => onPress(),
          child: whiteInterBold('SEND PASSWORD\nRESET EMAIL')));
}

Widget forgotPasswordButton({required Function onPress}) {
  return TextButton(
      onPressed: () => onPress(),
      child: blackInterBold('Forgot Password?',
          textDecoration: TextDecoration.underline));
}

Widget dontHaveAccountButton({required Function onPress}) {
  return TextButton(
      onPressed: () => onPress(),
      child: blackInterBold('Don\'t have an account?',
          textDecoration: TextDecoration.underline));
}

Widget homeButton(BuildContext context,
    {required String label, required int count, required Function onPress}) {
  return all10Pix(
      child: SizedBox(
          width: MediaQuery.of(context).size.width * 0.75,
          height: 125,
          child: ElevatedButton(
              onPressed: () => onPress(),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  whiteInterBold(label, fontSize: 20),
                  Gap(5),
                  whiteInterBold('$count AVAILABLE')
                ],
              ))));
}
