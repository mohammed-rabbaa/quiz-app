import 'package:get/get.dart';
import '../controller/quiz_controller.dart';

class BilndingsApp implements Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => QuizController());
  }
}