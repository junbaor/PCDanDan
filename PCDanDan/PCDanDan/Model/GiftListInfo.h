//
//  GiftListInfo.h
//  PCDanDan
//
//  Created by linqsh on 17/2/26.
//  Copyright © 2017年 vma-lin. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GiftListInfo : NSObject

@property (nonatomic, strong) NSString *id;
@property (nonatomic, strong) NSString *gift_name;//               名称
@property (nonatomic, assign) double gift_point;//                  积分
@property (nonatomic, strong) NSString *gift_photo;//    图片
@property (nonatomic, strong) NSString *status;


@end
