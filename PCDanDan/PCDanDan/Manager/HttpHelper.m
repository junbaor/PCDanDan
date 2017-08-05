//
//  HttpHelper.m
//  PCDanDan
//
//  Created by xcode.qi on 17/1/19.
//  Copyright © 2017年 li. All rights reserved.
//

#import "HttpHelper.h"
#import "AFHTTPSessionManager.h"
#import "SecurityUtil.h"

@implementation HttpHelper

#pragma mark - 注册登录

/**
 * 注册
 */
- (void)resigterAccountWithAccount:(NSString *)account
                          password:(NSString *)password
                              code:(NSString *)code
                   registration_id:(NSString *)registration_id
                            success:(void (^)(NSDictionary *resultDic))success
                               fail:(void (^)(NSString *description))fail
{
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    
    if (account) {
        [parameters setObject:account forKey:@"account"];
    }
    if (password) {
        [parameters setObject:password forKey:@"password"];
    }
    if (code) {
        [parameters setObject:code forKey:@"code"];
    }
    if (registration_id) {
        [parameters setObject:registration_id forKey:@"registration_id"];
    }
    [self postHttpWithDic:parameters urlStr:URL_Register signAddValue:password success:success fail:fail];
}

/**
 * 登录
 */
- (void)loginWithAccount:(NSString *)account
                password:(NSString *)password
         registration_id:(NSString *)registration_id
                 success:(void (^)(NSDictionary *resultDic))success
                    fail:(void (^)(NSString *description))fail
{
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    
    if (account) {
        [parameters setObject:account forKey:@"account"];
    }
    if (password) {
        NSString *pwd = [Tool encodeUsingMD5ByString:password letterCaseOption:LowerLetter];
        pwd = [Tool encodeUsingMD5ByString:pwd letterCaseOption:LowerLetter];
        pwd = [Tool encodeUsingMD5ByString:pwd letterCaseOption:LowerLetter];

        [parameters setObject:pwd forKey:@"password"];
    }
    if (registration_id) {
        [parameters setObject:registration_id forKey:@"registration_id"];
    }
    [self postHttpWithDic:parameters urlStr:URL_Login signAddValue:nil success:success fail:fail];
}


/**
 * 第三方登录
 */
- (void)loginOfThirdWithBandId:(NSString *)band_id
                     band_type:(NSString *)band_type
               registration_id:(NSString *)registration_id
                     nick_name:(NSString *)nick_name
                    user_photo:(NSString *)user_photo
                       success:(void (^)(NSDictionary *resultDic))success
                          fail:(void (^)(NSString *description))fail
{
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    
    if (band_id) {
        [parameters setObject:band_id forKey:@"band_id"];
    }
    if (band_type) {
        [parameters setObject:band_type forKey:@"band_type"];
    }
    if (registration_id) {
        [parameters setObject:registration_id forKey:@"registration_id"];
    }
    if (nick_name) {
        [parameters setObject:nick_name forKey:@"nick_name"];
    }
    if (user_photo) {
        [parameters setObject:user_photo forKey:@"user_photo"];
    }
    [self postHttpWithDic:parameters urlStr:URL_OtherLogin signAddValue:nil success:success fail:fail];
}

/**
 * 忘记密码
 */
- (void)forgetPwdWithAccount:(NSString *)account
                      mobile:(NSString *)mobile
                    password:(NSString *)password
                      msg_id:(NSString *)msg_id
                    msg_code:(NSString *)msg_code
                     success:(void (^)(NSDictionary *resultDic))success
                        fail:(void (^)(NSString *description))fail
{
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    
    if (account) {
        [parameters setObject:account forKey:@"account"];
    }
    if (mobile) {
        [parameters setObject:mobile forKey:@"mobile"];
    }
    if (password) {
        [parameters setObject:password forKey:@"password"];
    }
    if (msg_id) {
        [parameters setObject:msg_id forKey:@"msg_id"];
    }
    if (msg_code) {
        [parameters setObject:msg_code forKey:@"msg_code"];
    }
    [self postHttpWithDic:parameters urlStr:URL_ForgetPwd signAddValue:nil success:success fail:fail];
}


#pragma mark - 首页


/**
 * 版本检测接口
 */
- (void)checkVersionWithClientNo:(NSString *)client_no
                         success:(void (^)(NSDictionary *resultDic))success
                            fail:(void (^)(NSString *description))fail
{
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    
    if (client_no) {
        [parameters setObject:client_no forKey:@"client_no"];
    }
    [parameters setObject:@"ios" forKey:@"client_type"];
    
    
    [self postHttpWithDic:parameters urlStr:URL_CheckVersion signAddValue:nil success:success fail:fail];
    
}

/**
 * 获取首页数据
 */
