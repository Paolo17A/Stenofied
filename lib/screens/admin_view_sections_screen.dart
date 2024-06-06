import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';
import 'package:stenofied/providers/loading_provider.dart';
import 'package:stenofied/providers/sections_provider.dart';
import 'package:stenofied/utils/color_util.dart';
import 'package:stenofied/utils/future_util.dart';
import 'package:stenofied/utils/navigator_util.dart';
import 'package:stenofied/utils/string_util.dart';
import 'package:stenofied/widgets/app_bar_widget.dart';
import 'package:stenofied/widgets/custom_miscellaneous_widgets.dart';
import 'package:stenofied/widgets/custom_padding_widgets.dart';

import '../widgets/custom_text_widgets.dart';

class AdminViewSectionsScreen extends ConsumerStatefulWidget {
  const AdminViewSectionsScreen({super.key});

  @override
  ConsumerState<AdminViewSectionsScreen> createState() =>
      _AdminViewSectionsScreenState();
}

class _AdminViewSectionsScreenState
    extends ConsumerState<AdminViewSectionsScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) async {
      try {
        ref.read(loadingProvider).toggleLoading(true);
        ref.read(sectionsProvider).setSectionDocs(await getAllSectionDocs());

        //sectionDocs = await getAllSectionDocs();
        ref.read(loadingProvider).toggleLoading(false);
      } catch (error) {
        ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Error getting all sections: $error')));
        ref.read(loadingProvider).toggleLoading(false);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    ref.watch(loadingProvider);
    return PopScope(
      onPopInvoked: (_) => WidgetsBinding.instance.addPostFrameCallback(
          (timeStamp) => Navigator.of(context)
              .pushReplacementNamed(NavigatorRoutes.adminHome)),
      child: Scaffold(
        appBar: appBarWidget(mayGoBack: true, actions: [
          IconButton(
              onPressed: () => Navigator.of(context)
                  .pushNamed(NavigatorRoutes.adminAddSection),
              icon: Icon(Icons.add))
        ]),
        body: switchedLoadingContainer(
            ref.read(loadingProvider).isLoading,
            SizedBox(
              width: MediaQuery.of(context).size.width,
              child: SingleChildScrollView(
                child: all20Pix(
                    child: Column(
                  children: [
                    blackCinzelBold('SECTIONS', fontSize: 40),
                    Gap(60),
                    sectionEntries()
                  ],
                )),
              ),
            )),
      ),
    );
  }

  Widget sectionEntries() {
    return ref.read(sectionsProvider).sectionDocs.isNotEmpty
        ? Wrap(
            runAlignment: WrapAlignment.spaceAround,
            spacing: 12,
            runSpacing: 12,
            children: ref
                .read(sectionsProvider)
                .sectionDocs
                .asMap()
                .entries
                .map((section) {
              int index = section.key;
              final sectionData = section.value.data() as Map<dynamic, dynamic>;
              String name = sectionData[SectionFields.name];
              return Container(
                width: MediaQuery.of(context).size.width * 0.35,
                height: MediaQuery.of(context).size.width * 0.4,
                decoration: BoxDecoration(
                    color: CustomColors.ketchup,
                    borderRadius: BorderRadius.only(
                      topLeft: index % 4 == 0 || index % 4 == 3
                          ? Radius.zero
                          : Radius.circular(60),
                      topRight: index % 4 == 1 || index % 4 == 2
                          ? Radius.zero
                          : Radius.circular(60),
                      bottomLeft: index % 4 == 1 || index % 4 == 2
                          ? Radius.zero
                          : Radius.circular(60),
                      bottomRight: index % 4 == 0 || index % 4 == 3
                          ? Radius.zero
                          : Radius.circular(60),
                    )),
                child: TextButton(
                    onPressed: () => NavigatorRoutes.adminSelectedSection(
                        context,
                        sectionID: section.value.id),
                    child: whiteAndadaProBold(name)),
              );
            }).toList(),
          )
        : all20Pix(
            child: blackAndadaProBold('NO AVAILABLE SECTIONS', fontSize: 25));
  }
}
