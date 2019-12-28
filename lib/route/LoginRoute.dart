import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:tag/base/bloc.dart';
import 'package:tag/bloc/LoginBloc.dart';
import 'package:tag/util/DialogManager.dart';
import 'package:tag/view/widget/view/TextView.dart';
import 'package:tag/view/widget/view/View.dart';

class LoginRoute extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    LoginBloc bloc = LoginBloc();
    return BlocProvider(
      bloc: bloc,
      child: View(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[loginTitle(context, bloc), loginContent(context, bloc)],
          ),
        ),
      ).backgroundColorStr("#363636"),
    );
  }

  Widget loginTitle(BuildContext context, LoginBloc bloc) {
    return StreamBuilder<int>(
      stream: bloc.loginTypeStream,
      initialData: LoginBloc.LOING_PSW,
      builder: (BuildContext context, AsyncSnapshot<int> snapshot) {
        return Row(
          mainAxisAlignment: MainAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            TextView(
              "账号密码",
              textColor: isPswLogin(snapshot.data) ? Colors.black : Colors.white,
            ).size(width: 200, height: 64).corner(leftTop: 5, rightTop: 5).backgroundColor(isPswLogin(snapshot.data) ? Colors.white : Colors.black26).click(() {
              bloc.switchLoginType(LoginBloc.LOING_PSW);
            }),
            TextView(
              "Token",
              textColor: isTokenLogin(snapshot.data) ? Colors.black : Colors.white,
            ).size(width: 200, height: 64).corner(leftTop: 5, rightTop: 5).backgroundColor(isTokenLogin(snapshot.data) ? Colors.white : Colors.black26).click(() {
              bloc.switchLoginType(LoginBloc.LOING_TOKEN);
            }),
          ],
        );
      },
    );
  }

  final Widget pswContent = LoginPswWidget();
  final Widget tokenContent = LoginTokenWidget();

  Widget loginContent(BuildContext context, LoginBloc bloc) {
    PageController controller = PageController();
    bloc.loginTypeStream.listen((type) {
      controller.animateToPage(type == LoginBloc.LOING_PSW ? 0 : 1, duration: Duration(milliseconds: 100), curve: Curves.bounceIn);
    });

    return View(
        child: PageView(
      children: <Widget>[pswContent, tokenContent],
      controller: controller,
      physics: NeverScrollableScrollPhysics(),
    )).size(width: 500, height: 500).backgroundColor(Colors.white).corner(leftBottom: 5, rightBottom: 5);
  }

  Widget getTokenContent(BuildContext context, LoginBloc bloc) {
    return Container();
  }

  bool isPswLogin(int type) => type == LoginBloc.LOING_PSW;

  bool isTokenLogin(int type) => type == LoginBloc.LOING_TOKEN;
}

/// Token登录
class LoginTokenWidget extends StatefulWidget {
  @override
  _LoginTokenWidgetState createState() => _LoginTokenWidgetState();
}

class _LoginTokenWidgetState extends State<LoginTokenWidget> with AutomaticKeepAliveClientMixin {
  @override
  Widget build(BuildContext context) {
    LoginBloc bloc = BlocProvider.of(context);
    return View(
      child: Column(
        mainAxisSize: MainAxisSize.max,
        children: <Widget>[
          Expanded(
            flex: 1,
            child: View(
              child: Row(mainAxisSize: MainAxisSize.min, children: <Widget>[
                TextView(
                  "Token",
                  textColor: Colors.black,
                  textSize: 20,
                ).margin(right: 12),
                Expanded(
                  flex: 1,
                  child: View(
                    child: TextField(
                      decoration: InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: 'Token',
                      ),
                      style: TextStyle(color: Colors.black),
                      cursorColor: Colors.blue,
                      onChanged: (data) => bloc.updateUserToken(data),
                    ),
                  ).padding(left: 16).size(height: 80).corner(both: 5),
                )
              ]),
            ).size(height: 100),
          ),
          StreamBuilder(
            initialData: false,
            stream: bloc.loginTokenInfoAvail,
            builder: (BuildContext context, AsyncSnapshot<bool> snapshot) {
              return TextView(
                "登录",
                textColor: Colors.white,
              )
                  .size(height: 80)
                  .margin(top: 32, bottom: 32)
                  .corner(both: 5)
                  .backgroundColor(
                    snapshot.data ? Colors.blue : Colors.grey,
                  )
                  .click(snapshot.data ? () {} : null);
            },
          ),
          StreamBuilder(
            initialData: bloc.autoLogin,
            stream: bloc.autoLoginStream,
            builder: (BuildContext context, AsyncSnapshot<bool> snapshot) {
              return Row(
                children: <Widget>[
                  Checkbox(
                    onChanged: (bool newValue) {
                      bloc.updateAutoLogin(newValue);
                    },
                    value: snapshot.data,
                  ),
                  TextView(
                    "自动登录",
                    textColor: Colors.black,
                  )
                ],
              );
            },
          ),
        ],
      ),
    ).padding(top: 32, left: 32, right: 32);
  }

  @override
  bool get wantKeepAlive => true;
}

