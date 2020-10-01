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
    this.introduction,
    this.tsNote,
    this.rating,
    this.pricePerHour,
    this.user,
    this.profileLink,
  });

  String id;
  String userId;
  Contract voiceDemo;
  String interviewedBy;
  Contract contract;
  DateTime createdAt;
  DateTime modifiedAt;
  bool isActive;
  String teacherType;
  String introduction;
  String tsNote;
  int rating;
  double pricePerHour;
  User user;
  String profileLink;

  factory TeacherModel.fromJson(Map<String, dynamic> json) => TeacherModel(
    id: json["id"],
    userId: json["userId"],
    voiceDemo: Contract.fromJson(json["voiceDemo"]),
    interviewedBy: json["interviewedBy"],
    contract: Contract.fromJson(json["contract"]),
    createdAt: DateTime.parse(json["createdAt"]),
    modifiedAt: DateTime.parse(json["modifiedAt"]),
    isActive: json["isActive"],
    teacherType: json["teacherType"],
    introduction: json["introduction"],
    tsNote: json["tsNote"],
    rating: json["rating"],
    pricePerHour: json["pricePerHour"],
    user: User.fromJson(json["user"]),
    profileLink: json["profileLink"]
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "userId": userId,
    "voiceDemo": voiceDemo.toJson(),
    "interviewedBy": interviewedBy,
    "contract": contract.toJson(),
    "createdAt": createdAt.toIso8601String(),
    "modifiedAt": modifiedAt.toIso8601String(),
    "isActive": isActive,
    "teacherType": teacherType,
    "introduction": introduction,
    "tsNote": tsNote,
    "rating": rating,
    "pricePerHour": pricePerHour,
    "user": user.toJson(),
    "profileLink": profileLink,
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

  String id;
  String fileName;
  String bucketName;
  String region;
  String url;
  DateTime createdAt;

  factory Contract.fromJson(Map<String, dynamic> json) => Contract(
    id: json["id"],
    fileName: json["fileName"],
    bucketName: json["bucketName"],
    region: json["region"],
    url: json["url"],
    createdAt: DateTime.parse(json["createdAt"]),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "fileName": fileName,
    "bucketName": bucketName,
    "region": region,
    "url": url,
    "createdAt": createdAt.toIso8601String(),
  };
}

class User {
  User({
    this.id,
    this.birthDay,
    this.email,
    this.name,
    this.phoneNumber,
    this.createdAt,
    this.modifiedAt,
    this.avatar,
    this.address,
  });

  String id;
  int birthDay;
  String email;
  String name;
  String phoneNumber;
  int createdAt;
  int modifiedAt;
  Avatar avatar;
  Address address;

  factory User.fromJson(Map<String, dynamic> json) => User(
    id: json["id"],
    birthDay: json["birth_day"],
    email: json["email"],
    name: json["name"],
    phoneNumber: json["phone_number"],
    createdAt: json["created_at"],
    modifiedAt: json["modified_at"],
    avatar: Avatar.fromJson(json["avatar"]),
    address: Address.fromJson(json["address"]),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "birth_day": birthDay,
    "email": email,
    "name": name,
    "phone_number": phoneNumber,
    "created_at": createdAt,
    "modified_at": modifiedAt,
    "avatar": avatar.toJson(),
    "address": address.toJson(),
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

  String id;
  String address;
  String locationLevel1;
  String locationLevel2;
  String locationLevel3;

  factory Address.fromJson(Map<String, dynamic> json) => Address(
    id: json["id"],
    address: json["address"],
    locationLevel1: json["locationLevel1"],
    locationLevel2: json["locationLevel2"],
    locationLevel3: json["locationLevel3"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "address": address,
    "locationLevel1": locationLevel1,
    "locationLevel2": locationLevel2,
    "locationLevel3": locationLevel3,
  };
}

class Avatar {
  Avatar({
    this.id,
    this.bucketName,
    this.region,
    this.url,
    this.createdAt,
  });

  String id;
  String bucketName;
  String region;
  String url;
  int createdAt;

  factory Avatar.fromJson(Map<String, dynamic> json) => Avatar(
    id: json["id"],
    bucketName: json["bucketName"],
    region: json["region"],
    url: json["url"],
    createdAt: json["createdAt"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "bucketName": bucketName,
    "region": region,
    "url": url,
    "createdAt": createdAt,
  };
}