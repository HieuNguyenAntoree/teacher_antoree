// To parse this JSON data, do
//
//     final empty = emptyFromJson(jsonString);

import 'dart:convert';
List<TeacherModel> emptyFromJson(String str) => List<TeacherModel>.from(json.decode(str).map((x) => TeacherModel.fromJson(x)));

String emptyToJson(List<TeacherModel> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class TeacherModel {
  TeacherModel({
    this.id,
    this.userId,
    this.voiceDemo,
    this.interviewedBy,
    this.contract,
    this.createdAt,
    this.modifiedAt,
    this.isActive,
    this.teacherType,
    this.tsNote,
    this.rating,
    this.pricePerHour,
    this.profileLink,
    this.user,
    this.introduction,
    this.isTester,
  });

  String id;
  String userId;
  Contract voiceDemo;
  InterviewedBy interviewedBy;
  Contract contract;
  DateTime createdAt;
  DateTime modifiedAt;
  bool isActive;
  String teacherType;
  String tsNote;
  int rating;
  double pricePerHour;
  String profileLink;
  InterviewedBy user;
  Introduction introduction;
  bool isTester;

  factory TeacherModel.fromJson(Map<String, dynamic> json) => TeacherModel(
    id: json["id"] == null ? null : json["id"],
    userId: json["userId"] == null ? null : json["userId"],
    voiceDemo: json["voiceDemo"] == null ? null : Contract.fromJson(json["voiceDemo"]),
    interviewedBy: json["interviewedBy"] == null ? null : InterviewedBy.fromJson(json["interviewedBy"]),
    contract: json["contract"] == null ? null : Contract.fromJson(json["contract"]),
    createdAt: json["createdAt"] == null ? null : DateTime.parse(json["createdAt"]),
    modifiedAt: json["modifiedAt"] == null ? null : DateTime.parse(json["modifiedAt"]),
    isActive: json["isActive"] == null ? null : json["isActive"],
    teacherType: json["teacherType"] == null ? null : json["teacherType"],
    tsNote: json["tsNote"] == null ? null : json["tsNote"],
    rating: json["rating"] == null ? null : json["rating"],
    pricePerHour: json["pricePerHour"] == null ? null : json["pricePerHour"],
    profileLink: json["profileLink"] == null ? null : json["profileLink"],
    user: json["user"] == null ? null : InterviewedBy.fromJson(json["user"]),
    introduction: json["introduction"] == null ? null : introductionValues.map[json["introduction"]],
    isTester: json["isTester"] == null ? null : json["isTester"],
  );

  Map<String, dynamic> toJson() => {
    "id": id == null ? null : id,
    "userId": userId == null ? null : userId,
    "voiceDemo": voiceDemo == null ? null : voiceDemo.toJson(),
    "interviewedBy": interviewedBy == null ? null : interviewedBy.toJson(),
    "contract": contract == null ? null : contract.toJson(),
    "createdAt": createdAt == null ? null : createdAt.toIso8601String(),
    "modifiedAt": modifiedAt == null ? null : modifiedAt.toIso8601String(),
    "isActive": isActive == null ? null : isActive,
    "teacherType": teacherType == null ? null : teacherType,
    "tsNote": tsNote == null ? null : tsNote,
    "rating": rating == null ? null : rating,
    "pricePerHour": pricePerHour == null ? null : pricePerHour,
    "profileLink": profileLink == null ? null : profileLink,
    "user": user == null ? null : user.toJson(),
    "introduction": introduction == null ? null : introductionValues.reverse[introduction],
    "isTester": isTester == null ? null : isTester,
  };
}

class Contract {
  Contract({
    this.id,
    this.fileName,
    this.bucketName,
    this.region,
    this.url,
    this.createdAt,
  });

  ContractId id;
  FileName fileName;
  BucketName bucketName;
  Region region;
  String url;
  String createdAt;

  factory Contract.fromJson(Map<String, dynamic> json) => Contract(
    id: json["id"] == null ? null : contractIdValues.map[json["id"]],
    fileName: json["fileName"] == null ? null : fileNameValues.map[json["fileName"]],
    bucketName: json["bucketName"] == null ? null : bucketNameValues.map[json["bucketName"]],
    region: json["region"] == null ? null : regionValues.map[json["region"]],
    url: json["url"] == null ? null : json["url"],
    createdAt: json["createdAt"] == null ? null : json["createdAt"],
  );

  Map<String, dynamic> toJson() => {
    "id": id == null ? null : contractIdValues.reverse[id],
    "fileName": fileName == null ? null : fileNameValues.reverse[fileName],
    "bucketName": bucketName == null ? null : bucketNameValues.reverse[bucketName],
    "region": region == null ? null : regionValues.reverse[region],
    "url": url == null ? null : url,
    "createdAt": createdAt == null ? null : createdAt,
  };
}

enum BucketName { AWS_BUCKET }

final bucketNameValues = EnumValues({
  "awsBucket": BucketName.AWS_BUCKET
});

enum FileName { CONTRACT_PDF, ABC_MP3 }

final fileNameValues = EnumValues({
  "abc.mp3": FileName.ABC_MP3,
  "contract.pdf": FileName.CONTRACT_PDF
});

enum ContractId { DSDSD4444232_FF, F23_F3_T335_GG33_G, SDS333_D223 }

final contractIdValues = EnumValues({
  "dsdsd4444232ff": ContractId.DSDSD4444232_FF,
  "f23f3t335gg33g": ContractId.F23_F3_T335_GG33_G,
  "sds333d223": ContractId.SDS333_D223
});

enum Region { US }

final regionValues = EnumValues({
  "US": Region.US
});

class InterviewedBy {
  InterviewedBy({
    this.id,
    this.firstName,
    this.lastName,
    this.avatar,
    this.birthday,
    this.address,
    this.email,
    this.urlSkype,
    this.gender,
    this.createdAt,
    this.modifiedAt,
    this.status,
    this.displayName,
    this.country,
    this.urlFacebook,
    this.urlAvatar,
  });

  String id;
  String firstName;
  String lastName;
  Contract avatar;
  String birthday;
  Address address;
  String email;
  UrlSkype urlSkype;
  int gender;
  String createdAt;
  String modifiedAt;
  int status;
  String displayName;
  String country;
  String urlFacebook;
  String urlAvatar;

  factory InterviewedBy.fromJson(Map<String, dynamic> json) => InterviewedBy(
    id: json["id"] == null ? null : json["id"],
    firstName: json["firstName"] == null ? null : json["firstName"],
    lastName: json["lastName"] == null ? null : json["lastName"],
    avatar: json["avatar"] == null ? null : Contract.fromJson(json["avatar"]),
    birthday: json["birthday"] == null ? null : json["birthday"],
    address: json["address"] == null ? null : Address.fromJson(json["address"]),
    email: json["email"] == null ? null : json["email"],
    urlSkype: json["urlSkype"] == null ? null : urlSkypeValues.map[json["urlSkype"]],
    gender: json["gender"] == null ? null : json["gender"],
    createdAt: json["createdAt"] == null ? null : json["createdAt"],
    modifiedAt: json["modifiedAt"] == null ? null : json["modifiedAt"],
    status: json["status"] == null ? null : json["status"],
    displayName: json["displayName"] == null ? null : json["displayName"],
    country: json["country"] == null ? null : json["country"],
    urlFacebook: json["urlFacebook"] == null ? null : json["urlFacebook"],
    urlAvatar: json["urlAvatar"] == null ? null : json["urlAvatar"],
  );

  Map<String, dynamic> toJson() => {
    "id": id == null ? null : id,
    "firstName": firstName == null ? null : firstName,
    "lastName": lastName == null ? null : lastName,
    "avatar": avatar == null ? null : avatar.toJson(),
    "birthday": birthday == null ? null : birthday,
    "address": address == null ? null : address.toJson(),
    "email": email == null ? null : email,
    "urlSkype": urlSkype == null ? null : urlSkypeValues.reverse[urlSkype],
    "gender": gender == null ? null : gender,
    "createdAt": createdAt == null ? null : createdAt,
    "modifiedAt": modifiedAt == null ? null : modifiedAt,
    "status": status == null ? null : status,
    "displayName": displayName == null ? null : displayName,
    "country": country == null ? null : country,
    "urlFacebook": urlFacebook == null ? null : urlFacebook,
    "urlAvatar": urlAvatar == null ? null : urlAvatar,
  };
}

class Address {
  Address({
    this.id,
    this.address,
    this.locationLevel1,
    this.locationLevel2,
    this.locationLevel3,
  });

  AddressId id;
  String address;
  LocationLevel locationLevel1;
  LocationLevel locationLevel2;
  LocationLevel locationLevel3;

  factory Address.fromJson(Map<String, dynamic> json) => Address(
    id: json["id"] == null ? null : addressIdValues.map[json["id"]],
    address: json["address"] == null ? null : json["address"],
    locationLevel1: json["locationLevel1"] == null ? null : locationLevelValues.map[json["locationLevel1"]],
    locationLevel2: json["locationLevel2"] == null ? null : locationLevelValues.map[json["locationLevel2"]],
    locationLevel3: json["locationLevel3"] == null ? null : locationLevelValues.map[json["locationLevel3"]],
  );

  Map<String, dynamic> toJson() => {
    "id": id == null ? null : addressIdValues.reverse[id],
    "address": address == null ? null : address,
    "locationLevel1": locationLevel1 == null ? null : locationLevelValues.reverse[locationLevel1],
    "locationLevel2": locationLevel2 == null ? null : locationLevelValues.reverse[locationLevel2],
    "locationLevel3": locationLevel3 == null ? null : locationLevelValues.reverse[locationLevel3],
  };
}

enum AddressId { ADFDG8_G8_GF }

final addressIdValues = EnumValues({
  "adfdg8g8gf": AddressId.ADFDG8_G8_GF
});

enum LocationLevel { WTF }

final locationLevelValues = EnumValues({
  "wtf?": LocationLevel.WTF
});

enum UrlSkype { SKY5, SKY6, SKY3 }

final urlSkypeValues = EnumValues({
  "sky3": UrlSkype.SKY3,
  "sky5": UrlSkype.SKY5,
  "sky6": UrlSkype.SKY6
});

enum Introduction { PROFESSSONAL_TEACHER }

final introductionValues = EnumValues({
  "professsonal teacher": Introduction.PROFESSSONAL_TEACHER
});


class EnumValues<T> {
  Map<String, T> map;
  Map<T, String> reverseMap;

  EnumValues(this.map);

  Map<T, String> get reverse {
    if (reverseMap == null) {
      reverseMap = map.map((k, v) => new MapEntry(v, k));
    }
    return reverseMap;
  }
}