- (void)getHomePageDataWithSuccess:(void (^)(NSDictionary *resultDic))success
                              fail:(void (^)(NSString *description))fail
{
    
    //用户id
    NSString *useridStr = nil;
    if ([ShareManager shareInstance].userinfo
        && [ShareManager shareInstance].userinfo.islogin
        && [ShareManager shareInstance].userinfo.id.length > 0
        && [[ShareManager shareInstance].userinfo.id isEqualToString:@"<null>"]
        && [ShareManager shareInstance].userinfo.id) {
        useridStr = [ShareManager shareInstance].userinfo.id;
    }else{
        useridStr = @"0";
    }
    
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    [parameters setObject:useridStr forKey:@"user_id"];
   
    [self postHttpWithDic:parameters urlStr:URL_GetHomePageData signAddValue:nil success:success fail:fail];
}


/**
 * 获取房间区域
 * game_type" : "1"     1北京28   2加拿大28
 */
- (void)getGameHouseAreaListWithType:(NSString *)game_type
                             success:(void (^)(NSDictionary *resultDic))success
                              fail:(void (^)(NSString *description))fail
{
    
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    if (game_type) {
        [parameters setObject:game_type forKey:@"game_type"];
    }

    
    [self postHttpWithDic:parameters urlStr:URL_GetHouseAreaListInfo signAddValue:nil success:success fail:fail];
}

/**
 * 获取房间列表
 * game_type" : "1"     1北京28   2加拿大28
 */
- (void)getGameHouseListWithType:(NSString *)game_type
                         area_id:(NSString *)area_id
                         success:(void (^)(NSDictionary *resultDic))success
                            fail:(void (^)(NSString *description))fail
{
    
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    if (game_type) {
        [parameters setObject:game_type forKey:@"game_type"];
    }
    if (area_id) {
        [parameters setObject:area_id forKey:@"area_id"];
    }
    
    [self postHttpWithDic:parameters urlStr:URL_GetHouseListInfo signAddValue:nil success:success fail:fail];
}

/**
 * 加入房间
 */
- (void)joinGameRoomWithRoomId:(NSString *)room_id
                       user_id:(NSString *)user_id
                      password:(NSString *)password
                       success:(void (^)(NSDictionary *resultDic))success
                          fail:(void (^)(NSString *description))fail
{
    
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    if (room_id) {
        [parameters setObject:room_id forKey:@"room_id"];
    }
    if (user_id) {
        [parameters setObject:user_id forKey:@"user_id"];
    }
    if (password) {
        [parameters setObject:password forKey:@"password"];
    }
    [self postHttpWithDic:parameters urlStr:URL_JoinGameRoom signAddValue:nil success:success fail:fail];
}

/**
 * 通知服务器已加入房间
 */
- (void)putNotifSeverJoinRoomWithRoomId:(NSString *)room_id
                                user_id:(NSString *)user_id
                                success:(void (^)(NSDictionary *resultDic))success
                                   fail:(void (^)(NSString *description))fail
{
    
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    if (room_id) {
        [parameters setObject:room_id forKey:@"room_id"];
    }
    if (user_id) {
        [parameters setObject:user_id forKey:@"user_id"];
    }
    
    [self postHttpWithDic:parameters urlStr:URL_PutNotif signAddValue:nil success:success fail:fail];
}

/**
 * 离开房间
 */
- (void)leaveGameRoomWithRoomId:(NSString *)room_id
                       user_id:(NSString *)user_id
                       success:(void (^)(NSDictionary *resultDic))success
                          fail:(void (^)(NSString *description))fail
{
    
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    if (room_id) {
        [parameters setObject:room_id forKey:@"room_id"];
    }
    if (user_id) {
        [parameters setObject:user_id forKey:@"user_id"];
    }
    
    [self postHttpWithDic:parameters urlStr:URL_LeaveGameRoom signAddValue:nil success:success fail:fail];
}

/**
 * 获取下注比例
 * game_type   1北京快乐8 2加拿大快乐8
 */
- (void)getGameBiliWithGameType:(NSString *)game_type
                        area_id:(NSString *)area_id
                        success:(void (^)(NSDictionary *resultDic))success
                           fail:(void (^)(NSString *description))fail
{
    
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    if (game_type) {
        [parameters setObject:game_type forKey:@"game_type"];
    }
    if (area_id) {
        [parameters setObject:area_id forKey:@"area_id"];
    }
    [self postHttpWithDic:parameters urlStr:URL_GetGameBiLi signAddValue:nil success:success fail:fail];
}

/**
 * 下注
 * "choice_no" : "852154" ,           下注期数
 * "point" : "1" ,                     下注金额
 * "bili_id" : "1"                     选择的比例id
 */
