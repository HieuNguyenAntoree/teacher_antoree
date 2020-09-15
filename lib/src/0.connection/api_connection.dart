import 'dart:async';
import 'package:teacher_antoree/const/key.dart';
import 'package:teacher_antoree/const/sharedPreferences.dart';
import 'package:teacher_antoree/src/1.login/login_model.dart';
import 'package:connect_api/const/constant.dart';
import 'package:connect_api/connection/connection.dart';
import 'package:connect_api/connection/model/result.dart';

class APIConnect{
  //Creating Singleton
  APIConnect._privateConstructor();
  static final APIConnect _profileBloc = APIConnect._privateConstructor();
  factory APIConnect() => _profileBloc;

  final ConnectionAPI _connectionAPI = ConnectionAPI();

  StreamController<Result> _listenStream;
  Stream<Result> hasConnectionResponse() => _listenStream.stream;

  void init() => _listenStream = StreamController();

  void login(String username, String password) async {
    StorageUtil.getInstance();
    _listenStream.sink.add(Result.loading(MESSAGE.Loading));
    final accessToken = '';//StorageUtil.getAccessToken();
    Result result = await _connectionAPI.login(username, password);
    if (result is ParseJsonToObject){
      TokenModel user = TokenModel.fromJson(result.value);
//      StorageUtil.storeTokenObjectToSF(KEY.PROFILE, user.toJson());
      _listenStream.sink.add(Result.success(MESSAGE.Sucess));
    }else{
      ErrorState error = result;
      _listenStream.sink.add(Result.error(error.msg));
    }
  }

  void logout() async {
    StorageUtil.getInstance();
    _listenStream.sink.add(Result.loading(MESSAGE.Loading));
    final accessToken = '';//StorageUtil.getAccessToken();
    Result result = await _connectionAPI.logout(accessToken);
    if (result is ParseJsonToObject){
//      TokenModel user = TokenModel.fromJson(result.value);
//      StorageUtil.storeTokenObjectToSF(KEY.PROFILE, user.toJson());
      _listenStream.sink.add(Result.success(MESSAGE.Sucess));
    }else{
      ErrorState error = result;
      _listenStream.sink.add(Result.error(error.msg));
    }
  }
}