//
//  IntoRoomMessageTableViewCell.h
//  PCDanDan
//
//  Created by xcode.qi on 17/1/19.
//  Copyright © 2017年 li. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface IntoRoomMessageTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *labelWidth;
@property (weak, nonatomic) IBOutlet UIView *userInfoBgVIEW;
@property (weak, nonatomic) IBOutlet UIImageView *levelImage;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *levelImageTop;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *levelImageHeight;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *levelImageWidth;
@property (weak, nonatomic) IBOutlet UILabel *userNameLabel;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *nameLeft;

@end
