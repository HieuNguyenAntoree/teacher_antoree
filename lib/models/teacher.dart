// To parse this JSON data, do
//
//     final empty = emptyFromJson(jsonString);

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
    paging: Paging.fromJson(json["paging"]),
    objects: List<Teacher>.from(json["objects"].map((x) => Teacher.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "paging": paging.toJson(),
    "objects": List<dynamic>.from(objects.map((x) => x.toJson())),
  };
}

class Teacher {
  Teacher({
    this.id,
    this.user,
    this.identificationFiles,
    this.voice,
    this.voiceDemo,
    this.job,
    this.interviewedBy,
    this.isVerified,
    this.isAvailable,
    this.contract,
  });

  String id;
  InterviewedBy user;
  List<Contract> identificationFiles;
  String voice;
  Contract voiceDemo;
  String job;
  InterviewedBy interviewedBy;
  bool isVerified;
  bool isAvailable;
  Contract contract;

  factory Teacher.fromJson(Map<String, dynamic> json) => Teacher(
    id: json["id"],
    user: InterviewedBy.fromJson(json["user"]),
    identificationFiles: List<Contract>.from(json["identificationFiles"].map((x) => Contract.fromJson(x))),
    voice: json["voice"],
    voiceDemo: Contract.fromJson(json["voiceDemo"]),
    job: json["job"],
    interviewedBy: InterviewedBy.fromJson(json["interviewedBy:"]),
    isVerified: json["isVerified"],
    isAvailable: json["isAvailable"],
    contract: Contract.fromJson(json["contract"]),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "user": user.toJson(),
    "identificationFiles": List<dynamic>.from(identificationFiles.map((x) => x.toJson())),
    "voice": voice,
    "voiceDemo": voiceDemo.toJson(),
    "job": job,
    "interviewedBy:": interviewedBy.toJson(),
    "isVerified": isVerified,
    "isAvailable": isAvailable,
    "contract": contract.toJson(),
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

class InterviewedBy {
  InterviewedBy({
    this.id,
    this.firstName,
    this.lastName,
    this.avatar,
    this.birthday,
    this.phoneNumber,
    this.address,
    this.email,
    this.isPhoneVerified,
    this.isEmailVerified,
    this.status,
  });

  String id;
  String firstName;
  String lastName;
  Contract avatar;
  DateTime birthday;
  String phoneNumber;
  Address address;
  String email;
  bool isPhoneVerified;
  bool isEmailVerified;
  String status;

  factory InterviewedBy.fromJson(Map<String, dynamic> json) => InterviewedBy(
    id: json["id"],
    firstName: json["firstName"],
    lastName: json["lastName"],
    avatar: Contract.fromJson(json["avatar"]),
    birthday: DateTime.parse(json["birthday"]),
    phoneNumber: json["phoneNumber"],
    address: Address.fromJson(json["address"]),
    email: json["email"],
    isPhoneVerified: json["isPhoneVerified"],
    isEmailVerified: json["isEmailVerified"],
    status: json["status"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "firstName": firstName,
    "lastName": lastName,
    "avatar": avatar.toJson(),
    "birthday": "${birthday.year.toString().padLeft(4, '0')}-${birthday.month.toString().padLeft(2, '0')}-${birthday.day.toString().padLeft(2, '0')}",
    "phoneNumber": phoneNumber,
    "address": address.toJson(),
    "email": email,
    "isPhoneVerified": isPhoneVerified,
    "isEmailVerified": isEmailVerified,
    "status": status,
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
    page: json["page"],
    limit: json["limit"],
    offset: json["offset"],
    total: json["total"],
  );

  Map<String, dynamic> toJson() => {
    "page": page,
    "limit": limit,
    "offset": offset,
    "total": total,
  };
}
