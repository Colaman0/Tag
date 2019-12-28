import 'package:tag/base/bloc.dart';
import 'package:rxdart/rxdart.dart';

class LoginBloc extends BlocBase {
  static final int LOING_PSW = 1;
  static final int LOING_TOKEN = 2;

  PublishSubject<int> loginTypeStream = PublishSubject<int>().share();
  PublishSubject<bool> autoLoginStream = PublishSubject<bool>().share();
  PublishSubject<bool> loginInfoAvail = PublishSubject<bool>().share();
  PublishSubject<bool> loginTokenInfoAvail = PublishSubject<bool>().share();

  String _userName = "";
  String _userPsw = "";
  String _userToken = "";
  bool _preLoginInfoAvail = false;
  bool autoLogin = false;

  LoginBloc() {

  }

  void checkLoginInfo() {
    var pass = _userName.isNotEmpty && _userPsw.isNotEmpty;
    if (pass != _preLoginInfoAvail) {
      _preLoginInfoAvail = pass;
      loginInfoAvail.add(_preLoginInfoAvail);
    }
  }

  /// 切换登录类型
  void switchLoginType(int loginType) {
    loginTypeStream.add(loginType);
  }

  void updateUserName(String str) {
    _userName = str;
    checkLoginInfo();
  }

  void updateUserPsw(String str) {
    _userPsw = str;
    checkLoginInfo();
  }

  void updateUserToken(String str) {
    _userToken = str;
    loginTokenInfoAvail.add(_userToken.isNotEmpty);
  }

  void updateAutoLogin(bool autoLogin) {
    this.autoLogin = ! this.autoLogin;
    autoLoginStream.add(autoLogin);
  }

  bool actionAutoLogin() => autoLogin;

  @override
  bool autoRelease() {
    return false;
  }
  @override
  void dispose() {
    loginTypeStream.close();
    _userName = "";
    _userPsw = "";
    _userToken = "";
  }
}
