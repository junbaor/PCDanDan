//
//  GameRecordListTableViewCell.h
//  PCDanDan
//
//  Created by linqsh on 17/2/21.
//  Copyright © 2017年 vma-lin. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface GameRecordListTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIView *bgView;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *winLabel;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *winLabelWidth;

@property (weak, nonatomic) IBOutlet UILabel *kjhmLabel;

@property (weak, nonatomic) IBOutlet UILabel *kjlxLabel;
@property (weak, nonatomic) IBOutlet UILabel *tzlxLabel;
@property (weak, nonatomic) IBOutlet UILabel *tzjeLabel;
@property (weak, nonatomic) IBOutlet UILabel *zjjeLabel;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;

@end
