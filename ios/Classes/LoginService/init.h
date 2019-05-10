//
//  init.h
//  Pods
//
//  Created by g on 2019/5/9.
//

#import <Foundation/Foundation.h>
#import <Flutter/Flutter.h>

@interface LoginServiceHandler : NSObject

- (void)initAliBaiChuan:(FlutterMethodCall *)call result:(FlutterResult)result;
- (void)isLogin:(FlutterMethodCall *)call result:(FlutterResult)result;
- (void)login:(FlutterMethodCall *)call result:(FlutterResult)result;
- (void)logout:(FlutterMethodCall *)call result:(FlutterResult)result;

@end
