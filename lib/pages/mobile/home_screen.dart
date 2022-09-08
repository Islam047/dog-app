import 'package:flutter/material.dart' hide Image;
import 'package:my_dog_app/models/image_model.dart';
import 'package:my_dog_app/services/network_service.dart';
import 'package:my_dog_app/views/gallery_view.dart';

class HomeScreen extends StatefulWidget {
  final int subPage;
  final int crossAxisCount;
  const HomeScreen({Key? key, this.crossAxisCount = 2, this.subPage = 0}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late PageController controller;
  int currentScreen = 0;
  List<Image> allImage = [];

  int get limit {
    return widget.crossAxisCount * 15 >= 100 ? 90 : widget.crossAxisCount * 15;
  }

  void pressButton(int screen) {
    currentScreen = screen;
    controller.jumpToPage(screen);
    setState(() {});
  }

  void onScreenChanged(int screen) {
    currentScreen = screen;
    setState(() {});
  }

  @override
  void initState() {
    currentScreen = widget.subPage;
    controller = PageController(initialPage: widget.subPage, keepPage: true);
    super.initState();
  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        centerTitle: false,
        elevation: 0,
        title: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            // #all
            ElevatedButton(
              onPressed: () => pressButton(0),
              style: ElevatedButton.styleFrom(
                primary: currentScreen == 0 ? Colors.black : Colors.white,
                elevation: 0,
                padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 10),
                shape: const StadiumBorder(),
              ),
              child: Text("All", style: TextStyle(color: currentScreen == 0 ? Colors.white : Colors.black, fontSize: 20),),
            ),

            // #me
            ElevatedButton(
              onPressed: () => pressButton(1),
              style: ElevatedButton.styleFrom(
                primary: currentScreen == 1 ? Colors.black : Colors.white,
                elevation: 0,
                padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 10),
                shape: const StadiumBorder(),
              ),
              child: Text("My Dogs", style: TextStyle(color: currentScreen == 1 ? Colors.white : Colors.black, fontSize: 20),),
            ),
          ],
        ),
      ),
      body: PageView(
        controller: controller,
        onPageChanged: onScreenChanged,
        children: [
          GalleryView(api: NetworkService.API_IMAGE_LIST, crossAxisCount: widget.crossAxisCount, params: NetworkService.paramsImageSearch(size: "small", limit: limit),),
          GalleryView(api: NetworkService.API_MY_IMAGES, crossAxisCount: widget.crossAxisCount, params: NetworkService.paramsMyImage(limit: limit),),
        ],
      ),
    );
  }
}

