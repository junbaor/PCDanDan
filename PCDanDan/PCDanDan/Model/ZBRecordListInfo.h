//
//  ZBRecordListInfo.h
//  PCDanDan
//
//  Created by linqsh on 17/2/21.
//  Copyright © 2017年 vma-lin. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ZBRecordListInfo : NSObject
@property (nonatomic, strong) NSString *id;
@property (nonatomic, strong) NSString *user_id;
@property (nonatomic, assign) double point;//          变动金额
@property (nonatomic, strong) NSString *point_desc;//     变动记录
@property (nonatomic, strong) NSString *create_time;// 变动时间


@end
