import 'dart:math';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart' hide Image;
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:my_dog_app/models/favorite_image.dart';
import 'package:my_dog_app/services/network_service.dart';

class FavoriteView extends StatefulWidget {
  const FavoriteView({Key? key}) : super(key: key);

  @override
  State<FavoriteView> createState() => _FavoriteViewState();
}

class _FavoriteViewState extends State<FavoriteView> with AutomaticKeepAliveClientMixin {

  int page = 0;
  List<Image> list = [];
  final ScrollController _scrollController = ScrollController();

  @override
  bool get wantKeepAlive => true;

  @override
  void initState() {
    super.initState();
    _apiGetAllImage(page++);
    _scrollController.addListener(_pagination);
  }

  void _apiGetAllImage(int screen) async {
    String response = await NetworkService.GET(NetworkService.API_MY_FAVORITE, NetworkService.paramsVotesList(limit: 30, page: screen)) ?? "[]";
    List<Favorite> items = favoriteListFromJson(response);
    for(Favorite item in items) {
      if(item.image != null && item.image!.url != null) {
        list.add(item.image!);
      }
    }

    setState(() {});
  }

  void _pagination() {
    if(_scrollController.position.maxScrollExtent == _scrollController.position.pixels) {
      _apiGetAllImage(page++);
    }
  }

  @override
  void dispose() {
    super.dispose();
    _scrollController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GridView.custom(
      controller: _scrollController,
      gridDelegate: SliverQuiltedGridDelegate(
        crossAxisCount: 4,
        mainAxisSpacing: 4,
        crossAxisSpacing: 4,
        repeatPattern: QuiltedGridRepeatPattern.inverted,
        pattern: [
          const QuiltedGridTile(2, 2),
          const QuiltedGridTile(1, 1),
          const QuiltedGridTile(1, 1),
          const QuiltedGridTile(1, 2),
        ],
      ),
      childrenDelegate: SliverChildBuilderDelegate(
            (context, index) => CachedNetworkImage(
              fit: BoxFit.cover,
              imageUrl: list[index].url!,
              placeholder: (context, url) => Container(
                color: Colors.primaries[Random().nextInt(18) % 18],
              ),
              errorWidget: (context, url, error) => const Icon(Icons.error),
            ),
        childCount: list.length
      ),
    );
  }

}
