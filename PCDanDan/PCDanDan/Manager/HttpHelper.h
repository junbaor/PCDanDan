//
//  HttpHelper.h
//  PCDanDan
//
//  Created by xcode.qi on 17/1/19.
//  Copyright © 2017年 li. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HttpHelper : NSObject

#pragma mark - 公共资源
/**
 *获取公共资源 get请求
 */

- (void)getHttpWithUrlStr:(NSString *)urlStr
                  success:(void (^)(NSDictionary *resultDic))success
                     fail:(void (^)(NSString *description))fail;

/**
 * 获取验证码
 * place   1  app首页  其他待定
 */
- (void)getBannerInfoByPlace:(NSString *)place
                     success:(void (^)(NSDictionary *resultDic))success
                        fail:(void (^)(NSString *description))fail;

/**
 * 获取验证码
 */
- (void)getVerificationCodeByMobile:(NSString *)mobile
                            success:(void (^)(NSDictionary *resultDic))success
                               fail:(void (^)(NSString *description))fail;

/**
 * Post 上传图片
 */
- (void)postImageHttpWithImage:(UIImage*)image
                       success:(void (^)(NSDictionary *resultDic))success
                          fail:(void (^)(NSString *description))fail;

/**
 * 绑定手机号
 */
- (void)bangdingPhoneWithMobile:(NSString *)mobile
                        user_id:(NSString *)user_id
                         msg_id:(NSString *)msg_id
                       msg_code:(NSString *)msg_code
                        success:(void (^)(NSDictionary *resultDic))success
                           fail:(void (^)(NSString *description))fail;

#pragma mark - 注册登录

/**
 * 注册
 */
- (void)resigterAccountWithAccount:(NSString *)account
                          password:(NSString *)password
                              code:(NSString *)code
                   registration_id:(NSString *)registration_id
                           success:(void (^)(NSDictionary *resultDic))success
                              fail:(void (^)(NSString *description))fail;

/**
 * 登录
 */
- (void)loginWithAccount:(NSString *)account
                password:(NSString *)password
         registration_id:(NSString *)registration_id
                 success:(void (^)(NSDictionary *resultDic))success
                    fail:(void (^)(NSString *description))fail;

/**
 * 第三方登录
 */
- (void)loginOfThirdWithBandId:(NSString *)band_id
                     band_type:(NSString *)band_type
               registration_id:(NSString *)registration_id
                     nick_name:(NSString *)nick_name
                    user_photo:(NSString *)user_photo
                       success:(void (^)(NSDictionary *resultDic))success
                          fail:(void (^)(NSString *description))fail;

/**
 * 忘记密码
 */
- (void)forgetPwdWithAccount:(NSString *)account
                      mobile:(NSString *)mobile
                    password:(NSString *)password
                      msg_id:(NSString *)msg_id
                    msg_code:(NSString *)msg_code
                     success:(void (^)(NSDictionary *resultDic))success
                        fail:(void (^)(NSString *description))fail;



#pragma mark - 首页

/**
 * 版本检测接口
 */
- (void)checkVersionWithClientNo:(NSString *)client_no
                         success:(void (^)(NSDictionary *resultDic))success
                            fail:(void (^)(NSString *description))fail;

/**
 * 获取首页数据
 */
- (void)getHomePageDataWithSuccess:(void (^)(NSDictionary *resultDic))success
                              fail:(void (^)(NSString *description))fail;

/**
 * 获取房间区域
 * game_type" : "1"     1北京28   2加拿大28
 */
- (void)getGameHouseAreaListWithType:(NSString *)game_type
                             success:(void (^)(NSDictionary *resultDic))success
                                fail:(void (^)(NSString *description))fail;

/**
 * 获取房间列表
 * game_type" : "1"     1北京28   2加拿大28
 */
- (void)getGameHouseListWithType:(NSString *)game_type
                         area_id:(NSString *)area_id
                         success:(void (^)(NSDictionary *resultDic))success
                            fail:(void (^)(NSString *description))fail;

/**
 * 加入房间
 */
- (void)joinGameRoomWithRoomId:(NSString *)room_id
                       user_id:(NSString *)user_id
                      password:(NSString *)password
                       success:(void (^)(NSDictionary *resultDic))success
                          fail:(void (^)(NSString *description))fail;

/**
 * 通知服务器已加入房间
 */
- (void)putNotifSeverJoinRoomWithRoomId:(NSString *)room_id
                                user_id:(NSString *)user_id
                                success:(void (^)(NSDictionary *resultDic))success
                                   fail:(void (^)(NSString *description))fail;

/**
 * 离开房间
 */
- (void)leaveGameRoomWithRoomId:(NSString *)room_id
                        user_id:(NSString *)user_id
                        success:(void (^)(NSDictionary *resultDic))success
                           fail:(void (^)(NSString *description))fail;

/**
 * 获取下注比例
 * game_type   1北京快乐8 2加拿大快乐8
 */
- (void)getGameBiliWithGameType:(NSString *)game_type
                        area_id:(NSString *)area_id
                        success:(void (^)(NSDictionary *resultDic))success
                           fail:(void (^)(NSString *description))fail;

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
                           fail:(void (^)(NSString *description))fail;

/**
 * 获取倒计时和最近10期开奖记录
 * game_type   1北京快乐8 2加拿大快乐8
 */
