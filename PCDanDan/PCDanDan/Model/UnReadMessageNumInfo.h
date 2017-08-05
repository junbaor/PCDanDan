//
//  UnReadMessageNumInfo.h
//  PCDanDan
//
//  Created by linqsh on 17/2/20.
//  Copyright © 2017年 vma-lin. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UnReadMessageNumInfo : NSObject
@property (nonatomic, assign) double notice_count;//  未读消息总数
@property (nonatomic, assign) double my_notice_count;// 我的消息中未读数
@property (nonatomic, assign) double system_notice_count;// 系统消息未读数
@end
