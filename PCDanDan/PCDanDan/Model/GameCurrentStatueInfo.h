//
//  GameCurrentStatueInfo.h
//  PCDanDan
//
//  Created by linqsh on 17/2/19.
//  Copyright © 2017年 vma-lin. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GameHistoryListInfo : NSObject
@property (nonatomic, strong) NSString *id;
@property (nonatomic, strong) NSString *user_id;
@property (nonatomic, strong) NSString *game_type;
@property (nonatomic, strong) NSString *open_time;//   开奖时间
@property (nonatomic, strong) NSString *game_num;//    游戏期数
@property (nonatomic, strong) NSString *game_result;//    游戏结果
@property (nonatomic, strong) NSString *game_result_desc;//  游戏结果（式子）
@property (nonatomic, strong) NSString *result_type;//大,单",
@property (nonatomic, strong) NSString *color ;// 1红 2绿 3蓝 4无
@end

@interface GameCurrentStatueInfo : NSObject

@property (nonatomic, strong) NSMutableArray *open_time;
@property (nonatomic, assign) double point;//      余额
@property (nonatomic, assign) NSInteger seconds;  //    倒计时 单位秒
@property (nonatomic, strong) NSString *game_num;// 最近开奖期数
@property (nonatomic, strong) GameHistoryListInfo *first_result;

@property (nonatomic, strong) NSString *status; //1正常 2封盘 3停售

@property (nonatomic, assign) double per_max_point;//个人下注上限
@property (nonatomic, assign) double per_min_point;//   个人下注下限
@property (nonatomic, assign) double all_max_point;//         房间下注总额上限

@end
