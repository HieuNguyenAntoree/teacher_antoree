import 'dart:convert';

import 'package:teacher_antoree/const/constant.dart';

DeviceModel emptyFromJson(String str) => DeviceModel.fromJson(json.decode(str));

String emptyToJson(DeviceModel data) => json.encode(data.toJson());

class DeviceModel {
  DeviceModel({
    this.osVersion,
    this.platform,
    this.languageCode,
    this.appName,
    this.appVersion,
    this.lastOpenedAt,
    this.id,
    this.userId,
    this.fcmToken,
    this.createdAt,
    this.updatedAt,
  });

  String osVersion;
  String platform;
  String languageCode;
  String appName;
  String appVersion;
  DateTime lastOpenedAt;
  String id;
  String userId;
  String fcmToken;
  DateTime createdAt;
  DateTime updatedAt;

  factory DeviceModel.fromJson(Map<String, dynamic> json) => DeviceModel(
    osVersion: json["os_version"] == null ? null : json["os_version"],
    platform: json["platform"] == null ? null : json["platform"],
    languageCode: json["language_code"] == null ? null : json["language_code"],
    appName: json["app_name"] == null ? null : json["app_name"],
    appVersion: json["app_version"] == null ? null : json["app_version"],
    lastOpenedAt: json["last_opened_at"] == null ? null : DateTime.parse(VALUES.FORMAT_DATE_API.format(DateTime.parse(json["last_opened_at"]).toLocal())),
    id: json["id"] == null ? null : json["id"],
    userId: json["user_id"] == null ? null : json["user_id"],
    fcmToken: json["fcm_token"] == null ? null : json["fcm_token"],
    createdAt: json["created_at"] == null ? null : DateTime.parse(VALUES.FORMAT_DATE_API.format(DateTime.parse(json["created_at"]).toLocal())),
    updatedAt: json["updated_at"] == null ? null : DateTime.parse(VALUES.FORMAT_DATE_API.format(DateTime.parse(json["updated_at"]).toLocal())),
  );

  Map<String, dynamic> toJson() => {
    "os_version": osVersion == null ? null : osVersion,
    "platform": platform == null ? null : platform,
    "language_code": languageCode == null ? null : languageCode,
    "app_name": appName == null ? null : appName,
    "app_version": appVersion == null ? null : appVersion,
    "last_opened_at": lastOpenedAt == null ? null : lastOpenedAt.toIso8601String(),
    "id": id == null ? null : id,
    "user_id": userId == null ? null : userId,
    "fcm_token": fcmToken == null ? null : fcmToken,
    "created_at": createdAt == null ? null : createdAt.toIso8601String(),
    "updated_at": updatedAt == null ? null : updatedAt.toIso8601String(),
  };
}
