import 'package:flutter/material.dart';
import 'package:stenofied/widgets/custom_text_widgets.dart';

import '../utils/color_util.dart';

class BoolAnswerButton extends StatefulWidget {
  final bool boolVal;
  final String answer;
  final void Function() onTap;
  final bool isSelected;
  const BoolAnswerButton(
      {required this.boolVal,
      required this.answer,
      required this.onTap,
      required this.isSelected,
      super.key});

  @override
  State<BoolAnswerButton> createState() => _BoolAnswerButtonState();
}

class _BoolAnswerButtonState extends State<BoolAnswerButton> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: SizedBox(
        height: 70,
        child: ElevatedButton(
            onPressed: widget.onTap,
            style: ElevatedButton.styleFrom(
                backgroundColor:
                    widget.isSelected ? CustomColors.blush : Colors.white),
            child: andandaProText(widget.answer, fontSize: 14)),
      ),
    );
  }
}
