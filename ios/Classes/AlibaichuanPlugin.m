#import "AlibaichuanPlugin.h"
#import "LoginService/init.h"
@implementation AlibaichuanPlugin

LoginServiceHandler *_LoginServiceHandler;

- (id)init:(NSObject <FlutterPluginRegistrar> *)registrar {
    self = [super init];
    if (self) {
        _LoginServiceHandler = [[LoginServiceHandler alloc] init];
    }
    return self;
}

+ (void)registerWithRegistrar:(NSObject<FlutterPluginRegistrar>*)registrar {
    FlutterMethodChannel* channel = [FlutterMethodChannel
                                     methodChannelWithName:@"alibaichuan"
                                     binaryMessenger:[registrar messenger]];
    AlibaichuanPlugin* instance = [[AlibaichuanPlugin alloc] init:registrar];
    [registrar addMethodCallDelegate:instance channel:channel];
}

- (void)handleMethodCall:(FlutterMethodCall*)call result:(FlutterResult)result {
    //  if ([@"getPlatformVersion" isEqualToString:call.method]) {
    //    result([@"iOS " stringByAppendingString:[[UIDevice currentDevice] systemVersion]]);
    //  } else {
    //    result(FlutterMethodNotImplemented);
    //  }
    
    if ([@"initAliBaiChuan" isEqualToString:call.method]) {
        [_LoginServiceHandler initAliBaiChuan:call result:result];
    } else if ([@"isLogin" isEqualToString:call.method]) {
        [_LoginServiceHandler isLogin:call result:result];
    } else if ([@"login" isEqualToString:call.method]) {
        [_LoginServiceHandler login:call result:result];
    } else if ([@"logout" isEqualToString:call.method]) {
        [_LoginServiceHandler logout:call result:result];
    } else{
        result(FlutterMethodNotImplemented);
    }
}

@end

