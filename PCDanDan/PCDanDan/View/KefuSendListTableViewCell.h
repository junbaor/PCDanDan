//
//  KefuSendListTableViewCell.h
//  PCDanDan
//
//  Created by linqsh on 17/3/6.
//  Copyright © 2017年 vma-lin. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface KefuSendListTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *msgTextLabel;
@property (weak, nonatomic) IBOutlet UIImageView *photoImage;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@end
