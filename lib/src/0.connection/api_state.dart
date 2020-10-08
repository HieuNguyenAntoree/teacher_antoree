part of 'api_connection.dart';


class ApiState extends Equatable{
  final Result result;

  const ApiState({this.result});

  ApiState copyWith({Result result}) {
    return ApiState(result: result);
  }

  @override
  List<dynamic> get props => [result];
}