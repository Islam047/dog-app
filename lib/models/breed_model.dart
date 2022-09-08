library breed;
import 'dart:convert';

List<Breed> breedListFromJson(String str) {
  List list = jsonDecode(str);
  List<Breed> listBreed = list.map((item) => Breed.fromJson(item)).toList();
  return listBreed;
}
String breedListToJson(List<Breed> data) => jsonEncode(data.map((e) => e.toJson()).toList());

Breed breedFromJson(String str) => Breed.fromJson(json.decode(str));
String breedToJson(Breed data) => json.encode(data.toJson());

class Breed {
  Breed({
    this.weight,
    this.height,
    this.id,
    this.name,
    this.bredFor,
    this.breedGroup,
    this.lifeSpan,
    this.temperament,
    this.origin,
    this.referenceImageId,
    this.image,
  });

  Breed.fromJson(dynamic json) {
    weight = json['weight'] != null ? Weight.fromJson(json['weight']) : null;
    height = json['height'] != null ? Height.fromJson(json['height']) : null;
    id = json['id'];
    name = json['name'];
    bredFor = json['bred_for'];
    breedGroup = json['breed_group'];
    lifeSpan = json['life_span'];
    temperament = json['temperament'];
    origin = json['origin'];
    referenceImageId = json['reference_image_id'];
    image = json['image'] != null ? Image.fromJson(json['image']) : null;
  }

  Weight? weight;
  Height? height;
  int? id;
  String? name;
  String? bredFor;
  String? breedGroup;
  String? lifeSpan;
  String? temperament;
  String? origin;
  String? referenceImageId;
  Image? image;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    if (weight != null) {
      map['weight'] = weight?.toJson();
    }
    if (height != null) {
      map['height'] = height?.toJson();
    }
    map['id'] = id;
    map['name'] = name;
    map['bred_for'] = bredFor;
    map['breed_group'] = breedGroup;
    map['life_span'] = lifeSpan;
    map['temperament'] = temperament;
    map['origin'] = origin;
    map['reference_image_id'] = referenceImageId;
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
    this.width,
    this.height,
    this.url,
  });

  Image.fromJson(dynamic json) {
    id = json['id'];
    width = json['width'];
    height = json['height'];
    url = json['url'];
  }

  String? id;
  int? width;
  int? height;
  String? url;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = id;
    map['width'] = width;
    map['height'] = height;
    map['url'] = url;
    return map;
  }
}

Height heightFromJson(String str) => Height.fromJson(json.decode(str));

String heightToJson(Height data) => json.encode(data.toJson());

class Height {
  Height({
    this.imperial,
    this.metric,
  });

  Height.fromJson(dynamic json) {
    imperial = json['imperial'];
    metric = json['metric'];
  }

  String? imperial;
  String? metric;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['imperial'] = imperial;
    map['metric'] = metric;
    return map;
  }
}

Weight weightFromJson(String str) => Weight.fromJson(json.decode(str));

String weightToJson(Weight data) => json.encode(data.toJson());

class Weight {
  Weight({
    this.imperial,
    this.metric,
  });

  Weight.fromJson(dynamic json) {
    imperial = json['imperial'];
    metric = json['metric'];
  }

  String? imperial;
  String? metric;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['imperial'] = imperial;
    map['metric'] = metric;
    return map;
  }
}