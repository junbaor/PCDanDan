//
//  OnLineCZViewController.h
//  PCDanDan
//
//  Created by xcode.qi on 17/1/19.
//  Copyright © 2017年 li. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface OnLineCZViewController : UIViewController
@property (assign, nonatomic) BOOL isSelectWX;
@property (weak, nonatomic) IBOutlet UILabel *accountLabel;
@property (weak, nonatomic) IBOutlet UILabel *moneyLabel;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *moneyLabelWidth;

@property (weak, nonatomic) IBOutlet UIView *czMoneyView;
@property (weak, nonatomic) IBOutlet UITextField *czMoneyText;

@property (weak, nonatomic) IBOutlet UIButton *wxButton;
@property (weak, nonatomic) IBOutlet UILabel *wxLine;
@property (weak, nonatomic) IBOutlet UIButton *alipayButton;
@property (weak, nonatomic) IBOutlet UILabel *alipayLine;
@property (weak, nonatomic) IBOutlet UILabel *warnLabel;
@property (weak, nonatomic) IBOutlet UIButton *nextButton;


- (IBAction)clickUpdateButton:(id)sender;
- (IBAction)clickWXButton:(id)sender;
- (IBAction)clickAlipayButton:(id)sender;
- (IBAction)clickNextButton:(id)sender;

@end
