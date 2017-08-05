//
//  AppDelegate.m
//  PCDanDan
//
//  Created by xcode.qi on 17/1/19.
//  Copyright © 2017年 li. All rights reserved.
//


#import "AppDelegate.h"
#import "LKDBHelper.h"
#import <ShareSDK/ShareSDK.h>
#import <ShareSDKConnector/ShareSDKConnector.h>
//腾讯开放平台（对应QQ和QQ空间）SDK头文件
#import <TencentOpenAPI/TencentOAuth.h>
#import <TencentOpenAPI/QQApiInterface.h>
//微信SDK头文件
#import "WXApi.h"
#import <AlipaySDK/AlipaySDK.h>

@interface AppDelegate ()<WXApiDelegate>

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    self.window.backgroundColor = [UIColor whiteColor];
    [self.window makeKeyAndVisible];
    self.window.rootViewController =  [[UIViewController alloc] init];
    [NSThread sleepForTimeInterval:2.0];
    
    //导航栏背景图
    [[UINavigationBar appearance] setBarTintColor:AppColor];
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
    
    //web加载内存控制
    int cacheSizeMemory = 4*1024*1024; // 4MB
    int cacheSizeDisk = 30*1024*1024; // 30MB
    NSURLCache *sharedCache = [[NSURLCache alloc] initWithMemoryCapacity:cacheSizeMemory diskCapacity:cacheSizeDisk diskPath:@"nsurlcache"];
    [NSURLCache setSharedURLCache:sharedCache];
    
    [[IQKeyboardManager sharedManager] setToolbarManageBehaviour:IQAutoToolbarByPosition];
    [[IQKeyboardManager sharedManager] setShouldShowTextFieldPlaceholder:NO];
    
    //获取用户信息
    [self getSqliteInfo];
    
    [self initShareFunction];
    
    //初始化环信
    EMOptions *options = [EMOptions optionsWithAppkey:IMKey];
    [[EMClient sharedClient] initializeSDKWithOptions:options];
    
    self.window.rootViewController = [[TarBarController alloc] init];
    
    [ShareManager shareInstance].isShowTouZhuYDY = YES;
    [ShareManager shareInstance].isShowToCZYDY = YES;
    [ShareManager shareInstance].isShowToXZYDY = YES;
    
    return YES;
}

/**
 *  获取数据库相关信息(用户信息)
 */
- (void)getSqliteInfo
{
    LKDBHelper *DBHelper = [LKDBHelper getUsingLKDBHelper];
    
    if ([DBHelper getTableCreatedWithClass:[UserInfo class]]) {
        NSArray *array = [DBHelper search:[UserInfo class] where:nil orderBy:nil offset:0 count:0];
        
        if (array && array.count > 0) {
            for (UserInfo *info in array) {
                [ShareManager shareInstance].userinfo = info;
                break;
            }
        }
    }
}

#pragma mark - init sharesdk
- (void)initShareFunction
{
    [ShareSDK registerApp:@"iosv1101"
          activePlatforms:@[
                            @(SSDKPlatformTypeWechat),
                            @(SSDKPlatformTypeQQ)]
                 onImport:^(SSDKPlatformType platformType)
     {
         switch (platformType)
         {
             case SSDKPlatformTypeWechat:
                 [ShareSDKConnector connectWeChat:[WXApi class]];
                 break;
             case SSDKPlatformTypeQQ:
                 [ShareSDKConnector connectQQ:[QQApiInterface class] tencentOAuthClass:[TencentOAuth class]];
                 break;
             default:
                 break;
         }
     }
          onConfiguration:^(SSDKPlatformType platformType, NSMutableDictionary *appInfo)
     {
         
         switch (platformType)
         {
             case SSDKPlatformTypeWechat:
                 [WXApi registerApp:WeiXinAppId];
                 [appInfo SSDKSetupWeChatByAppId:WeiXinAppId
                                       appSecret:WeiXinAppSecret];
                 
                 break;
                  case SSDKPlatformTypeQQ:
                      [appInfo SSDKSetupQQByAppId:QQKey
                                           appKey:QQSecret
                                         authType:SSDKAuthTypeBoth];
     
                      break;
             default:
                 break;
         }
         
     }];
    
}


- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    [[EMClient sharedClient] applicationDidEnterBackground:application];
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    [[EMClient sharedClient] applicationWillEnterForeground:application];
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

