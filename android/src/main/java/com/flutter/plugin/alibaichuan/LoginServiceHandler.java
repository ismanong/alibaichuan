package com.flutter.plugin.alibaichuan;

import io.flutter.plugin.common.MethodCall;
import io.flutter.plugin.common.MethodChannel;
import io.flutter.plugin.common.PluginRegistry;

import android.content.Intent;

import com.ali.auth.third.core.MemberSDK;
import com.ali.auth.third.ui.context.CallbackContext;
import com.alibaba.baichuan.android.trade.AlibcTradeSDK;
import com.alibaba.baichuan.android.trade.callback.AlibcTradeInitCallback;
import com.alibaba.baichuan.trade.biz.AlibcTradeBiz;
import com.alibaba.baichuan.trade.biz.login.AlibcLogin;
import com.alibaba.baichuan.trade.biz.login.AlibcLoginCallback;
import com.alibaba.baichuan.trade.common.AlibcTradeCommon;

import java.util.HashMap;
import java.util.Map;

public class LoginServiceHandler {

    public LoginServiceHandler(PluginRegistry.Registrar registry) {
        this.registrar = registry;
    }

    private PluginRegistry.Registrar registrar;

    /**
     * 电商SDK初始化
     */
    public void initAliBaiChuan(MethodCall call, final MethodChannel.Result result) {
//      val version = call.argument<String?>("version");
//      if (!version.isNullOrBlank()) {
//          AlibcTradeSDK.setISVVersion(null);
//      }

        boolean debuggable = call.argument("debuggable");
        if (debuggable) {
            AlibcTradeCommon.turnOnDebug();
            AlibcTradeBiz.turnOnDebug();
            MemberSDK.turnOnDebug();
        } else {
            AlibcTradeCommon.turnOffDebug();
            AlibcTradeBiz.turnOffDebug();
//            MemberSDK.turnOnDebug();
            MemberSDK.turnOffDebug();
        }

        //电商SDK初始化
        AlibcTradeSDK.asyncInit(registrar.activity().getApplication(), new AlibcTradeInitCallback() {
            @Override
            public void onSuccess() {
//                Toast.makeText(AliSdkApplication.this, "初始化成功", Toast.LENGTH_SHORT).show();
//                Map utMap = new HashMap<>();
//                utMap.put("debug_api_url","http://muvp.alibaba-inc.com/online/UploadRecords.do");
//                utMap.put("debug_key","baichuan_sdk_utDetection");
//                UTTeamWork.getInstance().turnOnRealTimeDebug(utMap);
//                AlibcUserTracker.getInstance().sendInitHit4DAU("19","3.1.1.100");
                Map<String, Object> map = new HashMap<>();
                map.put("message", "初始化成功");
                map.put("isSuccess", true);
                result.success(map);
            }

            @Override
            public void onFailure(int code, String msg) {
//                Toast.makeText(AliSdkApplication.this, "初始化失败"+code+" / 错误消息="+msg, Toast.LENGTH_SHORT).show();
                Map<String, Object> map = new HashMap<>();
                map.put("message", "初始化失败");
                map.put("errorCode", code);
                map.put("errorMessage", msg);
                map.put("isSuccess", false);
                result.success(map);
            }
        });
    }

    /**
     * 登录
     */
    public void login(MethodCall call, final MethodChannel.Result result) {

        registrar.addActivityResultListener(new PluginRegistry.ActivityResultListener() {
            @Override
            public boolean onActivityResult(int requestCode, int resultCode, Intent data) {
                CallbackContext.onActivityResult(requestCode, resultCode, data);
                return true;
            }
        });

        AlibcLogin alibcLogin = AlibcLogin.getInstance();

        alibcLogin.showLogin(new AlibcLoginCallback() {
            @Override
            public void onSuccess(int i) {
//                Toast.makeText(AliSdkMenuActivity.this, "登录成功 ", Toast.LENGTH_LONG).show();
                Map<String, Object> map = new HashMap<>();
                map.put("message", "登录成功");
                map.put("isSuccess", true);
                result.success(map);
            }

            @Override
            public void onFailure(int code, String msg) {
//                Toast.makeText(AliSdkMenuActivity.this, "登录失败 ", Toast.LENGTH_LONG).show();
                Map<String, Object> map = new HashMap<>();
                map.put("message", "登录失败");
                map.put("errorCode", code);
                map.put("errorMessage", msg);
                map.put("isSuccess", false);
                result.success(map);
            }
        });
    }


    /**
     * 退出登录
     */
    public void logout(MethodCall call, final MethodChannel.Result result) {

        AlibcLogin alibcLogin = AlibcLogin.getInstance();

        alibcLogin.logout(new AlibcLoginCallback() {
            @Override
            public void onSuccess(int i) {
//                Toast.makeText(AliSdkMenuActivity.this, "登出成功 ", Toast.LENGTH_LONG).show();
                Map<String, Object> map = new HashMap<>();
                map.put("message", "登出成功");
                map.put("isSuccess", true);
                result.success(map);
            }

            @Override
            public void onFailure(int i, String s) {
//                Toast.makeText(AliSdkMenuActivity.this, "登录失败 ", Toast.LENGTH_LONG).show();
                Map<String, Object> map = new HashMap<>();
                map.put("message", "登出失败");
                map.put("errorCode", i);
                map.put("errorMessage", s);
                map.put("isSuccess", false);
                result.success(map);
            }
        });
    }

    public void isLogin(MethodCall call, final MethodChannel.Result result) {
        result.success(AlibcLogin.getInstance().isLogin());
    }
}
