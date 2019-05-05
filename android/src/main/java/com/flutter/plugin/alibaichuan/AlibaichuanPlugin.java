package com.flutter.plugin.alibaichuan;

import io.flutter.plugin.common.MethodCall;
import io.flutter.plugin.common.MethodChannel;
import io.flutter.plugin.common.MethodChannel.MethodCallHandler;
import io.flutter.plugin.common.MethodChannel.Result;
import io.flutter.plugin.common.PluginRegistry.Registrar;

/** AlibaichuanPlugin */
public class AlibaichuanPlugin implements MethodCallHandler {

  private static LoginServiceHandler loginServiceHandler;

  /** Plugin registration. */
  public static void registerWith(Registrar registrar) {
    final MethodChannel channel = new MethodChannel(registrar.messenger(), "alibaichuan");
    channel.setMethodCallHandler(new AlibaichuanPlugin());

    loginServiceHandler = new LoginServiceHandler(registrar);
  }

  @Override
  public void onMethodCall(MethodCall call, Result result) {
//    if (call.method.equals("getPlatformVersion")) {
//      result.success("Android " + android.os.Build.VERSION.RELEASE);
//    } else {
//      result.notImplemented();
//    }
    switch (call.method) {
      case "initAliBaiChuan":
        // 暂停
        loginServiceHandler.initAliBaiChuan(call, result);
        break;
      case "login":
        // 开始播放
        loginServiceHandler.login(call, result);
        break;
      case "logout":
        loginServiceHandler.logout(call, result);
        break;
      case "isLogin":
        loginServiceHandler.isLogin(call, result);
        break;
      default:
        result.notImplemented();
        break;
    }

  }
}
