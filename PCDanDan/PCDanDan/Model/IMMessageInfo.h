//
//  IMMessageInfo.h
//  PCDanDan
//
//  Created by xcode.qi on 17/1/19.
//  Copyright © 2017年 li. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface IMMessageInfo : NSObject
@property (nonatomic, strong) NSString *notice_type;//1进出房间消息   2下注  3开奖信息  4封盘信息 5、开盘
@property (nonatomic, strong) NSString *game_count;
@property (nonatomic, strong) NSString *game_type;
@property (nonatomic, assign) double point;//金额
@property (nonatomic, assign) double seconds;//倒计时数
@property (nonatomic, strong) NSString *im_account;
@property (nonatomic, strong) NSString *nick_name;
@property (nonatomic, strong) NSString *user_photo;
@property (nonatomic, strong) NSString *ext_content;
@property (nonatomic, strong) NSString *create_time;
@property (nonatomic, strong) NSString *bili_id;
@property (nonatomic, assign) int level;
@end
