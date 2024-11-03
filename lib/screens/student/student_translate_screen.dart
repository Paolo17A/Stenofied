import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:stenofied/utils/navigator_util.dart';
import 'package:stenofied/widgets/app_drawer_widget.dart';
import 'package:stenofied/widgets/custom_miscellaneous_widgets.dart';
import 'package:stenofied/widgets/custom_padding_widgets.dart';
import 'package:stenofied/widgets/navigator_rail_widget.dart';

import '../../utils/color_util.dart';
import '../../utils/shorthand_util.dart';
import '../../utils/string_util.dart';
import '../../widgets/custom_text_field_widget.dart';
import '../../widgets/custom_text_widgets.dart';

class StudentTranslateScreen extends ConsumerStatefulWidget {
  const StudentTranslateScreen({super.key});

  @override
  ConsumerState<StudentTranslateScreen> createState() =>
      _StudentTranslateScreenState();
}

class _StudentTranslateScreenState
    extends ConsumerState<StudentTranslateScreen> {
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();
  final TextEditingController contentController = TextEditingController();
  FocusNode _contentFocusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    _contentFocusNode.addListener(() {
      setState(() {});
    });
    contentController.addListener(() {
      setState(() {});
    });
  }

  @override
  void dispose() {
    super.dispose();
    _contentFocusNode.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        drawer: studentAppDrawer(context, ref,
            currentPath: NavigatorRoutes.studentTranslate),
        body: safeAreaWithRail(context,
            railWidget: studentRail(context, scaffoldKey,
                selectedIndex: 5,
                currentPath: NavigatorRoutes.studentTranslate),
            mainWidget: SizedBox(
              height: MediaQuery.of(context).size.height,
              width: MediaQuery.of(context).size.width,
              child: SingleChildScrollView(
                child: all20Pix(
                    child: Column(
                  children: [
                    _header(),
                    _contentContainer(),
                    _shortHandContainer()
                  ],
                )),
              ),
            )),
      ),
    );
  }

  Widget _header() {
    return Row(mainAxisAlignment: MainAxisAlignment.center, children: [
      blackAndadaProBold('LONGHAND', fontSize: 20),
      Column(children: [
        Icon(Icons.arrow_right_alt_outlined),
        Transform.flip(
            flipX: true, child: Icon(Icons.arrow_right_alt_outlined)),
      ]),
      blackAndadaProBold('SHORTHAND', fontSize: 20),
    ]);
  }

  Widget _contentContainer() {
    return vertical20Pix(
      child: Container(
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            color: CustomColors.sangria),
        padding: EdgeInsets.all(12),
        child: CustomTextField(
            text: 'Insert your content here...',
            controller: contentController,
            focusNode: _contentFocusNode,
            textInputType: TextInputType.multiline,
            fillColor: Colors.white,
            borderSide: BorderSide.none,
            textStyle: GoogleFonts.josefinSans(
                fontSize: 16, fontWeight: FontWeight.bold),
            displayPrefixIcon: null),
      ),
    );
  }

  Widget _shortHandContainer() {
    return Container(
        width: double.infinity,
        height: 360,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20), color: CustomColors.blush),
        padding: EdgeInsets.all(12),
        child: shortHandedContent());
  }

  Widget shortHandedContent() {
    String filteredCharacters = contentController.text;
    filteredCharacters =
        filteredCharacters.replaceAll(RegExp(r'[^a-zA-Z0-9\s]'), '');
    filteredCharacters = filteredCharacters.toLowerCase();
    List<String> fragmentedWords = filteredCharacters.split(' ');
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
      ),
      child: SingleChildScrollView(
        child: all20Pix(
          child: Wrap(
              spacing: 4,
              runSpacing: 4,
              children: fragmentedWords.map((word) {
                if (ShortHandUtil.vectorMap.keys.contains(word)) {
                  return Container(
                      width: 50,
                      height: 50,
                      child: SvgPicture.asset(ShortHandUtil.vectorMap[word]!,
                          fit: BoxFit.fill));
                } else {
                  return Wrap(
                      children: getLetters(word)
                          .map((letter) => Container(
                              width: 50,
                              height: 50,
                              child: ShortHandUtil.vectorMap[letter] != null
                                  ? SvgPicture.asset(
                                      ShortHandUtil.vectorMap[letter]!,
                                      fit: BoxFit.fill)
                                  : Text(letter)))
                          .toList());
                }
              }).toList()),
        ),
      ),
    );
  }
}