- (void)getDJSAndHistoryWithGameType:(NSString *)game_type
                             user_id:(NSString *)user_id
                             room_id:(NSString *)room_id
                             success:(void (^)(NSDictionary *resultDic))success
                                fail:(void (^)(NSString *description))fail;

#pragma mark - 充值
/**
 * 转账账号列表
 */
- (void)getZhuanZhangAccountListWithType:(NSString *)type
                                 success:(void (^)(NSDictionary *resultDic))success
                                    fail:(void (^)(NSString *description))fail;

/**
 * 新增转账记录
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
                                      fail:(void (^)(NSString *description))fail;

/**
 * 转账记录
 */
- (void)zzRecordListInfoWithUserId:(NSString *)user_id
                           page_no:(NSString *)page_no
                         page_size:(NSString *)page_size
                      account_type:(NSString *)account_type
                           success:(void (^)(NSDictionary *resultDic))success
                              fail:(void (^)(NSString *description))fail;

/**
 * 获取订单号
 */
- (void)getOrderNoWithUserId:(NSString *)user_id
                   total_fee:(NSString *)total_fee
                     success:(void (^)(NSDictionary *resultDic))success
                        fail:(void (^)(NSString *description))fail;

/**
 * 获取支付的url
 * pay_type=1支付宝 2微信
 */
- (void)getPayUrlWithUrl:(NSString *)url
                order_no:(NSString *)order_no
                     fee:(NSString *)fee
                pay_type:(NSString *)pay_type
                 success:(void (^)(NSDictionary *resultDic))success
                    fail:(void (^)(NSString *description))fail;

/**
 * 检测是否支付成功
 */
- (void)checkIsPaySuccessWithOrder_no:(NSString *)order_no
                              user_id:(NSString *)user_id
                              success:(void (^)(NSDictionary *resultDic))success
                                 fail:(void (^)(NSString *description))fail;

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
                           fail:(void (^)(NSString *description))fail;

/**
 * 获取未读消息数量
 */
- (void)getUnreadNoticeNumWithSuccess:(void (^)(NSDictionary *resultDic))success
                                 fail:(void (^)(NSString *description))fail;

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
                            fail:(void (^)(NSString *description))fail;

/*
 * 获取用户信息
 */

- (void)getUserInfoWithUserId:(NSString *)user_id
                      success:(void (^)(NSDictionary *resultDic))success
                         fail:(void (^)(NSString *description))fail;

/*
 * 获取充值信记录
 */

- (void)getCZRecordListInfoWithUserId:(NSString *)user_id
                              page_no:(NSString *)page_no
                            page_size:(NSString *)page_size
                              success:(void (^)(NSDictionary *resultDic))success
                                 fail:(void (^)(NSString *description))fail;

/*
 * 提现
 */

- (void)putTXInfoWithUserId:(NSString *)user_id
                        fee:(NSString *)fee
       withdrawals_password:(NSString *)withdrawals_password
                    success:(void (^)(NSDictionary *resultDic))success
                       fail:(void (^)(NSString *description))fail;

/*
 * 获取提现记录
 */

- (void)getTXRecordListInfoWithUserId:(NSString *)user_id
                              page_no:(NSString *)page_no
                            page_size:(NSString *)page_size
                              success:(void (^)(NSDictionary *resultDic))success
                                 fail:(void (^)(NSString *description))fail;

/*
 * 获取提现提示
 */

- (void)getTXWarnInfoWithUserId:(NSString *)user_id
                        success:(void (^)(NSDictionary *resultDic))success
                           fail:(void (^)(NSString *description))fail;

/*
 * 账变记录
 */

- (void)getZBRecordListInfoWithUserId:(NSString *)user_id
                              page_no:(NSString *)page_no
                            page_size:(NSString *)page_size
                              success:(void (^)(NSDictionary *resultDic))success
                                 fail:(void (^)(NSString *description))fail;

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
                                 fail:(void (^)(NSString *description))fail;

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
                          fail:(void (^)(NSString *description))fail;

/*
 * 礼物列表
 */
- (void)getGiftListInfoWithPage_no:(NSString *)page_no
                         page_size:(NSString *)page_size
                           success:(void (^)(NSDictionary *resultDic))success
                              fail:(void (^)(NSString *description))fail;

/*
 * 兑换礼物
 */
- (void)exchangeGiftWithIdStr:(NSString *)gift_id
                   gift_count:(NSString *)gift_count
                      address:(NSString *)address
                      user_id:(NSString *)user_id
                      success:(void (^)(NSDictionary *resultDic))success
                         fail:(void (^)(NSString *description))fail;
/*
 * 兑换记录
 */
- (void)getExchangeGiftRecordWithIdStr:(NSString *)user_id
                               page_no:(NSString *)page_no
                             page_size:(NSString *)page_size
                               success:(void (^)(NSDictionary *resultDic))success
                                  fail:(void (^)(NSString *description))fail;

/*
 * 回水记录
 */
- (void)getHuiShuiRecordWithIdStr:(NSString *)user_id
                          page_no:(NSString *)page_no
                        page_size:(NSString *)page_size
                             type:(NSString *)type //1初级 2中级 3 高级
                          success:(void (^)(NSDictionary *resultDic))success
                             fail:(void (^)(NSString *description))fail;




/*
 * 我的收益
 */
- (void)getMyShouYiRecordWithIdStr:(NSString *)user_id
                           page_no:(NSString *)page_no
                         page_size:(NSString *)page_size
                           success:(void (^)(NSDictionary *resultDic))success
                              fail:(void (^)(NSString *description))fail;



@end
