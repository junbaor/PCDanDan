//
//  BannerListInfo.h
//  PCDanDan
//
//  Created by xcode.qi on 17/1/19.
//  Copyright © 2017年 li. All rights reserved.
//


#import <Foundation/Foundation.h>

@interface BannerListInfo : NSObject


@property (nonatomic, strong) NSString *id;
@property (nonatomic, strong) NSString *banner_imgurl;
@property (nonatomic, strong) NSString *banner_name;
@property (nonatomic, strong) NSString *banner_place;
@property (nonatomic, strong) NSString *banner_order;
@property (nonatomic, strong) NSString *content;
@property (nonatomic, strong) NSString *create_time;
@property (nonatomic, strong) NSString *is_go;//是否跳转
@property (nonatomic, strong) NSString *url;
@property (nonatomic, strong) NSString *status;
@end
