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
    final accessToken = StorageUtil.getAccessToken();
    Result result = await _connectionAPI.getScheduleList(accessToken, VALUES.PAGE_SIZE, offset, from_date, to_date);
    if (result is ParseJsonToObject){
      ScheduleModel user = ScheduleModel.fromJson(result.value[0]);
      StorageUtil.storeScheduleListToSF(user.toJson());
    }else{
      ErrorState error = result;
    }
  }

  @override
  Stream<ApiState> mapEventToState(ApiEvent event) async* {
    yield ApiState(result: LoadingState(MESSAGE.Loading) );
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
        ScheduleModel user = ScheduleModel.fromJson(result.value);
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
      Result result = await _connectionAPI.putRating(accessToken, event.idSchedule, event.rating, event.role);
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
        List<TeacherModel> user = List<TeacherModel>();
        for(Map i in result.value){
          user.add(TeacherModel.fromJson(i));
        }
        StorageUtil.storeTeacherListToSF(result.value);
        yield ApiState(result: result );
      }else{
        yield ApiState(result: result );
      }
    }
    else if(event is ChangeTeacher){
      final accessToken = StorageUtil.getAccessToken();
      Result result = await _connectionAPI.changeTeacher(accessToken, event.idSchedule, event.datetime, event.idTeacher, event.role);
      if (result is ParseJsonToObject){
        yield ApiState(result: result );
      }else{
        yield ApiState(result: result );
      }
    }
    else if(event is CallVideo){
      final accessToken = StorageUtil.getAccessToken();
      Result result = await _connectionAPI.video(accessToken, event.idSchedule, event.role);
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