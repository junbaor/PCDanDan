//
//  ShareRuleInfo.h
//  PCDanDan
//
//  Created by linqsh on 2017/4/2.
//  Copyright © 2017年 vma-lin. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ShareRuleListInfo : NSObject
@property (nonatomic, strong) NSString *id;
@property (nonatomic, strong) NSString *level;//    等级
@property (nonatomic, strong) NSString *start_point;//   起始金额
@property (nonatomic, strong) NSString *end_point;// 截止金额
@property (nonatomic, strong) NSString *get_point;//    获取佣金
@property (nonatomic, strong) NSString *create_time;

@end

@interface ShareRuleInfo : NSObject
@property (nonatomic, assign) int num;
@property (nonatomic, strong) NSString *share_url;
@property (nonatomic, strong) NSMutableArray *bili_list;
@end
