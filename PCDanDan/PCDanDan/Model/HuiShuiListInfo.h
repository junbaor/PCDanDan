//
//  HuiShuiListInfo.h
//  PCDanDan
//
//  Created by linqsh on 17/2/26.
//  Copyright © 2017年 vma-lin. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HuiShuiListInfo : NSObject

@property (nonatomic, strong) NSString *id;
@property (nonatomic, strong) NSString *type;
@property (nonatomic, strong) NSString *user_id;
@property (nonatomic, strong) NSString *point;//  当天下注金额
@property (nonatomic, assign) double bili;//        回水比例
@property (nonatomic, assign) double hui_shui_point;//   回水金额
@property (nonatomic, strong) NSString *status;//    0待处理 1处理 2未满足
@property (nonatomic, strong) NSString *create_time;


@end
