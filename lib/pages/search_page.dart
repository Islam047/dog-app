import 'package:flutter/material.dart' hide Image;
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:my_dog_app/models/breed_model.dart' hide Image;
import 'package:my_dog_app/models/image_model.dart';
import 'package:my_dog_app/services/network_service.dart';
import 'package:my_dog_app/views/image_view.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({Key? key}) : super(key: key);

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  List<Breed> _breeds = [];
  List<Image> _images = [];
  int _breedId = 1;
  bool _isFinally = false;
  int _page = 0;
  ScrollController controller = ScrollController();


  @override
  initState() {
    super.initState();
    _apiGetAllBreed();
    controller.addListener(loadMore);
  }

  String _displayStringForOption(Breed option) => option.name ?? "";

  void _apiGetAllBreed() async {
    String? response = await NetworkService.GET(NetworkService.API_LIST_BREADS,
        NetworkService.paramsEmpty());
    _breeds = breedListFromJson(response!);
    setState(() {});
  }

  void _apiGetAllImage(int page) async {
    if(!_isFinally) {
      String? resAllImages = await NetworkService.GET(NetworkService.API_IMAGE_LIST,
          NetworkService.paramsImageSearch(size: "small", limit: 10, page: page, breedId: _breedId.toString()));
      var list = imageListFromJson(resAllImages!);

      if(list.length < 10) {
        _isFinally = true;
      }
      _images.addAll(list);
      setState(() {});
    }
  }

  void _onSelected(Breed selection) {
    debugPrint('You just selected ${_displayStringForOption(selection)}');
    _images = [];
    _breedId = selection.id!;
    _page = 0;
    _isFinally = false;
    setState(() {});
    _apiGetAllImage(_page++);
  }

  void loadMore() {
    if(controller.position.maxScrollExtent == controller.position.pixels) {
      _apiGetAllImage(_page++);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Row(
          children: [
            Icon(
              Icons.search,
              color: Colors.grey.shade600,
              size: 30,
            ),
            const SizedBox(width: 10,),
            Expanded(
              child: Autocomplete<Breed>(
                displayStringForOption: _displayStringForOption,
                optionsBuilder: (TextEditingValue textEditingValue) {
                  debugPrint('TextEditingValue: ${textEditingValue.text}');
                  if (textEditingValue.text == '') {
                    return const Iterable<Breed>.empty();
                  }

                  return _breeds.where((Breed option) {
                    return option.name!.toLowerCase().startsWith(textEditingValue.text.toLowerCase());
                  });
                },
                // optionsViewBuilder: (context, displayStringForOption, breeds) {
                //   return Align(
                //       alignment: Alignment.topLeft,
                //       child: Material(
                //         color: Colors.white,
                //         elevation: 4.0,
                //         // size works, when placed here below the Material widget
                //         child: Container(
                //
                //           // I have the text field wrapped in a container with
                //           // EdgeInsets.all(20) so subtract 40 from the width for the width
                //           // of the text box. You could also just use a padding widget
                //           // with EdgeInsets.only(right: 20)
                //             width: MediaQuery.of(context).size.width - 40,
                //             child: ListView.separated(
                //               shrinkWrap: true,
                //               padding: const EdgeInsets.all(8.0),
                //               itemCount: breeds.length,
                //               separatorBuilder: (context, i) {
                //                 return const Divider();
                //               },
                //               itemBuilder: (BuildContext context, int index) {
                //                 return ListTile(
                //                   contentPadding: const EdgeInsets.symmetric(horizontal: 10),
                //                   leading: const Icon(Icons.search),
                //                   title: Text(breeds.elementAt(index).name!),
                //                 );
                //               },
                //             )
                //         ),
                //       )
                //   );
                // },
                onSelected: _onSelected,
              ),
            ),
            const SizedBox(width: 30,),
          ],
        ),
      ),
      body: MasonryGridView.count(
        shrinkWrap: true,
        controller: controller,
        crossAxisCount: 2,
        itemCount: _images.length,
        mainAxisSpacing: 10,
        crossAxisSpacing: 10,
        padding: const EdgeInsets.all(10),
        itemBuilder: (context, index) {
          return ImageView(image: _images[index], crossAxisCount: 2,);
        },
      ),
    );
  }
}
