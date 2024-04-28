import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:stenofied/providers/loading_provider.dart';
import 'package:stenofied/utils/color_util.dart';
import 'package:stenofied/utils/future_util.dart';
import 'package:stenofied/widgets/app_bar_widget.dart';
import 'package:stenofied/widgets/custom_miscellaneous_widgets.dart';
import 'package:stenofied/widgets/custom_padding_widgets.dart';
import 'package:stenofied/widgets/custom_text_widgets.dart';

class AdminAddSectionScreen extends ConsumerStatefulWidget {
  const AdminAddSectionScreen({super.key});

  @override
  ConsumerState<AdminAddSectionScreen> createState() =>
      _AdminAddSectionScreenState();
}

class _AdminAddSectionScreenState extends ConsumerState<AdminAddSectionScreen> {
  final nameController = TextEditingController();

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
                blackInterBold('CREATE NEW SECTION', fontSize: 25),
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
          color: CustomColors.ketchup, borderRadius: BorderRadius.circular(10)),
      child: regularTextField(
          label: 'Section Name', textController: nameController),
    ));
  }

  Widget createSectionButton() {
    return vertical10Pix(
        child: ElevatedButton(
            onPressed: () =>
                addNewSection(context, ref, nameController: nameController),
            child: whiteInterBold('CREATE SECTION')));
  }
}
