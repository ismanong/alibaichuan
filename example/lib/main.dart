import 'package:flutter/material.dart';
import 'package:alibaichuan/alibaichuan.dart';
import 'taobao_auth_webview.dart';

void main() => runApp(MaterialApp(
      home: MyApp(),
    ));

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  String _initTradeServiceResult;
  bool isLoginResult;
  String _avatarUrl;
  String _nick;
  String message;

  getAuth() async {
    Map res = await Alibaichuan.login;
    setState(() {
      message = '$res';
      isLoginResult = res['isSuccess'];
    });
    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => TaoBaoAuthWebView(),
      ),
    );
  }

  logout() async {
    Map res = await Alibaichuan.logout();
    setState(() {
      message = '$res';
      isLoginResult = !res['isSuccess'];
    });
  }

  void initTradeService() async {
    Map res = await Alibaichuan.initAliBaiChuan;
    bool bo = await Alibaichuan.isLogin();
    setState(() {
      _initTradeServiceResult = "$res";
      isLoginResult = bo;
    });
//    var user = await nautilus.getUser();
//    print('--------------------------------------------------');
//    print('topAccessToken : ${user?.topAccessToken}');
//    print('--------------------------------------------------');
//    setState(() {
//      _nick = user.nick;
//      _avatarUrl = user.avatarUrl;
//    });
  }

  @override
  initState() {
    super.initState();
    initTradeService();
  }

  Widget _body() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: new Text('初始化结果：$_initTradeServiceResult'),
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: new Text('是否登陆：$isLoginResult'),
        ),
        RaisedButton(
          onPressed: () => getAuth(),
          child: Text("淘宝 免登陆 授权"),
        ),
        RaisedButton(
          onPressed: () => logout(),
          child: Text("退出授权"),
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text("message：$message"),
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text("昵称：$_nick"),
        ),
        _avatarUrl == null
            ? Container()
            : CircleAvatar(
          backgroundColor: Colors.grey,
          backgroundImage: NetworkImage(_avatarUrl),
          radius: 40.0,
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Plugin example app'),
      ),
      body: _body(),
    );
  }
}