- (void)putXiaZhuInfoWithRoomId:(NSString *)room_id
                        user_id:(NSString *)user_id
                      choice_no:(NSString *)choice_no
                          point:(NSString *)point
                        bili_id:(NSString *)bili_id
                        area_id:(NSString *)area_id
                        success:(void (^)(NSDictionary *resultDic))success
                           fail:(void (^)(NSString *description))fail
{
    
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    if (room_id) {
        [parameters setObject:room_id forKey:@"room_id"];
    }
    if (user_id) {
        [parameters setObject:user_id forKey:@"user_id"];
    }
    if (choice_no) {
        [parameters setObject:choice_no forKey:@"choice_no"];
    }
    if (point) {
        [parameters setObject:point forKey:@"point"];
    }
    if (bili_id) {
        [parameters setObject:bili_id forKey:@"bili_id"];
    }
    if (area_id) {
        [parameters setObject:area_id forKey:@"area_id"];
    }
    [self postHttpWithDic:parameters urlStr:URL_XiaZhu signAddValue:[NSString stringWithFormat:@"%@,%@",choice_no,point] success:success fail:fail];
}


/**
 * 获取倒计时和最近10期开奖记录
 * game_type   1北京快乐8 2加拿大快乐8
 */
- (void)getDJSAndHistoryWithGameType:(NSString *)game_type
                             user_id:(NSString *)user_id
                             room_id:(NSString *)room_id
                             success:(void (^)(NSDictionary *resultDic))success
                                fail:(void (^)(NSString *description))fail
{
    
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    if (game_type) {
        [parameters setObject:game_type forKey:@"game_type"];
    }
    if (user_id) {
        [parameters setObject:user_id forKey:@"user_id"];
    }
    if (room_id) {
        [parameters setObject:room_id forKey:@"room_id"];
    }
    [self postHttpWithDic:parameters urlStr:URL_GetDJSORHistory signAddValue:nil success:success fail:fail];
}

#pragma mark - 充值
/**
 * 转账账号列表
 */
- (void)getZhuanZhangAccountListWithType:(NSString *)type //1银行卡  2支付宝 3微信
                                 success:(void (^)(NSDictionary *resultDic))success
                                    fail:(void (^)(NSString *description))fail
{
    
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    if (type) {
        [parameters setObject:type forKey:@"type"];
    }
    [self postHttpWithDic:parameters urlStr:URL_GetZhuanZhangAccountList signAddValue:nil success:success fail:fail];
}

/**
 * 新增转账记录
 * account_type //1银行卡  2支付宝 3微信
 */
- (void)addZhuanZhangRecordInfoWithAccount:(NSString *)account
                              account_type:(NSString *)account_type
                                 real_name:(NSString *)real_name
                                 bank_name:(NSString *)bank_name
                                     point:(NSString *)point
                                   user_id:(NSString *)user_id
                                  add_type:(NSString *)add_type
                                account_id:(NSString *)account_id
                                 success:(void (^)(NSDictionary *resultDic))success
                                    fail:(void (^)(NSString *description))fail
{
    
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    if (account) {
        [parameters setObject:account forKey:@"account"];
    }
    if (account_type) {
        [parameters setObject:account_type forKey:@"account_type"];
    }
    if (real_name) {
        [parameters setObject:real_name forKey:@"real_name"];
    }
    if (bank_name) {
        [parameters setObject:bank_name forKey:@"bank_name"];
    }
    if (point) {
        [parameters setObject:point forKey:@"point"];
    }
    if (user_id) {
        [parameters setObject:user_id forKey:@"user_id"];
    }
    if (add_type) {
        [parameters setObject:add_type forKey:@"add_type"];
    }
    if (account_id) {
        [parameters setObject:account_id forKey:@"account_id"];
    }
    [self postHttpWithDic:parameters urlStr:URL_AddZhuanZhangList signAddValue:point success:success fail:fail];
}

/**
 * 转账记录
 */
- (void)zzRecordListInfoWithUserId:(NSString *)user_id
                           page_no:(NSString *)page_no
                         page_size:(NSString *)page_size
                      account_type:(NSString *)account_type
                           success:(void (^)(NSDictionary *resultDic))success
                              fail:(void (^)(NSString *description))fail
{
    
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    if (user_id) {
        [parameters setObject:user_id forKey:@"user_id"];
    }
    if (page_no) {
        [parameters setObject:page_no forKey:@"page_no"];
    }
    if (page_size) {
        [parameters setObject:page_size forKey:@"page_size"];
    }
    if (account_type) {
        [parameters setObject:account_type forKey:@"account_type"];
    }
    [self postHttpWithDic:parameters urlStr:URL_ZZRecordList signAddValue:nil success:success fail:fail];
}

/**
 * 获取订单号
 */
- (void)getOrderNoWithUserId:(NSString *)user_id
                    total_fee:(NSString *)total_fee
                     success:(void (^)(NSDictionary *resultDic))success
                        fail:(void (^)(NSString *description))fail
{
    
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    if (user_id) {
        [parameters setObject:user_id forKey:@"user_id"];
    }
    if (total_fee) {
        [parameters setObject:total_fee forKey:@"total_fee"];
    }
    [self postHttpWithDic:parameters urlStr:URL_GetOrderNo signAddValue:total_fee success:success fail:fail];
}

