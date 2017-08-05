//
//  HttpMangerHelper.h
//  PCDanDan
//
//  Created by xcode.qi on 17/1/19.
//  Copyright © 2017年 li. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface HttpMangerHelper : NSObject

/*
 *
 * 获取个人信息
 *
 */
+ (void)getUserSelfInfoSuccess:(void (^)(UserInfo * info))success
                          fail:(void (^)(NSString *description))fail;

/*
 *
 * 未读消息数量
 *
 */
+ (void)getUnReadMessageNumWithSuccess:(void (^)(UnReadMessageNumInfo *info))success
                                  fail:(void (^)(NSString *description))fail;

/*
 *
 * 获取平台官网／微信／qq信息
 *
 */
+ (void)getPTInfoWithSuccess:(void (^)(PingTaiServerInfo *info))success
                        fail:(void (^)(NSString *description))fail;

/*
 *
 * 获取分享数据
 *
 */
+ (void)getShareInfoWithSuccess:(void (^)(ShareInfo *info))success
                           fail:(void (^)(NSString *description))fail;

/*
 * 判断是否登录
 */
+ (BOOL)islogin;

/*
 * 弹出登录页面
 */
+ (void)loginWithAnimated:(BOOL)animated viewController:(UIViewController *)viewControl;


//是否绑定手机号
+ (BOOL)isBangDingPhone;


//绑定手机号
+ (void)gotoBangDingWithAnimated:(BOOL)animated viewController:(UIViewController *)viewControl;

//是否设置提现密码
+ (BOOL)isSetTiXianPwd;

//设置提现密码
+ (void)setTiXianPwdWithAnimated:(BOOL)animated viewController:(UIViewController *)viewControl;

@end
