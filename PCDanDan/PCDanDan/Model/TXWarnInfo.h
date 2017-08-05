//
//  TXWarnInfo.h
//  PCDanDan
//
//  Created by linqsh on 17/2/26.
//  Copyright © 2017年 vma-lin. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TXWarnInfo : NSObject

@property (nonatomic, assign) double point;//                       余额
@property (nonatomic, assign) int free_count;//                 剩余免费次数
@property (nonatomic, assign) int tixian_free_count;//      每天提现免费次数
@property (nonatomic, assign) double tixian_min_fee;//      提现最低额度
@property (nonatomic, assign) double tixian_bili;//       提现比例 0.2 表示 20%

@end