/// 密码登录
class LoginPswWidget extends StatefulWidget {
  @override
  _LoginPswWidgetState createState() => _LoginPswWidgetState();
}

class _LoginPswWidgetState extends State<LoginPswWidget> with AutomaticKeepAliveClientMixin {
  @override
  Widget build(BuildContext context) {
    LoginBloc bloc = BlocProvider.of(context);
    return View(
      child: Column(
        mainAxisSize: MainAxisSize.max,
        children: <Widget>[
          View(
            child: Row(mainAxisSize: MainAxisSize.min, children: <Widget>[
              TextView(
                "账号",
                textColor: Colors.black,
                textSize: 20,
              ).margin(right: 12),
              Expanded(
                flex: 1,
                child: View(
                  child: TextField(
                    decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: 'Account',
                    ),
                    style: TextStyle(color: Colors.black),
                    cursorColor: Colors.blue,
                    onChanged: (data) => bloc.updateUserName(data),
                  ),
                ).padding(left: 16).size(height: 80).corner(both: 5),
              )
            ]),
          ).size(height: 100),
          View(
            child: Row(mainAxisSize: MainAxisSize.min, children: <Widget>[
              TextView(
                "密码",
                textColor: Colors.black,
                textSize: 20,
              ).margin(right: 12),
              Expanded(
                flex: 1,
                child: View(
                  child: TextField(
                    style: TextStyle(color: Colors.black),
                    cursorColor: Colors.blue,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: 'PassWord',
                    ),
                    onChanged: (data) => bloc.updateUserPsw(data),
                  ),
                ).padding(left: 16).size(height: 80).corner(both: 5),
              )
            ]),
          ).size(height: 100),
          StreamBuilder(
            initialData: false,
            stream: bloc.loginInfoAvail,
            builder: (BuildContext context, AsyncSnapshot<bool> snapshot) {
              return TextView(
                "登录",
                textColor: Colors.white,
              )
                  .size(height: 80)
                  .margin(top: 32)
                  .corner(both: 5)
                  .backgroundColor(
                    snapshot.data ? Colors.blue : Colors.grey,
                  )
                  .click(snapshot.data
                      ? () {
                          DialogManager.getInstance().showLoadingDialog(context);
                        }
                      : null);
            },
          ),
          Spacer(),
          StreamBuilder(
            initialData: bloc.autoLogin,
            stream: bloc.autoLoginStream,
            builder: (BuildContext context, AsyncSnapshot<bool> snapshot) {
              return Row(
                children: <Widget>[
                  Checkbox(
                    onChanged: (bool newValue) {
                      bloc.updateAutoLogin(newValue);
                    },
                    value: snapshot.data,
                  ),
                  TextView(
                    "自动登录",
                    textColor: Colors.black,
                  )
                ],
              );
            },
          ),
        ],
      ),
    ).padding(top: 32, left: 32, right: 32);
  }

  @override
  bool get wantKeepAlive => true;
}
