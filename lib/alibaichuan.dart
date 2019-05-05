import 'dart:async';

import 'package:flutter/services.dart';

class Alibaichuan {
  static const MethodChannel _channel =
      const MethodChannel('alibaichuan');

  static Future<Map> get initAliBaiChuan async {
    final Map res = await _channel.invokeMethod('initAliBaiChuan', {"debuggable": false, "version": null});
    return res;
  }

  static Future<Map> get login async {
    final Map res = await _channel.invokeMethod('login');
    return res;
  }

  static Future<Map> logout() async {
    return await _channel.invokeMethod("logout");
  }

  static Future<bool> isLogin() async {
    return await _channel.invokeMethod("isLogin");
  }

}
