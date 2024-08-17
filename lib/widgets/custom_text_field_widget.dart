import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../utils/color_util.dart';

class CustomTextField extends StatefulWidget {
  final String text;
  final TextEditingController controller;
  final TextInputType textInputType;
  final Icon? displayPrefixIcon;
  final bool enabled;
  final bool hasSearchButton;
  final Function? onSearchPress;
  final Color? fillColor;
  final TextStyle? textStyle;
  final BorderSide? borderSide;
  final FocusNode? focusNode;
  const CustomTextField(
      {super.key,
      required this.text,
      required this.controller,
      required this.textInputType,
      required this.displayPrefixIcon,
      this.enabled = true,
      this.hasSearchButton = false,
      this.fillColor,
      this.onSearchPress,
      this.textStyle,
      this.focusNode,
      this.borderSide});

  @override
  State<CustomTextField> createState() => _LiliwECommerceTextFieldState();
}

class _LiliwECommerceTextFieldState extends State<CustomTextField> {
  late bool isObscured;

  @override
  void initState() {
    super.initState();
    isObscured = widget.textInputType == TextInputType.visiblePassword;
  }

  @override
  Widget build(BuildContext context) {
    return TextField(
        enabled: widget.enabled,
        focusNode: widget.focusNode,
        controller: widget.controller,
        obscureText: isObscured,
        cursorColor: Colors.black,
        onSubmitted: (value) {
          if (widget.onSearchPress != null &&
              widget.controller.text.isNotEmpty) {
            widget.onSearchPress!();
          }
        },
        style:
            widget.textStyle ?? TextStyle(color: Colors.black.withOpacity(0.9)),
        decoration: InputDecoration(
            alignLabelWithHint: true,
            labelText: widget.text,
            labelStyle: GoogleFonts.josefinSans(
                textStyle: TextStyle(
                    color: Colors.black.withOpacity(0.5),
                    fontStyle: FontStyle.italic)),
            filled: true,
            floatingLabelBehavior: FloatingLabelBehavior.never,
            fillColor: widget.fillColor ?? Colors.white.withOpacity(0.9),
            border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: widget.borderSide ??
                    const BorderSide(color: Colors.black, width: 3.0)),
            contentPadding:
                const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
            prefixIcon: widget.displayPrefixIcon,
            suffixIcon: widget.textInputType == TextInputType.visiblePassword
                ? IconButton(
                    onPressed: () {
                      setState(() {
                        isObscured = !isObscured;
                      });
                    },
                    icon: Icon(
                      isObscured ? Icons.visibility : Icons.visibility_off,
                      color: Colors.black.withOpacity(0.6),
                    ))
                : widget.hasSearchButton && widget.onSearchPress != null
                    ? Transform.scale(
                        scale: 0.95,
                        child: ElevatedButton(
                            onPressed: () {
                              if (widget.controller.text.isEmpty) return;
                              widget.onSearchPress!();
                            },
                            style: ElevatedButton.styleFrom(
                                backgroundColor: CustomColors.ketchup),
                            child: const Icon(
                              Icons.search,
                              color: Colors.white,
                            )),
                      )
                    : null),
        keyboardType: widget.textInputType,
        maxLines: widget.textInputType == TextInputType.multiline ? 10 : 1);
  }
}
