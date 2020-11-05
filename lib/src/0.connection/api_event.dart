part of 'api_connection.dart';

abstract class ApiEvent extends Equatable {
  const ApiEvent();

  @override
  List<Object> get props => [];

}

class LoginSubmitted extends ApiEvent {
  const LoginSubmitted(this.username, this.password);

  final dynamic password;
  final dynamic username;

  @override
  List<Object> get props => [username, password];
}

class ScheduleFetched extends ApiEvent {
  const ScheduleFetched(
      this.offset,
      this.from_date,
      this.to_date,
      );
  final dynamic offset;
  final dynamic from_date;
  final dynamic to_date;

  @override
  List<Object> get props => [offset, from_date, to_date];
}

class CancelSchedule extends ApiEvent {
  const CancelSchedule(this.idSchedule, this.reason, this.other_reason);

  final dynamic idSchedule;
  final dynamic reason;
  final dynamic other_reason;

  @override
  List<Object> get props => [idSchedule, reason, other_reason];
}

class Rating extends ApiEvent {
  const Rating(this.idSchedule, this.rating, this.role);

  final dynamic idSchedule;
  final dynamic rating;
  final dynamic role;

  @override
  List<Object> get props => [idSchedule, rating, role];
}

class ChangeSchedule extends ApiEvent {
  const ChangeSchedule(this.idSchedule, this.datetime);

  final dynamic idSchedule;
  final dynamic datetime;

  @override
  List<Object> get props => [idSchedule, datetime];
}

class TeacherList extends ApiEvent {
  const TeacherList( this.offset, this.available_time);

  final dynamic available_time;
  final dynamic offset;

  @override
  List<Object> get props => [offset, available_time];
}

class ChangeTeacher extends ApiEvent {
  const ChangeTeacher(this.idSchedule, this.datetime, this.idTeacher, this.role);

  final dynamic idSchedule;
  final dynamic idTeacher;
  final dynamic datetime;
  final dynamic role;

  @override
  List<Object> get props => [idSchedule, datetime, idTeacher, role];
}

class CallVideo extends ApiEvent {
  const CallVideo(this.idSchedule, this.role);

  final dynamic idSchedule;
  final dynamic role;

  @override
  List<Object> get props => [idSchedule, role];
}

class TimeSheetList extends ApiEvent {
  const TimeSheetList( this.date);

  final dynamic date;

  @override
  List<Object> get props => [date];
}

class SetTimeSheet extends ApiEvent {
  const SetTimeSheet(this.status, this.startTime, this.endTime);

  final dynamic startTime;
  final dynamic endTime;
  final dynamic status;

  @override
  List<Object> get props => [status, startTime, endTime];
}

class CancelTimeSheet extends ApiEvent {
  const CancelTimeSheet(this.idTimeSheet);

  final dynamic idTimeSheet;

  @override
  List<Object> get props => [idTimeSheet];
}

class AddDevice extends ApiEvent {
  const AddDevice(this.os_version, this.platform, this.language_code, this.app_version, this.app_name,  this.fcm_token, this.last_opened_at);

  final dynamic  os_version;
  final dynamic platform;
  final dynamic language_code;
  final dynamic app_version;
  final dynamic app_name;
  final dynamic fcm_token;
  final dynamic last_opened_at;


  @override
  List<Object> get props => [os_version, platform, language_code, app_version, app_name, fcm_token, last_opened_at];
}

class UpdateDevice extends ApiEvent {
  const UpdateDevice(this.device_id, this.os_version, this.platform, this.language_code, this.app_version, this.app_name,  this.fcm_token, this.last_opened_at);

  final dynamic  device_id;
  final dynamic  os_version;
  final dynamic platform;
  final dynamic language_code;
  final dynamic app_version;
  final dynamic app_name;
  final dynamic fcm_token;
  final dynamic last_opened_at;


  @override
  List<Object> get props => [device_id, os_version, platform, language_code, app_version, app_name,  fcm_token, last_opened_at];
}

class DeleteDevice extends ApiEvent {
  const DeleteDevice(this.device_id);

  final dynamic  device_id;


  @override
  List<Object> get props => [device_id];
}
