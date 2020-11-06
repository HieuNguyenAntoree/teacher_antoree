import 'dart:convert';

import 'package:Antoree/const/constant.dart';


ScheduleModel emptyFromJson(String str) => ScheduleModel.fromJson(json.decode(str));

String emptyToJson(ScheduleModel data) => json.encode(data.toJson());

class ScheduleModel {
  ScheduleModel({
    this.paging,
    this.objects,
  });

  Paging paging;
  List<Object> objects;

  factory ScheduleModel.fromJson(Map<String, dynamic> json) => ScheduleModel(
    paging: json["paging"] == null ? null : Paging.fromJson(json["paging"]),
    objects: json["objects"] == null ? null : List<Object>.from(json["objects"].map((x) => Object.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "paging": paging == null ? null : paging.toJson(),
    "objects": objects == null ? null : List<dynamic>.from(objects.map((x) => x.toJson())),
  };
}

class Object {
  Object({
    this.date,
    this.schedules,
  });

  DateTime date;
  List<Schedule> schedules;

  factory Object.fromJson(Map<String, dynamic> json) => Object(
    date: json["date"] == null ? null : DateTime.parse(json["date"]),
    schedules: json["schedules"] == null ? null : List<Schedule>.from(json["schedules"].map((x) => Schedule.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "date": date == null ? null : date.toIso8601String(),
    "schedules": schedules == null ? null : List<dynamic>.from(schedules.map((x) => x.toJson())),
  };
}

class Schedule {
  Schedule({
    this.id,
    this.description,
    this.content,
    this.startTime,
    this.endTime,
    this.status,
    this.createdAt,
    this.modifiedAt,
    this.users,
    this.scheduleType,
    this.comment,
  });

  String id;
  String description;
  String content;
  DateTime startTime;
  DateTime endTime;
  int status;
  DateTime createdAt;
  DateTime modifiedAt;
  List<User> users;
  dynamic scheduleType;
  String comment;

  factory Schedule.fromJson(Map<String, dynamic> json) => Schedule(
    id: json["id"] == null ? null : json["id"],
    description: json["description"] == null ? null : json["description"],
    content: json["content"] == null ? null : json["content"],
    startTime: json["startTime"] == null ? null : DateTime.parse(json["startTime"]),
    endTime: json["endTime"] == null ? null : DateTime.parse(json["endTime"]),
    status: json["status"] == null ? null : json["status"],
    createdAt: json["createdAt"] == null ? null : DateTime.parse(json["createdAt"]),
    modifiedAt: json["modifiedAt"] == null ? null : DateTime.parse(json["modifiedAt"]),
    users: json["users"] == null ? null : List<User>.from(json["users"].map((x) => User.fromJson(x))),
    scheduleType: json["scheduleType"],
    comment: json["comment"] == null ? null : json["comment"],
  );

  Map<String, dynamic> toJson() => {
    "id": id == null ? null : id,
    "description": description == null ? null : description,
    "content": content == null ? null : content,
    "startTime": startTime == null ? null : startTime.toIso8601String(),
    "endTime": endTime == null ? null : endTime.toIso8601String(),
    "status": status == null ? null : status,
    "createdAt": createdAt == null ? null : createdAt.toIso8601String(),
    "modifiedAt": modifiedAt == null ? null : modifiedAt.toIso8601String(),
    "users": users == null ? null : List<dynamic>.from(users.map((x) => x.toJson())),
    "scheduleType": scheduleType,
    "comment": comment == null ? null : comment,
  };
}

class User {
  User({
    this.id,
    this.firstName,
    this.lastName,
    this.avatar,
    this.birthday,
    this.phoneNumber,
    this.address,
    this.email,
    this.status,
    this.urlSkype,
    this.urlFacebook,
    this.alternateEmail,
    this.password,
    this.displayName,
    this.urlAvatar,
    this.gender,
    this.createdAt,
    this.modifiedAt,
    this.code,
    this.country,
    this.role,
    this.active,
    this.phoneVerified,
    this.emailVerified,
  });

  String id;
  String firstName;
  String lastName;
  Avatar avatar;
  dynamic birthday;
  dynamic phoneNumber;
  Address address;
  String email;
  int status;
  String urlSkype;
  dynamic urlFacebook;
  dynamic alternateEmail;
  dynamic password;
  String displayName;
  dynamic urlAvatar;
  int gender;
  String createdAt;
  String modifiedAt;
  dynamic code;
  String country;
  String role;
  dynamic active;
  dynamic phoneVerified;
  dynamic emailVerified;

  factory User.fromJson(Map<String, dynamic> json) => User(
    id: json["id"] == null ? null : json["id"],
    firstName: json["firstName"] == null ? null : json["firstName"],
    lastName: json["lastName"] == null ? null : json["lastName"],
    avatar: json["avatar"] == null ? Avatar() : Avatar.fromJson(json["avatar"]),
    birthday: json["birthday"],
    phoneNumber: json["phoneNumber"],
    address: json["address"] == null ? null : Address.fromJson(json["address"]),
    email: json["email"] == null ? null : json["email"],
    status: json["status"] == null ? null : json["status"],
    urlSkype: json["urlSkype"] == null ? null : json["urlSkype"],
    urlFacebook: json["urlFacebook"],
    alternateEmail: json["alternateEmail"],
    password: json["password"],
    displayName: json["displayName"] == null ? null : json["displayName"],
    urlAvatar: json["urlAvatar"],
    gender: json["gender"] == null ? null : json["gender"],
    createdAt: json["createdAt"] == null ? null : json["createdAt"],
    modifiedAt: json["modifiedAt"] == null ? null : json["modifiedAt"],
    code: json["code"],
    country: json["country"] == null ? null : json["country"],
    role: json["role"] == null ? null : json["role"],
    active: json["active"],
    phoneVerified: json["phoneVerified"],
    emailVerified: json["emailVerified"],
  );

  Map<String, dynamic> toJson() => {
    "id": id == null ? null : id,
    "firstName": firstName == null ? null : firstName,
    "lastName": lastName == null ? null : lastName,
    "avatar": avatar == null ? null : avatar.toJson(),
    "birthday": birthday,
    "phoneNumber": phoneNumber,
    "address": address == null ? null : address.toJson(),
    "email": email == null ? null : email,
    "status": status == null ? null : status,
    "urlSkype": urlSkype == null ? null : urlSkype,
    "urlFacebook": urlFacebook,
    "alternateEmail": alternateEmail,
    "password": password,
    "displayName": displayName == null ? null : displayName,
    "urlAvatar": urlAvatar,
    "gender": gender == null ? null : gender,
    "createdAt": createdAt == null ? null : createdAt,
    "modifiedAt": modifiedAt == null ? null : modifiedAt,
    "code": code,
    "country": country == null ? null : country,
    "role": role == null ? null : role,
    "active": active,
    "phoneVerified": phoneVerified,
    "emailVerified": emailVerified,
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
    id: json["id"] == null ? null : json["id"],
    address: json["address"] == null ? null : json["address"],
    locationLevel1: json["locationLevel1"] == null ? null : json["locationLevel1"],
    locationLevel2: json["locationLevel2"] == null ? null : json["locationLevel2"],
    locationLevel3: json["locationLevel3"] == null ? null : json["locationLevel3"],
  );

  Map<String, dynamic> toJson() => {
    "id": id == null ? null : id,
    "address": address == null ? null : address,
    "locationLevel1": locationLevel1 == null ? null : locationLevel1,
    "locationLevel2": locationLevel2 == null ? null : locationLevel2,
    "locationLevel3": locationLevel3 == null ? null : locationLevel3,
  };
}

class Avatar {
  Avatar({
    this.id,
    this.fileName,
    this.bucketName,
    this.region,
    this.url,
    this.createdAt,
  });

  String id = "";
  dynamic fileName = "";
  String bucketName = "";
  String region = "";
  String url = "";
  String createdAt = "";

  factory Avatar.fromJson(Map<String, dynamic> json) => Avatar(
    id: json["id"] == null ? "" : json["id"],
    fileName: json["fileName"],
    bucketName: json["bucketName"] == "" ? null : json["bucketName"],
    region: json["region"] == null ? "" : json["region"],
    url: json["url"] == null ? "" : json["url"],
    createdAt: json["createdAt"] == null ? "" : json["createdAt"],
  );

  Map<String, dynamic> toJson() => {
    "id": id == null ? "" : id,
    "fileName": fileName,
    "bucketName": bucketName == null ? "" : bucketName,
    "region": region == null ? "" : region,
    "url": url == null ? "" : url,
    "createdAt": createdAt == null ? "" : createdAt,
  };
}

class Paging {
  Paging({
    this.limit,
    this.offset,
    this.page,
    this.total,
  });

  int limit;
  int offset;
  dynamic page;
  int total;

  factory Paging.fromJson(Map<String, dynamic> json) => Paging(
    limit: json["limit"] == null ? null : json["limit"],
    offset: json["offset"] == null ? null : json["offset"],
    page: json["page"],
    total: json["total"] == null ? null : json["total"],
  );

  Map<String, dynamic> toJson() => {
    "limit": limit == null ? null : limit,
    "offset": offset == null ? null : offset,
    "page": page,
    "total": total == null ? null : total,
  };
}