//禁止横屏
- (UIInterfaceOrientationMask)application:(UIApplication *)application supportedInterfaceOrientationsForWindow:(nullable UIWindow *)window {
    return UIInterfaceOrientationMaskPortrait;
}

#pragma mark - 各平台回调

- (BOOL)application:(UIApplication *)application handleOpenURL:(NSURL *)url
{
    if ([url.host isEqualToString:@"safepay"])
    {
        [[AlipaySDK defaultService] processOrderWithPaymentResult:url
                                                  standbyCallback:^(NSDictionary *resultDic) {
                                                      //【由于在跳转支付宝客户端支付的过程中,商户 app 在后台很可能被系统 kill 了,所以 pay 接口的 callback 就会失效,请商户对 standbyCallback 返回的回调结果进行处理,就是在这个方 法里面处理跟 callback 一样的逻辑】
                                                      NSLog(@"result = %@",resultDic);
                                                      NSString *resultStatue = (NSString *)[resultDic objectForKey:@"resultStatus"];
                                                      [self handlePayResultNotification:resultStatue];
                                                  }];
    }
    
    return  [WXApi handleOpenURL:url delegate:self];
    
    return YES;
}


- (BOOL)application:(UIApplication *)app openURL:(NSURL *)url options:(NSDictionary*)options
{
    
    if ([url.host isEqualToString:@"safepay"])
    {
        [[AlipaySDK defaultService] processOrderWithPaymentResult:url
                                                  standbyCallback:^(NSDictionary *resultDic) {
                                                      //【由于在跳转支付宝客户端支付的过程中,商户 app 在后台很可能被系统 kill 了,所以 pay 接口的 callback 就会失效,请商户对 standbyCallback 返回的回调结果进行处理,就是在这个方 法里面处理跟 callback 一样的逻辑】
                                                      NSLog(@"result = %@",resultDic);
                                                      NSString *resultStatue = (NSString *)[resultDic objectForKey:@"resultStatus"];
                                                      [self handlePayResultNotification:resultStatue];
                                                  }];
    }
    
    return  [WXApi handleOpenURL:url delegate:self];
    return YES;
}



/**
 *  支付结果处理支付结果
 */
- (void)handlePayResultNotification:(NSString *)resultStatue
{
    switch ([resultStatue intValue] ) {
        case 9000:
            [Tool showPromptContent:@"恭喜您，支付成功！" onView:self.window];
            break;
        case 8000:
            [Tool showPromptContent:@"正在处理中,请稍候查看！" onView:self.window];
            break;
        case 4000:
            [Tool showPromptContent:@"很遗憾，您此次支付失败，请您重新支付！" onView:self.window];
            break;
        case 6001:
            [Tool showPromptContent:@"您已取消了支付操作！" onView:self.window];
            break;
        case 6002:
            [Tool showPromptContent:@"网络连接出错，请您重新支付！" onView:self.window];
            break;
        default:
            break;
    }
}

#pragma mark - 微信支付回调

-(void)onResp:(BaseResp *)resp{
    NSString *strTitle;
    if ([resp isKindOfClass:[SendMessageToWXResp class]]) {
        strTitle = [NSString stringWithFormat:@"发送媒体消息结果"];
    }
    if ([resp isKindOfClass:[PayResp class]]) {
        strTitle = [NSString stringWithFormat:@"支付结果"];
        
        int isSuccess  = 0;
        
        switch (resp.errCode) {
            case WXSuccess:
            {
                NSLog(@"支付成功!");
                isSuccess = 0;
            }
                break;
            case WXErrCodeCommon:
                isSuccess = -1;
                break;
            case WXErrCodeUserCancel:
                isSuccess = -2;
                break;
            case WXErrCodeSentFail:
                isSuccess = -3;
                break;
            case WXErrCodeUnsupport:
                isSuccess = -5;
                break;
            case WXErrCodeAuthDeny:
                isSuccess = -4;
                break;
            default:
                break;
        }
        
        NSDictionary *parameters = nil;
        parameters = [NSDictionary dictionaryWithObjectsAndKeys:[NSString stringWithFormat:@"%d",isSuccess],@"statue",nil];
        //登录成功通知
        [[NSNotificationCenter defaultCenter] postNotificationName:kWeiXinPayNotif object:nil userInfo:parameters];
    }
}


@end