/**
 * 获取支付的url
 * pay_type=1支付宝 2微信
 */
- (void)getPayUrlWithUrl:(NSString *)url
                order_no:(NSString *)order_no
                     fee:(NSString *)fee
                pay_type:(NSString *)pay_type
                 success:(void (^)(NSDictionary *resultDic))success
                    fail:(void (^)(NSString *description))fail
{
    
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    if (order_no) {
        [parameters setObject:order_no forKey:@"order_no"];
    }
    if (fee) {
        [parameters setObject:fee forKey:@"fee"];
    }
    if (pay_type) {
        [parameters setObject:pay_type forKey:@"pay_type"];
    }
    [self postHttpWithDic:parameters urlStr:url signAddValue:order_no success:success fail:fail];
}

/**
 * 检测是否支付成功
 */
- (void)checkIsPaySuccessWithOrder_no:(NSString *)order_no
                              user_id:(NSString *)user_id
                              success:(void (^)(NSDictionary *resultDic))success
                                 fail:(void (^)(NSString *description))fail
{
    
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    if (order_no) {
        [parameters setObject:order_no forKey:@"order_no"];
    }
    if (user_id) {
        [parameters setObject:user_id forKey:@"user_id"];
    }
    [self postHttpWithDic:parameters urlStr:URL_CheckIsPaySuccess signAddValue:nil success:success fail:fail];
}


#pragma mark - 动态
/**
 * 获取消息列表
 * type" :  1系统通知  2我的消息
 */
- (void)getNoticeListWithPageNo:(NSString *)page_no
                      page_size:(NSString *)page_size
                        user_id:(NSString *)user_id
                           type:(NSString *)type
                         success:(void (^)(NSDictionary *resultDic))success
                            fail:(void (^)(NSString *description))fail
{
    
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    if (page_no) {
        [parameters setObject:page_no forKey:@"page_no"];
    }
    if (page_size) {
        [parameters setObject:page_size forKey:@"page_size"];
    }
    if (user_id) {
        [parameters setObject:user_id forKey:@"user_id"];
    }
    if (type) {
        [parameters setObject:type forKey:@"type"];
    }
    [self postHttpWithDic:parameters urlStr:URL_GetNoticeListInfo signAddValue:nil success:success fail:fail];
}

/**
 * 获取未读消息数量
 */
- (void)getUnreadNoticeNumWithSuccess:(void (^)(NSDictionary *resultDic))success
                                 fail:(void (^)(NSString *description))fail
{
    
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    [self postHttpWithDic:parameters urlStr:URL_GetUnreadNoticeNum signAddValue:nil success:success fail:fail];
}

#pragma mark -个人中心
/**
 * 更新用户信息
 */
- (void)updateUserInfoWithUserId:(NSString *)user_id
                      user_photo:(NSString *)user_photo
                       nick_name:(NSString *)nick_name
                         signStr:(NSString *)signStr
                             sex:(NSString *)sex
                          mobile:(NSString *)mobile
            withdrawals_password:(NSString *)withdrawals_password//提现密码
                    old_password:(NSString *)old_password//原密码
                        password:(NSString *)password//登录密码
                          msg_id:(NSString *)msg_id
                        msg_code:(NSString *)msg_code
                         success:(void (^)(NSDictionary *resultDic))success
                            fail:(void (^)(NSString *description))fail
{
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    
    if (user_id) {
        [parameters setObject:user_id forKey:@"user_id"];
    }
    if (user_photo) {
        [parameters setObject:user_photo forKey:@"user_photo"];
    }
    if (nick_name) {
        [parameters setObject:nick_name forKey:@"nick_name"];
    }
    if (signStr) {
        [parameters setObject:signStr forKey:@"personal_sign"];
    }
    if (sex) {
        [parameters setObject:sex forKey:@"sex"];
    }
    if (mobile) {
        [parameters setObject:mobile forKey:@"mobile"];
    }
    if (withdrawals_password) {
        [parameters setObject:withdrawals_password forKey:@"withdrawals_password"];
    }
    if (old_password) {
        NSString *pwd = [Tool encodeUsingMD5ByString:old_password letterCaseOption:LowerLetter];
        pwd = [Tool encodeUsingMD5ByString:pwd letterCaseOption:LowerLetter];
        pwd = [Tool encodeUsingMD5ByString:pwd letterCaseOption:LowerLetter];
        [parameters setObject:pwd forKey:@"old_password"];
        
    }
    if (password) {
        [parameters setObject:password forKey:@"password"];
    }
    if (msg_id) {
        [parameters setObject:msg_id forKey:@"msg_id"];
    }
    if (msg_code) {
        [parameters setObject:msg_code forKey:@"msg_code"];
    }
    [self postHttpWithDic:parameters urlStr:URL_UpdateUserInfo signAddValue:nil success:success fail:fail];
}


/*
 * 获取用户信息
 */

