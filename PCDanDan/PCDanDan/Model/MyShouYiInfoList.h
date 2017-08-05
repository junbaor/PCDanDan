//
//  MyShouYiInfoList.h
//  PCDanDan
//
//  Created by linqsh on 2017/4/2.
//  Copyright © 2017年 vma-lin. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MyShouYiInfoList : NSObject

@property (nonatomic, strong) NSString *id;
@property (nonatomic, strong) NSString *user_id;
@property (nonatomic, assign) double point;//      累计投注金额
@property (nonatomic, strong) NSString *fenxiao_point;//       佣金
@property (nonatomic, strong) NSString *status;
@property (nonatomic, strong) NSString *zuhe_point;
@property (nonatomic, assign) int point_num;//  累计次数
@property (nonatomic, strong) NSString *get_point;
@property (nonatomic, strong) NSString *xhibit_point;
@property (nonatomic, strong) NSString *fenxiao_user_id;
@property (nonatomic, strong) NSString *create_time;//日期
@property (nonatomic, strong) NSString *nick_name;
@end
