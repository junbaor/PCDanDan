//
//  TiXianViewController.h
//  PCDanDan
//
//  Created by xcode.qi on 17/1/17.
//  Copyright © 2017年 li. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TiXianViewController : UIViewController
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *bgviewWidth;
@property (weak, nonatomic) IBOutlet UIView *accountView;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *bankNameLabel;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *bankNameLabelWidth;
@property (weak, nonatomic) IBOutlet UIView *warn1View;
@property (weak, nonatomic) IBOutlet UIView *warn2View;
@property (weak, nonatomic) IBOutlet UILabel *zdtxWarnLabel;

@property (weak, nonatomic) IBOutlet UILabel *yueLabel;
@property (weak, nonatomic) IBOutlet UILabel *txcsLabel;
@property (weak, nonatomic) IBOutlet UILabel *sxfLabel;

@property (weak, nonatomic) IBOutlet UITextField *moneyText;
@property (weak, nonatomic) IBOutlet UITextField *pwdText;
@property (weak, nonatomic) IBOutlet UIButton *sureButton;

- (IBAction)clickSureButtonAction:(id)sender;
@end
