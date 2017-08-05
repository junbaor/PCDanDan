//
//  DuiHuanInfoViewController.h
//  PCDanDan
//
//  Created by xcode.qi on 17/1/19.
//  Copyright © 2017年 li. All rights reserved.
//


#import <UIKit/UIKit.h>
#import "GiftListInfo.h"

@interface DuiHuanInfoViewController : UIViewController
@property (strong, nonatomic)  GiftListInfo *giftInfo;
@property (weak, nonatomic) IBOutlet UIButton *sureButton;
@property (weak, nonatomic) IBOutlet UIButton *cannelButton;

@property (weak, nonatomic) IBOutlet UILabel *moneyLabel;
@property (weak, nonatomic) IBOutlet UILabel *allMoneyLabel;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *phoneLabel;
@property (weak, nonatomic) IBOutlet UITextField *numText;
@property (weak, nonatomic) IBOutlet UITextView *addressTextView;

- (IBAction)clickSureButtonAction:(id)sender;
- (IBAction)clickCloseButtonAction:(id)sender;
@end
