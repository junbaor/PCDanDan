//
//  CZRecordListInfo.h
//  PCDanDan
//
//  Created by linqsh on 17/2/21.
//  Copyright © 2017年 vma-lin. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CZRecordListInfo : NSObject


@property (nonatomic, assign) double total_fee;//  充值金额
@property (nonatomic, strong) NSString *create_time;//     充值时间
@property (nonatomic, strong) NSString *update_time;
@property (nonatomic, strong) NSString *pay_type;
@property (nonatomic, strong) NSString *status;// 0待确认  1成功
@property (nonatomic, assign) double result_fee;


@end
