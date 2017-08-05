//
//  GameRecordListInfo.h
//  PCDanDan
//
//  Created by linqsh on 17/2/21.
//  Copyright © 2017年 vma-lin. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GameRecordListInfo : NSObject

@property (nonatomic, strong) NSString *id;
@property (nonatomic, strong) NSString *user_id;
@property (nonatomic, strong) NSString *choice_no;//  期数
@property (nonatomic, strong) NSString *choice_result;//0,1,2,3,4,5,6,7,8,9,10,11,12,13",
@property (nonatomic, strong) NSString *choice_name;//       投注类型
@property (nonatomic, strong) NSString *bili;//
@property (nonatomic, assign) double point;//    投注金额
@property (nonatomic, strong) NSString *real_result;
@property (nonatomic, strong) NSString *result_type;
@property (nonatomic, assign) double get_point;//   中奖金额
@property (nonatomic, strong) NSString *create_time;//   下注时间
@property (nonatomic, strong) NSString *game_type;//  1北京快8   2加拿大
@property (nonatomic, strong) NSString *is_zhong;//     是否中奖 -1待开奖 1中奖 0未中
@property (nonatomic, strong) NSString *bili_id;


@end
