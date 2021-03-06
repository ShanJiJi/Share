//
//  AppDelegate.m
//  Share
//
//  Created by 珍玮 on 16/6/7.
//  Copyright © 2016年 ZhenWei. All rights reserved.
//

#import "AppDelegate.h"
#import "WXApi.h"
#import "TencentOpenAPI.framework/Headers/QQApiInterface.h"

//注册应用是的APPID
#define WXAPPID  @"wxb9bd182722d85fae"

#define QQAPPID  @"1105384223"

@interface AppDelegate ()<WXApiDelegate,QQApiInterfaceDelegate>

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    //注册微信
    [WXApi registerApp:WXAPPID];
    
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

-(BOOL)application:(UIApplication *)app openURL:(NSURL *)url options:(NSDictionary<NSString *,id> *)options{
    NSLog(@"url.scheme = %@",url.scheme);
    if ([url.scheme isEqualToString:WXAPPID]) {
        return [WXApi handleOpenURL:url delegate:self];
    }else if ([url.scheme isEqualToString:[NSString stringWithFormat:@"tencent%@",QQAPPID]]) {
        return [QQApiInterface handleOpenURL:url delegate:self];
    }else{
        return YES;
    }
}

#pragma mark - WXPaiDelegate 微信分享的相关回调

//onReq是微信终端向第三方程序发起请求，要求第三方程序相应。第三方程序响应完后必须调用sendRsp返回。在调用sendRsp返回时，会切回到微信终端程序界面。
/**
 处理来至QQ的请求
 */

-(void)onReq:(BaseReq *)req{
    
}

/** 如果第三方程序向微信发送了sendReq的请求，那么onResp会被回调。sendReq请求调用后，会切到微信终端程序界面。*/
/**
 enum  WXErrCode {
 WXSuccess           = 0,    //< 成功
WXErrCodeCommon     = -1,   //< 普通错误类型
WXErrCodeUserCancel = -2,   //< 用户点击取消并返回
WXErrCodeSentFail   = -3,   //< 发送失败
WXErrCodeAuthDeny   = -4,   //< 授权失败
WXErrCodeUnsupport  = -5,   //< 微信不支持
};*/

-(void)onResp:(BaseResp *)resp{
    
    NSLog(@"这里响应了");
    NSLog(@"resp = %@",resp);
    //这里判断返回的响应类的基类是该类为微信终端SDK所有响应类的基类
    if ([resp isKindOfClass:[BaseResp class]]) {
        
        if([resp isKindOfClass:[SendMessageToWXResp class]]) {
            BaseResp *resp1 = resp;
            switch (resp1.errCode) {
                case WXSuccess:
                {
                    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"成功" message:@"微信分享成功" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
                    [alert show];
                }
                    break;
                case WXErrCodeUserCancel:
                {
                    NSLog(@"用户点击取消并返回");
                }
                    break;
                case WXErrCodeCommon:
                {
                    NSLog(@"普通错误类型");
                }
                    break;
                case WXErrCodeSentFail:
                {
                    NSLog(@"发送失败");
                }
                    break;
                case WXErrCodeAuthDeny:
                {
                    NSLog(@"授权失败");
                }
                    break;
                case WXErrCodeUnsupport:
                {
                    NSLog(@"微信不支持");
                }
                    break;
                default:
                {
                    
                }
                    
                    break;
            }    
        }
        
    }else{
        //处理来至QQ的响应
         
        SendMessageToQQResp *sendResp = (SendMessageToQQResp *)resp;
        if ([sendResp.result isEqualToString:@"0"]) {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"成功" message:@"QQ分享成功" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
            [alert show];
        }else {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"失败" message:@"QQ分享失败" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
            [alert show];
        }
        
    }
    
}


#pragma mark - QQApiInterfaceDelegate QQ分享的相关回调

//处理QQ在线状态的回调
-(void)isOnlineResponse:(NSDictionary *)response{
    NSLog(@"response = %@",response);
}

@end
