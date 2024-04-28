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
];
