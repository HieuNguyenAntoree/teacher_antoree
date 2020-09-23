import 'dart:async';
import 'package:connect_api/const/constant.dart';
import 'package:connect_api/connection/connection.dart';
import 'package:connect_api/connection/model/result.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:teacher_antoree/const/sharedPreferences.dart';
import 'package:teacher_antoree/models/schedule.dart';
import 'package:teacher_antoree/models/teacher.dart';
import 'package:teacher_antoree/models/token.dart';
part 'api_event.dart';
part 'api_state.dart';

class APIConnect extends Bloc<ApiEvent, ApiState>{
  //Creating Singleton
  final ConnectionAPI _connectionAPI = ConnectionAPI();

  APIConnect() : super(const ApiState());

  Future<Result> login(String username, String password) async {
    Result result = await _connectionAPI.login(username, password);
    if (result is ParseJsonToObject){
      TokenItem user = TokenItem.fromJson(result.value);
      StorageUtil.storeTokenObjectToSF(user.toJson());
      return result;
    }else{
      return result;
    }
  }

  void getSchedules(int offset, String from_date, String to_date) async {
    StorageUtil.getInstance();
//    _listenStream.sink.add(Result.loading(MESSAGE.Loading));
    final accessToken = StorageUtil.getAccessToken();
    Result result = await _connectionAPI.getScheduleList(accessToken, VALUES.PAGE_SIZE, offset, from_date, to_date);
    if (result is ParseJsonToObject){
      ScheduleModel user = ScheduleModel.fromJson(result.value[0]);
      StorageUtil.storeScheduleListToSF(user.toJson());
//      _listenStream.sink.add(Result.success(MESSAGE.Sucess));
    }else{
      ErrorState error = result;
//      _listenStream.sink.add(Result.error(error.msg));
    }
  }

  @override
  Stream<ApiState> mapEventToState(ApiEvent event) async* {
    // TODO: implement mapEventToState
    if(event is LoginSubmitted){
      Result result = await _connectionAPI.login(event.username, event.password);
      if (result is ParseJsonToObject){
        TokenItem user = TokenItem.fromJson(result.value);
        StorageUtil.storeTokenObjectToSF(user.toJson());
        yield ApiState(result: result );
      }else{
        yield ApiState(result: result);
      }
    }else if(event is ScheduleFetched){
      final accessToken = StorageUtil.getAccessToken();
      Result result = await _connectionAPI.getScheduleList(accessToken, VALUES.PAGE_SIZE, event.offset, event.from_date, event.to_date);
      if (result is ParseJsonToObject){
        ScheduleModel user = ScheduleModel.fromJson(result.value[0]);
        StorageUtil.storeScheduleListToSF(user.toJson());
        yield ApiState(result: result );
      }else{
        yield ApiState(result: result );
      }
    }
    else if(event is CancelSchedule){
      final accessToken = StorageUtil.getAccessToken();
      Result result = await _connectionAPI.cancelSchedule(accessToken, event.idSchedule, event.reason, event.other_reason);
      if (result is ParseJsonToObject){
        yield ApiState(result: result );
      }else{
        yield ApiState(result: result );
      }
    }else if(event is Rating){
      final accessToken = StorageUtil.getAccessToken();
      Result result = await _connectionAPI.postRating(accessToken, event.idSchedule, event.rating, event.feedback);
      if (result is ParseJsonToObject){
        yield ApiState(result: result );
      }else{
        yield ApiState(result: result );
      }
    }
    else if(event is ChangeSchedule){
      final accessToken = StorageUtil.getAccessToken();
      Result result = await _connectionAPI.changeSchedule(accessToken, event.idSchedule, event.datetime);
      if (result is ParseJsonToObject){
        yield ApiState(result: result );
      }else{
        yield ApiState(result: result );
      }
    }
    else if(event is TeacherList){
      final accessToken = StorageUtil.getAccessToken();
      Result result = await _connectionAPI.getTeacherList(accessToken, VALUES.PAGE_SIZE, event.offset, event.available_time);
      if (result is ParseJsonToObject){
        TeacherModel user = TeacherModel.fromJson(result.value);
        StorageUtil.storeTeacherListToSF(user.toJson());
        yield ApiState(result: result );
      }else{
        yield ApiState(result: result );
      }
    }
    else if(event is ChangeTeacher){
      final accessToken = StorageUtil.getAccessToken();
      Result result = await _connectionAPI.changeTeacher(accessToken, event.idSchedule, event.datetime, event.idTeacher);
      if (result is ParseJsonToObject){
        yield ApiState(result: result );
      }else{
        yield ApiState(result: result );
      }
    }
    else{

    }

  }
}