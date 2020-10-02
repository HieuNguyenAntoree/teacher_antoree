// To parse this JSON data, do
//
//     final empty = emptyFromJson(jsonString);

import 'dart:convert';

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
    timeStart: DateTime.parse(json["timeStart"]),
    timeEnd: DateTime.parse(json["timeEnd"]),
    status: json["status"],
    createdAt: DateTime.parse(json["createdAt"]),
    modifiedAt: DateTime.parse(json["modifiedAt"]),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "teacherId": teacherId,
    "timeStart": timeStart.toIso8601String(),
    "timeEnd": timeEnd.toIso8601String(),
    "status": status,
    "createdAt": createdAt.toIso8601String(),
    "modifiedAt": modifiedAt.toIso8601String(),
  };
}
