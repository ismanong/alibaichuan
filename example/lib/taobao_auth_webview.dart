import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

class TaoBaoAuthWebView extends StatefulWidget {
  TaoBaoAuthWebView({Key key}) : super(key: key);
  @override
  State<StatefulWidget> createState() => new _TaoBaoAuthWebViewState();
}

class _TaoBaoAuthWebViewState extends State<TaoBaoAuthWebView> {
  final Completer<WebViewController> _controller =
      Completer<WebViewController>();

  _getCode(context, String url) {
    Uri u = Uri.parse(url); // dart core的Uri库, queryParameters成员返回一张地图
    Map<String, String> qp = u.queryParameters;
    print(qp);
    String code = qp['code'];
    Navigator.pop(context, code);
  }

  void _selectLogin(BuildContext context) async {
    showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('授权检测'),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text('自动登录失败，请您点击返回，并重试几次'),
              ],
            ),
          ),
          actions: <Widget>[
            FlatButton(
              textColor: Colors.blueAccent,
              child: Text('手动登录'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            FlatButton(
              textColor: Colors.blueAccent,
              child: Text('返回'),
              onPressed: () {
                Navigator.of(context).pop();
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  SampleMenu sampleMenu;
  @override
  void initState() {
    super.initState();
    _controller.future.then((WebViewController ctl) {
      sampleMenu = SampleMenu(ctl);
    });
  }

  @override
  Widget build(BuildContext context) {
    String url =
        'https://oauth.taobao.com/authorize?response_type=code&client_id=25639014&redirect_uri=http://app.lilivip.com/shop-api/download.jsp&state=1212&view=wap';
//  String url = 'https://oauth.m.taobao.com/authorize?response_type=token&client_id=25639014';
    return Scaffold(
      appBar: AppBar(
        brightness: Brightness.light,
        title: const Text('应用授权'),
        actions: <Widget>[
          NavigationControls(_controller.future),
        ],
      ),
      body: Builder(builder: (BuildContext context) {
        return WebView(
          initialUrl: url,
          javascriptMode: JavascriptMode.unrestricted,
          onWebViewCreated: (WebViewController webViewController) {
            _controller.complete(webViewController);
          },
          javascriptChannels: <JavascriptChannel>[
            _toasterJavascriptChannel(context),
          ].toSet(),
          navigationDelegate: (NavigationRequest request) {
            if (request.url
                .startsWith('http://app.lilivip.com/shop-api/download.jsp')) {
              print('阻止导航 $request}');
              _getCode(context, request.url);
              return NavigationDecision.prevent;
            }
            if (request.url.contains('login.m.taobao.com')) {
              _selectLogin(context);
            }
            print('允许导航 $request');
            return NavigationDecision.navigate;
          },
          onPageFinished: (String url) {
            print('页面完成加载: $url');
            //sampleMenu.onListCookies(context);
            //sampleMenu.checkLogin(context);
          },
        );
      }),
    );
  }

  JavascriptChannel _toasterJavascriptChannel(BuildContext context) {
    return JavascriptChannel(
        name: 'Toaster',
        onMessageReceived: (JavascriptMessage message) {
          Scaffold.of(context).showSnackBar(
            SnackBar(content: Text(message.message)),
          );
        });
  }
}

class SampleMenu {
  final CookieManager cookieManager = CookieManager();
  WebViewController controller;
  SampleMenu(ctl) {
    this.controller = ctl;
  }

  void _onShowUserAgent(BuildContext context) async {
    // Send a message with the user agent string to the Toaster JavaScript channel we registered
    // with the WebView.
    controller.evaluateJavascript(
        'Toaster.postMessage("User Agent: " + navigator.userAgent);');
  }

  void checkLogin(BuildContext context) async {
    final String innerHTML =
        await controller.evaluateJavascript('document.body.innerHTML');
    print(innerHTML);
    if (innerHTML
        .contains('src="https://login.m.taobao.com/login/login.htm')) {}
  }

  void onListCookies(BuildContext context) async {
    final String cookies =
        await controller.evaluateJavascript('document.cookie');
    Scaffold.of(context).showSnackBar(SnackBar(
      content: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          const Text('Cookies:'),
          _getCookieList(cookies),
        ],
      ),
    ));
  }

  void _onAddToCache(BuildContext context) async {
    await controller.evaluateJavascript(
        'caches.open("test_caches_entry"); localStorage["test_localStorage"] = "dummy_entry";');
    Scaffold.of(context).showSnackBar(const SnackBar(
      content: Text('Added a test entry to cache.'),
    ));
  }

  void _onListCache(BuildContext context) async {
    await controller.evaluateJavascript('caches.keys()'
        '.then((cacheKeys) => JSON.stringify({"cacheKeys" : cacheKeys, "localStorage" : localStorage}))'
        '.then((caches) => Toaster.postMessage(caches))');
  }

  void _onClearCache(BuildContext context) async {
    await controller.clearCache();
    Scaffold.of(context).showSnackBar(const SnackBar(
      content: Text("Cache cleared."),
    ));
  }

  void _onClearCookies(BuildContext context) async {
    final bool hadCookies = await cookieManager.clearCookies();
    String message = 'There were cookies. Now, they are gone!';
    if (!hadCookies) {
      message = 'There are no cookies.';
    }
    Scaffold.of(context).showSnackBar(SnackBar(
      content: Text(message),
    ));
  }

  void _onNavigationDelegateExample(BuildContext context) async {
    const String kNavigationExamplePage = '''
<!DOCTYPE html><html>
<head><title>Navigation Delegate Example</title></head>
<body>
<p>
The navigation delegate is set to block navigation to the youtube website.
</p>
<ul>
<ul><a href="https://www.youtube.com/">https://www.youtube.com/</a></ul>
<ul><a href="https://www.google.com/">https://www.google.com/</a></ul>
</ul>
</body>
</html>
''';
    final String contentBase64 =
        base64Encode(const Utf8Encoder().convert(kNavigationExamplePage));
    controller.loadUrl('data:text/html;base64,$contentBase64');
  }

  Widget _getCookieList(String cookies) {
    if (cookies == null || cookies == '""') {
      return Container();
    }
    final List<String> cookieList = cookies.split(';');
    final Iterable<Text> cookieWidgets =
        cookieList.map((String cookie) => Text(cookie));
    return Column(
      mainAxisAlignment: MainAxisAlignment.end,
      mainAxisSize: MainAxisSize.min,
      children: cookieWidgets.toList(),
    );
  }
}

class NavigationControls extends StatelessWidget {
  const NavigationControls(this._webViewControllerFuture)
      : assert(_webViewControllerFuture != null);

  final Future<WebViewController> _webViewControllerFuture;

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<WebViewController>(
      future: _webViewControllerFuture,
      builder:
          (BuildContext context, AsyncSnapshot<WebViewController> snapshot) {
        final bool webViewReady =
            snapshot.connectionState == ConnectionState.done;
        final WebViewController controller = snapshot.data;
        return Row(
          children: <Widget>[
//            IconButton(
//              icon: const Icon(Icons.arrow_back_ios),
//              onPressed: !webViewReady
//                  ? null
//                  : () async {
//                      if (await controller.canGoBack()) {
//                        controller.goBack();
//                      } else {
//                        Scaffold.of(context).showSnackBar(
//                          const SnackBar(content: Text("No back history item")),
//                        );
//                        return;
//                      }
//                    },
//            ),
//            IconButton(
//              icon: const Icon(Icons.arrow_forward_ios),
//              onPressed: !webViewReady
//                  ? null
//                  : () async {
//                      if (await controller.canGoForward()) {
//                        controller.goForward();
//                      } else {
//                        Scaffold.of(context).showSnackBar(
//                          const SnackBar(
//                              content: Text("No forward history item")),
//                        );
//                        return;
//                      }
//                    },
//            ),
            IconButton(
              icon: const Icon(Icons.replay),
              onPressed: !webViewReady
                  ? null
                  : () {
                      controller.reload();
                    },
            ),
          ],
        );
      },
    );
  }
}
