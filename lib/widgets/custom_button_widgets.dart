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
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10))),
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
          onPressed: () => onPress(),
          style:
              ElevatedButton.styleFrom(backgroundColor: CustomColors.parchment),
          child: blackInterBold('LOG-IN', fontSize: 18)));
}

Widget registerButton({required Function onPress}) {
  return all10Pix(
      child: ElevatedButton(
          onPressed: () => onPress(),
          style:
              ElevatedButton.styleFrom(backgroundColor: CustomColors.parchment),
          child: blackInterBold('REGISTER')));
}

Widget sendPasswordResetEmailButton({required Function onPress}) {
  return all10Pix(
      child: ElevatedButton(
          onPressed: () => onPress(),
          style:
              ElevatedButton.styleFrom(backgroundColor: CustomColors.parchment),
          child: blackInterBold('SEND PASSWORD\nRESET EMAIL')));
}

Widget forgotPasswordButton({required Function onPress}) {
  return TextButton(
      onPressed: () => onPress(), child: whiteInterBold('Forgot Password?'));
}

Widget dontHaveAccountButton({required Function onPress}) {
  return TextButton(
      onPressed: () => onPress(),
      child: whiteInterBold('Don\'t have an account?'));
}

Widget homeButton(BuildContext context,
    {required String label,
    required double width,
    required double height,
    required Color color,
    int? count,
    required Function onPress,
    bool willDisplayCount = false}) {
  return SizedBox(
      width: width,
      height: height,
      child: ElevatedButton(
          onPressed: () => onPress(),
          style: ElevatedButton.styleFrom(backgroundColor: color),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              whiteInterBold(label, fontSize: 21),
              Gap(5),
              if (willDisplayCount) whiteInterBold('$count AVAILABLE')
            ],
          )));
}

Widget selectUserTypeButton(BuildContext context,
    {required String label,
    required String imagePath,
    required double scale,
    required Function onPress}) {
  return all10Pix(
      child: Container(
    width: MediaQuery.of(context).size.width * 0.8,
    child: ElevatedButton(
        onPressed: () => onPress(),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            all10Pix(child: Image.asset(imagePath, scale: scale)),
            whiteInterBold(label, fontSize: 28)
          ],
        )),
  ));
}

Widget studentHomeButton(BuildContext context,
    {required String label, required Function onPress}) {
  return vertical20Pix(
      child: SizedBox(
    width: MediaQuery.of(context).size.width * 0.8,
    height: 80,
    child: ElevatedButton(
        onPressed: () => onPress(), child: whiteInterBold(label, fontSize: 24)),
  ));
}
