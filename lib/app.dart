import 'package:flutter/material.dart';
import 'package:my_dog_app/pages/main_page.dart';

class MyDogApp extends StatelessWidget {
  const MyDogApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      title: "My Dog App",
      debugShowCheckedModeBanner: false,
      home: MainPage(),
    );
  }
}
