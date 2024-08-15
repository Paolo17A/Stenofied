import 'package:easy_pdf_viewer/easy_pdf_viewer.dart';
import 'package:flutter/material.dart';
import 'package:stenofied/models/lesson_model.dart';
import 'package:stenofied/utils/color_util.dart';
import 'package:stenofied/widgets/app_bar_widget.dart';

class StudentSelectedLessonScreen extends StatelessWidget {
  final LessonModel lessonModel;
  const StudentSelectedLessonScreen({super.key, required this.lessonModel});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBarWidget(mayGoBack: true),
      body: FutureBuilder(
        future: PDFDocument.fromAsset(lessonModel.modulePath),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: const CircularProgressIndicator());
          } else if (!snapshot.hasData || snapshot.hasError) {
            print('HAS DATA: ${snapshot.hasData}');
            return Text('Error viewing PDF');
          }
          return PDFViewer(
            document: snapshot.data!,
            pickerButtonColor: CustomColors.ketchup,
          );
        },
      ),
    );
  }
}
