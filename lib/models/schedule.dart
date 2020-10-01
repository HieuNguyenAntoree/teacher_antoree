import 'dart:convert';

ScheduleModel emptyFromJson(String str) => ScheduleModel.fromJson(json.decode(str));

String emptyToJson(ScheduleModel data) => json.encode(data.toJson());

class ScheduleModel {
  ScheduleModel({
    this.paging,
    this.objects,
  });

  Paging paging;
  List<Dates> objects;

  factory ScheduleModel.fromJson(Map<String, dynamic> json) => ScheduleModel(
    paging: Paging.fromJson(json["paging"]),
    objects: List<Dates>.from(json["objects"].map((x) => Dates.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "paging": paging.toJson(),
    "objects": List<dynamic>.from(objects.map((x) => x.toJson())),
  };
}

class Dates {
  Dates({
    this.date,
    this.schedules,
  });

  DateTime date;
  List<Schedule> schedules;

  factory Dates.fromJson(Map<String, dynamic> json) => Dates(
    date: json["date"] != null ? DateTime.parse(json["date"]) : DateTime.now(),
    schedules: List<Schedule>.from(json["schedules"].map((x) => Schedule.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "date": date.toIso8601String(),
    "schedules": List<dynamic>.from(schedules.map((x) => x.toJson())),
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
  String comment;
  dynamic scheduleType;

  factory Schedule.fromJson(Map<String, dynamic> json) => Schedule(
    id: json["id"],
    comment: json["comment"],
    description: json["description"],
    content: json["content"],
    startTime: DateTime.parse(json["startTime"]),
    endTime: DateTime.parse(json["endTime"]),
    status: json["status"],
    createdAt: DateTime.parse(json["createdAt"]),
    modifiedAt: DateTime.parse(json["modifiedAt"]),
    users: List<User>.from(json["users"].map((x) => User.fromJson(x))),
    scheduleType: json["scheduleType"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "comment": comment,
    "description": description,
    "content": content,
    "startTime": startTime.toIso8601String(),
    "endTime": endTime.toIso8601String(),
    "status": status,
    "createdAt": createdAt.toIso8601String(),
    "modifiedAt": modifiedAt.toIso8601String(),
    "users": List<dynamic>.from(users.map((x) => x.toJson())),
    "scheduleType": scheduleType,
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
    this.phoneVerified,
    this.emailVerified,
    this.role,
  });

  String id;
  dynamic firstName;
  dynamic lastName;
  Avatar avatar;
  dynamic birthday;
  dynamic phoneNumber;
  Address address;
  String email;
  String status;
  dynamic phoneVerified;
  dynamic emailVerified;
  String role;

  factory User.fromJson(Map<String, dynamic> json) => User(
    id: json["id"],
    firstName: json["firstName"],
    lastName: json["lastName"],
    avatar: Avatar.fromJson(json["avatar"]),
    birthday: json["birthday"],
    phoneNumber: json["phoneNumber"],
    address: Address.fromJson(json["address"]),
    email: json["email"],
    status: json["status"],
    phoneVerified: json["phoneVerified"],
    emailVerified: json["emailVerified"],
    role: json["role"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "firstName": firstName,
    "lastName": lastName,
    "avatar": avatar.toJson(),
    "birthday": birthday,
    "phoneNumber": phoneNumber,
    "address": address.toJson(),
    "email": email,
    "status": status,
    "phoneVerified": phoneVerified,
    "emailVerified": emailVerified,
    "role": role,
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

  dynamic id;
  dynamic address;
  dynamic locationLevel1;
  dynamic locationLevel2;
  dynamic locationLevel3;

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

  dynamic id;
  dynamic fileName;
  dynamic bucketName;
  dynamic region;
  dynamic url;
  dynamic createdAt;

  factory Avatar.fromJson(Map<String, dynamic> json) => Avatar(
    id: json["id"],
    fileName: json["fileName"],
    bucketName: json["bucketName"],
    region: json["region"],
    url: json["url"],
    createdAt: json["createdAt"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "fileName": fileName,
    "bucketName": bucketName,
    "region": region,
    "url": url,
    "createdAt": createdAt,
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
    limit: json["limit"],
    offset: json["offset"],
    page: json["page"],
    total: json["total"],
  );

  Map<String, dynamic> toJson() => {
    "limit": limit,
    "offset": offset,
    "page": page,
    "total": total,
  };
}