- (void)getUserInfoWithUserId:(NSString *)user_id
                      success:(void (^)(NSDictionary *resultDic))success
                         fail:(void (^)(NSString *description))fail
{
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    
    if (user_id) {
        [parameters setObject:user_id forKey:@"user_id"];
    }
    
    [self postHttpWithDic:parameters urlStr:URL_GetUserInfo signAddValue:nil success:success fail:fail];
}


/*
 * 获取充值信记录
 */

- (void)getCZRecordListInfoWithUserId:(NSString *)user_id
                              page_no:(NSString *)page_no
                            page_size:(NSString *)page_size
                              success:(void (^)(NSDictionary *resultDic))success
                                 fail:(void (^)(NSString *description))fail
{
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    
    if (user_id) {
        [parameters setObject:user_id forKey:@"user_id"];
    }
    if (page_no) {
        [parameters setObject:page_no forKey:@"page_no"];
    }
    if (page_size) {
        [parameters setObject:page_size forKey:@"page_size"];
    }
    [parameters setObject:@"2" forKey:@"type"];
    
    [self postHttpWithDic:parameters urlStr:URL_GetCZRecordListInfo signAddValue:nil success:success fail:fail];
}

/*
 * 提现
 */

- (void)putTXInfoWithUserId:(NSString *)user_id
                        fee:(NSString *)fee
       withdrawals_password:(NSString *)withdrawals_password
                    success:(void (^)(NSDictionary *resultDic))success
                       fail:(void (^)(NSString *description))fail
{
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    
    if (user_id) {
        [parameters setObject:user_id forKey:@"user_id"];
    }
    if (fee) {
        [parameters setObject:fee forKey:@"fee"];
    }
    if (withdrawals_password) {
        NSString *pwd = [Tool encodeUsingMD5ByString:withdrawals_password letterCaseOption:LowerLetter];
        pwd = [Tool encodeUsingMD5ByString:pwd letterCaseOption:LowerLetter];
        pwd = [Tool encodeUsingMD5ByString:pwd letterCaseOption:LowerLetter];
        [parameters setObject:pwd forKey:@"withdrawals_password"];
    }
    NSString *str = [NSString stringWithFormat:@"%@,%@",[parameters objectForKey:@"withdrawals_password"],fee];
    [self postHttpWithDic:parameters urlStr:URL_TiXian signAddValue:str success:success fail:fail];
}


/*
 * 获取提现记录
 */

- (void)getTXRecordListInfoWithUserId:(NSString *)user_id
                              page_no:(NSString *)page_no
                            page_size:(NSString *)page_size
                              success:(void (^)(NSDictionary *resultDic))success
                                 fail:(void (^)(NSString *description))fail
{
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    
    if (user_id) {
        [parameters setObject:user_id forKey:@"user_id"];
    }
    if (page_no) {
        [parameters setObject:page_no forKey:@"page_no"];
    }
    if (page_size) {
        [parameters setObject:page_size forKey:@"page_size"];
    }
    
    [self postHttpWithDic:parameters urlStr:URL_GetTXRecordListInfo signAddValue:nil success:success fail:fail];
}

/*
 * 获取提现提示
 */

- (void)getTXWarnInfoWithUserId:(NSString *)user_id
                        success:(void (^)(NSDictionary *resultDic))success
                           fail:(void (^)(NSString *description))fail
{
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    
    if (user_id) {
        [parameters setObject:user_id forKey:@"user_id"];
    }
    [self postHttpWithDic:parameters urlStr:URL_TiXianWarn signAddValue:nil success:success fail:fail];
}


/*
 * 账变记录
 */

- (void)getZBRecordListInfoWithUserId:(NSString *)user_id
                              page_no:(NSString *)page_no
                            page_size:(NSString *)page_size
                              success:(void (^)(NSDictionary *resultDic))success
                                 fail:(void (^)(NSString *description))fail
{
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    
    if (user_id) {
        [parameters setObject:user_id forKey:@"user_id"];
    }
    if (page_no) {
        [parameters setObject:page_no forKey:@"page_no"];
    }
    if (page_size) {
        [parameters setObject:page_size forKey:@"page_size"];
    }
    [self postHttpWithDic:parameters urlStr:URL_GetZBRecordListInfo signAddValue:nil success:success fail:fail];
}

/*
 * 游戏记录
 */

- (void)getYXRecordListInfoWithUserId:(NSString *)user_id
                              page_no:(NSString *)page_no
                            page_size:(NSString *)page_size
                            game_type:(NSString *)game_type
                           start_time:(NSString *)start_time
                             end_time:(NSString *)end_time
                              room_id:(NSString *)room_id
                              success:(void (^)(NSDictionary *resultDic))success
                                 fail:(void (^)(NSString *description))fail
{
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    
    if (user_id) {
        [parameters setObject:user_id forKey:@"user_id"];
    }
    if (page_no) {
        [parameters setObject:page_no forKey:@"page_no"];
    }
    if (page_size) {
        [parameters setObject:page_size forKey:@"page_size"];
    }
    if (game_type) {
        [parameters setObject:game_type forKey:@"game_type"];
    }
    if (start_time) {
        [parameters setObject:start_time forKey:@"start_time"];
    }
    if (end_time) {
        [parameters setObject:end_time forKey:@"end_time"];
    }
    if (room_id) {
        [parameters setObject:room_id forKey:@"room_id"];
    }
    [self postHttpWithDic:parameters urlStr:URL_GetYXRecordListInfo signAddValue:nil success:success fail:fail];
}

