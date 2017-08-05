//
//  BankAccountLabelTableViewCell.h
//  PCDanDan
//
//  Created by xcode.qi on 17/1/19.
//  Copyright © 2017年 li. All rights reserved.
//


#import <UIKit/UIKit.h>

@interface BankAccountLabelTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *bankName;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *nameLabelWidth;
@property (weak, nonatomic) IBOutlet UILabel *bankDetail;
@property (weak, nonatomic) IBOutlet UILabel *bankAccount;

@end
