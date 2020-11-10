// To parse this JSON data, do
//
//     final empty = emptyFromJson(jsonString);

import 'dart:convert';

import 'package:teacher_antoree/const/defaultValue.dart';

List<TimeSheet> emptyFromJson(String str) => List<TimeSheet>.from(json.decode(str).map((x) => TimeSheet.fromJson(x)));

String emptyToJson(List<TimeSheet> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class TimeSheet {
  TimeSheet({
    this.id,
    this.teacherId,
    this.timeStart,
    this.timeEnd,
    this.status,
    this.createdAt,
    this.modifiedAt,
  });

  String id;
  String teacherId;
  DateTime timeStart;
  DateTime timeEnd;
  int status;
  DateTime createdAt;
  DateTime modifiedAt;

  factory TimeSheet.fromJson(Map<String, dynamic> json) => TimeSheet(
    id: json["id"],
    teacherId: json["teacherId"],
    timeStart: DateTime.parse(VALUES.FORMAT_DATE_API.format(DateTime.parse(json["timeStart"]).toLocal())),
    timeEnd: DateTime.parse(VALUES.FORMAT_DATE_API.format(DateTime.parse(json["timeEnd"]).toLocal())),
    status: json["status"],
    createdAt: DateTime.parse(VALUES.FORMAT_DATE_API.format(DateTime.parse(json["createdAt"]).toLocal())),
    modifiedAt: DateTime.parse(VALUES.FORMAT_DATE_API.format(DateTime.parse(json["modifiedAt"]).toLocal())),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "teacherId": teacherId,
    "timeStart": timeStart.toUtc(),
    "timeEnd": timeEnd.toUtc(),
    "status": status,
    "createdAt": createdAt.toUtc(),
    "modifiedAt": modifiedAt.toUtc(),
  };
}
