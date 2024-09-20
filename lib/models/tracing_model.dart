import 'package:stenofied/utils/string_util.dart';

class ExerciseModel {
  int exerciseIndex;
  String exerciseDescription;
  List<TracingModel> tracingModels;
  ExerciseModel(
      {required this.exerciseIndex,
      required this.exerciseDescription,
      required this.tracingModels});
}

final alphabetExercise = ExerciseModel(
    exerciseIndex: 1,
    exerciseDescription: 'Alphabet',
    tracingModels: [
      TracingModel(
          word: 'A', imagePath: '${ImagePaths.tracingPath}/alphabet/A.jpg'),
      TracingModel(
          word: 'B', imagePath: '${ImagePaths.tracingPath}/alphabet/B.jpg'),
      TracingModel(
          word: 'C', imagePath: '${ImagePaths.tracingPath}/alphabet/C.jpg'),
      TracingModel(
          word: 'D', imagePath: '${ImagePaths.tracingPath}/alphabet/D.jpg'),
      TracingModel(
          word: 'E', imagePath: '${ImagePaths.tracingPath}/alphabet/E.jpg'),
      TracingModel(
          word: 'F', imagePath: '${ImagePaths.tracingPath}/alphabet/F.jpg'),
      TracingModel(
          word: 'G', imagePath: '${ImagePaths.tracingPath}/alphabet/G.jpg'),
      TracingModel(
          word: 'H', imagePath: '${ImagePaths.tracingPath}/alphabet/H.jpg'),
      TracingModel(
          word: 'I', imagePath: '${ImagePaths.tracingPath}/alphabet/I.jpg'),
      TracingModel(
          word: 'J', imagePath: '${ImagePaths.tracingPath}/alphabet/J.jpg'),
      TracingModel(
          word: 'K', imagePath: '${ImagePaths.tracingPath}/alphabet/K.jpg'),
      TracingModel(
          word: 'L', imagePath: '${ImagePaths.tracingPath}/alphabet/L.jpg'),
      TracingModel(
          word: 'M', imagePath: '${ImagePaths.tracingPath}/alphabet/M.jpg'),
      TracingModel(
          word: 'N', imagePath: '${ImagePaths.tracingPath}/alphabet/N.jpg'),
      TracingModel(
          word: 'O', imagePath: '${ImagePaths.tracingPath}/alphabet/O.jpg'),
      TracingModel(
          word: 'P', imagePath: '${ImagePaths.tracingPath}/alphabet/P.jpg'),
      TracingModel(
          word: 'Q', imagePath: '${ImagePaths.tracingPath}/alphabet/Q.jpg'),
      TracingModel(
          word: 'R', imagePath: '${ImagePaths.tracingPath}/alphabet/R.jpg'),
      TracingModel(
          word: 'S', imagePath: '${ImagePaths.tracingPath}/alphabet/S.jpg'),
      TracingModel(
          word: 'T', imagePath: '${ImagePaths.tracingPath}/alphabet/T.jpg'),
      TracingModel(
          word: 'U', imagePath: '${ImagePaths.tracingPath}/alphabet/U.jpg'),
      TracingModel(
          word: 'V', imagePath: '${ImagePaths.tracingPath}/alphabet/V.jpg'),
      TracingModel(
          word: 'W', imagePath: '${ImagePaths.tracingPath}/alphabet/W.jpg'),
      TracingModel(
          word: 'X', imagePath: '${ImagePaths.tracingPath}/alphabet/X.jpg'),
      TracingModel(
          word: 'Y', imagePath: '${ImagePaths.tracingPath}/alphabet/Y.jpg'),
      TracingModel(
          word: 'Z', imagePath: '${ImagePaths.tracingPath}/alphabet/Z.jpg')
    ]);

