
class LoginInfo {

  String userName;
  String userPsw;
  String token;

	LoginInfo.fromJsonMap(Map<String, dynamic> map):
		userName = map["userName"],
		userPsw = map["userPsw"],
		token = map["token"];

	Map<String, dynamic> toJson() {
		final Map<String, dynamic> data = new Map<String, dynamic>();
		data['userName'] = userName;
		data['userPsw'] = userPsw;
		data['token'] = token;
		return data;
	}
}
