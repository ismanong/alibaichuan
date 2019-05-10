//
// Created by mo on 2018/11/23.
//
#import <AlibcTradeSDK/AlibcTradeSDK.h>
#import <AlibabaAuthSDK/ALBBSDK.h>
//#import <AlibcTradeBiz/AlibcTradeBiz.h>
//#import <AlibabaAuthSDK/albbsdk.h>

#import "init.h"

@implementation LoginServiceHandler

- (void)initAliBaiChuan:(FlutterMethodCall *)call result:(FlutterResult)result {
    BOOL debuggable = [call.arguments[@"debuggable"] boolValue];
    
    NSString *version = call.arguments[@"version"];
    
    // 开发阶段打开日志开关，方便排查错误信息
    //默认调试模式打开日志,release关闭,可以不调用下面的函数
    [[AlibcTradeSDK sharedInstance] setDebugLogOpen:debuggable];//开发阶段打开日志开关，方便排查错误信息
//    if (![NautilusStringUtil isBlank:version]) {
//        [[AlibcTradeSDK sharedInstance] setIsvVersion:version];
//    }
    
    
    //设置全局的app标识，在电商模块里等同于isv_code
    //没有申请过isv_code的接入方,默认不需要调用该函数
    [[AlibcTradeSDK sharedInstance] setISVCode:@"your_isv_code"];
    
    // 设置全局配置，是否强制使用h5
    [[AlibcTradeSDK sharedInstance] setIsForceH5:NO];
    
    // 百川平台基础SDK初始化，加载并初始化各个业务能力插件
    [[AlibcTradeSDK sharedInstance] asyncInitWithSuccess:^{
        //您必须在Dictionary中使用 @(value) 作为非指针数据类型值存储。
        NSDictionary* jsonDict = @{
                                   @"message": @"初始化成功",
                                   @"isSuccess": @YES,
                                   };
        result(jsonDict);
    } failure:^(NSError *error) {
        NSDictionary* jsonDict = @{
                                   @"message": @"初始化失败",
                                   @"isSuccess": @NO,
                                   @"errorCode": @(error.code),
                                   @"errorMessage": error.description,
                                   };
        result(jsonDict);
    }];
    
}

- (void)isLogin:(FlutterMethodCall *)call result:(FlutterResult)result {
    result( @([[ALBBSession sharedInstance] isLogin]) );
}

- (void)login:(FlutterMethodCall *)call result:(FlutterResult)result {
    if(![[ALBBSession sharedInstance] isLogin]){
        UIViewController *rootViewController =
        [UIApplication sharedApplication].delegate.window.rootViewController;
        [[ALBBSDK sharedInstance] auth:rootViewController successCallback:^(ALBBSession *session){
            NSString *tip=[NSString stringWithFormat:@"登录的用户信息:%@",[session getUser]];
            NSDictionary* jsonDict = @{
                                       @"message": @"登录成功",
                                       @"isSuccess": @YES,
                                       @"data": tip,
                                       };
            result(jsonDict);
        } failureCallback:^(ALBBSession *session, NSError *error){
            NSDictionary* jsonDict = @{
                                       @"message": @"登录失败",
                                       @"isSuccess": @NO,
                                       @"errorCode": @(error.code),
                                       @"errorMessage": error.description,
                                       };
            result(jsonDict);
        }];
    }else{
        ALBBSession *session=[ALBBSession sharedInstance];
        NSString *tip=[NSString stringWithFormat:@"登录的用户信息:%@",[[session getUser] ALBBUserDescription]];
        NSDictionary* jsonDict = @{
                                   @"message": @"登录成功",
                                   @"isSuccess": @YES,
                                   @"data": tip,
                                   };
        result(jsonDict);
    }
}

- (void)logout:(FlutterMethodCall *)call result:(FlutterResult)result {
    [[ALBBSDK sharedInstance] logout];
    NSDictionary* jsonDict = @{
                               @"message": @"退出登录",
                               @"isSuccess": @YES,
                               };
    result(jsonDict);
}

@end
