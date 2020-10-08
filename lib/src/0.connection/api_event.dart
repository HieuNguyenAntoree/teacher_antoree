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

