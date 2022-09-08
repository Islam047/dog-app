import 'dart:convert';

List<Favorite> favoriteListFromJson(String str) {
  List list = jsonDecode(str);
  List<Favorite> favorites = list.map((e) => Favorite.fromJson(e)).toList();
  return favorites;
}

Favorite favoriteFromJson(String str) => Favorite.fromJson(json.decode(str));
String favoriteToJson(Favorite data) => json.encode(data.toJson());
class Favorite {
  Favorite({
      this.id, 
      this.userId, 
      this.imageId, 
      this.subId, 
      this.createdAt, 
      this.image,});

  Favorite.fromJson(dynamic json) {
    id = json['id'];
    userId = json['user_id'];
    imageId = json['image_id'];
    subId = json['sub_id'];
    createdAt = json['created_at'];
    image = json['image'] != null ? Image.fromJson(json['image']) : null;
  }
  int? id;
  String? userId;
  String? imageId;
  String? subId;
  String? createdAt;
  Image? image;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = id;
    map['user_id'] = userId;
    map['image_id'] = imageId;
    map['sub_id'] = subId;
    map['created_at'] = createdAt;
    if (image != null) {
      map['image'] = image?.toJson();
    }
    return map;
  }

}

Image imageFromJson(String str) => Image.fromJson(json.decode(str));
String imageToJson(Image data) => json.encode(data.toJson());
class Image {
  Image({
      this.id, 
      this.url,});

  Image.fromJson(dynamic json) {
    id = json['id'];
    url = json['url'];
  }
  String? id;
  String? url;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = id;
    map['url'] = url;
    return map;
  }

}