/*
 * 绑定银行卡
 */

- (void)bangdingBankWithUserId:(NSString *)user_id
          withdrawals_password:(NSString *)withdrawals_password
                     real_name:(NSString *)real_name
                     bank_name:(NSString *)bank_name
                       bank_no:(NSString *)bank_no
             open_card_address:(NSString *)open_card_address
                       success:(void (^)(NSDictionary *resultDic))success
                          fail:(void (^)(NSString *description))fail
{
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    
    if (user_id) {
        [parameters setObject:user_id forKey:@"user_id"];
    }
    if (withdrawals_password) {
        NSString *pwd = [Tool encodeUsingMD5ByString:withdrawals_password letterCaseOption:LowerLetter];
        pwd = [Tool encodeUsingMD5ByString:pwd letterCaseOption:LowerLetter];
        pwd = [Tool encodeUsingMD5ByString:pwd letterCaseOption:LowerLetter];
        [parameters setObject:pwd forKey:@"withdrawals_password"];
    }
    if (real_name) {
        [parameters setObject:real_name forKey:@"real_name"];
    }
    if (bank_name) {
        [parameters setObject:bank_name forKey:@"bank_name"];
    }
    if (bank_no) {
        [parameters setObject:bank_no forKey:@"bank_no"];
    }
    if (open_card_address) {
        [parameters setObject:open_card_address forKey:@"open_card_address"];
    }
    [self postHttpWithDic:parameters urlStr:URL_BankBangding signAddValue:[parameters objectForKey:@"withdrawals_password"] success:success fail:fail];
}

/*
 * 礼物列表
 */
- (void)getGiftListInfoWithPage_no:(NSString *)page_no
                         page_size:(NSString *)page_size
                           success:(void (^)(NSDictionary *resultDic))success
                              fail:(void (^)(NSString *description))fail
{
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    
    if (page_no) {
        [parameters setObject:page_no forKey:@"page_no"];
    }
    if (page_size) {
        [parameters setObject:page_size forKey:@"page_size"];
    }
    [self postHttpWithDic:parameters urlStr:URL_GiftList signAddValue:nil success:success fail:fail];
}

/*
 * 兑换礼物
 */
- (void)exchangeGiftWithIdStr:(NSString *)gift_id
                   gift_count:(NSString *)gift_count
                      address:(NSString *)address
                      user_id:(NSString *)user_id
                      success:(void (^)(NSDictionary *resultDic))success
                         fail:(void (^)(NSString *description))fail
{
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    
    if (gift_id) {
        [parameters setObject:gift_id forKey:@"gift_id"];
    }
    if (gift_count) {
        [parameters setObject:gift_count forKey:@"gift_count"];
    }
    if (address) {
        [parameters setObject:address forKey:@"address"];
    }
    if (user_id) {
        [parameters setObject:user_id forKey:@"user_id"];
    }
    [self postHttpWithDic:parameters urlStr:URL_ExchangeGift signAddValue:gift_count success:success fail:fail];
}

/*
 * 兑换记录
 */
- (void)getExchangeGiftRecordWithIdStr:(NSString *)user_id
                               page_no:(NSString *)page_no
                             page_size:(NSString *)page_size
                               success:(void (^)(NSDictionary *resultDic))success
                                  fail:(void (^)(NSString *description))fail
{
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    
    if (user_id) {
        [parameters setObject:user_id forKey:@"user_id"];
    }
    if (page_no) {
        [parameters setObject:page_no forKey:@"page_no"];
    }
    if (page_size) {
        [parameters setObject:page_size forKey:@"page_size"];
    }
    [self postHttpWithDic:parameters urlStr:URL_ExchangeGiftRecord signAddValue:nil success:success fail:fail];
}

/*
 * 回水记录
 */
- (void)getHuiShuiRecordWithIdStr:(NSString *)user_id
                          page_no:(NSString *)page_no
                        page_size:(NSString *)page_size
                             type:(NSString *)type //1初级 2中级 3 高级
                          success:(void (^)(NSDictionary *resultDic))success
                             fail:(void (^)(NSString *description))fail
{
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    
    if (user_id) {
        [parameters setObject:user_id forKey:@"user_id"];
    }
    if (page_no) {
        [parameters setObject:page_no forKey:@"page_no"];
    }
    if (page_size) {
        [parameters setObject:page_size forKey:@"page_size"];
    }
    if (type) {
        [parameters setObject:type forKey:@"type"];
    }
    [self postHttpWithDic:parameters urlStr:URL_HuiShuiRecord signAddValue:nil success:success fail:fail];
}

