//
//  DuiHuanRecordInfo.h
//  PCDanDan
//
//  Created by linqsh on 17/2/26.
//  Copyright © 2017年 vma-lin. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DuiHuanRecordInfo : NSObject

@property (nonatomic, strong) NSString *id;
@property (nonatomic, strong) NSString *gift_id;
@property (nonatomic, strong) NSString *user_id;
@property (nonatomic, strong) NSString *gift_name;//   礼物名称
@property (nonatomic, strong) NSString *gift_count;//      兑换数量
@property (nonatomic, strong) NSString *status;//        0待处理  1已处理
@property (nonatomic, strong) NSString *create_time;//  提交时间
@property (nonatomic, assign) double point;//        消耗积分
@property (nonatomic, assign) double gift_point;//    单件积分


@end
