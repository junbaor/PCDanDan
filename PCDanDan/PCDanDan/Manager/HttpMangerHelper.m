//
//  HttpMangerHelper.m
//  PCDanDan
//
//  Created by xcode.qi on 17/1/19.
//  Copyright © 2017年 li. All rights reserved.
//

#import "HttpMangerHelper.h"
#import "BangDingPhoneViewController.h"
#import "SetTiXianPwdViewController.h"
#import "PingTaiServerInfo.h"
#import "ShareInfo.h"

@implementation HttpMangerHelper

/*
 *
 * 获取个人信息
 *
 */
+ (void)getUserSelfInfoSuccess:(void (^)(UserInfo *info))success
                          fail:(void (^)(NSString *description))fail
{
    HttpHelper *helper = [[HttpHelper alloc] init];
    [helper getUserInfoWithUserId:[ShareManager shareInstance].userinfo.id
                          success:^(NSDictionary *resultDic){
                              if ([[resultDic objectForKey:@"result_code"] integerValue] == 0) {
                                  
                                  UserInfo *info = [[resultDic objectForKey:@"data"] objectByClass:[UserInfo class]];
                                  [ShareManager shareInstance].userinfo = info;
                                  [Tool saveUserInfoToDB:YES];
                                  if(success)
                                  {
                                      success(info);
                                  }
                              }else{
                                  if(fail)
                                  {
                                      fail([resultDic objectForKey:@"result_desc"]);
                                  }
                                  
                              }
                          }fail:^(NSString *decretion){
                              if(fail)
                              {
                                  fail(decretion);
                              }
                              
                          }];
    
}

/*
 *
 * 未读消息数量
 *
 */
+ (void)getUnReadMessageNumWithSuccess:(void (^)(UnReadMessageNumInfo *info))success
                                  fail:(void (^)(NSString *description))fail
{
    HttpHelper *helper = [[HttpHelper alloc] init];
    [helper getUnreadNoticeNumWithSuccess:^(NSDictionary *resultDic){
                              if ([[resultDic objectForKey:@"result_code"] integerValue] == 0) {
                                  
                                  UnReadMessageNumInfo *info = [[resultDic objectForKey:@"data"] objectByClass:[UnReadMessageNumInfo class]];
                                  [ShareManager shareInstance].unreadMessageInfo = info;
                                  if(success)
                                  {
                                      success(info);
                                  }
                              }else{
                                  if(fail)
                                  {
                                      fail([resultDic objectForKey:@"result_desc"]);
                                  }
                              }
                          }fail:^(NSString *decretion){
                              if(fail)
                              {
                                  fail(decretion);
                              }
                              
                          }];
    
}

/*
 *
 * 获取平台官网／微信／qq信息
 *
 */
+ (void)getPTInfoWithSuccess:(void (^)(PingTaiServerInfo *info))success
                        fail:(void (^)(NSString *description))fail
{
    HttpHelper *helper = [[HttpHelper alloc] init];
    [helper getHttpWithUrlStr:URL_GetPTInfo
                       success:^(NSDictionary *resultDic){
        if ([[resultDic objectForKey:@"result_code"] integerValue] == 0) {
            
            PingTaiServerInfo *info = [[resultDic objectForKey:@"data"] objectByClass:[PingTaiServerInfo class]];
            [ShareManager shareInstance].ptkfInfo = info;
            if(success)
            {
                success(info);
            }
        }else{
            if(fail)
            {
                fail([resultDic objectForKey:@"result_desc"]);
            }
        }
    }fail:^(NSString *decretion){
        if(fail)
        {
            fail(decretion);
        }
        
    }];
    
}

/*
 *
 * 获取分享数据
 *
 */
+ (void)getShareInfoWithSuccess:(void (^)(ShareInfo *info))success
                        fail:(void (^)(NSString *description))fail
{
    HttpHelper *helper = [[HttpHelper alloc] init];
    [helper getHttpWithUrlStr:URL_GetShareInfo
                      success:^(NSDictionary *resultDic){
                          if ([[resultDic objectForKey:@"result_code"] integerValue] == 0) {
                              
                              ShareInfo *info = [[resultDic objectForKey:@"data"] objectByClass:[ShareInfo class]];
                              
                              if(success)
                              {
                                  success(info);
                              }
                          }else{
                              if(fail)
                              {
                                  fail([resultDic objectForKey:@"result_desc"]);
                              }
                          }
                      }fail:^(NSString *decretion){
                          if(fail)
                          {
                              fail(decretion);
                          }
                      }];
    
}

+ (BOOL)islogin
{
    if ([ShareManager shareInstance].userinfo ) {
        return [ShareManager shareInstance].userinfo.islogin;
    }
    return NO;
}

+ (void)loginWithAnimated:(BOOL)animated viewController:(UIViewController *)viewControl
{
    LoginViewController *vc = [[LoginViewController alloc]initWithNibName:@"LoginViewController" bundle:nil];
    UINavigationController *nav = [[UINavigationController alloc]initWithRootViewController:vc];
    if (!viewControl) {
        [[UIApplication sharedApplication].keyWindow.rootViewController presentViewController:nav animated:animated completion:nil];
    }else{
        [viewControl presentViewController:nav animated:animated completion:nil];
    }
}

//是否绑定手机号
+ (BOOL)isBangDingPhone
{
    if ([ShareManager shareInstance].userinfo &&  ([ShareManager shareInstance].userinfo.mobile.length > 0 && ![[ShareManager shareInstance].userinfo.mobile isEqualToString:@"<null>"])) {
        return YES;
    }
    return NO;
}

//绑定手机号
+ (void)gotoBangDingWithAnimated:(BOOL)animated viewController:(UIViewController *)viewControl
{
    BangDingPhoneViewController *vc = [[BangDingPhoneViewController alloc]initWithNibName:@"BangDingPhoneViewController" bundle:nil];
    vc.hidesBottomBarWhenPushed = YES;
    [viewControl.navigationController pushViewController:vc animated:animated];
}

//是否设置提现密码
+ (BOOL)isSetTiXianPwd
{
    if ([ShareManager shareInstance].userinfo &&  ([ShareManager shareInstance].userinfo.withdrawals_password.length > 0 && ![[ShareManager shareInstance].userinfo.withdrawals_password isEqualToString:@"<null>"])) {
        return YES;
    }
    return NO;
}

//设置提现密码
+ (void)setTiXianPwdWithAnimated:(BOOL)animated viewController:(UIViewController *)viewControl
{
    SetTiXianPwdViewController *vc = [[SetTiXianPwdViewController alloc]initWithNibName:@"SetTiXianPwdViewController" bundle:nil];
    vc.isSetPwd = YES;
    vc.hidesBottomBarWhenPushed = YES;
    [viewControl.navigationController pushViewController:vc animated:animated];
}

@end