final allExerciseModels = [
  alphabetExercise,
  ExerciseModel(
      exerciseIndex: 2,
      exerciseDescription: 'T, D Words',
      tracingModels: [
        TracingModel(
            word: 'meat', imagePath: '${ImagePaths.tracingPath}/L1T1.png'),
        TracingModel(
            word: 'dim', imagePath: '${ImagePaths.tracingPath}/L1T2.png'),
        TracingModel(
            word: 'eat', imagePath: '${ImagePaths.tracingPath}/L1T3.png'),
        TracingModel(
            word: 'did', imagePath: '${ImagePaths.tracingPath}/L1T4.png'),
        TracingModel(
            word: 'teen', imagePath: '${ImagePaths.tracingPath}/L1T5.png'),
        TracingModel(
            word: 'team', imagePath: '${ImagePaths.tracingPath}/L1T6.png'),
        TracingModel(
            word: 'data', imagePath: '${ImagePaths.tracingPath}/L1T7.png'),
        TracingModel(
            word: 'meet', imagePath: '${ImagePaths.tracingPath}/L1T8.png'),
        TracingModel(
            word: 'tame', imagePath: '${ImagePaths.tracingPath}/L1T9.png'),
      ]),
  ExerciseModel(
      exerciseIndex: 3,
      exerciseDescription: 'H, I, -ing Words',
      tracingModels: [
        TracingModel(
            word: 'aiding', imagePath: '${ImagePaths.tracingPath}/L2T1.png'),
        TracingModel(
            word: 'ham', imagePath: '${ImagePaths.tracingPath}/L2T2.png'),
        TracingModel(
            word: 'hat', imagePath: '${ImagePaths.tracingPath}/L2T3.png'),
        TracingModel(
            word: 'heading', imagePath: '${ImagePaths.tracingPath}/L2T4.png'),
        TracingModel(
            word: 'meeting', imagePath: '${ImagePaths.tracingPath}/L2T5.png'),
        TracingModel(
            word: 'heat', imagePath: '${ImagePaths.tracingPath}/L2T6.png'),
        TracingModel(
            word: 'meaning', imagePath: '${ImagePaths.tracingPath}/L2T7.png'),
        TracingModel(
            word: 'taming', imagePath: '${ImagePaths.tracingPath}/L2T8.png'),
        TracingModel(
            word: 'tie', imagePath: '${ImagePaths.tracingPath}/L2T9.png'),
        TracingModel(
            word: 'dime', imagePath: '${ImagePaths.tracingPath}/L2T10.png'),
        TracingModel(
            word: 'night', imagePath: '${ImagePaths.tracingPath}/L2T11.png'),
        TracingModel(
            word: 'dying', imagePath: '${ImagePaths.tracingPath}/L2T12.png'),
        TracingModel(
            word: 'might', imagePath: '${ImagePaths.tracingPath}/L2T13.png'),
        TracingModel(
            word: 'died', imagePath: '${ImagePaths.tracingPath}/L2T14.png'),
        TracingModel(
            word: 'nine', imagePath: '${ImagePaths.tracingPath}/L2T15.png'),
        TracingModel(
            word: 'mine', imagePath: '${ImagePaths.tracingPath}/L2T16.png'),
        TracingModel(
            word: 'tied', imagePath: '${ImagePaths.tracingPath}/L2T17.png')
      ]),
  ExerciseModel(
      exerciseIndex: 4,
      exerciseDescription: 'O, R, L words',
      tracingModels: [
        TracingModel(
            word: 'Tow', imagePath: '${ImagePaths.tracingPath}/L3T1.png'),
        TracingModel(
            word: 'on', imagePath: '${ImagePaths.tracingPath}/L3T2.png'),
        TracingModel(
            word: 'know', imagePath: '${ImagePaths.tracingPath}/L3T3.png'),
        TracingModel(
            word: 'no', imagePath: '${ImagePaths.tracingPath}/L3T4.png'),
        TracingModel(
            word: 'mode', imagePath: '${ImagePaths.tracingPath}/L3T5.png'),
        TracingModel(
            word: 'nod', imagePath: '${ImagePaths.tracingPath}/L3T6.png'),
        TracingModel(
            word: 'note', imagePath: '${ImagePaths.tracingPath}/L3T7.png'),
        TracingModel(
            word: 'odd', imagePath: '${ImagePaths.tracingPath}/L3T8.png'),
        TracingModel(
            word: 'owning', imagePath: '${ImagePaths.tracingPath}/L3T9.png'),
        TracingModel(
            word: 'toning', imagePath: '${ImagePaths.tracingPath}/L3T10.png'),
        TracingModel(
            word: 'Totie', imagePath: '${ImagePaths.tracingPath}/L3T11.png'),
        TracingModel(
            word: 'Tom', imagePath: '${ImagePaths.tracingPath}/L3T12.png'),
        TracingModel(
            word: 'tear', imagePath: '${ImagePaths.tracingPath}/L3T13.png'),
        TracingModel(
            word: 'dire', imagePath: '${ImagePaths.tracingPath}/L3T14.png'),
        TracingModel(
            word: 'more', imagePath: '${ImagePaths.tracingPath}/L3T15.png'),
        TracingModel(
            word: 'dear', imagePath: '${ImagePaths.tracingPath}/L3T16.png'),
        TracingModel(
            word: 'or', imagePath: '${ImagePaths.tracingPath}/L3T17.png'),
        TracingModel(
            word: 'raid', imagePath: '${ImagePaths.tracingPath}/L3T18.png'),
        TracingModel(
            word: 'drain', imagePath: '${ImagePaths.tracingPath}/L3T19.png'),
        TracingModel(
            word: 'rate', imagePath: '${ImagePaths.tracingPath}/L3T20.png'),
        TracingModel(
            word: 'ray', imagePath: '${ImagePaths.tracingPath}/L3T21.png'),
        TracingModel(
            word: 'tried', imagePath: '${ImagePaths.tracingPath}/L3T22.png'),
        TracingModel(
            word: 'road', imagePath: '${ImagePaths.tracingPath}/L3T23.png'),
        TracingModel(
            word: 'row', imagePath: '${ImagePaths.tracingPath}/L3T24.png'),
        TracingModel(
            word: 'trade', imagePath: '${ImagePaths.tracingPath}/L3T25.png'),
        TracingModel(
            word: 'rain', imagePath: '${ImagePaths.tracingPath}/L3T26.png'),
        TracingModel(
            word: 'tale', imagePath: '${ImagePaths.tracingPath}/L3T27.png'),
        TracingModel(
            word: 'Lanie', imagePath: '${ImagePaths.tracingPath}/L3T28.png'),
        TracingModel(
            word: 'let', imagePath: '${ImagePaths.tracingPath}/L3T29.png'),
        TracingModel(
            word: 'lain', imagePath: '${ImagePaths.tracingPath}/L3T30.png'),
        TracingModel(
            word: 'Lee', imagePath: '${ImagePaths.tracingPath}/L3T31.png'),
        TracingModel(
            word: 'loan', imagePath: '${ImagePaths.tracingPath}/L3T32.png'),
        TracingModel(
            word: 'lead', imagePath: '${ImagePaths.tracingPath}/L3T33.png'),
        TracingModel(
            word: 'lied', imagePath: '${ImagePaths.tracingPath}/L3T34.png'),
        TracingModel(
            word: 'light', imagePath: '${ImagePaths.tracingPath}/L3T35.png'),
        TracingModel(
            word: 'lite', imagePath: '${ImagePaths.tracingPath}/L3T36.png'),
        TracingModel(
            word: 'low', imagePath: '${ImagePaths.tracingPath}/L3T37.png'),
        TracingModel(
            word: 'mailing', imagePath: '${ImagePaths.tracingPath}/L3T38.png'),
      ]),
  ExerciseModel(
      exerciseIndex: 5,
      exerciseDescription:
          'Omission of Minor Vowel Words & Shorthand Principle for the Sound of Short I',
      tracingModels: [
        TracingModel(
            word: 'dealer', imagePath: '${ImagePaths.tracingPath}/L4T1.png'),
        TracingModel(
            word: 'delay', imagePath: '${ImagePaths.tracingPath}/L4T2.png'),
        TracingModel(
            word: 'delight', imagePath: '${ImagePaths.tracingPath}/L4T3.png'),
        TracingModel(
            word: 'later', imagePath: '${ImagePaths.tracingPath}/L4T4.png'),
        TracingModel(
            word: 'leader', imagePath: '${ImagePaths.tracingPath}/L4T5.png'),
        TracingModel(
            word: 'lighter', imagePath: '${ImagePaths.tracingPath}/L4T6.png'),
        TracingModel(
            word: 'meter', imagePath: '${ImagePaths.tracingPath}/L4T7.png'),
        TracingModel(
            word: 'motor', imagePath: '${ImagePaths.tracingPath}/L4T8.png'),
        TracingModel(
            word: 'reader', imagePath: '${ImagePaths.tracingPath}/L4T9.png'),
        TracingModel(
            word: 'mother', imagePath: '${ImagePaths.tracingPath}/L4T10.png'),
        TracingModel(
            word: 'tid', imagePath: '${ImagePaths.tracingPath}/L4T11.png'),
        TracingModel(
            word: 'rim', imagePath: '${ImagePaths.tracingPath}/L4T12.png'),
        TracingModel(
            word: 'hit', imagePath: '${ImagePaths.tracingPath}/L4T13.png'),
        TracingModel(
            word: 'hit', imagePath: '${ImagePaths.tracingPath}/L4T14.png'),
        TracingModel(
            word: 'knit', imagePath: '${ImagePaths.tracingPath}/L4T15.png'),
        TracingModel(
            word: 'lit', imagePath: '${ImagePaths.tracingPath}/L4T16.png'),
        TracingModel(
            word: 'little', imagePath: '${ImagePaths.tracingPath}/L4T17.png'),
        TracingModel(
            word: 'Tim', imagePath: '${ImagePaths.tracingPath}/L4T18.png'),
      ]),
  ExerciseModel(
      exerciseIndex: 6,
      exerciseDescription:
          'Shorthand Principles for the Sounds of S, F, V, FR, FL, and O',
      tracingModels: [
        TracingModel(
            word: 'says', imagePath: '${ImagePaths.tracingPath}/L5T1.png'),
        TracingModel(
            word: 'ass', imagePath: '${ImagePaths.tracingPath}/L5T2.png'),
        TracingModel(
            word: 'sane', imagePath: '${ImagePaths.tracingPath}/L5T3.png'),
        TracingModel(
            word: 'sat', imagePath: '${ImagePaths.tracingPath}/L5T4.png'),
        TracingModel(
            word: 'sees', imagePath: '${ImagePaths.tracingPath}/L5T5.png'),
        TracingModel(
            word: 'seamer', imagePath: '${ImagePaths.tracingPath}/L5T6.png'),
        TracingModel(
            word: 'seen, scene',
            imagePath: '${ImagePaths.tracingPath}/L5T7.png'),
        TracingModel(
            word: 'seat, set, sit',
            imagePath: '${ImagePaths.tracingPath}/L5T8.png'),
        TracingModel(
            word: 'signing', imagePath: '${ImagePaths.tracingPath}/L5T9.png'),
        TracingModel(
            word: 'sight, site, cite',
            imagePath: '${ImagePaths.tracingPath}/L5T10.png'),
        TracingModel(
            word: 'sow', imagePath: '${ImagePaths.tracingPath}/L5T11.png'),
        TracingModel(
            word: 'stayed', imagePath: '${ImagePaths.tracingPath}/L5T12.png'),
        TracingModel(
            word: 'fate', imagePath: '${ImagePaths.tracingPath}/L5T13.png'),
        TracingModel(
            word: 'fane', imagePath: '${ImagePaths.tracingPath}/L5T14.png'),
        TracingModel(
            word: 'fast, faced',
            imagePath: '${ImagePaths.tracingPath}/L5T15.png'),
        TracingModel(
            word: 'faye', imagePath: '${ImagePaths.tracingPath}/L5T16.png'),
        TracingModel(
            word: 'fear', imagePath: '${ImagePaths.tracingPath}/L5T17.png'),
        TracingModel(
            word: 'feeding', imagePath: '${ImagePaths.tracingPath}/L5T18.png'),
        TracingModel(
            word: 'feet', imagePath: '${ImagePaths.tracingPath}/L5T19.png'),
        TracingModel(
            word: 'if', imagePath: '${ImagePaths.tracingPath}/L5T20.png'),
        TracingModel(
            word: 'laughing', imagePath: '${ImagePaths.tracingPath}/L5T21.png'),
        TracingModel(
            word: 'phone', imagePath: '${ImagePaths.tracingPath}/L5T22.png'),
        TracingModel(
            word: 'safe', imagePath: '${ImagePaths.tracingPath}/L5T23.png'),
        TracingModel(
            word: 'safe', imagePath: '${ImagePaths.tracingPath}/L5T24.png'),
        TracingModel(
            word: 'Dave', imagePath: '${ImagePaths.tracingPath}/L5T25.png'),
        TracingModel(
            word: 'saves', imagePath: '${ImagePaths.tracingPath}/L5T26.png'),
        TracingModel(
            word: 'vain', imagePath: '${ImagePaths.tracingPath}/L5T27.png'),
        TracingModel(
            word: 'Evening', imagePath: '${ImagePaths.tracingPath}/L5T28.png'),
        TracingModel(
            word: 'saving', imagePath: '${ImagePaths.tracingPath}/L5T29.png'),
        TracingModel(
            word: 'vase', imagePath: '${ImagePaths.tracingPath}/L5T30.png'),
        TracingModel(
            word: 'Navy', imagePath: '${ImagePaths.tracingPath}/L5T31.png'),
        TracingModel(
            word: 'Steven', imagePath: '${ImagePaths.tracingPath}/L5T32.png'),
        TracingModel(
            word: 'voting', imagePath: '${ImagePaths.tracingPath}/L5T33.png'),
        TracingModel(
            word: 'fleet', imagePath: '${ImagePaths.tracingPath}/L5T34.png'),
        TracingModel(
            word: 'flaming', imagePath: '${ImagePaths.tracingPath}/L5T35.png'),
        TracingModel(
            word: 'flu', imagePath: '${ImagePaths.tracingPath}/L5T36.png'),
        TracingModel(
            word: 'fry', imagePath: '${ImagePaths.tracingPath}/L5T37.png'),
        TracingModel(
            word: 'flying', imagePath: '${ImagePaths.tracingPath}/L5T38.png'),
        TracingModel(
            word: 'freight', imagePath: '${ImagePaths.tracingPath}/L5T39.png'),
        TracingModel(
            word: 'Freddie', imagePath: '${ImagePaths.tracingPath}/L5T40.png'),
        TracingModel(
            word: 'free', imagePath: '${ImagePaths.tracingPath}/L5T41.png'),
        TracingModel(
            word: 'fried', imagePath: '${ImagePaths.tracingPath}/L5T42.png'),
        TracingModel(
            word: 'all', imagePath: '${ImagePaths.tracingPath}/L5T43.png'),
        TracingModel(
            word: 'hot', imagePath: '${ImagePaths.tracingPath}/L5T44.png'),
        TracingModel(
            word: 'law', imagePath: '${ImagePaths.tracingPath}/L5T45.png'),
        TracingModel(
            word: 'lot', imagePath: '${ImagePaths.tracingPath}/L5T46.png'),
        TracingModel(
            word: 'on', imagePath: '${ImagePaths.tracingPath}/L5T47.png'),
        TracingModel(
            word: 'saw', imagePath: '${ImagePaths.tracingPath}/L5T48.png'),
        TracingModel(
            word: 'small', imagePath: '${ImagePaths.tracingPath}/L5T49.png'),
        TracingModel(
            word: 'taught', imagePath: '${ImagePaths.tracingPath}/L5T50.png'),
        TracingModel(
            word: 'Tom', imagePath: '${ImagePaths.tracingPath}/L5T51.png'),
      ]),
  ExerciseModel(
      exerciseIndex: 7,
      exerciseDescription: 'In & Oo Words, and Sounds of K, G, W, SW, WH',
      tracingModels: [
        TracingModel(
            word: 'Instead', imagePath: '${ImagePaths.tracingPath}/L6T1.png'),
        TracingModel(
            word: 'insight', imagePath: '${ImagePaths.tracingPath}/L6T2.png'),
        TracingModel(
            word: 'investing', imagePath: '${ImagePaths.tracingPath}/L6T3.png'),
        TracingModel(
            word: 'invest', imagePath: '${ImagePaths.tracingPath}/L6T4.png'),
        TracingModel(
            word: 'invited', imagePath: '${ImagePaths.tracingPath}/L6T5.png'),
        TracingModel(
            word: 'inviting', imagePath: '${ImagePaths.tracingPath}/L6T6.png'),
        TracingModel(
            word: 'to', imagePath: '${ImagePaths.tracingPath}/L6T7.png'),
        TracingModel(
            word: 'duty', imagePath: '${ImagePaths.tracingPath}/L6T8.png'),
        TracingModel(
            word: 'food', imagePath: '${ImagePaths.tracingPath}/L6T9.png'),
        TracingModel(
            word: 'flew', imagePath: '${ImagePaths.tracingPath}/L6T10.png'),
        TracingModel(
            word: 'fruit', imagePath: '${ImagePaths.tracingPath}/L6T11.png'),
        TracingModel(
            word: 'knew, new',
            imagePath: '${ImagePaths.tracingPath}/L6T12.png'),
        TracingModel(
            word: 'move', imagePath: '${ImagePaths.tracingPath}/L6T13.png'),
        TracingModel(
            word: 'moved', imagePath: '${ImagePaths.tracingPath}/L6T14.png'),
        TracingModel(
            word: 'room', imagePath: '${ImagePaths.tracingPath}/L6T15.png'),
        TracingModel(
            word: 'sue', imagePath: '${ImagePaths.tracingPath}/L6T16.png'),
        TracingModel(
            word: 'suit', imagePath: '${ImagePaths.tracingPath}/L6T17.png'),
        TracingModel(
            word: 'to, too, two',
            imagePath: '${ImagePaths.tracingPath}/L6T18.png'),
        TracingModel(
            word: 'who', imagePath: '${ImagePaths.tracingPath}/L6T19.png'),
        TracingModel(
            word: 'whom', imagePath: '${ImagePaths.tracingPath}/L6T20.png'),
        TracingModel(
            word: 'care, car',
            imagePath: '${ImagePaths.tracingPath}/L6T21.png'),
        TracingModel(
            word: 'came', imagePath: '${ImagePaths.tracingPath}/L6T22.png'),
        TracingModel(
            word: 'cream', imagePath: '${ImagePaths.tracingPath}/L6T23.png'),
        TracingModel(
            word: 'clam', imagePath: '${ImagePaths.tracingPath}/L6T24.png'),
        TracingModel(
            word: 'clear', imagePath: '${ImagePaths.tracingPath}/L6T25.png'),
        TracingModel(
            word: 'crate', imagePath: '${ImagePaths.tracingPath}/L6T26.png'),
        TracingModel(
            word: 'like', imagePath: '${ImagePaths.tracingPath}/L6T27.png'),
        TracingModel(
            word: 'liked', imagePath: '${ImagePaths.tracingPath}/L6T28.png'),
        TracingModel(
            word: 'mock', imagePath: '${ImagePaths.tracingPath}/L6T29.png'),
        TracingModel(
            word: 'make', imagePath: '${ImagePaths.tracingPath}/L6T30.png'),
        TracingModel(
            word: 'mic', imagePath: '${ImagePaths.tracingPath}/L6T31.png'),
        TracingModel(
            word: 'gain', imagePath: '${ImagePaths.tracingPath}/L6T32.png'),
        TracingModel(
            word: 'eagle', imagePath: '${ImagePaths.tracingPath}/L6T33.png'),
        TracingModel(
            word: 'game', imagePath: '${ImagePaths.tracingPath}/L6T34.png'),
        TracingModel(
            word: 'grain', imagePath: '${ImagePaths.tracingPath}/L6T35.png'),
        TracingModel(
            word: 'gate', imagePath: '${ImagePaths.tracingPath}/L6T36.png'),
        TracingModel(
            word: 'given', imagePath: '${ImagePaths.tracingPath}/L6T37.png'),
        TracingModel(
            word: 'give', imagePath: '${ImagePaths.tracingPath}/L6T38.png'),
        TracingModel(
            word: 'gleamy', imagePath: '${ImagePaths.tracingPath}/L6T39.png'),
        TracingModel(
            word: 'glowing', imagePath: '${ImagePaths.tracingPath}/L6T40.png'),
        TracingModel(
            word: 'great', imagePath: '${ImagePaths.tracingPath}/L6T41.png'),
        TracingModel(
            word: 'gray', imagePath: '${ImagePaths.tracingPath}/L6T42.png'),
        TracingModel(
            word: 'greatness',
            imagePath: '${ImagePaths.tracingPath}/L6T43.png'),
        TracingModel(
            word: 'green', imagePath: '${ImagePaths.tracingPath}/L6T44.png'),
        TracingModel(
            word: 'going', imagePath: '${ImagePaths.tracingPath}/L6T45.png'),
        TracingModel(
            word: 'goal', imagePath: '${ImagePaths.tracingPath}/L6T46.png'),
        TracingModel(
            word: 'guild', imagePath: '${ImagePaths.tracingPath}/L6T47.png'),
        TracingModel(
            word: 'legal', imagePath: '${ImagePaths.tracingPath}/L6T48.png'),
        TracingModel(
            word: 'regret', imagePath: '${ImagePaths.tracingPath}/L6T49.png'),
        TracingModel(
            word: 'sweat', imagePath: '${ImagePaths.tracingPath}/L6T50.png'),
        TracingModel(
            word: 'swelling', imagePath: '${ImagePaths.tracingPath}/L6T51.png'),
        TracingModel(
            word: 'whale', imagePath: '${ImagePaths.tracingPath}/L6T52.png'),
        TracingModel(
            word: 'swim', imagePath: '${ImagePaths.tracingPath}/L6T53.png'),
        TracingModel(
            word: 'way', imagePath: '${ImagePaths.tracingPath}/L6T54.png'),
        TracingModel(
            word: 'we', imagePath: '${ImagePaths.tracingPath}/L6T55.png'),
        TracingModel(
            word: 'weak', imagePath: '${ImagePaths.tracingPath}/L6T56.png'),
        TracingModel(
            word: 'weeks', imagePath: '${ImagePaths.tracingPath}/L6T57.png'),
        TracingModel(
            word: 'while', imagePath: '${ImagePaths.tracingPath}/L6T58.png'),
        TracingModel(
            word: 'white', imagePath: '${ImagePaths.tracingPath}/L6T59.png'),
        TracingModel(
            word: 'why', imagePath: '${ImagePaths.tracingPath}/L6T60.png'),
      ]),
  ExerciseModel(
      exerciseIndex: 8,
      exerciseDescription: 'Sounds of S, P, B, and OO',
      tracingModels: [
        TracingModel(
            word: 'days', imagePath: '${ImagePaths.tracingPath}/L7T1.png'),
        TracingModel(
            word: 'desk, disk',
            imagePath: '${ImagePaths.tracingPath}/L7T2.png'),
        TracingModel(
            word: 'increase', imagePath: '${ImagePaths.tracingPath}/L7T3.png'),
        TracingModel(
            word: 'leads', imagePath: '${ImagePaths.tracingPath}/L7T4.png'),
        TracingModel(
            word: 'leasing', imagePath: '${ImagePaths.tracingPath}/L7T5.png'),
        TracingModel(
            word: 'lease', imagePath: '${ImagePaths.tracingPath}/L7T6.png'),
        TracingModel(
            word: 'list', imagePath: '${ImagePaths.tracingPath}/L7T7.png'),
        TracingModel(
            word: 'most', imagePath: '${ImagePaths.tracingPath}/L7T8.png'),
        TracingModel(
            word: 'names', imagePath: '${ImagePaths.tracingPath}/L7T9.png'),
        TracingModel(
            word: 'needs', imagePath: '${ImagePaths.tracingPath}/L7T10.png'),
        TracingModel(
            word: 'nice', imagePath: '${ImagePaths.tracingPath}/L7T11.png'),
        TracingModel(
            word: 'raised', imagePath: '${ImagePaths.tracingPath}/L7T12.png'),
        TracingModel(
            word: 'readers', imagePath: '${ImagePaths.tracingPath}/L7T13.png'),
        TracingModel(
            word: 'sales', imagePath: '${ImagePaths.tracingPath}/L7T14.png'),
        TracingModel(
            word: 'seems', imagePath: '${ImagePaths.tracingPath}/L7T15.png'),
        TracingModel(
            word: 'writers', imagePath: '${ImagePaths.tracingPath}/L7T16.png'),
        TracingModel(
            word: 'despite', imagePath: '${ImagePaths.tracingPath}/L7T17.png'),
        TracingModel(
            word: 'hope', imagePath: '${ImagePaths.tracingPath}/L7T18.png'),
        TracingModel(
            word: 'opens', imagePath: '${ImagePaths.tracingPath}/L7T19.png'),
        TracingModel(
            word: 'paper', imagePath: '${ImagePaths.tracingPath}/L7T20.png'),
        TracingModel(
            word: 'Paul', imagePath: '${ImagePaths.tracingPath}/L7T21.png'),
        TracingModel(
            word: 'pay', imagePath: '${ImagePaths.tracingPath}/L7T22.png'),
        TracingModel(
            word: 'pays, pass',
            imagePath: '${ImagePaths.tracingPath}/L7T23.png'),
        TracingModel(
            word: 'people', imagePath: '${ImagePaths.tracingPath}/L7T24.png'),
        TracingModel(
            word: 'piece', imagePath: '${ImagePaths.tracingPath}/L7T25.png'),
        TracingModel(
            word: 'pipe', imagePath: '${ImagePaths.tracingPath}/L7T26.png'),
        TracingModel(
            word: 'place', imagePath: '${ImagePaths.tracingPath}/L7T27.png'),
        TracingModel(
            word: 'please', imagePath: '${ImagePaths.tracingPath}/L7T28.png'),
        TracingModel(
            word: 'price, prize',
            imagePath: '${ImagePaths.tracingPath}/L7T29.png'),
        TracingModel(
            word: 'post', imagePath: '${ImagePaths.tracingPath}/L7T30.png'),
        TracingModel(
            word: 'space', imagePath: '${ImagePaths.tracingPath}/L7T31.png'),
        TracingModel(
            word: 'beats', imagePath: '${ImagePaths.tracingPath}/L7T32.png'),
        TracingModel(
            word: 'beds', imagePath: '${ImagePaths.tracingPath}/L7T33.png'),
        TracingModel(
            word: 'best', imagePath: '${ImagePaths.tracingPath}/L7T34.png'),
        TracingModel(
            word: 'better', imagePath: '${ImagePaths.tracingPath}/L7T35.png'),
        TracingModel(
            word: 'big', imagePath: '${ImagePaths.tracingPath}/L7T36.png'),
        TracingModel(
            word: 'blame', imagePath: '${ImagePaths.tracingPath}/L7T37.png'),
        TracingModel(
            word: 'brief', imagePath: '${ImagePaths.tracingPath}/L7T38.png'),
        TracingModel(
            word: 'bright', imagePath: '${ImagePaths.tracingPath}/L7T39.png'),
        TracingModel(
            word: 'bought, boat',
            imagePath: '${ImagePaths.tracingPath}/L7T40.png'),
        TracingModel(
            word: 'buy', imagePath: '${ImagePaths.tracingPath}/L7T41.png'),
        TracingModel(
            word: 'label', imagePath: '${ImagePaths.tracingPath}/L7T42.png'),
        TracingModel(
            word: 'neighbor', imagePath: '${ImagePaths.tracingPath}/L7T43.png'),
        TracingModel(
            word: 'based', imagePath: '${ImagePaths.tracingPath}/L7T44.png'),
        TracingModel(
            word: 'bay', imagePath: '${ImagePaths.tracingPath}/L7T45.png'),
        TracingModel(
            word: 'does', imagePath: '${ImagePaths.tracingPath}/L7T46.png'),
        TracingModel(
            word: 'enough', imagePath: '${ImagePaths.tracingPath}/L7T47.png'),
        TracingModel(
            word: 'must', imagePath: '${ImagePaths.tracingPath}/L7T48.png'),
        TracingModel(
            word: 'number', imagePath: '${ImagePaths.tracingPath}/L7T49.png'),
        TracingModel(
            word: 'up', imagePath: '${ImagePaths.tracingPath}/L7T50.png'),
        TracingModel(
            word: 'us', imagePath: '${ImagePaths.tracingPath}/L7T51.png'),
        TracingModel(
            word: 'book', imagePath: '${ImagePaths.tracingPath}/L7T52.png'),
        TracingModel(
            word: 'books', imagePath: '${ImagePaths.tracingPath}/L7T53.png'),
        TracingModel(
            word: 'cook', imagePath: '${ImagePaths.tracingPath}/L7T54.png'),
        TracingModel(
            word: 'cookbook', imagePath: '${ImagePaths.tracingPath}/L7T55.png'),
        TracingModel(
            word: 'foot', imagePath: '${ImagePaths.tracingPath}/L7T56.png'),
        TracingModel(
            word: 'pull', imagePath: '${ImagePaths.tracingPath}/L7T57.png'),
        TracingModel(
            word: 'put', imagePath: '${ImagePaths.tracingPath}/L7T58.png'),
        TracingModel(
            word: 'took', imagePath: '${ImagePaths.tracingPath}/L7T59.png'),
      ]),
  ExerciseModel(
      exerciseIndex: 9,
      exerciseDescription: 'Brief Forms, Derivates, and Phrases',
      tracingModels: [
        TracingModel(
            word: 'a, an', imagePath: '${ImagePaths.tracingPath}/L8T1.png'),
        TracingModel(
            word: 'for', imagePath: '${ImagePaths.tracingPath}/L8T2.png'),
        TracingModel(
            word: 'Mr.', imagePath: '${ImagePaths.tracingPath}/L8T3.png'),
        TracingModel(
            word: 'am', imagePath: '${ImagePaths.tracingPath}/L8T4.png'),
        TracingModel(
            word: 'good', imagePath: '${ImagePaths.tracingPath}/L8T5.png'),
        TracingModel(
            word: 'of', imagePath: '${ImagePaths.tracingPath}/L8T6.png'),
        TracingModel(
            word: 'are, our, hour',
            imagePath: '${ImagePaths.tracingPath}/L8T7.png'),
        TracingModel(
            word: 'have', imagePath: '${ImagePaths.tracingPath}/L8T8.png'),
        TracingModel(
            word: 'will, well',
            imagePath: '${ImagePaths.tracingPath}/L8T9.png'),
        TracingModel(
            word: 'at, it', imagePath: '${ImagePaths.tracingPath}/L8T10.png'),
        TracingModel(
            word: 'I', imagePath: '${ImagePaths.tracingPath}/L8T11.png'),
        TracingModel(
            word: 'would', imagePath: '${ImagePaths.tracingPath}/L8T12.png'),
        TracingModel(
            word: 'be, by', imagePath: '${ImagePaths.tracingPath}/L8T13.png'),
        TracingModel(
            word: 'is, his', imagePath: '${ImagePaths.tracingPath}/L8T14.png'),
        TracingModel(
            word: 'you, your',
            imagePath: '${ImagePaths.tracingPath}/L8T15.png'),
        TracingModel(
            word: 'can', imagePath: '${ImagePaths.tracingPath}/L8T16.png'),
        TracingModel(
            word: 'in, not', imagePath: '${ImagePaths.tracingPath}/L8T17.png'),
        TracingModel(
            word: 'afford', imagePath: '${ImagePaths.tracingPath}/L8T18.png'),
        TracingModel(
            word: 'believe', imagePath: '${ImagePaths.tracingPath}/L8T19.png'),
        TracingModel(
            word: 'forgive', imagePath: '${ImagePaths.tracingPath}/L8T20.png'),
        TracingModel(
            word: 'became', imagePath: '${ImagePaths.tracingPath}/L8T21.png'),
        TracingModel(
            word: 'beside', imagePath: '${ImagePaths.tracingPath}/L8T22.png'),
        TracingModel(
            word: 'form', imagePath: '${ImagePaths.tracingPath}/L8T23.png'),
        TracingModel(
            word: 'because', imagePath: '${ImagePaths.tracingPath}/L8T24.png'),
        TracingModel(
            word: 'cannot', imagePath: '${ImagePaths.tracingPath}/L8T25.png'),
        TracingModel(
            word: 'forms', imagePath: '${ImagePaths.tracingPath}/L8T26.png'),
        TracingModel(
            word: 'before', imagePath: '${ImagePaths.tracingPath}/L8T27.png'),
        TracingModel(
            word: 'force', imagePath: '${ImagePaths.tracingPath}/L8T28.png'),
        TracingModel(
            word: 'goods', imagePath: '${ImagePaths.tracingPath}/L8T29.png'),
        TracingModel(
            word: 'began', imagePath: '${ImagePaths.tracingPath}/L8T30.png'),
        TracingModel(
            word: 'forced', imagePath: '${ImagePaths.tracingPath}/L8T31.png'),
        TracingModel(
            word: 'having', imagePath: '${ImagePaths.tracingPath}/L8T32.png'),
        TracingModel(
            word: 'being', imagePath: '${ImagePaths.tracingPath}/L8T33.png'),
        TracingModel(
            word: 'forget', imagePath: '${ImagePaths.tracingPath}/L8T34.png'),
        TracingModel(
            word: 'inform', imagePath: '${ImagePaths.tracingPath}/L8T35.png'),
        TracingModel(
            word: 'I will have',
            imagePath: '${ImagePaths.tracingPath}/L8T36.png'),
        TracingModel(
            word: 'we will be',
            imagePath: '${ImagePaths.tracingPath}/L8T37.png'),
        TracingModel(
            word: 'you will not be',
            imagePath: '${ImagePaths.tracingPath}/L8T38.png'),
        TracingModel(
            word: 'I will not',
            imagePath: '${ImagePaths.tracingPath}/L8T39.png'),
        TracingModel(
            word: 'will not', imagePath: '${ImagePaths.tracingPath}/L8T40.png'),
        TracingModel(
            word: 'you will not',
            imagePath: '${ImagePaths.tracingPath}/L8T41.png'),
        TracingModel(
            word: 'I will not be',
            imagePath: '${ImagePaths.tracingPath}/L8T42.png'),
        TracingModel(
            word: 'you will', imagePath: '${ImagePaths.tracingPath}/L8T43.png'),
        TracingModel(
            word: 'have', imagePath: '${ImagePaths.tracingPath}/L8T44.png'),
        TracingModel(
            word: 'I would', imagePath: '${ImagePaths.tracingPath}/L8T45.png'),
        TracingModel(
            word: 'you would',
            imagePath: '${ImagePaths.tracingPath}/L8T46.png'),
        TracingModel(
            word: 'you would not be',
            imagePath: '${ImagePaths.tracingPath}/L8T47.png'),
        TracingModel(
            word: 'I would be',
            imagePath: '${ImagePaths.tracingPath}/L8T48.png'),
        TracingModel(
            word: 'you would be',
            imagePath: '${ImagePaths.tracingPath}/L8T49.png'),
        TracingModel(
            word: 'you would not have',
            imagePath: '${ImagePaths.tracingPath}/L8T50.png'),
        TracingModel(
            word: 'I would not',
            imagePath: '${ImagePaths.tracingPath}/L8T51.png'),
        TracingModel(
            word: 'you would have',
            imagePath: '${ImagePaths.tracingPath}/L8T52.png'),
        TracingModel(
            word: 'can have', imagePath: '${ImagePaths.tracingPath}/L8T53.png'),
        TracingModel(
            word: 'I cannot', imagePath: '${ImagePaths.tracingPath}/L8T54.png'),
        TracingModel(
            word: 'you can', imagePath: '${ImagePaths.tracingPath}/L8T55.png'),
        TracingModel(
            word: 'cannot be',
            imagePath: '${ImagePaths.tracingPath}/L8T56.png'),
        TracingModel(
            word: 'I cannot be',
            imagePath: '${ImagePaths.tracingPath}/L8T57.png'),
        TracingModel(
            word: 'you can be',
            imagePath: '${ImagePaths.tracingPath}/L8T58.png'),
        TracingModel(
            word: 'I can', imagePath: '${ImagePaths.tracingPath}/L8T59.png'),
        TracingModel(
            word: 'we can', imagePath: '${ImagePaths.tracingPath}/L8T60.png'),
        TracingModel(
            word: 'you can have',
            imagePath: '${ImagePaths.tracingPath}/L8T61.png'),
        TracingModel(
            word: 'I can be', imagePath: '${ImagePaths.tracingPath}/L8T62.png'),
        TracingModel(
            word: 'we cannot',
            imagePath: '${ImagePaths.tracingPath}/L8T63.png'),
        TracingModel(
            word: 'you cannot',
            imagePath: '${ImagePaths.tracingPath}/L8T64.png'),
        TracingModel(
            word: 'are in, are not',
            imagePath: '${ImagePaths.tracingPath}/L8T65.png'),
        TracingModel(
            word: 'I have', imagePath: '${ImagePaths.tracingPath}/L8T66.png'),
        TracingModel(
            word: 'by the', imagePath: '${ImagePaths.tracingPath}/L8T67.png'),
        TracingModel(
            word: 'I have not',
            imagePath: '${ImagePaths.tracingPath}/L8T68.png'),
        TracingModel(
            word: 'by you, by your',
            imagePath: '${ImagePaths.tracingPath}/L8T69.png'),
        TracingModel(
            word: 'in it', imagePath: '${ImagePaths.tracingPath}/L8T70.png'),
        TracingModel(
            word: 'have not', imagePath: '${ImagePaths.tracingPath}/L8T71.png'),
        TracingModel(
            word: 'in our', imagePath: '${ImagePaths.tracingPath}/L8T72.png'),
        TracingModel(
            word: 'I am', imagePath: '${ImagePaths.tracingPath}/L8T73.png'),
        TracingModel(
            word: 'it is', imagePath: '${ImagePaths.tracingPath}/L8T74.png'),
      ]),
  ExerciseModel(
      exerciseIndex: 10,
      exerciseDescription: 'Sound of Th, Sh, Ch, and J Words',
      tracingModels: [
        TracingModel(
            word: 'these', imagePath: '${ImagePaths.tracingPath}/L9T1.png'),
        TracingModel(
            word: 'Keith', imagePath: '${ImagePaths.tracingPath}/L9T2.png'),
        TracingModel(
            word: 'then, thin',
            imagePath: '${ImagePaths.tracingPath}/L9T3.png'),
        TracingModel(
            word: 'Ruth', imagePath: '${ImagePaths.tracingPath}/L9T4.png'),
        TracingModel(
            word: 'thick', imagePath: '${ImagePaths.tracingPath}/L9T5.png'),
        TracingModel(
            word: 'smooth', imagePath: '${ImagePaths.tracingPath}/L9T6.png'),
        TracingModel(
            word: 'math', imagePath: '${ImagePaths.tracingPath}/L9T7.png'),
        TracingModel(
            word: 'truth', imagePath: '${ImagePaths.tracingPath}/L9T8.png'),
        TracingModel(
            word: 'Smith', imagePath: '${ImagePaths.tracingPath}/L9T9.png'),
        TracingModel(
            word: 'faith', imagePath: '${ImagePaths.tracingPath}/L9T10.png'),
        TracingModel(
            word: 'she', imagePath: '${ImagePaths.tracingPath}/L9T11.png'),
        TracingModel(
            word: 'shape', imagePath: '${ImagePaths.tracingPath}/L9T12.png'),
        TracingModel(
            word: 'show', imagePath: '${ImagePaths.tracingPath}/L9T13.png'),
        TracingModel(
            word: 'sure', imagePath: '${ImagePaths.tracingPath}/L9T14.png'),
        TracingModel(
            word: 'showed', imagePath: '${ImagePaths.tracingPath}/L9T15.png'),
        TracingModel(
            word: 'issue', imagePath: '${ImagePaths.tracingPath}/L9T16.png'),
        TracingModel(
            word: 'share', imagePath: '${ImagePaths.tracingPath}/L9T17.png'),
        TracingModel(
            word: 'issued', imagePath: '${ImagePaths.tracingPath}/L9T18.png'),
        TracingModel(
            word: 'shade', imagePath: '${ImagePaths.tracingPath}/L9T19.png'),
        TracingModel(
            word: 'sheep', imagePath: '${ImagePaths.tracingPath}/L9T20.png'),
      ]),
  ExerciseModel(
      exerciseIndex: 11,
      exerciseDescription: 'Brief Forms and -ly words',
      tracingModels: [
        TracingModel(
            word: 'the', imagePath: '${ImagePaths.tracingPath}/L10T1.png'),
        TracingModel(
            word: 'that', imagePath: '${ImagePaths.tracingPath}/L10T2.png'),
        TracingModel(
            word: 'this', imagePath: '${ImagePaths.tracingPath}/L10T3.png'),
        TracingModel(
            word: 'them', imagePath: '${ImagePaths.tracingPath}/L10T4.png'),
        TracingModel(
            word: 'should', imagePath: '${ImagePaths.tracingPath}/L10T5.png'),
        TracingModel(
            word: 'could', imagePath: '${ImagePaths.tracingPath}/L10T6.png'),
        TracingModel(
            word: 'but', imagePath: '${ImagePaths.tracingPath}/L10T7.png'),
        TracingModel(
            word: 'which', imagePath: '${ImagePaths.tracingPath}/L10T8.png'),
        TracingModel(
            word: 'of the', imagePath: '${ImagePaths.tracingPath}/L10T9.png'),
        TracingModel(
            word: 'in the', imagePath: '${ImagePaths.tracingPath}/L10T10.png'),
        TracingModel(
            word: 'in which',
            imagePath: '${ImagePaths.tracingPath}/L10T11.png'),
        TracingModel(
            word: 'of these',
            imagePath: '${ImagePaths.tracingPath}/L10T12.png'),
        TracingModel(
            word: 'on the', imagePath: '${ImagePaths.tracingPath}/L10T13.png'),
        TracingModel(
            word: 'which is',
            imagePath: '${ImagePaths.tracingPath}/L10T14.png'),
        TracingModel(
            word: 'of them', imagePath: '${ImagePaths.tracingPath}/L10T15.png'),
        TracingModel(
            word: 'is this, is in',
            imagePath: '${ImagePaths.tracingPath}/L10T16.png'),
        TracingModel(
            word: 'is not', imagePath: '${ImagePaths.tracingPath}/L10T17.png'),
        TracingModel(
            word: 'on the', imagePath: '${ImagePaths.tracingPath}/L10T18.png'),
        TracingModel(
            word: 'this is', imagePath: '${ImagePaths.tracingPath}/L10T19.png'),
        TracingModel(
            word: 'should be',
            imagePath: '${ImagePaths.tracingPath}/L10T20.png'),
        TracingModel(
            word: 'as the', imagePath: '${ImagePaths.tracingPath}/L10T21.png'),
        TracingModel(
            word: 'this is the',
            imagePath: '${ImagePaths.tracingPath}/L10T22.png'),
        TracingModel(
            word: 'should have',
            imagePath: '${ImagePaths.tracingPath}/L10T23.png'),
        TracingModel(
            word: 'by the', imagePath: '${ImagePaths.tracingPath}/L10T24.png'),
        TracingModel(
            word: 'in this', imagePath: '${ImagePaths.tracingPath}/L10T25.png'),
        TracingModel(
            word: 'I could', imagePath: '${ImagePaths.tracingPath}/L10T26.png'),
        TracingModel(
            word: 'to the', imagePath: '${ImagePaths.tracingPath}/L10T27.png'),
        TracingModel(
            word: 'on this', imagePath: '${ImagePaths.tracingPath}/L10T28.png'),
        TracingModel(
            word: 'I could not',
            imagePath: '${ImagePaths.tracingPath}/L10T29.png'),
        TracingModel(
            word: 'for the', imagePath: '${ImagePaths.tracingPath}/L10T30.png'),
        TracingModel(
            word: 'this will',
            imagePath: '${ImagePaths.tracingPath}/L10T31.png'),
        TracingModel(
            word: 'did not', imagePath: '${ImagePaths.tracingPath}/L10T32.png'),
        TracingModel(
            word: 'for this',
            imagePath: '${ImagePaths.tracingPath}/L10T33.png'),
        TracingModel(
            word: 'this will be',
            imagePath: '${ImagePaths.tracingPath}/L10T34.png'),
        TracingModel(
            word: 'for you, for your',
            imagePath: '${ImagePaths.tracingPath}/L10T35.png'),
        TracingModel(
            word: 'that will',
            imagePath: '${ImagePaths.tracingPath}/L10T36.png'),
        TracingModel(
            word: 'only', imagePath: '${ImagePaths.tracingPath}/L10T37.png'),
        TracingModel(
            word: 'likely', imagePath: '${ImagePaths.tracingPath}/L10T38.png'),
        TracingModel(
            word: 'greatly', imagePath: '${ImagePaths.tracingPath}/L10T39.png'),
        TracingModel(
            word: 'clearly', imagePath: '${ImagePaths.tracingPath}/L10T40.png'),
        TracingModel(
            word: 'properly',
            imagePath: '${ImagePaths.tracingPath}/L10T41.png'),
        TracingModel(
            word: 'highly', imagePath: '${ImagePaths.tracingPath}/L10T42.png'),
        TracingModel(
            word: 'weekly', imagePath: '${ImagePaths.tracingPath}/L10T43.png'),
        TracingModel(
            word: 'daily', imagePath: '${ImagePaths.tracingPath}/L10T44.png'),
        TracingModel(
            word: 'mostly', imagePath: '${ImagePaths.tracingPath}/L10T45.png'),
        TracingModel(
            word: 'early', imagePath: '${ImagePaths.tracingPath}/L10T46.png'),
        TracingModel(
            word: 'sincerely',
            imagePath: '${ImagePaths.tracingPath}/L10T47.png'),
      ])
];

class TracingModel {
  String word;
  String imagePath;
  TracingModel({required this.word, required this.imagePath});
}
