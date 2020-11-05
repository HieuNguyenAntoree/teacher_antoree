
import 'package:shared_preferences/shared_preferences.dart';
import 'package:teacher_antoree/models/schedule.dart';
import 'package:teacher_antoree/models/teacher.dart';
import 'package:teacher_antoree/models/timesheet.dart';
import 'package:teacher_antoree/models/token.dart';
import 'package:intl/intl.dart' show DateFormat;
import 'dart:convert';

import 'key.dart';

class StorageUtil {
  static StorageUtil _storageUtil;
  static SharedPreferences _preferences;

  static Future<StorageUtil> getInstance() async {
    if (_storageUtil == null) {
      // keep local instance till it is fully initialized.
      var secureStorage = StorageUtil._();
      await secureStorage._init();
      _storageUtil = secureStorage;
    }
    return _storageUtil;
  }
  StorageUtil._();
  Future _init() async {
    _preferences = await SharedPreferences.getInstance();
  }

  static storeStringToSF(String key, String value) async{
    if (_preferences != null){
      _preferences.setString(key, value);
    }
    else {
      await StorageUtil.getInstance();
      _preferences.setString(key, value);
    }
  }

  static storeIntToSF(String key, int value) async {
    if (_preferences != null) _preferences.setInt(key, value);
    else {
      await StorageUtil.getInstance();
      _preferences.setInt(key, value);
    }
  }

  static storeDoubleToSF(String key, double value) async {
    if (_preferences != null) _preferences.setDouble(key, value);
    else {
      await StorageUtil.getInstance();
      _preferences.setDouble(key, value);
    }
  }

  static storeBoolToSF(String key, bool value) async {
    if (_preferences != null) _preferences.setBool(key, value);
    else {
      await StorageUtil.getInstance();
      _preferences.setBool(key, value);
    }
  }

 static String getStringValuesSF(String key){
   if (_preferences != null) {
     String deviceId = _preferences.getString(key);
     if( deviceId != null){
       return deviceId;
     }
     return "";
   }
     return "";
  }

  static bool getBoolValuesSF(String key) {
    if (_preferences != null) return _preferences.getBool(key);
    return false;
  }

  static int getIntValuesSF(String key) {
    if (_preferences != null) return _preferences.getInt(key);
    return -1;
  }

  static double getDoubleValuesSF(String key)  {
    if (_preferences != null) return _preferences.getDouble(key);
    return -1;
  }

  static removeValues(String key) {
    if (_preferences != null) return _preferences.remove(key);
  }

  static removeAllCache() {
    if (_preferences != null) {
      _preferences.remove(KEY.TOKEN);
      _preferences.remove(KEY.SCHEDULE);
      _preferences.remove(KEY.TEACHER);
      _preferences.remove(KEY.TIMESHEET);
      _preferences.remove(KEY.DEVICE_ID);
      _preferences.clear();
    }
  }
 /*----------------------------TOKEN ITEM------------------------------*/
  static storeAuthorizationToSF(Map<String, dynamic> value) async{
//    Map<String, dynamic> decodeOptions = jsonDecode(jsonString);
    String jsonObject = jsonEncode(Authorization.fromJson(value));
    if (_preferences != null) {
      _preferences.setString(KEY.TOKEN, jsonObject);
    }
    else {
      await StorageUtil.getInstance();
      _preferences.setString(KEY.TOKEN, jsonObject);
    }
  }

  static Authorization getTokenObject() {
    if (_preferences != null) {
      String tokenStr = _preferences.getString(KEY.TOKEN);
      if(tokenStr != null){
        Map tokenItemMap = jsonDecode(tokenStr);
        var tokenItem = Authorization.fromJson(tokenItemMap);
        return tokenItem;
      }
      return null;
    }else{
      return null;
    }
  }

  static String getAccessToken(){
    var tokenItem = StorageUtil.getTokenObject();
    if(tokenItem != null){
      return tokenItem.authorization;
    }
    return "";
  }

//  /*----------------------------SCHEDULE------------------------------*/
  static storeScheduleListToSF( Map value) async{
//    Map decodeOptions = jsonDecode(value);
    String jsonObject = jsonEncode(ScheduleModel.fromJson(value));
    if (_preferences != null) {
      _preferences.setString(KEY.SCHEDULE, jsonObject);
    }
    else {
      await StorageUtil.getInstance();
      _preferences.setString(KEY.SCHEDULE, jsonObject);
    }
  }

