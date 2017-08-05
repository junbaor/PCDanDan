//
//  FenPanOrKaiPanTableViewCell.h
//  PCDanDan
//
//  Created by xcode.qi on 17/1/19.
//  Copyright © 2017年 li. All rights reserved.
//


#import <UIKit/UIKit.h>

@interface FenPanOrKaiPanTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *labelHeight;
@property (weak, nonatomic) IBOutlet UILabel *bgLabel;

@end
