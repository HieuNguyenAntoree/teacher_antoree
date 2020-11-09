part of 'api_connection.dart';

abstract class ApiEvent extends Equatable {
  const ApiEvent();

  @override
  List<Object> get props => [];

}

class LoginSubmitted extends ApiEvent {
  const LoginSubmitted(this.username, this.password);

  final String password;
  final String username;

  @override
  List<Object> get props => [username, password];
}

class ScheduleFetched extends ApiEvent {
  const ScheduleFetched(
      this.offset,
      this.from_date,
      this.to_date,
      );
  final int offset;
  final DateTime from_date;
  final DateTime to_date;

  @override
  List<Object> get props => [offset, from_date, to_date];
}

class CancelSchedule extends ApiEvent {
  const CancelSchedule(this.idSchedule, this.reason, this.other_reason);

  final String idSchedule;
  final String reason;
  final String other_reason;

  @override
  List<Object> get props => [idSchedule, reason, other_reason];
}

class Rating extends ApiEvent {
  const Rating(this.idSchedule, this.rating, this.role);

  final String idSchedule;
  final int rating;
  final String role;

  @override
  List<Object> get props => [idSchedule, rating, role];
}

class ChangeSchedule extends ApiEvent {
  const ChangeSchedule(this.idSchedule, this.datetime);

  final String idSchedule;
  final DateTime datetime;

  @override
  List<Object> get props => [idSchedule, datetime];
}

class TeacherList extends ApiEvent {
  const TeacherList( this.offset, this.available_time);

  final DateTime available_time;
  final int offset;

  @override
  List<Object> get props => [offset, available_time];
}

class ChangeTeacher extends ApiEvent {
  const ChangeTeacher(this.idSchedule, this.datetime, this.idTeacher, this.role);

  final String idSchedule;
  final String idTeacher;
  final DateTime datetime;
  final String role;

  @override
  List<Object> get props => [idSchedule, datetime, idTeacher, role];
}

class CallVideo extends ApiEvent {
  const CallVideo(this.idSchedule, this.role);

  final String idSchedule;
  final String role;

  @override
  List<Object> get props => [idSchedule, role];
}

class TimeSheetList extends ApiEvent {
  const TimeSheetList( this.date);

  final DateTime date;

  @override
  List<Object> get props => [date];
}

class SetTimeSheet extends ApiEvent {
  const SetTimeSheet(this.status, this.startTime, this.endTime);

  final DateTime startTime;
  final DateTime endTime;
  final int status;

  @override
  List<Object> get props => [status, startTime, endTime];
}

class CancelTimeSheet extends ApiEvent {
  const CancelTimeSheet(this.idTimeSheet);

  final String idTimeSheet;

  @override
  List<Object> get props => [idTimeSheet];
}

class AddDevice extends ApiEvent {
  const AddDevice(this.os_version, this.platform, this.language_code, this.app_version, this.app_name,  this.fcm_token, this.last_opened_at);

  final String  os_version;
  final String platform;
  final String language_code;
  final String app_version;
  final String app_name;
  final String fcm_token;
  final DateTime last_opened_at;


  @override
  List<Object> get props => [os_version, platform, language_code, app_version, app_name, fcm_token, last_opened_at];
}

class UpdateDevice extends ApiEvent {
  const UpdateDevice(this.device_id, this.os_version, this.platform, this.language_code, this.app_version, this.app_name,  this.fcm_token, this.last_opened_at);

  final String  device_id;
  final String  os_version;
  final String platform;
  final String language_code;
  final String app_version;
  final String app_name;
  final String fcm_token;
  final DateTime last_opened_at;


  @override
  List<Object> get props => [device_id, os_version, platform, language_code, app_version, app_name,  fcm_token, last_opened_at];
}

class DeleteDevice extends ApiEvent {
  const DeleteDevice(this.device_id);

  final String  device_id;


  @override
  List<Object> get props => [device_id];
}
