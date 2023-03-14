import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:quiz_app/util/bindings_app.dart';

import 'view/quiz_screen/quiz_screen.dart';
import 'view/result_screen/result_screen.dart';
import 'view/welcome_screen.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      initialBinding: BilndingsApp(),
      title: 'Flutter Quiz App',
      home:  WelcomeScreen(),
      getPages: [
         GetPage(name: WelcomeScreen.routeName, page: () => WelcomeScreen()),
         GetPage(name: QuizScreen.routeName, page: () =>  QuizScreen()),
         GetPage(name: ResultScreen.routeName, page: () =>  ResultScreen()),
      ],
    );
  }
}