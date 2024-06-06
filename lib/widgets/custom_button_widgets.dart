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
          style: ElevatedButton.styleFrom(
              backgroundColor: CustomColors.ketchup,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30))),
          child: whiteJosefinSansBold('LOG-IN', fontSize: 18)));
}

Widget registerButton({required Function onPress}) {
  return all10Pix(
      child: ElevatedButton(
          onPressed: () => onPress(),
          style: ElevatedButton.styleFrom(
              backgroundColor: CustomColors.ketchup,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30))),
          child: whiteJosefinSansBold('REGISTER')));
}

Widget sendPasswordResetEmailButton({required Function onPress}) {
  return all10Pix(
      child: ElevatedButton(
          onPressed: () => onPress(),
          style:
              ElevatedButton.styleFrom(backgroundColor: CustomColors.ketchup),
          child: whiteJosefinSansBold('SEND PASSWORD\nRESET EMAIL')));
}

Widget forgotPasswordButton({required Function onPress}) {
  return TextButton(
      onPressed: () => onPress(), child: sangriaInterBold('Forgot Password?'));
}

Widget dontHaveAccountButton({required Function onPress}) {
  return TextButton(
      onPressed: () => onPress(),
      child: sangriaInterBold('Don\'t have an account?'));
}

Widget homeButton(BuildContext context,
    {required String label,
    required String imagePath,
    int? count,
    required Function onPress,
    bool willDisplayCount = false}) {
  return Container(
      width: 150,
      height: 250,
      decoration:
          BoxDecoration(borderRadius: BorderRadius.circular(40), boxShadow: [
        BoxShadow(
            blurRadius: 6,
            spreadRadius: 1,
            offset: Offset(1, 1),
            color: Colors.black.withOpacity(0.5))
      ]),
      child: ElevatedButton(
          onPressed: () => onPress(),
          style: ElevatedButton.styleFrom(
              backgroundColor: CustomColors.ketchup,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(40))),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset(imagePath),
              whiteAndadaProBold(label,
                  fontSize: 16, textOverflow: TextOverflow.ellipsis),
              Gap(5),
              if (willDisplayCount) andandaProText('$count AVAILABLE')
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
            whiteAndadaProBold(label, fontSize: 28)
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
        onPressed: () => onPress(),
        child: whiteAndadaProBold(label, fontSize: 24)),
  ));
}
