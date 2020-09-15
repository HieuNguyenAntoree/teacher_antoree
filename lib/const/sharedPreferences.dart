
import 'package:shared_preferences/shared_preferences.dart';
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
    if (_preferences != null) _preferences.setString(key, value);
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
   if (_preferences != null) return _preferences.getString(key);
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


//  /*----------------------------NETWORK------------------------------*/
//  static String getAccessToken(){
//    var tokenItem = StorageUtil.getTokenObject();
//    if(tokenItem != null){
//      return "Bearer " + tokenItem.accessToken;
//    }
//    return "";
//  }
  /*----------------------------TOKEN ITEM------------------------------*/
//  static storeTokenObjectToSF(String key, Map<String, dynamic> value) async{
////    Map<String, dynamic> decodeOptions = jsonDecode(jsonString);
//    String jsonObject = jsonEncode(TokenItem.fromJson(value));
//    if (_preferences != null) {
//      _preferences.setString(key, jsonObject);
//    }
//    else {
//      await StorageUtil.getInstance();
//     _preferences.setString(key, jsonObject);
//    }
//  }
//
//  static TokenItem getTokenObject() {
//    if (_preferences != null) {
//      String tokenStr = _preferences.getString(KEY.TOKEN);
//      if(tokenStr != null){
//        Map tokenItemMap = jsonDecode(tokenStr);
//        var tokenItem = TokenItem.fromJson(tokenItemMap);
//        return tokenItem;
//      }
//      return null;
//    }else{
//      return null;
//    }
//  }
//
//  static String getAccessToken(){
//    var tokenItem = StorageUtil.getTokenObject();
//    if(tokenItem != null){
//      return "Bearer " + tokenItem.accessToken;
//    }
//    return "";
//  }
//
//  /*----------------------------USER------------------------------*/
//  static storeUserObjectToSF(String key, Map value) async{
////    Map decodeOptions = jsonDecode(value);
//    String jsonObject = jsonEncode(LoginUser.fromJson(value));
//    if (_preferences != null) {
//      _preferences.setString(key, jsonObject);
//    }
//    else {
//      await StorageUtil.getInstance();
//      _preferences.setString(key, jsonObject);
//    }
//  }
//
//  static LoginUser getUserObject()  {
//    if (_preferences != null) {
//      String loginUserStr = _preferences.getString(KEY.USER);
//      if(loginUserStr != null) {
//        Map userItemMap = jsonDecode(loginUserStr);
//        var user = LoginUser.fromJson(userItemMap);
//        return user;
//      }
//      return null;
//    }else{
//      return null;
//    }
//  }
//
//  /*----------------------------PROFILE------------------------------*/
//  static storeProfileObjectToSF(String key, Map value) async{
////    Map decodeOptions = jsonDecode(value);
//    String jsonObject = jsonEncode(Welcome.fromJson(value));
//    if (_preferences != null) {
//      _preferences.setString(key, jsonObject);
//    }
//    else {
//      await StorageUtil.getInstance();
//      _preferences.setString(key, jsonObject);
//    }
//  }
//
//  static Welcome getProfileObject()  {
//    if (_preferences != null) {
//      String welcomeStr = _preferences.getString(KEY.PROFILE);
//      if(welcomeStr != null) {
//        Map userItemMap = jsonDecode(welcomeStr);
//        var user = Welcome.fromJson(userItemMap);
//        return user;
//      }
//      return null;
//    }else{
//      return null;
//    }
//  }
//
//  /*----------------------------COURSES------------------------------*/
//  static storeCoursesListToSF(String key, Map value) async{
////    Map decodeOptions = jsonDecode(value);
//    String jsonObject = jsonEncode(CourseObject.fromJson(value));
//    if (_preferences != null) {
//      _preferences.setString(key, jsonObject);
//    }
//    else {
//      await StorageUtil.getInstance();
//      _preferences.setString(key, jsonObject);
//    }
//  }
//
//  static CourseObject getCoursesList()  {
//    if (_preferences != null) {
//      String courseStr = _preferences.getString(KEY.COURSES);
//      if(courseStr != null){
//        Map userItemMap = jsonDecode(courseStr);
//        var user = CourseObject.fromJson(userItemMap);
//        return user;
//      }
//      return null;
//    }else{
//      return null;
//    }
//  }
}