/*
 * 我的收益
 */
- (void)getMyShouYiRecordWithIdStr:(NSString *)user_id
                           page_no:(NSString *)page_no
                         page_size:(NSString *)page_size
                           success:(void (^)(NSDictionary *resultDic))success
                              fail:(void (^)(NSString *description))fail
{
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    
    if (user_id) {
        [parameters setObject:user_id forKey:@"user_id"];
    }
    if (page_no) {
        [parameters setObject:page_no forKey:@"page_no"];
    }
    if (page_size) {
        [parameters setObject:page_size forKey:@"page_size"];
    }
    
    [self postHttpWithDic:parameters urlStr:URL_GetMyShouYi signAddValue:nil success:success fail:fail];
}

#pragma mark - 获取公共资源

/**
 * 获取验证码
 */
- (void)getVerificationCodeByMobile:(NSString *)mobile
                            success:(void (^)(NSDictionary *resultDic))success
                               fail:(void (^)(NSString *description))fail
{
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    
    if (mobile) {
        [parameters setObject:mobile forKey:@"phone"];
    }
    
    [self postHttpWithDic:parameters urlStr:URL_GetVerificationCode  signAddValue:nil success:success fail:fail];
}

/**
 * 获取banner
 * place   1  app首页  其他待定
 */
- (void)getBannerInfoByPlace:(NSString *)place
                            success:(void (^)(NSDictionary *resultDic))success
                               fail:(void (^)(NSString *description))fail
{
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    
    if (place) {
        [parameters setObject:place forKey:@"place"];
    }
    
    [self postHttpWithDic:parameters urlStr:URL_GeBannerInfo  signAddValue:nil success:success fail:fail];
}

/**
 * 绑定手机号
 */
- (void)bangdingPhoneWithMobile:(NSString *)mobile
                        user_id:(NSString *)user_id
                         msg_id:(NSString *)msg_id
                       msg_code:(NSString *)msg_code
                     success:(void (^)(NSDictionary *resultDic))success
                        fail:(void (^)(NSString *description))fail
{
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    
    if (mobile) {
        [parameters setObject:mobile forKey:@"mobile"];
    }
    if (user_id) {
        [parameters setObject:user_id forKey:@"user_id"];
    }
    if (msg_id) {
        [parameters setObject:msg_id forKey:@"msg_id"];
    }
    if (msg_code) {
        [parameters setObject:msg_code forKey:@"msg_code"];
    }
    [self postHttpWithDic:parameters urlStr:URL_BangDingPhone  signAddValue:nil success:success fail:fail];
}

#pragma mark -  get请求 底层 post数据请求和图片上传
/**
 * Post请求数据
 */
- (void)postHttpWithDic:(NSMutableDictionary *)jsParameters
                 urlStr:(NSString *)urlStr
           signAddValue:(NSString *)signAddValue
                success:(void (^)(NSDictionary *resultDic))success //成功
                   fail:(void (^)(NSString *description))fail      //失败
{
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    [manager.requestSerializer willChangeValueForKey:@"timeoutInterval"];
    manager.requestSerializer.timeoutInterval = 10.f;
    [manager.requestSerializer didChangeValueForKey:@"timeoutInterval"];
    
//    //https请求
//    NSString *cerPath    = [[NSBundle mainBundle] pathForResource:@"putian.h5h5h5.cn" ofType:@"cer"];
//    NSData *certData     = [NSData dataWithContentsOfFile:cerPath];
//    AFSecurityPolicy *securityPolicy = [AFSecurityPolicy policyWithPinningMode:AFSSLPinningModeCertificate];
//    [securityPolicy setAllowInvalidCertificates:NO];
//    [securityPolicy setPinnedCertificates:@[certData]];
//    [securityPolicy setValidatesDomainName:YES];
//    manager.securityPolicy = securityPolicy;
//    [manager.securityPolicy setAllowInvalidCertificates:YES];
    
    //时间戳
    NSString *currentTime = [Tool getCurrentTimeWithFormat:@"yyyy-MM-dd HH:mm:ss"];
    [jsParameters setObject:currentTime forKey:@"timestamp"];
    
    //用户id
    NSString *useridStr = nil;
    if ([ShareManager shareInstance].userinfo
        && [ShareManager shareInstance].userinfo.islogin
        && [ShareManager shareInstance].userinfo.id.length > 0
        && ![[ShareManager shareInstance].userinfo.id isEqualToString:@"<null>"]
        && [ShareManager shareInstance].userinfo.id) {
        useridStr = [ShareManager shareInstance].userinfo.id;
    }else{
        useridStr = @"0";
    }
    [jsParameters setObject:useridStr forKey:@"user_id"];

    //签名
    NSString *signStr = nil;
    if (signAddValue) {
        signStr = [NSString stringWithFormat:@"%@,%@,%@,%@",HttpSecret,currentTime,useridStr,signAddValue];
    }else{
        signStr = [NSString stringWithFormat:@"%@,%@,%@",HttpSecret,currentTime,useridStr];
    }
    NSString *str = [SecurityUtil encodeBase64Data:[SecurityUtil encryptAES128Data:signStr]];
    NSString *signResultStr = [Tool encodeUsingMD5ByString:str letterCaseOption:LowerLetter];
    signResultStr = [Tool encodeUsingMD5ByString:signResultStr letterCaseOption:LowerLetter];
    [jsParameters setObject:signResultStr forKey:@"sign"];

    NSLog(@"json = %@",jsParameters);
    
     NSData *jsData = [NSJSONSerialization dataWithJSONObject:jsParameters  options:NSJSONWritingPrettyPrinted error:nil];
    NSString *aString = [[NSString alloc] initWithData:jsData encoding:NSUTF8StringEncoding];
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setObject:aString forKey:@"param"];
    
    NSString *URLString = [self getURLbyKey:urlStr];
    [manager POST:URLString parameters:params constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
        
    } progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        if(responseObject)
        {
            if (success) {
                success((NSDictionary *)responseObject);
                NSLog(@"result = %@",responseObject);
            }
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        if (fail) {
            NSLog(@"error:%@",error);
            fail(@"网络请求失败了");
        }
    }];
}

