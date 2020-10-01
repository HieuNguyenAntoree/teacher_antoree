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
  final String from_date;
  final String to_date;

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
  final String datetime;

  @override
  List<Object> get props => [idSchedule, datetime];
}

class TeacherList extends ApiEvent {
  const TeacherList( this.offset, this.available_time);

  final String available_time;
  final int offset;

  @override
  List<Object> get props => [offset, available_time];
}

class ChangeTeacher extends ApiEvent {
  const ChangeTeacher(this.idSchedule, this.datetime, this.idTeacher, this.role);

  final String idSchedule;
  final String idTeacher;
  final String datetime;
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
