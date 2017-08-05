//
//  ZZRecordInfo.h
//  PCDanDan
//
//  Created by linqsh on 17/2/27.
//  Copyright © 2017年 vma-lin. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ZhuanZhangAccountInfo.h"

@interface ZZRecordInfo : NSObject

@property (nonatomic, strong) NSString *id;
@property (nonatomic, strong) NSString *account;
@property (nonatomic, strong) NSString *account_type;//1银行卡  2支付宝
@property (nonatomic, strong) NSString *real_name;
@property (nonatomic, strong) NSString *bank_name;
@property (nonatomic, assign) double point;   //     转账金额
@property (nonatomic, strong) NSString *status;//        0待确认 1确认收到  2未收到
@property (nonatomic, strong) NSString *create_time;//
@property (nonatomic, strong) NSString *user_id;
@property (nonatomic, strong) NSString *add_type;
@property (nonatomic, strong) ZhuanZhangAccountInfo *account_info;

@end
