import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:stenofied/providers/loading_provider.dart';
import 'package:stenofied/utils/future_util.dart';
import 'package:stenofied/utils/navigator_util.dart';
import 'package:stenofied/utils/string_util.dart';
import 'package:stenofied/widgets/app_bar_widget.dart';
import 'package:stenofied/widgets/custom_miscellaneous_widgets.dart';
import 'package:stenofied/widgets/custom_padding_widgets.dart';

import '../utils/color_util.dart';
import '../widgets/custom_text_widgets.dart';

class AdminViewSectionsScreen extends ConsumerStatefulWidget {
  const AdminViewSectionsScreen({super.key});

  @override
  ConsumerState<AdminViewSectionsScreen> createState() =>
      _AdminViewSectionsScreenState();
}

class _AdminViewSectionsScreenState
    extends ConsumerState<AdminViewSectionsScreen> {
  List<DocumentSnapshot> sectionDocs = [];

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) async {
      try {
        ref.read(loadingProvider).toggleLoading(true);
        sectionDocs = await getAllSectionDocs();
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
            SingleChildScrollView(
              child: all20Pix(
                  child: Column(
                children: [
                  blackInterBold('SECTIONS', fontSize: 40),
                  Divider(color: CustomColors.turquoise),
                  sectionEntries()
                ],
              )),
            )),
      ),
    );
  }

  Widget sectionEntries() {
    return sectionDocs.isNotEmpty
        ? ListView.builder(
            shrinkWrap: true,
            itemCount: sectionDocs.length,
            itemBuilder: (context, index) {
              final sectionData =
                  sectionDocs[index].data() as Map<dynamic, dynamic>;
              String name = sectionData[SectionFields.name];
              return ElevatedButton(
                  onPressed: () => NavigatorRoutes.adminSelectedSection(context,
                      sectionID: sectionDocs[index].id),
                  child: whiteInterBold(name));
            })
        : all20Pix(
            child: blackInterBold('NO AVAILABLE SECTIONS', fontSize: 25));
  }
}