  static ScheduleModel getScheduleList()  {
    if (_preferences != null) {
      String schedulesStr = _preferences.getString(KEY.SCHEDULE);
      if(schedulesStr != null){
        Map scheduleItemMap = jsonDecode(schedulesStr);
        var schedules = ScheduleModel.fromJson(scheduleItemMap);
        return schedules;
      }
      return null;
    }else{
      return null;
    }
  }

  /*----------------------------TEACHER------------------------------*/
  static storeTeacherListToSF(  Map value) async{
    String jsonObject = jsonEncode(TeacherModel.fromJson(value));
    if (_preferences != null) {
      _preferences.setString(KEY.TEACHER, jsonObject);
    }
    else {
      await StorageUtil.getInstance();
      _preferences.setString(KEY.TEACHER, jsonObject);
    }
  }

  static List<Teacher> getTeacherList()  {
    if (_preferences != null) {
      String courseStr = _preferences.getString(KEY.TEACHER);
      if(courseStr != null){
        var value = jsonDecode(courseStr);
        var model = TeacherModel.fromJson(value);

        List<Teacher> user = List<Teacher>();
        for(Teacher i in model.objects){
          user.add(i);
        }
        return user;
      }
      return null;
    }else{
      return null;
    }
  }

  static addTeacherToList( Map newValue)  {

    if (_preferences != null) {
      String courseStr = _preferences.getString(KEY.TEACHER);
      if(courseStr != null){
        var value = jsonDecode(courseStr);
        var model = TeacherModel.fromJson(value);
        var newList = TeacherModel.fromJson(newValue);
        newList.objects.insertAll(0, model.objects);
        String jsonObject = jsonEncode(newList);
        _preferences.setString(KEY.TEACHER, jsonObject);
      }
      else{
        storeTeacherListToSF(newValue);
      }
    }else{
      storeTeacherListToSF(newValue);
    }
  }

  /*----------------------------TIMESHEET------------------------------*/
  static storeTimeSheetListToSF( List<dynamic> value, String date) async{
//    Map decodeOptions = jsonDecode(value);
    DateTime dateTime = DateTime.parse(date);
    String selectDate = DateFormat("yyyy-MM-dd").format(dateTime);
    String jsonObject = jsonEncode(value);
    if (_preferences != null) {
      _preferences.setString(KEY.TIMESHEET + "_" + selectDate, jsonObject);
    }
    else {
      await StorageUtil.getInstance();
      _preferences.setString(KEY.TIMESHEET + "_" + selectDate, jsonObject);
    }
  }

  static List<TimeSheet> getTimeSheetList(String date)  {
    DateTime dateTime = DateFormat("yyyy-MM-dd").parse(date);
    String selectDate = DateFormat("yyyy-MM-dd").format(dateTime);
    if (_preferences != null) {
      String courseStr = _preferences.getString(KEY.TIMESHEET + "_" + selectDate);
      if(courseStr != null){
        var value = jsonDecode(courseStr);
        List<TimeSheet> ts = List<TimeSheet>();
        for(Map i in value){
          ts.add(TimeSheet.fromJson(i));
        }
        return ts;
      }
      return null;
    }else{
      return null;
    }
  }

  static addTimeSheetToList(String date, TimeSheet timeSheet)  {
    DateTime dateTime = DateFormat("yyyy-MM-dd").parse(date);
    String selectDate = DateFormat("yyyy-MM-dd").format(dateTime);
    if (_preferences != null) {
      String courseStr = _preferences.getString(KEY.TIMESHEET + "_" + selectDate);
      if(courseStr != null){
        var value = jsonDecode(courseStr);
        List<TimeSheet> ts = List<TimeSheet>();
        for(Map i in value){
          ts.add(TimeSheet.fromJson(i));
        }
        ts.add(timeSheet);
        storeTimeSheetListToSF(ts, date);
      }
      else{
        List<TimeSheet> ts = List<TimeSheet>();
        ts.add(timeSheet);
        storeTimeSheetListToSF(ts, date);
      }
    }else{
      return;
    }
  }

  static removeTimeSheetToList(String date, String idTimeSheet)  {
    DateTime dateTime = DateFormat("yyyy-MM-dd").parse(date);
    String selectDate = DateFormat("yyyy-MM-dd").format(dateTime);
    if (_preferences != null) {
      String courseStr = _preferences.getString(KEY.TIMESHEET + "_" + selectDate);
      if(courseStr != null){
        var value = jsonDecode(courseStr);
        List<TimeSheet> ts = List<TimeSheet>();
        for(Map i in value){
          ts.add(TimeSheet.fromJson(i));
        }
        ts.removeWhere((element) => element.id == idTimeSheet);
        storeTimeSheetListToSF(ts, date);
      }
      return;
    }else{
      return;
    }
  }
}