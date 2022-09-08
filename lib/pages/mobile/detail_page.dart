import 'dart:math';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:my_dog_app/models/image_model.dart' as model;
import 'package:my_dog_app/services/network_service.dart';
import 'package:my_dog_app/views/gallery_view.dart';
import 'package:share_plus/share_plus.dart';

import '../../services/util_service.dart';

class DetailPage extends StatefulWidget {
  final int crossAxisCount;
  final model.Image image;

  const DetailPage({Key? key, required this.image, this.crossAxisCount = 2}) : super(key: key);

  @override
  State<DetailPage> createState() => _DetailPageState();
}

class _DetailPageState extends State<DetailPage> {
  late model.Image image;
  double ratio = 16 / 9;
  String title = "";
  String subTitle = "";
  int vote = 0;

  @override
  void initState() {
    super.initState();
    _convertData();
  }

  int get limit {
    return widget.crossAxisCount * 15 >= 100 ? 90 : widget.crossAxisCount * 15;
  }

  void _convertData() {
    image = widget.image;
    if (image.width != null && image.height != null) {
      ratio = image.width! / image.height!;
    }
    if(image.breeds != null && image.breeds!.isNotEmpty) {
      title = image.breeds!.first.name ?? "";
      subTitle = image.breeds!.first.bredFor ?? "";
    }
    setState(() {});
  }

  void pressVote() async {
    String? responseCreate;
    if(vote == 0) {
      responseCreate = await NetworkService.POST(NetworkService.API_LIST_VOTES, NetworkService.paramsEmpty(), NetworkService.bodyVotes(image.id!, image.subId, 1));
      if(responseCreate != null) {
        vote = 1;
      }
    } else {
      responseCreate = await NetworkService.POST(NetworkService.API_LIST_VOTES, NetworkService.paramsEmpty(), NetworkService.bodyVotes(image.id!, image.subId, 0));
      if(responseCreate != null) {
        vote = 0;
      }
    }

    setState(() {});
  }
// #saveImageDetailPage
  void saveImage(String images) async {
    if(kIsWeb) {
      await NetworkService.GETDOWNLOADWEB(images,image.createdAt!);
    }
    else{
      await NetworkService.GETDOWNLOAD(images,image.width.toString()).whenComplete(() {
        Util.fireSnackBar("Image was uploaded successfully", context);
      });
    }
  }
  // #shareImageDetailPage
  void shareImage(String image) async {
    await Share.share("Check this out $image");
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(

      extendBody: true,
      extendBodyBehindAppBar: true,
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        actions: [
          IconButton(
            splashRadius: 35,
            onPressed: () {},
            icon: const Icon(Icons.more_horiz_outlined, size: 30,),
          )
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            
            // #image
            Container(
              clipBehavior: Clip.antiAlias,
              decoration: const BoxDecoration(
                borderRadius: BorderRadius.vertical(top: Radius.circular(30)),
              ),
              foregroundDecoration: BoxDecoration(
                borderRadius: const BorderRadius.vertical(top: Radius.circular(30)),
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.center,
                  colors: [
                    Colors.black.withOpacity(0.9),
                    Colors.black.withOpacity(0.6),
                    Colors.black.withOpacity(0.2),
                    Colors.black.withOpacity(0.1),
                  ]
                )
              ),
              child: AspectRatio(
                aspectRatio: ratio,
                child: CachedNetworkImage(
                  fit: BoxFit.cover,
                  imageUrl: image.url!,
                  placeholder: (context, url) => Container(
                    color: Colors.primaries[Random().nextInt(18) % 18],
                  ),
                  errorWidget: (context, url, error) => const Icon(Icons.error),
                ),
              ),
            ),
            
            // #footer
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.vertical(bottom: Radius.circular(30)),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [

                  // #vote and #channel
                  ListTile(
                    leading: const CircleAvatar(
                      radius: 25,
                      backgroundColor: Colors.pink,
                    ),
                    contentPadding: const EdgeInsets.symmetric(vertical: 10),
                    title: const Text("My Dogs"),
                    trailing: IconButton(
                      icon: vote == 0
                          ? const Icon(Icons.thumb_up_alt_outlined, size: 30,)
                          : const Icon(Icons.thumb_up_alt, color: Colors.red, size: 30,),
                      onPressed: pressVote,
                    ),
                  ),
                  const SizedBox(height: 10,),

                  // #title
                  Visibility(
                    visible: title.isNotEmpty,
                    child: Text(title, style: const TextStyle(
                      fontSize: 25,
                      color: Colors.black,
                      fontWeight: FontWeight.bold
                    ),),
                  ),
                  const SizedBox(height: 10,),

                  // #subtitle
                  Visibility(
                    visible: subTitle.isNotEmpty,
                    child: Text(subTitle, style: const TextStyle(
                        fontSize: 20,
                        color: Colors.black,
                        fontWeight: FontWeight.w500
                    ),),
                  ),
                  const SizedBox(height: 10,),

                  Row(
                    children: [
                      const Expanded(
                        flex: 1,
                        child: SizedBox.shrink(),
                      ),

                      // #favorite
                      Expanded(
                        flex: 2,
                        child: ElevatedButton(
                          onPressed: (){},
                          style: ElevatedButton.styleFrom(
                            elevation: 0,
                            primary: const Color.fromRGBO(239, 239, 239, 1),
                            shape: const StadiumBorder(),
                            padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 15),
                          ),
                          child: const Text("Favorite", style: TextStyle(color: Colors.black, fontSize: 17.5, fontWeight: FontWeight.w600),),
                        ),
                      ),
                      const SizedBox(width: 15,),

                      // #save
                      Expanded(
                        flex: 2,
                        child: ElevatedButton(
                          onPressed:() {
                               print(image.url!);
                            saveImage(image.url!);
                          },
                          style: ElevatedButton.styleFrom(
                            elevation: 0,
                            primary: Colors.red,
                            shape: const StadiumBorder(),
                            padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 15),
                          ),
                          child: const Text("Save", style: TextStyle(fontSize: 17.5, fontWeight: FontWeight.w600),),
                        ),
                      ),

                      // #share
                      Expanded(
                        flex: 1,
                        child: IconButton(
                          icon: const Icon(Icons.share, size: 30,),
                          onPressed: () => shareImage(image.url.toString()),
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 20,)
                ],
              ),
            ),
            const SizedBox(height: 2,),
            
            // #similary
            Container(
              constraints: BoxConstraints(
                minHeight: MediaQuery.of(context).size.height
              ),
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.vertical(top: Radius.circular(30)),
              ),
              child: Column(
                children: [
                  Container(
                    height: 65,
                    padding: const EdgeInsets.only(top: 10),
                    alignment: Alignment.center,
                    width: MediaQuery.of(context).size.width,
                    child: const Text("Similar", style: TextStyle(color: Colors.black, fontSize: 25, fontWeight: FontWeight.bold),),
                  ),
                  GalleryView(
                    api: NetworkService.API_IMAGE_LIST,
                    crossAxisCount: widget.crossAxisCount,
                    params: NetworkService.paramsImageSearch(size: "small", breedId: image.breedIds,
                        limit: limit,
                    ),
                    physics: const NeverScrollableScrollPhysics(),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
