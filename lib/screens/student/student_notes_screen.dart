import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';
import 'package:intl/intl.dart';
import 'package:stenofied/providers/loading_provider.dart';
import 'package:stenofied/providers/notes_provider.dart';
import 'package:stenofied/utils/color_util.dart';
import 'package:stenofied/utils/delete_entry_dialog_util.dart';
import 'package:stenofied/utils/future_util.dart';
import 'package:stenofied/utils/string_util.dart';
import 'package:stenofied/widgets/custom_miscellaneous_widgets.dart';
import 'package:stenofied/widgets/custom_padding_widgets.dart';
import 'package:stenofied/widgets/custom_text_widgets.dart';
import 'package:stenofied/widgets/navigator_rail_widget.dart';

import '../../utils/navigator_util.dart';
import '../../widgets/app_drawer_widget.dart';

class StudentNotesScreen extends ConsumerStatefulWidget {
  const StudentNotesScreen({super.key});

  @override
  ConsumerState<StudentNotesScreen> createState() => _StudentNotesScreenState();
}

class _StudentNotesScreenState extends ConsumerState<StudentNotesScreen> {
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      final scaffoldMessenger = ScaffoldMessenger.of(context);
      try {
        ref.read(loadingProvider).toggleLoading(true);
        ref
            .read(notesProvider)
            .setNotesDocs(await NotesCollectionUtil.getCurrentUserNotes());
        ref.read(loadingProvider).toggleLoading(false);
      } catch (error) {
        ref.read(loadingProvider).toggleLoading(false);
        scaffoldMessenger.showSnackBar(
            SnackBar(content: Text('Error getting student notes: $error')));
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    ref.watch(loadingProvider);
    ref.watch(notesProvider);
    return Scaffold(
      key: scaffoldKey,
      drawer: studentAppDrawer(context, ref,
          currentPath: NavigatorRoutes.studentNotes),
      body: safeAreaWithRail(context,
          railWidget: studentRail(context, scaffoldKey,
              selectedIndex: 4, currentPath: NavigatorRoutes.studentNotes),
          mainWidget: SizedBox(
            height: MediaQuery.of(context).size.height,
            child: SingleChildScrollView(
              child: Column(
                children: [
                  _addNoteButton(),
                  _myNotesHeader(),
                  _notesContainer()
                ],
              ),
            ),
          )),
    );
  }

  Widget _addNoteButton() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        TextButton(
            onPressed: () =>
                Navigator.of(context).pushNamed(NavigatorRoutes.studentAddNote),
            child: blackAndadaProBold('+', fontSize: 24)),
      ],
    );
  }

  Widget _myNotesHeader() {
    return vertical20Pix(child: blackCinzelBold('MY NOTES', fontSize: 36));
  }

  Widget _notesContainer() {
    return all20Pix(
      child: ref.read(notesProvider).getNoteDocs().isNotEmpty
          ? ListView.builder(
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
              itemCount: ref.read(notesProvider).getNoteDocs().length,
              itemBuilder: (context, index) => _noteEntryWidget(
                  index, ref.read(notesProvider).getNoteDocs()[index]),
            )
          : Center(
              child: blackAndadaProRegular('You have not yet created any notes',
                  fontSize: 24)),
    );
  }

  Widget _noteEntryWidget(int index, DocumentSnapshot noteDoc) {
    final noteData = noteDoc.data() as Map<dynamic, dynamic>;
    String title = noteData[NotesFields.title];
    String content = noteData[NotesFields.content];
    DateTime dateModified =
        (noteData[NotesFields.dateModified] as Timestamp).toDate();
    return GestureDetector(
      onTap: () => NavigatorRoutes.studentEditNote(context, noteID: noteDoc.id),
      onLongPress: () => showModalBottomSheet(
        context: context,
        builder: (_) => SingleChildScrollView(
          child: Column(
            children: [
              ListTile(
                  tileColor: Colors.white,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(30),
                          topRight: Radius.circular(30))),
                  title: Center(
                    child: blackJosefinSansBold('Delete Note'),
                  ),
                  onTap: () {
                    Navigator.of(context).pop();
                    displayDeleteEntryDialog(context,
                        message: 'Are you sure you wish to delete this note?',
                        deleteEntry: () => NotesCollectionUtil.deleteThisNote(
                            context, ref,
                            noteID: noteDoc.id));
                  }),
            ],
          ),
        ),
      ),
      child: vertical10Pix(
          child: Container(
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: index % 2 == 0
                      ? CustomColors.ketchup
                      : CustomColors.blush),
              padding: EdgeInsets.all(8),
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    blackAndadaProBold(title,
                        textAlign: TextAlign.left,
                        textOverflow: TextOverflow.ellipsis,
                        maxLines: 1,
                        fontSize: 16),
                    Row(children: [
                      blackAndadaProBold('Date Last Mofied: ',
                          textAlign: TextAlign.left,
                          textOverflow: TextOverflow.ellipsis),
                      blackAndadaProRegular(
                          DateFormat('MMM dd, yyyy').format(dateModified),
                          textAlign: TextAlign.left,
                          textOverflow: TextOverflow.ellipsis)
                    ]),
                    Gap(4),
                    blackAndadaProRegular(content,
                        textAlign: TextAlign.left,
                        maxLines: 2,
                        textOverflow: TextOverflow.ellipsis)
                  ]))),
    );
  }
}
