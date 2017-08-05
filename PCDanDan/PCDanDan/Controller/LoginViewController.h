//
//  LoginViewController.h
//  PCDanDan
//
//  Created by xcode.qi on 17/1/19.
//  Copyright © 2017年 li. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LoginViewController : UIViewController
@property (weak, nonatomic) IBOutlet UIView *bgView;
@property (weak, nonatomic) IBOutlet UITextField *accountText;
@property (weak, nonatomic) IBOutlet UILabel *accountBgLabel;

@property (weak, nonatomic) IBOutlet UITextField *pwdText;
@property (weak, nonatomic) IBOutlet UILabel *pwdBgLabel;
@property (weak, nonatomic) IBOutlet UIButton *loginButton;
@property (weak, nonatomic) IBOutlet UIView *thirdView;

- (IBAction)clickCloseButtonAction:(id)sender;
- (IBAction)clickLoginButtonAction:(id)sender;
- (IBAction)clickResigterButtonAction:(id)sender;
- (IBAction)clickForgetPwdButtonAction:(id)sender;
- (IBAction)clickWeixinButtonAction:(id)sender;
- (IBAction)clickQQButtonAction:(id)sender;
@end
