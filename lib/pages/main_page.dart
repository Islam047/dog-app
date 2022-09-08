import 'package:flutter/material.dart';

import 'home_page.dart';

class MainPage extends StatefulWidget {
  const MainPage({Key? key}) : super(key: key);

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, boxConstraints) {
        int crossAxisCount = boxConstraints.maxWidth ~/ 250;
        if(boxConstraints.maxWidth < 580) {
          // phone
          return const HomePage(crossAxisCount: 2);
        } if(boxConstraints.maxWidth < 1025) {
          // tablet
          return HomePage(crossAxisCount: crossAxisCount);
        } else {
          // desktop
          return HomePage(crossAxisCount: crossAxisCount);
        }
      }
    );
  }
}
