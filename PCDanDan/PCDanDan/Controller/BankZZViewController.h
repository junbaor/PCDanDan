//
//  BankZZViewController.h
//  PCDanDan
//
//  Created by xcode.qi on 17/1/19.
//  Copyright © 2017年 li. All rights reserved.
//


#import <UIKit/UIKit.h>
#import "ZhuanZhangAccountInfo.h"

@interface BankZZViewController : UIViewController
@property (strong, nonatomic) ZhuanZhangAccountInfo *accountInfo;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *bgViewWidth;

@property (weak, nonatomic) IBOutlet UILabel *skTitleLabel;
@property (weak, nonatomic) IBOutlet UIView *skInfoView;
@property (weak, nonatomic) IBOutlet UILabel *skrLabel;
@property (weak, nonatomic) IBOutlet UILabel *accountLabel;
@property (weak, nonatomic) IBOutlet UIButton *fz1Button;
@property (weak, nonatomic) IBOutlet UIButton *fz2Button;

@property (weak, nonatomic) IBOutlet UIButton *commonButton;

@property (weak, nonatomic) IBOutlet UITextField *wxNickNameText;
@property (weak, nonatomic) IBOutlet UITextField *wxAccountText;


@property (weak, nonatomic) IBOutlet UITextField *moneyText;

@property (weak, nonatomic) IBOutlet UIButton *sureButton;

- (IBAction)clickSureButtonAction:(id)sender;
- (IBAction)clicCopyType:(id)sender;
@end
