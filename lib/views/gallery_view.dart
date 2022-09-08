import 'dart:io';

import 'package:flutter/material.dart' hide Image;
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:my_dog_app/models/image_model.dart';
import 'package:my_dog_app/services/network_service.dart';
import 'package:my_dog_app/views/image_view.dart';

class GalleryView extends StatefulWidget {
  final int crossAxisCount;
  final String api;
  final Map<String, String> params;
  final ScrollPhysics? physics;
  const GalleryView({Key? key, this.physics, this.crossAxisCount = 2, required this.api, required this.params}) : super(key: key);

  @override
  State<GalleryView> createState() => _GalleryViewState();
}

class _GalleryViewState extends State<GalleryView> with AutomaticKeepAliveClientMixin{

  List<Image> items = [];
  ScrollController controller = ScrollController();
  Map<String, String> params = {};
  int currentPage = 0;

  @override
  bool get wantKeepAlive => true;

  @override
  void initState() {
    super.initState();
    params = widget.params;
    apiGetAllImage(currentPage++);
    controller.addListener(loadMore);
  }

  void apiGetAllImage(int page) async {
    params['page'] = page.toString();
    String? resAllImages = await NetworkService.GET(widget.api, params);
    items.addAll(imageListFromJson(resAllImages!));
    setState(() {});
  }

  void loadMore() {
    if(controller.position.maxScrollExtent == controller.position.pixels) {
      apiGetAllImage(currentPage++);
    }
  }

  Future<void> onRefresh() async {
    items = [];
    currentPage = 0;
    setState(() {});
    if(Platform.isAndroid) {
      apiGetAllImage(currentPage++);
    }
  }

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: onRefresh,
      child: MasonryGridView.count(
        physics: widget.physics,
        shrinkWrap: true,
        controller: controller,
        crossAxisCount: widget.crossAxisCount,
        itemCount: items.length,
        mainAxisSpacing: 10,
        crossAxisSpacing: 10,
        padding: const EdgeInsets.all(10),
        itemBuilder: (context, index) {
          return ImageView(image: items[index], crossAxisCount: widget.crossAxisCount,);
        },
      ),
    );
  }
}
