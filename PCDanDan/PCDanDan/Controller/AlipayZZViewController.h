//
//  AlipayZZViewController.h
//  PCDanDan
//
//  Created by xcode.qi on 17/1/19.
//  Copyright © 2017年 li. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ZhuanZhangAccountInfo.h"

@interface AlipayZZViewController : UIViewController

@property (strong, nonatomic) ZhuanZhangAccountInfo *accountInfo;

@property (weak, nonatomic) IBOutlet UIView *infoView;
@property (weak, nonatomic) IBOutlet CycleScrollView *bannerView;
@property (weak, nonatomic) IBOutlet UIButton *commitButton;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *bgViewWidth;

@property (weak, nonatomic) IBOutlet UILabel *sknTitle;
@property (weak, nonatomic) IBOutlet UIButton *fz1Button;
@property (weak, nonatomic) IBOutlet UIButton *fz2Button;

@property (weak, nonatomic) IBOutlet UILabel *accountLabel;
@property (weak, nonatomic) IBOutlet UILabel *accountNameLabel;

@property (weak, nonatomic) IBOutlet UITextField *acconutNameText;
@property (weak, nonatomic) IBOutlet UITextField *accountText;
@property (weak, nonatomic) IBOutlet UITextField *moneyText;

- (IBAction)clickSureButtonAction:(id)sender;
- (IBAction)clicCopyType:(id)sender;
@end
