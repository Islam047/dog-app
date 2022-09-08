import 'dart:convert';
import 'dart:math';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:my_dog_app/models/image_model.dart' as model;
import 'package:my_dog_app/pages/mobile/detail_page.dart';
import 'package:my_dog_app/services/network_service.dart';

class ImageView extends StatefulWidget {
  final int crossAxisCount;
  final model.Image image;

  const ImageView({Key? key, required this.image, this.crossAxisCount = 2}) : super(key: key);

  @override
  State<ImageView> createState() => _ImageViewState();
}

class _ImageViewState extends State<ImageView> {
  late model.Image image;
  double ratio = 16 / 9;
  bool visible = false;
  bool isLike = false;
  String? favoriteId;

  @override
  void initState() {
    super.initState();
    _convertData();
  }

  void _convertData() {
    image = widget.image;
    if (image.width != null && image.height != null) {
      ratio = image.width! / image.height!;
    }
    setState(() {});
  }

  void _favorite() async {

    setState(() {
      isLike = !isLike;
      visible = true;
    });

    if(isLike) {
      String? responseFavorite = await NetworkService.POST(NetworkService.API_MY_FAVORITE, NetworkService.paramsEmpty(), NetworkService.bodyFavourite(image.id.toString(), subId: image.subId));
      debugPrint(responseFavorite);
      if(responseFavorite != null) {
        favoriteId = jsonDecode(responseFavorite)["id"].toString();
        setState(() {});
      }
    }

    if(!isLike) {
      String? responseFavorite = await NetworkService.DELETE("${NetworkService.API_FAVORITE_DELETE}$favoriteId", NetworkService.paramsEmpty());
      debugPrint(responseFavorite);
    }
  }
  
  void openDetailPage() {
    Navigator.push(
        context,
        PageRouteBuilder(
          pageBuilder: (context, animation, secondaryAnimation) =>  DetailPage(image: image, crossAxisCount: widget.crossAxisCount,),
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            var begin = const Offset(0.0, 1.0);
            var end = Offset.zero;
            var curve = Curves.ease;

            var tween = Tween(begin: begin, end: end).chain(CurveTween(curve: curve));

            return SlideTransition(
              position: animation.drive(tween),
              child: child,
            );
          },
        )
    );
  }

  @override
  Widget build(BuildContext context) {

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        // #image
        GestureDetector(
          onDoubleTap: _favorite,
          onTap: openDetailPage,
          child: ClipRRect(
            borderRadius: BorderRadius.circular(15),
            child: AspectRatio(
              aspectRatio: ratio,
              child: Stack(
                alignment: Alignment.center,
                children: [
                  CachedNetworkImage(
                    imageUrl: image.url!,
                    placeholder: (context, url) => Container(
                      color: Colors.primaries[Random().nextInt(18) % 18],
                    ),
                    errorWidget: (context, url, error) => const Icon(Icons.error),
                  ),

                  if(!isLike && visible)
                    Center(
                        child: Lottie.asset(
                            "assets/lottie/lottie_broken_heart.json",
                            repeat: false,
                            onLoaded: (lottieComposition) {
                              Future.delayed(
                                lottieComposition.duration,
                                    () {
                                  setState(() {
                                    visible = false;
                                  });
                                },);
                            }
                        )
                    ),

                  if(isLike && visible)
                    Center(
                        child: Lottie.asset(
                            "assets/lottie/lottie_heart.json",
                            repeat: false,
                            onLoaded: (lottieComposition) {
                              Future.delayed(
                                lottieComposition.duration,
                                    () {
                                  setState(() {
                                    visible = false;
                                  });
                                },);
                            }
                        )
                    ),
                ],
              ),
            ),
          ),
        ),

        // #image_data

        ListTile(
          dense: true,
          contentPadding: const EdgeInsets.only(bottom: 10, top: 5, left: 5),
          title: image.breeds != null && image.breeds!.isNotEmpty
              ? Text(image.breeds!.first.name ?? "", maxLines: 1, overflow: TextOverflow.ellipsis,) : null,
          subtitle: image.breeds != null && image.breeds!.isNotEmpty
              ? Text(image.breeds!.first.temperament ?? "", maxLines: 2, overflow: TextOverflow.ellipsis,) : null,
          trailing: IconButton(
            splashRadius: 20,
            onPressed: () {},
            icon: const Icon(Icons.more_horiz_outlined),
          ),
        ),
      ],
    );
  }
}
