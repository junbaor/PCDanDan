//
//  UserInfo.h
//  PCDanDan
//
//  Created by xcode.qi on 17/1/17.
//  Copyright © 2017年 li. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UserInfo : NSObject
@property (nonatomic, assign) BOOL islogin;   //是否登录
@property (nonatomic, strong) NSString * id;   //是否登录

@property (nonatomic, strong) NSString *password;
@property (nonatomic, strong) NSString * account;//    帐号
@property (nonatomic, strong) NSString * user_photo;
@property (nonatomic, strong) NSString * nick_name;//   昵称
@property (nonatomic, strong) NSString * sex;//    性别 1男2女
@property (nonatomic, strong) NSString * mobile;//       绑定电话
@property (nonatomic, assign) double point;//         余额
@property (nonatomic, strong) NSString * create_time;//  注册时间
@property (nonatomic, strong) NSString * band_id;
@property (nonatomic, strong) NSString * band_type;// 绑定类型 2微信  3qq
@property (nonatomic, strong) NSString * registration_id;
@property (nonatomic, strong) NSString * im_account;//      环信帐号
@property (nonatomic, strong) NSString * level;
@property (nonatomic, strong) NSString * level_name;//        会员名称
@property (nonatomic, strong) NSString * user_type;
@property (nonatomic, strong) NSString * login_time;
@property (nonatomic, strong) NSString * personal_sign;
@property (nonatomic, strong) NSString * withdrawals_password;//       提现密码
@property (nonatomic, strong) NSString * real_name;//         开户姓名
@property (nonatomic, strong) NSString * bank_name;//      银行名称
@property (nonatomic, strong) NSString * bank_no;// 银行卡号
@property (nonatomic, strong) NSString * open_card_address;//    开户地址

@end
