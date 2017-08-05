//
//  TXRcordListInfo.h
//  PCDanDan
//
//  Created by linqsh on 17/2/21.
//  Copyright © 2017年 vma-lin. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TXRcordListInfo : NSObject

@property (nonatomic, strong) NSString *id;
@property (nonatomic, strong) NSString *user_id;
@property (nonatomic, assign) double fee;//         提现金额
@property (nonatomic, assign) double  real_fee;//  实际到账金额
@property (nonatomic, strong) NSString *account;
@property (nonatomic, strong) NSString *status;//     --0提现中 1成功 2失败
@property (nonatomic, strong) NSString *source;// -- 1支付宝 2微信 3银行卡
@property (nonatomic, strong) NSString *create_time;//    提现时间
@property (nonatomic, strong) NSString *real_name;//真实名字",
@property (nonatomic, strong) NSString *mobile;


@end
