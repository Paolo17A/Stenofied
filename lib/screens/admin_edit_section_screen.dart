import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:stenofied/providers/loading_provider.dart';
import 'package:stenofied/utils/color_util.dart';
import 'package:stenofied/utils/future_util.dart';
import 'package:stenofied/utils/string_util.dart';
import 'package:stenofied/widgets/app_bar_widget.dart';
import 'package:stenofied/widgets/custom_miscellaneous_widgets.dart';
import 'package:stenofied/widgets/custom_padding_widgets.dart';
import 'package:stenofied/widgets/custom_text_widgets.dart';

class AdminEditSectionScreen extends ConsumerStatefulWidget {
  final String sectionID;
  const AdminEditSectionScreen({super.key, required this.sectionID});

  @override
  ConsumerState<AdminEditSectionScreen> createState() =>
      _AdminEditSectionScreenState();
}

class _AdminEditSectionScreenState
    extends ConsumerState<AdminEditSectionScreen> {
  final nameController = TextEditingController();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      try {
        ref.read(loadingProvider).toggleLoading(true);
        final section = await getThisSectionDoc(widget.sectionID);
        final sectionData = section.data() as Map<dynamic, dynamic>;
        nameController.text = sectionData[SectionFields.name];
        ref.read(loadingProvider).toggleLoading(false);
      } catch (error) {
        ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Error getting section details: $error')));
        ref.read(loadingProvider).toggleLoading(false);
      }
    });
  }

  @override
  void dispose() {
    super.dispose();
    nameController.dispose();
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
            SingleChildScrollView(
                child: all20Pix(
                    child: Column(
              children: [
                blackInterBold('EDIT SECTION', fontSize: 25),
                sectionDetails(),
                createSectionButton()
              ],
            )))),
      ),
    );
  }

  Widget sectionDetails() {
    return vertical10Pix(
        child: Container(
      decoration: BoxDecoration(
          color: CustomColors.turquoise,
          borderRadius: BorderRadius.circular(10)),
      child: regularTextField(
          label: 'Section Name', textController: nameController),
    ));
  }

  Widget createSectionButton() {
    return vertical10Pix(
        child: ElevatedButton(
            onPressed: () => editThisSection(context, ref,
                sectionID: widget.sectionID, nameController: nameController),
            child: whiteInterBold('EDIT SECTION')));
  }
}
