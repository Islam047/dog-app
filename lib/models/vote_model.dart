import 'dart:convert';

List<Vote> voteListFromJson(String str) {
  List list = jsonDecode(str);
  List<Vote> votes = list.map((e) => Vote.fromJson(e)).toList();
  return votes;
}

Vote voteFromJson(String str) => Vote.fromJson(json.decode(str));
String voteToJson(Vote data) => json.encode(data.toJson());

class Vote {
  Vote({
    this.id,
    this.imageId,
    this.subId,
    this.createdAt,
    this.value,
    this.countryCode,
  });

  Vote.fromJson(dynamic json) {
    id = json['id'];
    imageId = json['image_id'];
    subId = json['sub_id'];
    createdAt = json['created_at'];
    value = json['value'];
    countryCode = json['country_code'];
  }

  int? id;
  String? imageId;
  String? subId;
  String? createdAt;
  int? value;
  String? countryCode;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = id;
    map['image_id'] = imageId;
    map['sub_id'] = subId;
    map['created_at'] = createdAt;
    map['value'] = value;
    map['country_code'] = countryCode;
    return map;
  }
}
