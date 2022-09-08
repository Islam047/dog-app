import 'dart:convert';

List<Image> imageListFromJson(String str) {
  List list = jsonDecode(str);
  List<Image> images = list.map((e) => Image.fromJson(e)).toList();
  return images;
}

Image imageFromJson(String str) => Image.fromJson(json.decode(str));
String imageToJson(Image data) => json.encode(data.toJson());

class Image {
  Image({
    this.breeds,
    this.id,
    this.url,
    this.width,
    this.height,
    this.subId,
    this.createdAt,
    this.originalFilename,
    this.breedIds,});

  Image.fromJson(dynamic json) {
    if (json['breeds'] != null) {
      breeds = [];
      json['breeds'].forEach((v) {
        breeds?.add(Breeds.fromJson(v));
      });
    }
    id = json['id'];
    url = json['url'];
    width = json['width'];
    height = json['height'];
    subId = json['sub_id'];
    createdAt = json['created_at'];
    originalFilename = json['original_filename'];
    breedIds = json['breed_ids'];
  }
  List<Breeds>? breeds;
  String? id;
  String? url;
  int? width;
  int? height;
  String? subId;
  String? createdAt;
  String? originalFilename;
  String? breedIds;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    if (breeds != null) {
      map['breeds'] = breeds?.map((v) => v.toJson()).toList();
    }
    map['id'] = id;
    map['url'] = url;
    map['width'] = width;
    map['height'] = height;
    map['sub_id'] = subId;
    map['created_at'] = createdAt;
    map['original_filename'] = originalFilename;
    map['breed_ids'] = breedIds;
    return map;
  }

}

Breeds breedsFromJson(String str) => Breeds.fromJson(json.decode(str));
String breedsToJson(Breeds data) => json.encode(data.toJson());

class Breeds {
  Breeds({
    this.weight,
    this.height,
    this.id,
    this.name,
    this.countryCode,
    this.bredFor,
    this.breedGroup,
    this.lifeSpan,
    this.temperament,
    this.referenceImageId,
  });

  Breeds.fromJson(dynamic json) {
    weight = json['weight'] != null ? Weight.fromJson(json['weight']) : null;
    height = json['height'] != null ? Height.fromJson(json['height']) : null;
    id = json['id'];
    name = json['name'];
    countryCode = json['country_code'];
    bredFor = json['bred_for'];
    breedGroup = json['breed_group'];
    lifeSpan = json['life_span'];
    temperament = json['temperament'];
    referenceImageId = json['reference_image_id'];
  }

  Weight? weight;
  Height? height;
  int? id;
  String? name;
  String? countryCode;
  String? bredFor;
  String? breedGroup;
  String? lifeSpan;
  String? temperament;
  String? referenceImageId;

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
    map['country_code'] = countryCode;
    map['bred_for'] = bredFor;
    map['breed_group'] = breedGroup;
    map['life_span'] = lifeSpan;
    map['temperament'] = temperament;
    map['reference_image_id'] = referenceImageId;
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
