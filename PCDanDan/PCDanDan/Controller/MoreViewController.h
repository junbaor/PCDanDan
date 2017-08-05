//
//  MoreViewController.h
//  PCDanDan
//
//  Created by xcode.qi on 17/1/19.
//  Copyright © 2017年 li. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MoreViewController : UIViewController
@property (weak, nonatomic) IBOutlet UIImageView *headImage;
@property (weak, nonatomic) IBOutlet UILabel *moneyLabel;
@property (weak, nonatomic) IBOutlet UIButton *czButtonAction;
@property (weak, nonatomic) IBOutlet UIButton *txButtonAction;
@property (weak, nonatomic) IBOutlet UILabel *warnLabel;

- (IBAction)clickCZButtonAction:(id)sender;
- (IBAction)clickTXButtonAction:(id)sender;
- (IBAction)clickWallectButtonAction:(id)sender;
- (IBAction)clickMessageButtonAction:(id)sender;
- (IBAction)clickCloseButtonAction:(id)sender;

@end
