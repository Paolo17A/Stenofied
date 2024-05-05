class QuizModel {
  int quizIndex;
  String quizDescription;
  List<String> wordsToWrite;

  QuizModel(
      {required this.quizIndex,
      required this.quizDescription,
      required this.wordsToWrite});
}

final allQuizModels = [
  QuizModel(quizIndex: 1, quizDescription: 'W words', wordsToWrite: [
    'wheel',
    'swimmer',
    'wolves',
    'swan',
    'whiskey',
    'wine',
    'swearing'
  ]),
  QuizModel(quizIndex: 2, quizDescription: 'Th words', wordsToWrite: [
    'sooths',
    'broth',
    'teeth',
    'theme',
    'clothes',
    'bath',
    'growth'
  ]),
  QuizModel(quizIndex: 3, quizDescription: 'Wh words', wordsToWrite: [
    'Why',
    'When',
    'Whale',
    'Where',
    'White',
    'Whine',
    'Whisper'
  ]),
  QuizModel(quizIndex: 4, quizDescription: 'oo words', wordsToWrite: [
    'loop',
    'room',
    'oompa',
    'zoom',
    'cool',
  ]),
];
