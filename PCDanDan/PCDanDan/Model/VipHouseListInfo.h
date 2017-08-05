//
//  VipHouseListInfo.h
//  PCDanDan
//
//  Created by xcode.qi on 17/1/17.
//  Copyright © 2017年 li. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface VipHouseListInfo : NSObject

@property (nonatomic, strong) NSString *id;
@property (nonatomic, strong) NSString *im_gourp_id;//        环信 群组id
@property (nonatomic, strong) NSString *room_name;
@property (nonatomic, strong) NSString *room_photo;
@property (nonatomic, strong) NSString *people_max_count;//人数上限
@property (nonatomic, strong) NSString *per_max_point;//  个人下注上限
@property (nonatomic, strong) NSString *per_min_point;//  个人下注下限
@property (nonatomic, strong) NSString *all_max_point;//    房间下注总额上限
@property (nonatomic, assign) double people_count;//  总人数
@property (nonatomic, strong) NSString *password;

@end