/**
 * 拼接:URL_Server+keyURL
 */
- (NSString *)getURLbyKey:(NSString *)URLKey{
    
    return [NSMutableString stringWithFormat:@"%@%@", URL_Server, URLKey];
}



/**
 *获取公共资源 get请求
 */

- (void)getHttpWithUrlStr:(NSString *)urlStr
                  success:(void (^)(NSDictionary *resultDic))success
                     fail:(void (^)(NSString *description))fail
{
    [self postHttpWithDic:[NSMutableDictionary dictionary] urlStr:urlStr signAddValue:nil success:success fail:fail];
}



/**
 * Post 上传图片
 */
- (void)postImageHttpWithImage:(UIImage*)image
                       success:(void (^)(NSDictionary *resultDic))success
                          fail:(void (^)(NSString *description))fail
{
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    
    //时间戳
    NSString *currentTime = [Tool getCurrentTimeWithFormat:@"yyyy-MM-dd HH:mm:ss"];
    [params setObject:currentTime forKey:@"timestamp"];
    
    //用户id
    NSString *useridStr = nil;
    if ([ShareManager shareInstance].userinfo
        && [ShareManager shareInstance].userinfo.islogin
        && [ShareManager shareInstance].userinfo.id.length > 0
        && [[ShareManager shareInstance].userinfo.id isEqualToString:@"<null>"]
        && [ShareManager shareInstance].userinfo.id) {
        useridStr = [ShareManager shareInstance].userinfo.id;
    }else{
        useridStr = @"0";
    }
    [params setObject:useridStr forKey:@"user_id"];
    
    //图片所属
    [params setValue:[NSString stringWithFormat:@"%@_img",useridStr] forKey:@"business_type"];
    
    //签名
    NSString *signStr = [NSString stringWithFormat:@"%@,%@,%@",HttpSecret,currentTime,useridStr];
    NSString *str = [SecurityUtil encodeBase64Data:[SecurityUtil encryptAES128Data:signStr]];
    NSString *signResultStr = [Tool encodeUsingMD5ByString:str letterCaseOption:LowerLetter];
    signResultStr = [Tool encodeUsingMD5ByString:signResultStr letterCaseOption:LowerLetter];
    [params setObject:signResultStr forKey:@"sign"];
    

    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    [manager.requestSerializer willChangeValueForKey:@"timeoutInterval"];
    manager.requestSerializer.timeoutInterval = 10.f;
    [manager.requestSerializer didChangeValueForKey:@"timeoutInterval"];

    
    NSData *jsData = [NSJSONSerialization dataWithJSONObject:params  options:NSJSONWritingPrettyPrinted error:nil];
    NSString *aString = [[NSString alloc] initWithData:jsData encoding:NSUTF8StringEncoding];
    NSMutableDictionary *paramsall = [NSMutableDictionary dictionary];
    [paramsall setObject:aString forKey:@"param"];
    
    NSString *url = [self getURLbyKey:URL_UpdateImageUrl];
    
    
    [manager POST:url parameters:paramsall constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
        if(image)
        {
            NSData *imageData = UIImageJPEGRepresentation(image,0.5);
            [formData appendPartWithFileData:imageData name:@"myfiles" fileName:@"111.jpg" mimeType:@"image/jpg"];
        }
    } progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        if(responseObject)
        {
            if (success) {
                success((NSDictionary *)responseObject);
            }
        }
        
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        if (fail) {
            fail(@"网络请求失败了");
        }
        
    }];
    
}

@end
