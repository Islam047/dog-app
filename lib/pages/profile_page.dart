import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:my_dog_app/services/network_service.dart';
import 'package:my_dog_app/services/util_service.dart';

import 'home_page.dart';

class ProfilePage extends StatefulWidget {
  final int crossAxisCount;

  const ProfilePage({Key? key, this.crossAxisCount = 2}) : super(key: key);

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  File? file;
  final ImagePicker _picker = ImagePicker();
  TextEditingController controller = TextEditingController();
  bool isLoading = false;

  void _getImage() {
    showModalBottomSheet(
      context: context,
      builder: (context) => SafeArea(
        child: Wrap(
          children: [
            ListTile(
              leading: const Icon(Icons.photo_library),
              title: const Text("Gallery"),
              onTap: _gallery,
            ),
            ListTile(
              leading: const Icon(Icons.photo_camera),
              title: const Text("Camera"),
              onTap: _camera,
            ),
          ],
        ),
      ),
    );
  }

  void _gallery() async {
    Navigator.of(context).pop();
    final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
    if (image != null) {
      file = File(image.path);
    }
    setState(() {});
  }

  void _camera() async {
    Navigator.of(context).pop();
    final XFile? image = await _picker.pickImage(source: ImageSource.camera);
    if (image != null) {
      file = File(image.path);
    }
    setState(() {});
  }

  void _clear() {
    file = null;
    setState(() {});
  }

  void _upload() async {
    String subId = controller.text.trim();
    if (subId.isEmpty || file == null) {
      Util.fireSnackBar("Please upload image or enter title!", context);
      return;
    }

    isLoading = true;
    setState(() {});

    String? resUploadImg = await NetworkService.MULTIPART(
        NetworkService.API_IMAGE_UPLOAD,
        file!.path,
        NetworkService.bodyImageUpload(subId));

    isLoading = false;
    setState(() {});

    if (resUploadImg != null) {
      if (mounted) {
        Util.fireSnackBar("Your image was/is successfully uploaded!", context);
      }
      controller.clear();
      file = null;
      if (mounted) {
        Navigator.pushReplacement(
          context,
          PageRouteBuilder(
            pageBuilder: (context, animation, secondaryAnimation) => HomePage(
              crossAxisCount: widget.crossAxisCount,
              subPage: 1,
            ),
            transitionDuration: const Duration(seconds: 0),
          ),
        );
      }
    } else {
      if (mounted) {
        Util.fireSnackBar(
            "Failed! Please try again! System error! (Ko'pakni yukla)",
            context);
      }
    }
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        actions: [
          Padding(
            padding: const EdgeInsets.all(10.0),
            child: TextButton(
              onPressed: _upload,
              child: const Text(
                "Upload",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
            ),
          )
        ],
      ),
      body: Stack(
        children: [
          Column(
            children: [
              Expanded(
                flex: 2,
                child: Center(
                  child: file == null
                      ? GestureDetector(
                          onTap: _getImage,
                          child: Container(
                            alignment: const Alignment(0, 0.35),
                            constraints: const BoxConstraints(
                              minWidth: 250,
                              minHeight: 250,
                              maxHeight: 400,
                              maxWidth: 400,
                            ),
                            decoration: const BoxDecoration(
                                image: DecorationImage(
                              image:
                                  AssetImage("assets/images/place_holder.jpeg"),
                            )),
                            child: const Icon(
                              Icons.add_circle_outline,
                              color: Colors.white,
                              size: 80,
                            ),
                          ),
                        )
                      : Container(
                          constraints: const BoxConstraints(
                            minWidth: 250,
                            minHeight: 250,
                            maxHeight: 400,
                            maxWidth: 400,
                          ),
                          child: Stack(
                            alignment: Alignment.topRight,
                            children: [
                              Image.file(
                                file!,
                                fit: BoxFit.cover,
                              ),
                              IconButton(
                                  onPressed: _clear,
                                  splashRadius: 25,
                                  icon: const Icon(
                                    Icons.cancel_outlined,
                                    color: Colors.white,
                                    size: 30,
                                    shadows: [
                                      BoxShadow(
                                        color: Colors.grey,
                                        blurRadius: 7,
                                        spreadRadius: 7,
                                      ),
                                    ],
                                  ))
                            ],
                          ),
                        ),
                ),
              ),
              Expanded(
                flex: 3,
                child: Container(
                  padding: const EdgeInsets.all(20),
                  child: TextField(
                    controller: controller,
                    decoration: const InputDecoration(hintText: "Title"),
                    style: const TextStyle(
                        color: Colors.black,
                        fontSize: 20,
                        fontWeight: FontWeight.w600),
                  ),
                ),
              ),
            ],
          ),
          Visibility(
            visible: isLoading,
            child: const Center(
              child: CircularProgressIndicator(),
            ),
          )
        ],
      ),
    );
  }
}
