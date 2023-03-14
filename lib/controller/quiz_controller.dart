import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:quiz_app/model/question_model.dart';

import '../view/result_screen/result_screen.dart';
import '../view/welcome_screen.dart';

class QuizController extends GetxController {
  String name = '';
  final List<QuestionModel> _questionList = [
    QuestionModel(
      id: 1,
      answer: 1,
      question: 'ماهو اطول جسر بحري في العالم؟',
      options: [
        'جسر أكاشي كايكو',
        'جسر هونغ كونغ تشوهاي ماكاو',
        'جسر لاكي كنوت',
        ' جسر الملك فهد',
      ],
    ),
    QuestionModel(
      id: 2,
      answer: 0,
      question: 'ماهو شعار دولة الولايات المتحدة الامريكية؟',
      options: [
        'النسر',
        'الاسد',
        'الزرافة',
        'النمر',
      ],
    ),
    QuestionModel(
      id: 3,
      answer: 3,
      question: 'متى قامت أمريكا بأول رحلة فضائية؟',
      options: [
        '1999 م',
        '1900 م',
        '1960 م',
        '1962 م',
      ],
    ),
    QuestionModel(
      id: 4,
      answer: 0,
      question: 'في اي مدينة تقع ساعة بيج بين الشهيرة؟',
      options: [
        'لندن',
        'ليفربول',
        'جيزان',
        'توكيو',
      ],
    ),
    QuestionModel(
      id: 5,
      answer: 2,
      question: 'الي ماذا يشير مصطلح الذهب الاسود؟',
      options: [
        'الحبر',
        'الفضى',
        'البترول',
        'الرصاص',
      ],
    ),
    QuestionModel(
      id: 6,
      answer: 0,
      question: 'في أي مدينة يقع جامع الزيتون؟',
      options: [
        'تونس',
        'طهران',
        'باريس',
        'دمشق',
      ],
    ),
    QuestionModel(
      id: 7,
      answer: 3,
      question: 'ماهي اصغر دولة عربية؟',
      options: [
        'تونس',
        'المغرب',
        'قطر',
        'البحرين',
      ],
    ),
    QuestionModel(
      id: 8,
      answer: 0,
      question: 'ماهو علم السيتولوجيا ؟',
      options: [
        'علم الخلايا',
        'علم الاعصاب',
        'علم الاعضاء التناسلية',
        'علم الالم',
      ],
    ),
    QuestionModel(
      id: 9,
      answer: 2,
      question: 'ماأسم المضيق الذي يربط البحر الاسود ببحر مرمره ؟',
      options: [
        'مضيق باب المندب',
        'مضيق بالي',
        'مضيق البسفور',
        'مضيق برينغ',
      ],
    ),
    QuestionModel(
      id: 10,
      answer: 0,
      question: 'كم قلب للاخطبوط ؟',
      options: [
        '3',
        '2',
        '4',
        '5',
      ],
    ),
  ];

  bool _isPressed = false;
  double _numberOfQuestion = 1;
  int? _selectedAnswer;
  int _countOfCorrectAnswer = 0;
  final RxInt _sec = 15.obs;

  int get countOfQuestion => _questionList.length;
  List<QuestionModel> get questionList => _questionList;
  bool get isPressed => _isPressed;
  double get numberOfQuestions => _numberOfQuestion;
  int? get selectedAnswer => _selectedAnswer;
  int get countOfCorrectAnswer => _countOfCorrectAnswer;
  RxInt get sec => _sec;

  int? _correctAnswer;
  final Map<int, bool> _questionIsAnswer = {};
  Timer? _timer;
  final maxSec = 15;
  late PageController pageController;

  @override
  void onInit() {
    pageController = PageController(initialPage: 0);
    resetAnswer();
    super.onInit();
  }

  @override
  void onClose() {
    pageController.dispose();
    super.onClose();
  }

  double get scoreResult {
    return countOfCorrectAnswer * 100 / _questionList.length;
  }

  void checkAnswer(int selectedAnswer, QuestionModel questionModel) {
    _isPressed = true;
    _selectedAnswer = selectedAnswer;
    _correctAnswer = questionModel.answer;
    if (_selectedAnswer == _correctAnswer) {
      _countOfCorrectAnswer++;
    }
    stopTimer();
    _questionIsAnswer.update(questionModel.id, (value) => true);
    Future.delayed(const Duration(milliseconds: 500))
        .then((value) => nextQuestion());
    update();
  }

  bool questionHasBeenAnswered(int quezId) {
    return _questionIsAnswer.entries
        .firstWhere((element) => element.key == quezId)
        .value;
  }

  nextQuestion() {
    if (_timer != null || _timer!.isActive) {
      stopTimer();
    }
    if (pageController.page == questionList.length - 1) {
      Get.offAndToNamed(ResultScreen.routeName);
    } else {
      _isPressed = false;
      pageController.nextPage(
          duration: const Duration(milliseconds: 500), curve: Curves.ease);
      startTimer();
    }
    _numberOfQuestion = pageController.page!+ 2 ;
    update();
  }

  void resetAnswer() {
    for (var e in _questionList) {
      _questionIsAnswer.addAll({e.id: false});
    }
  }

  Color getColor(int answerIndex) {
    if (_isPressed) {
      if (answerIndex == _correctAnswer) {
        return Colors.green;
      } else if (answerIndex == _selectedAnswer &&
          _correctAnswer != _selectedAnswer) {
        return Colors.red;
      }
    }
    return Colors.white;
  }

  IconData getIcon(int answerIndex) {
    if (_isPressed) {
      if (answerIndex == _correctAnswer) {
        return Icons.done;
      } else if (answerIndex == _selectedAnswer &&
          _correctAnswer != _selectedAnswer) {
        return Icons.close;
      }
    }
    return Icons.close;
  }

  void startTimer() {
    resetTimer();
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_sec > 0) {
        _sec.value--;
      } else {
        stopTimer();
        nextQuestion();
      }
    });
  }

  void stopTimer() => _timer!.cancel();

  void resetTimer() => _sec.value = maxSec;

  void startAgain() {
    _correctAnswer = null;
    _countOfCorrectAnswer = 0;
    _numberOfQuestion = 1;
    resetAnswer();
    _selectedAnswer = null;
    Get.offAllNamed(WelcomeScreen.routeName);
  }
}
