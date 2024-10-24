import 'dart:io';

import 'package:avatar_glow/avatar_glow.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:gap/gap.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_mlkit_text_recognition/google_mlkit_text_recognition.dart';
import 'package:image_picker/image_picker.dart';
import 'package:stenofied/providers/loading_provider.dart';
import 'package:stenofied/utils/color_util.dart';
import 'package:stenofied/utils/delete_entry_dialog_util.dart';
import 'package:stenofied/utils/future_util.dart';
import 'package:stenofied/utils/string_util.dart';
import 'package:stenofied/widgets/app_bar_widget.dart';
import 'package:stenofied/widgets/custom_miscellaneous_widgets.dart';
import 'package:stenofied/widgets/custom_padding_widgets.dart';
import 'package:stenofied/widgets/custom_text_field_widget.dart';
import 'package:stenofied/widgets/custom_text_widgets.dart';

import '../../utils/shorthand_util.dart';
import 'package:speech_to_text/speech_to_text.dart' as stt;

class StudentEditNoteScreen extends ConsumerStatefulWidget {
  final String noteID;
  const StudentEditNoteScreen({super.key, required this.noteID});

  @override
  ConsumerState<StudentEditNoteScreen> createState() =>
      _StudentEditNoteScreenState();
}

class _StudentEditNoteScreenState extends ConsumerState<StudentEditNoteScreen> {
  FocusNode _titleFocusNode = FocusNode();
  FocusNode _contentFocusNode = FocusNode();

  bool mayPop = false;
  bool isViewingShortHand = false;
  bool isLowerCase = true;
  final titleController = TextEditingController();
  final contentController = TextEditingController();
  ImagePicker imagePicker = ImagePicker();
  TextRecognizer textRecognizer =
      TextRecognizer(script: TextRecognitionScript.latin);
  //  SPEECH TO TEXT VARIABLES
  late stt.SpeechToText _speech;
  bool _isListening = false;

  void toggleIsViewingShortHand() {
    FocusScope.of(context).unfocus();
    setState(() {
      isViewingShortHand = !isViewingShortHand;
    });
  }

  _imgFromCamera() async {
    XFile? pickedFile = await imagePicker.pickImage(source: ImageSource.camera);
    if (pickedFile == null) return;
    File image = File(pickedFile.path);
    setState(() {
      doTextRecognition(image);
    });
  }

  doTextRecognition(File _image) async {
    InputImage inputImage = InputImage.fromFile(_image);

    final RecognizedText recognizedText =
        await textRecognizer.processImage(inputImage);

    //String text = recognizedText.text;
    String result = "";
    for (TextBlock block in recognizedText.blocks) {
      // final Rect rect = block.boundingBox;
      // final List<Point<int>> cornerPoints = block.cornerPoints;
      // final String text = block.text;
      // final List<String> languages = block.recognizedLanguages;

      for (TextLine line in block.lines) {
        // Same getters as TextBlock
        for (TextElement element in line.elements) {
          // Same getters as TextBlock
          result += "${element.text} ";
        }
        result += "\n";
      }
      result += "\n";
    }
    setState(() {
      contentController.text += result;
    });
  }

