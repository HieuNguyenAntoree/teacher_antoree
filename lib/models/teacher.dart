import 'dart:convert';
TeacherModel emptyFromJson(String str) => TeacherModel.fromJson(json.decode(str));

String emptyToJson(TeacherModel data) => json.encode(data.toJson());

class TeacherModel {
  TeacherModel({
    this.paging,
    this.objects,
  });

  Paging paging;
  List<Teacher> objects;

  factory TeacherModel.fromJson(Map<String, dynamic> json) => TeacherModel(
    paging: json["paging"] == null ? null : Paging.fromJson(json["paging"]),
    objects: json["objects"] == null ? null : List<Teacher>.from(json["objects"].map((x) => Teacher.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "paging": paging == null ? null : paging.toJson(),
    "objects": objects == null ? null : List<dynamic>.from(objects.map((x) => x.toJson())),
  };
}

class Teacher {
  Teacher({
    this.id,
    this.userId,
    this.voiceDemo,
    this.interviewedBy,
    this.contract,
    this.createdAt,
    this.modifiedAt,
    this.isActive,
    this.teacherType,
    this.introduction,
    this.tsNote,
    this.rating,
    this.pricePerHour,
    this.profileLink,
    this.isTester,
    this.userInfo,
    this.user,
  });

  String id = "";
  String userId = "";
  Contract voiceDemo;
  String interviewedBy;
  Contract contract;
  DateTime createdAt;
  DateTime modifiedAt;
  bool isActive;
  String teacherType = "";
  String introduction = "";
  String tsNote = "";
  int rating = 0;
  double pricePerHour = 0;
  String profileLink = "";
  bool isTester;
  User userInfo;
  User user;

  factory Teacher.fromJson(Map<String, dynamic> json) => Teacher(
    id: json["id"] == null ? null : json["id"],
    userId: json["userId"] == null ? null : json["userId"],
    voiceDemo: json["voiceDemo"] == null ? null : Contract.fromJson(json["voiceDemo"]),
    interviewedBy: json["interviewedBy"] == null ? "" : json["interviewedBy"],
    contract: json["contract"] == null ? null : Contract.fromJson(json["contract"]),
    createdAt: json["createdAt"] == null ? null : DateTime.parse(json["createdAt"]),
    modifiedAt: json["modifiedAt"] == null ? null : DateTime.parse(json["modifiedAt"]),
    isActive: json["isActive"] == null ? null : json["isActive"],
    teacherType: json["teacherType"] == null ? null : json["teacherType"],
    introduction: json["introduction"] == null ? null : json["introduction"],
    tsNote: json["tsNote"] == null ? null : json["tsNote"],
    rating: json["rating"] == null ? null : json["rating"],
    pricePerHour: json["pricePerHour"] == null ? 0 : json["pricePerHour"],
    profileLink: json["profileLink"] == null ? null : json["profileLink"],
    isTester: json["isTester"] == null ? null : json["isTester"],
    userInfo: json["userInfo"] == null ? null : User.fromJson(json["userInfo"]),
    user: json["user"] == null ? null : User.fromJson(json["user"]),
  );

  Map<String, dynamic> toJson() => {
    "id": id == null ? null : id,
    "userId": userId == null ? null : userId,
    "voiceDemo": voiceDemo == null ? null : voiceDemo.toJson(),
    "interviewedBy": interviewedBy == null ? "" : interviewedBy,
    "contract": contract == null ? null : contract.toJson(),
    "createdAt": createdAt == null ? null : createdAt.toIso8601String(),
    "modifiedAt": modifiedAt == null ? null : modifiedAt.toIso8601String(),
    "isActive": isActive == null ? null : isActive,
    "teacherType": teacherType == null ? null : teacherType,
    "introduction": introduction == null ? null : introduction,
    "tsNote": tsNote == null ? null : tsNote,
    "rating": rating == null ? null : rating,
    "pricePerHour": pricePerHour == null ? 0 : pricePerHour,
    "profileLink": profileLink == null ? null : profileLink,
    "isTester": isTester == null ? null : isTester,
    "userInfo": userInfo == null ? null : userInfo.toJson(),
    "user": user == null ? null : user.toJson(),
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
  String url = "";
  String createdAt = "";

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
  InterviewedBy();

  factory InterviewedBy.fromJson(Map<String, dynamic> json) => InterviewedBy(
  );

  Map<String, dynamic> toJson() => {
  };
}

class User {
  User({
    this.id,
    this.firstName,
    this.lastName,
    this.avatar,
    this.birthday,
    this.address,
    this.email,
    this.status,
    this.displayName,
    this.gender,
    this.createdAt,
    this.modifiedAt,
    this.country,
  });

  String id = "";
  String firstName = "";
  String lastName = "";
  Contract avatar;
  String birthday = "";
  Address address;
  String email = "";
  int status;
  String displayName;
  int gender;
  String createdAt;
  String modifiedAt;
  String country;

  factory User.fromJson(Map<String, dynamic> json) => User(
    id: json["id"] == null ? "" : json["id"],
    firstName: json["firstName"] == null ? "" : json["firstName"],
    lastName: json["lastName"] == null ? "" : json["lastName"],
    avatar: json["avatar"] == null ? null : Contract.fromJson(json["avatar"]),
    birthday: json["birthday"] == null ? null : json["birthday"],
    address: json["address"] == null ? null : Address.fromJson(json["address"]),
    email: json["email"] == null ? null : json["email"],
    status: json["status"] == null ? null : json["status"],
    displayName: json["displayName"] == null ? null : json["displayName"],
    gender: json["gender"] == null ? null : json["gender"],
    createdAt: json["createdAt"] == null ? null : json["createdAt"],
    modifiedAt: json["modifiedAt"] == null ? null : json["modifiedAt"],
    country: json["country"] == null ? null : json["country"],
  );

  Map<String, dynamic> toJson() => {
    "id": id == null ? null : id,
    "firstName": firstName == null ? null : firstName,
    "lastName": lastName == null ? null : lastName,
    "avatar": avatar == null ? null : avatar.toJson(),
    "birthday": birthday == null ? null : birthday,
    "address": address == null ? null : address.toJson(),
    "email": email == null ? null : email,
    "status": status == null ? null : status,
    "displayName": displayName == null ? null : displayName,
    "gender": gender == null ? null : gender,
    "createdAt": createdAt == null ? null : createdAt,
    "modifiedAt": modifiedAt == null ? null : modifiedAt,
    "country": country == null ? null : country,
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

class Paging {
  Paging({
    this.page,
    this.limit,
    this.offset,
    this.total,
  });

  int page;
  int limit;
  int offset;
  int total;

  factory Paging.fromJson(Map<String, dynamic> json) => Paging(
    page: json["page"] == null ? null : json["page"],
    limit: json["limit"] == null ? null : json["limit"],
    offset: json["offset"] == null ? null : json["offset"],
    total: json["total"] == null ? null : json["total"],
  );

  Map<String, dynamic> toJson() => {
    "page": page == null ? null : page,
    "limit": limit == null ? null : limit,
    "offset": offset == null ? null : offset,
    "total": total == null ? null : total,
  };
}

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
