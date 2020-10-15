import 'dart:async';
import 'package:connect_api/const/constant.dart';
import 'package:connect_api/connection/connection.dart';
import 'package:connect_api/connection/model/result.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';
import 'package:teacher_antoree/const/sharedPreferences.dart';
import 'package:teacher_antoree/models/schedule.dart';
import 'package:teacher_antoree/models/teacher.dart';
import 'package:teacher_antoree/models/timesheet.dart';
import 'package:teacher_antoree/models/token.dart';
import 'package:teacher_antoree/app_config.dart';
part 'api_event.dart';
part 'api_state.dart';


class APIConnect extends Bloc<ApiEvent, ApiState>{
  //Creating Singleton
  final ConnectionAPI _connectionAPI = ConnectionAPI();
  final BuildContext context;

  APIConnect(this.context) : super(const ApiState());

  @override
  Stream<ApiState> mapEventToState(ApiEvent event) async* {
    yield ApiState(result: LoadingState(MESSAGE.Loading) );
    // TODO: implement mapEventToState
    if(event is LoginSubmitted){
      Result result = await _connectionAPI.login(AppConfig.of(context).gateBaseUrl, event.username, event.password);
      if (result is ParseJsonToObject){
        TokenItem user = TokenItem.fromJson(result.value);
        StorageUtil.storeTokenObjectToSF(user.toJson());
        yield ApiState(result: result );
      }else{
        yield ApiState(result: result);
      }
    }else if(event is ScheduleFetched){
      final accessToken = StorageUtil.getAccessToken();
      Result result = await _connectionAPI.getScheduleList(AppConfig.of(context).apiBaseUrl, accessToken, VALUES.PAGE_SIZE, event.offset, event.from_date, event.to_date);
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
      Result result = await _connectionAPI.cancelSchedule(AppConfig.of(context).apiBaseUrl, accessToken, event.idSchedule, event.reason, event.other_reason);
      if (result is ParseJsonToObject){
        yield ApiState(result: result );
      }else{
        yield ApiState(result: result );
      }
    }else if(event is Rating){
      final accessToken = StorageUtil.getAccessToken();
      Result result = await _connectionAPI.putRating(AppConfig.of(context).apiBaseUrl, accessToken, event.idSchedule, event.rating, event.role);
      if (result is ParseJsonToObject){
        yield ApiState(result: result );
      }else{
        yield ApiState(result: result );
      }
    }
    else if(event is ChangeSchedule){
      final accessToken = StorageUtil.getAccessToken();
      Result result = await _connectionAPI.changeSchedule(AppConfig.of(context).apiBaseUrl, accessToken, event.idSchedule, event.datetime);
      if (result is ParseJsonToObject){
        yield ApiState(result: result );
      }else{
        yield ApiState(result: result );
      }
    }
    else if(event is TeacherList){
      final accessToken = StorageUtil.getAccessToken();
      Result result = await _connectionAPI.getTeacherList(AppConfig.of(context).apiBaseUrl, accessToken, VALUES.PAGE_SIZE, event.offset, event.available_time);
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
      Result result = await _connectionAPI.changeTeacher(AppConfig.of(context).apiBaseUrl, accessToken, event.idSchedule, event.datetime, event.idTeacher, event.role);
      if (result is ParseJsonToObject){
        yield ApiState(result: result );
      }else{
        yield ApiState(result: result );
      }
    }
    else if(event is CallVideo){
      final accessToken = StorageUtil.getAccessToken();
      Result result = await _connectionAPI.video(AppConfig.of(context).apiBaseUrl, accessToken, event.idSchedule, event.role);
      if (result is SuccessState){
        yield ApiState(result: result );
      }else{
        yield ApiState(result: result );
      }
    }
    else if(event is TimeSheetList){
      final accessToken = StorageUtil.getAccessToken();
      Result result = await _connectionAPI.getTeacherTimeSheet(AppConfig.of(context).apiBaseUrl, accessToken, event.date);
      if (result is ParseJsonToObject){
        List<TimeSheet> ts = List<TimeSheet>();
        for(Map i in result.value){
          ts.add(TimeSheet.fromJson(i));
        }

        StorageUtil.storeTimeSheetListToSF(result.value, event.date);
        yield ApiState(result: result );
      }else{
        yield ApiState(result: result );
      }
    }
    else if(event is CancelTimeSheet){
      final accessToken = StorageUtil.getAccessToken();
      Result result = await _connectionAPI.cancelTeacherTimeSheet(AppConfig.of(context).apiBaseUrl, accessToken, event.idTimeSheet);
      if (result is SuccessState){
        SuccessState success = SuccessState('Cancel');
        yield ApiState(result: success );
      }else{
        ErrorState error = ErrorState("Cancel");
        yield ApiState(result: error );
      }
    }
    else if(event is SetTimeSheet){
      final accessToken = StorageUtil.getAccessToken();
      Result result = await _connectionAPI.postTeacherTimeSheet(AppConfig.of(context).apiBaseUrl, accessToken, event.status, event.startTime, event.endTime);
      if (result is ParseJsonToObject){
        TimeSheet timeSheet = TimeSheet.fromJson(result.value);
        StorageUtil.addTimeSheetToList(event.startTime, timeSheet);
        yield ApiState(result: result );
      }else{
        ErrorState error = ErrorState("Set");
        yield ApiState(result: error );
      }
    }
    else{

    }

  }
}