  @override
  void initState() {
    super.initState();
    _titleFocusNode.addListener(() {
      setState(() {
        isViewingShortHand = false;
      });
    });
    _contentFocusNode.addListener(() {
      setState(() {
        isViewingShortHand = false;
      });
    });
    _speech = stt.SpeechToText();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      final scaffoldMessenger = ScaffoldMessenger.of(context);
      final navigator = Navigator.of(context);
      try {
        ref.read(loadingProvider).toggleLoading(true);
        final noteDoc = await NotesCollectionUtil.getThisNote(widget.noteID);
        final noteData = noteDoc.data() as Map<dynamic, dynamic>;
        titleController.text = noteData[NotesFields.title];
        contentController.text = noteData[NotesFields.content];

        ref.read(loadingProvider).toggleLoading(false);
      } catch (error) {
        ref.read(loadingProvider).toggleLoading(false);
        scaffoldMessenger.showSnackBar(
            SnackBar(content: Text('Error getting note data: $error')));
        navigator.pop();
      }
    });
  }

  @override
  void dispose() {
    super.dispose();
    _titleFocusNode.dispose();
    _contentFocusNode.dispose();
    _speech.stop();
  }

  void _listen() async {
    print('listen button pressed');
    if (_isListening) {
      _stopListening();
      return;
    }
    setState(() {
      _isListening = true;
    });
    bool available = await _speech.initialize(
        finalTimeout: Duration(seconds: 4),
        onStatus: (val) {
          if (val == 'done') {
            setState(() {
              print('done listening');
              _isListening = false;
              _speech.stop();
            });
          }
        },
        onError: (val) {
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
              content:
                  Text('Error initializing microphone: ${val.toString()}')));
        });
    if (available) {
      print('we are available');
      setState(() {
        _isListening = true;
      });

      _speech.listen(
          //listenFor: const Duration(seconds: 4),
          /*listenOptions:
              stt.SpeechListenOptions(listenMode: stt.ListenMode.dictation),*/
          onResult: (val) {
        setState(() {
          print(val.recognizedWords);
          if (val.hasConfidenceRating && val.confidence > 0) {
            //  We must first determine if the app detected words from the mic
            int words = _getDetectedWords(val.recognizedWords);
            if (words > 1) {
              contentController.text += ' ' + val.recognizedWords + ' ';
            }
            _speech.stop();
            _isListening = false;
          }
        });
      });
    }
    //  This is for handling initialization failure
    else {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('Something happened')));
      _stopListening();
    }
  }

  void _stopListening() async {
    setState(() {
      _isListening = false;
      _speech.stop();
    });
  }

  int _getDetectedWords(String sentence) {
    List<String> words = sentence.split(' ');
    return words.length;
  }

  @override
  Widget build(BuildContext context) {
    ref.watch(loadingProvider);
    return PopScope(
      canPop: mayPop,
      onPopInvoked: mayPop
          ? null
          : (_) => displayDeleteEntryDialog(context,
                  message:
                      'Are you sure you wish to exit without saving your note?',
                  deleteWord: 'Exit', deleteEntry: () {
                if (!mounted) return;
                setState(() {
                  mayPop = true;
                });
                WidgetsBinding.instance
                    .addPostFrameCallback((_) => Navigator.of(context).pop());
              }),
      child: GestureDetector(
        onTap: () => FocusScope.of(context).unfocus(),
        child: Scaffold(
          appBar: appBarWidget(mayGoBack: true, actions: [_saveButton()]),
          body: stackedLoadingContainer(
              context,
              ref.read(loadingProvider).isLoading,
              Stack(
                children: [
                  SizedBox(
                      height: MediaQuery.of(context).size.height,
                      child: SingleChildScrollView(
                          physics: isViewingShortHand
                              ? NeverScrollableScrollPhysics()
                              : null,
                          child: all20Pix(
                            child: Column(
                              children: [
                                _titleAndConvertWidgets(),
                                Gap(12),
                                _contentContainer(),
                              ],
                            ),
                          ))),
                  if (isViewingShortHand) customShorthandKeyboard()
                ],
              )),
        ),
      ),
    );
  }

  Widget _saveButton() {
    return IconButton(
        onPressed: () {
          mayPop = true;
          NotesCollectionUtil.editThisNote(context, ref,
              noteID: widget.noteID,
              title: titleController.text.trim(),
              content: contentController.text.trim());
        },
        icon: Image.asset(ImagePaths.edit, scale: 28));
  }

  Widget _titleAndConvertWidgets() {
    return Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
      SizedBox(
        width: MediaQuery.of(context).size.width * 0.5,
        child: CustomTextField(
            text: 'Title',
            focusNode: _titleFocusNode,
            controller: titleController,
            textInputType: TextInputType.text,
            fillColor: Colors.transparent,
            textStyle: GoogleFonts.josefinSans(
                fontSize: 16, fontWeight: FontWeight.bold),
            displayPrefixIcon: null),
      ),
      AvatarGlow(
        animate: _isListening,
        glowColor: CustomColors.blush,
        child: Container(
          height: 50,
          child: ElevatedButton(
              onPressed: () => _listen(),
              style: ElevatedButton.styleFrom(
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(90))),
              child: Icon(_isListening ? Icons.mic_outlined : Icons.mic,
                  color: Colors.white)),
        ),
      ),
      SizedBox(
        height: 50,
        child: ElevatedButton(
            onPressed: _imgFromCamera,
            style: ElevatedButton.styleFrom(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(60))),
            child: Icon(Icons.camera_alt, color: Colors.white)),
      ),
    ]);
  }

  Widget _contentContainer() {
    return Container(
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20), color: CustomColors.sangria),
      padding: EdgeInsets.all(12),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              IconButton(
                  onPressed: () => toggleIsViewingShortHand(),
                  icon: Image.asset(ImagePaths.convert, scale: 1)),
            ],
          ),
          isViewingShortHand
              ? Container(
                  width: MediaQuery.of(context).size.width * 0.9,
                  height: MediaQuery.of(context).size.height * 0.25,
                  child: shortHandedContent())
              : CustomTextField(
                  text: 'Insert your content here...',
                  focusNode: _contentFocusNode,
                  controller: contentController,
                  textInputType: TextInputType.multiline,
                  fillColor: Colors.transparent,
                  borderSide: BorderSide.none,
                  textStyle: GoogleFonts.josefinSans(
                      fontSize: 16, fontWeight: FontWeight.bold),
                  displayPrefixIcon: null),
        ],
      ),
    );
  }

  Widget shortHandedContent() {
    contentController.text.replaceAll('.', '');
    contentController.text.replaceAll(',', '');
    List<String> fragmentedWords = contentController.text.split(' ');
    return SingleChildScrollView(
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
    );
  }

  Widget customShorthandKeyboard() {
    return Positioned(
      bottom: 0,
      left: 0,
      right: 0,
      child: Container(
          //height: MediaQuery.of(context).size.height * 0.3,
          decoration: BoxDecoration(
              borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(20), topRight: Radius.circular(20)),
              color: CustomColors.blush),
          padding: EdgeInsets.all(20),
          child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
            Row(mainAxisAlignment: MainAxisAlignment.center, children: [
              _customizedLetterButton('1'),
              _customizedLetterButton('2'),
              _customizedLetterButton('3'),
              _customizedLetterButton('4'),
              _customizedLetterButton('5'),
              _customizedLetterButton('6'),
              _customizedLetterButton('7'),
              _customizedLetterButton('8'),
              _customizedLetterButton('9'),
              _customizedLetterButton('0')
            ]),
            vertical10Pix(
              child:
                  Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                _customizedLetterButton('Q'),
                _customizedLetterButton('W'),
                _customizedLetterButton('E'),
                _customizedLetterButton('R'),
                _customizedLetterButton('T'),
                _customizedLetterButton('Y'),
                _customizedLetterButton('U'),
                _customizedLetterButton('I'),
                _customizedLetterButton('O'),
                _customizedLetterButton('P')
              ]),
            ),
            Row(mainAxisAlignment: MainAxisAlignment.center, children: [
              _customizedLetterButton('A'),
              _customizedLetterButton('S'),
              _customizedLetterButton('D'),
              _customizedLetterButton('F'),
              _customizedLetterButton('G'),
              _customizedLetterButton('H'),
              _customizedLetterButton('J'),
              _customizedLetterButton('K'),
              _customizedLetterButton('L'),
            ]),
            Gap(10),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _upperCaseButton(),
                _customizedLetterButton('Z'),
                _customizedLetterButton('X'),
                _customizedLetterButton('C'),
                _customizedLetterButton('V'),
                _customizedLetterButton('B'),
                _customizedLetterButton('N'),
                _customizedLetterButton('M'),
                _backspaceButton()
              ],
            ),
            Gap(10),
            Row(mainAxisAlignment: MainAxisAlignment.center, children: [
              _customizedLetterButton(','),
              _spaceBarButton(),
              _customizedLetterButton('.'),
            ])
          ])),
    );
  }

  Widget _customizedLetterButton(String letter) {
    String letterToAdd =
        isLowerCase ? letter.toLowerCase() : letter.toUpperCase();
    return Padding(
      padding: const EdgeInsets.all(2),
      child: InkWell(
        onTap: () {
          setState(() {
            contentController.text = contentController.text + letterToAdd;
          });
        },
        highlightColor: CustomColors.sangria.withOpacity(0.5),
        splashColor: Colors.white,
        child: Container(
          width: 30,
          height: 50,
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(5),
              color: CustomColors.sangria),
          child: Center(child: whiteAndadaProBold(letterToAdd, fontSize: 20)),
        ),
      ),
    );
  }

  Widget _spaceBarButton() {
    return Padding(
      padding: const EdgeInsets.all(2),
      child: InkWell(
        onTap: () {
          setState(() {
            contentController.text = contentController.text + " ";
          });
        },
        highlightColor: CustomColors.sangria.withOpacity(0.5),
        splashColor: Colors.white,
        child: Container(
          width: 170,
          height: 50,
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(5),
              color: CustomColors.sangria),
          child: Center(child: whiteAndadaProBold("", fontSize: 20)),
        ),
      ),
    );
  }

  Widget _upperCaseButton() {
    return Padding(
      padding: const EdgeInsets.all(2),
      child: InkWell(
        onTap: () {
          if (contentController.text.isEmpty) return;
          setState(() {
            isLowerCase = !isLowerCase;
          });
        },
        highlightColor: CustomColors.sangria.withOpacity(0.5),
        splashColor: Colors.white,
        child: Container(
          width: 50,
          height: 50,
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(5),
              color: CustomColors.sangria),
          child: Center(
              child: Icon(
                  isLowerCase ? Icons.arrow_upward_sharp : Icons.arrow_upward,
                  color: Colors.white)),
        ),
      ),
    );
  }

  Widget _backspaceButton() {
    return Padding(
      padding: const EdgeInsets.all(2),
      child: InkWell(
        onTap: () {
          if (contentController.text.isEmpty) return;
          setState(() {
            contentController.text = contentController.text
                .substring(0, contentController.text.length - 1);
          });
        },
        highlightColor: CustomColors.sangria.withOpacity(0.5),
        splashColor: Colors.white,
        child: Container(
          width: 50,
          height: 50,
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(5),
              color: CustomColors.sangria),
          child: Center(child: Icon(Icons.arrow_back, color: Colors.white)),
        ),
      ),
    );
  }
}
