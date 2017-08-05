//
//  ZhuanZhangAccountInfo.h
//  PCDanDan
//
//  Created by linqsh on 17/2/26.
//  Copyright © 2017年 vma-lin. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ZhuanZhangAccountInfo : NSObject


@property (nonatomic, strong) NSString *id;
@property (nonatomic, strong) NSString *account;//      银行卡或者支付宝帐号
@property (nonatomic, strong) NSString *account_type;
@property (nonatomic, strong) NSString *real_name;//     户主
@property (nonatomic, strong) NSString *bank_name;//   银行卡名称
@property (nonatomic, strong) NSString *open_card_address;//     开户行


@end
