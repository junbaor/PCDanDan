//
//  HouseAreaListInfo.h
//  PCDanDan
//
//  Created by xcode.qi on 17/1/19.
//  Copyright © 2017年 li. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HouseAreaListInfo : NSObject

@property (nonatomic, strong) NSString *id;
@property (nonatomic, strong) NSString *game_type;
@property (nonatomic, strong) NSString *area_type;
@property (nonatomic, strong) NSString *area_name;//初级房",
@property (nonatomic, strong) NSString *area_photo;//图片 全路径
@property (nonatomic, strong) NSString *feedback_desc;//高赔率 1%回水",
@property (nonatomic, assign) double min_point;
@property (nonatomic, strong) NSString *create_time;
@property (nonatomic, assign) double people_count;//      总数


@end
