import 'dart:math';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart' hide Image;
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:my_dog_app/models/vote_model.dart';
import 'package:my_dog_app/models/image_model.dart';
import 'package:my_dog_app/services/network_service.dart';

class VoteView extends StatefulWidget {
  const VoteView({Key? key}) : super(key: key);

  @override
  State<VoteView> createState() => _VoteViewState();
}

class _VoteViewState extends State<VoteView> with AutomaticKeepAliveClientMixin {
  List<Vote> _items = [];
  List<Image> _images = [];
  int _page = 0;
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _apiGetAllVote(_page++);
    _scrollController.addListener(_loadMore);
  }

  void _apiGetAllVote(int screen) async {
    String response = await NetworkService.GET(NetworkService.API_LIST_VOTES,
            NetworkService.paramsVotesList(limit: 90, page: screen)) ??
        '[]';
    _items.addAll(voteListFromJson(response));

    Set<String?> uniqueUrls = _items.map((item) => item.imageId).toSet();

    for (var item in uniqueUrls) {
      if (item != null) {
        var image = await _apiGetImage(item);
        if (image != null) {
          _images.add(image);
          setState(() {});
        }
      }
    }
  }

  Future<Image?> _apiGetImage(String imageId) async {
    String? oneImageResponse = await NetworkService.GET(
        NetworkService.API_ONE_IMAGE + imageId, NetworkService.paramsEmpty());

    if (oneImageResponse == null) return null;

    Image image = imageFromJson(oneImageResponse);
    return image;
  }

  void _loadMore() {
    if(_scrollController.position.maxScrollExtent == _scrollController.position.pixels) {
      _apiGetAllVote(_page++);
    }
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  Future<void> _onRefresh() async {
    _items = [];
    _images = [];
    _page = 0;
    setState(() {});
    _apiGetAllVote(_page++);
  }

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: _onRefresh,
      child: GridView.custom(
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
                  imageUrl: _images[index].url!,
                  placeholder: (context, url) => Container(
                    color: Colors.primaries[Random().nextInt(18) % 18],
                  ),
                  errorWidget: (context, url, error) => const Icon(Icons.error),
                ),
            childCount: _images.length,
        ),
      ),
    );
  }

  @override
  bool get wantKeepAlive => true;
}
