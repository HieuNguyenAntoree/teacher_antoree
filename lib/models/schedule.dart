// To parse this JSON data, do
//
//     final empty = emptyFromJson(jsonString);

import 'dart:convert';

ScheduleModel emptyFromJson(String str) => ScheduleModel.fromJson(json.decode(str));

String emptyToJson(ScheduleModel data) => json.encode(data.toJson());

class ScheduleModel {
  ScheduleModel({
    this.paging,
    this.objects,
  });

  Paging paging;
  List<Schedule> objects;

  factory ScheduleModel.fromJson(Map<String, dynamic> json) => ScheduleModel(
    paging: Paging.fromJson(json["paging"]),
    objects: List<Schedule>.from(json["objects"].map((x) => Schedule.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "paging": paging.toJson(),
    "objects": List<dynamic>.from(objects.map((x) => x.toJson())),
  };
}

class Schedule {
  Schedule({
    this.id,
    this.attendees,
    this.dateTime,
  });

  String id;
  List<Attendee> attendees;
  DateTime dateTime;

  factory Schedule.fromJson(Map<String, dynamic> json) => Schedule(
    id: json["id"],
    attendees: List<Attendee>.from(json["attendees"].map((x) => Attendee.fromJson(x))),
    dateTime: DateTime.parse(json["dateTime"]),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "attendees": List<dynamic>.from(attendees.map((x) => x.toJson())),
    "dateTime": dateTime.toIso8601String(),
  };
}

class Attendee {
  Attendee({
    this.user,
    this.role,
  });

  User user;
  String role;

  factory Attendee.fromJson(Map<String, dynamic> json) => Attendee(
    user: User.fromJson(json["user"]),
    role: json["role"],
  );

  Map<String, dynamic> toJson() => {
    "user": user.toJson(),
    "role": role,
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
    this.isPhoneVerified,
    this.isEmailVerified,
    this.status,
  });

  String id;
  String firstName;
  String lastName;
  Avatar avatar;
  DateTime birthday;
  String phoneNumber;
  Address address;
  String email;
  bool isPhoneVerified;
  bool isEmailVerified;
  String status;

  factory User.fromJson(Map<String, dynamic> json) => User(
    id: json["id"],
    firstName: json["firstName"],
    lastName: json["lastName"],
    avatar: Avatar.fromJson(json["avatar"]),
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

class Avatar {
  Avatar({
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

  factory Avatar.fromJson(Map<String, dynamic> json) => Avatar(
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