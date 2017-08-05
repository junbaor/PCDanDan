//
//  HouseListTableViewCell.h
//  PCDanDan
//
//  Created by xcode.qi on 17/1/19.
//  Copyright © 2017年 li. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HouseListTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *bgImage;
@property (weak, nonatomic) IBOutlet UIButton *plButton;
@property (weak, nonatomic) IBOutlet UILabel *houseType;
@property (weak, nonatomic) IBOutlet UILabel *housDetail;
@property (weak, nonatomic) IBOutlet UILabel *peopleNum;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *peopleNumWidth;

@end
