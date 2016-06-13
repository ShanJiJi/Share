//
//  ViewController.m
//  Share
//
//  Created by 珍玮 on 16/6/7.
//  Copyright © 2016年 ZhenWei. All rights reserved.
//

#import "ViewController.h"
#import "WXApi.h"
#import "WXApiObject.h"
#import "TencentOpenAPI.framework/Headers/TencentOAuth.h"
#import "TencentOpenAPI.framework/Headers/QQApiInterfaceObject.h"
#import "TencentOpenAPI.framework/Headers/QQApiInterface.h"

#define QQAPPID  @"1105384223"

@interface ViewController ()<TencentSessionDelegate>

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
}

//************************************
//************************************
//************这里是微信分享************
//************************************
//************************************
- (IBAction)shareClick:(id)sender {
    
    [self SendTextImageLink:NO scene:0];
}
- (IBAction)share2Click:(id)sender {
    
    [self SendTextImageLink:NO scene:1];
}
- (IBAction)share3:(id)sender {
    
    [self SendTextImageLink:YES scene:0];
}
- (IBAction)share4:(id)sender {
    
    [self SendTextImageLink:YES scene:1];
}

//bText = YES表示使用文本信息 NO表示不使用文本信息
//scene = 0：分享到好友列表 1：分享到朋友圈  2：收藏
-(void)SendTextImageLink:(BOOL)bText scene:(int)scene{
    
    //判断用户是否安装了微信
    if (![WXApi isWXAppInstalled]) {
        NSLog(@"没有安装，请去前去下载按装");
    }else{
        
        //第三方程序向微信发送信息需要传入SendMessageToWXReq结构体，信息类型包括文本消息和多媒体消息
        SendMessageToWXReq *sendReq = [[SendMessageToWXReq alloc] init];
        
        //发送消息的类型，包括文本消息和多媒体消息两种，两者只能选择其一，不能同时发送文本和多媒体消息
        sendReq.bText = bText;//YES表示使用文本信息 NO表示不使用文本信息
        
        //判断只发文本还是发图片和文本
        if (bText) {
            sendReq.text = @"这是分享测试，，测试，，";
        }else{
            
            //创建分享内容
            WXMediaMessage *message = [WXMediaMessage message];
            //分享标题
            message.title = @"这是标题";
            //分享描述，或内容
            message.description = @"这是内容描述！这是内容描述！这是内容描述！这是内容描述！这是内容描述！这是内容描述！这是内容描述！";
            //分享的图片
            [message setThumbImage:[UIImage imageNamed:@"这里写要发送的图片名"]];//分享图片,使用SDK的setThumbImage方法可压缩图片大小
            
            //创建多媒体对象
            WXWebpageObject *webObj = [WXWebpageObject object];
            //点击后的跳转链接
            webObj.webpageUrl = @"www.baidu.com";
            //多媒体数据对象，可以为WXImageObject，WXMusicObject，WXVideoObject，WXWebpageObject等。
            message.mediaObject = webObj;
            //发送消息的多媒体内容
            sendReq.message = message;
            
        }
        
        //发送的目标场景，可以选择发送到会话(WXSceneSession)或者朋友圈(WXSceneTimeline)。 默认发送到会话。
        sendReq.scene = scene;// 0：分享到好友列表 1：分享到朋友圈  2：收藏
                //发送请求到微信
        [WXApi sendReq:sendReq];
        
    }
    
}



//************************************
//************************************
//************这里是QQ分享************
//************************************
//************************************

- (IBAction)share5:(id)sender {
    
    [self sendTextImageLinkToQQ:YES scene:0];
}
- (IBAction)share6:(id)sender {
    
    [self sendTextImageLinkToQQ:YES scene:1];
}
- (IBAction)share7:(id)sender {
    
   [self sendTextImageLinkToQQ:NO scene:0];
}
- (IBAction)share8:(id)sender {
    
   [self sendTextImageLinkToQQ:NO scene:1];
}

-(void)sendTextImageLinkToQQ:(BOOL)isText scene:(int)scene{
    
    //判断手机上有没有安装客户端
    if (![TencentOAuth iphoneQQInstalled]) {
        NSLog(@"请去下载");
    }else{
        
        TencentOAuth *tencentOAuth = [[TencentOAuth alloc] initWithAppId:QQAPPID andDelegate:self];
        
        //判断是否发送纯文本
        if (isText) {
            
            QQApiTextObject *newObj = [QQApiTextObject objectWithText:@"QQ分享到好友列表的测试"];
            
            SendMessageToQQReq *req = [SendMessageToQQReq reqWithContent:newObj];
            
            if (scene == 0) {
                NSLog(@"haha - %d",[QQApiInterface sendReq:req]);
            }else if (scene == 1) {
                NSLog(@"haha - %d",[QQApiInterface SendReqToQZone:req]);
            }
            
        }else{
         
            QQApiNewsObject *newObj = [QQApiNewsObject objectWithURL:[NSURL URLWithString:@"www.baidu.com"] title:@"这是标题" description:@"这是内容！这是内容！这是内容！这是内容！这是内容！这是内容！这是内容！这是内容！这是内容！这是内容！" previewImageData:UIImageJPEGRepresentation([UIImage imageNamed:@""], 1)];
            
            SendMessageToQQReq *req = [SendMessageToQQReq reqWithContent:newObj];
            if (scene == 0) {
                NSLog(@"QQ好友列表分享 - %d",[QQApiInterface sendReq:req]);
            }else if (scene == 1) {
                NSLog(@"QQ好友列表分享 - %d",[QQApiInterface SendReqToQZone:req]);
            }
            
        }
        
    }
    
}




@end
