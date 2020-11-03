
//TokenItem tokenFromJson(String str) => TokenItem.fromJson(json.decode(str));
//String welcomeToJson(TokenItem data) => json.encode(data.toJson());
class TokenItem {
  TokenItem({this.tokenType, this.expiresIn, this.accessToken,
  this.refreshToken,});

  String tokenType;
  int expiresIn;
  String accessToken;
  String refreshToken;

  factory TokenItem.fromJson(Map<String, dynamic> json) => TokenItem(
        tokenType: json["token_type"],
        expiresIn: json["expires_in"],
        accessToken: json["access_token"],
        refreshToken: json["refresh_token"],
  );

  Map<String, dynamic> toJson() => {
        "token_type": tokenType,
        "expires_in": expiresIn,
        "access_token": accessToken,
        "refresh_token": refreshToken,
  };
}

class Authorization {
  Authorization({this.authorization});

  String authorization;

  factory Authorization.fromJson(Map<String, dynamic> json) => Authorization(
    authorization: json["authorization"],
  );

  Map<String, dynamic> toJson() => {
    "authorization": authorization,
  };
}
