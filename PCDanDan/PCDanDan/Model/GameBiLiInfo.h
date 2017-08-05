//
//  GameBiLiInfo.h
//  PCDanDan
//
//  Created by xcode.qi on 17/1/19.
//  Copyright © 2017年 li. All rights reserved.
//


#import <Foundation/Foundation.h>
@interface GameBiLiListInfo : NSObject
@property (nonatomic, assign) double bili ;
@property (nonatomic, strong) NSString *bili_name;
@property (nonatomic, strong) NSString *bili_type;
@property (nonatomic, strong) NSString *game_type;
@property (nonatomic, strong) NSString *id ;
@property (nonatomic, strong) NSString *result;
@property (nonatomic, assign) double min_point;
@property (nonatomic, assign) double max_point;
@end

@interface GameBiLiInfo : NSObject

@property (nonatomic, strong) NSMutableArray *da_xiao;
@property (nonatomic, strong) NSMutableArray *shu_zi;
@property (nonatomic, strong) NSMutableArray *te_shu;
@end
