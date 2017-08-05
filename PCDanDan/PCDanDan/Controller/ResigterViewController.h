//
//  ResigterViewController.h
//  PCDanDan
//
//  Created by xcode.qi on 17/1/17.
//  Copyright © 2017年 li. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ResigterViewController : UIViewController
@property (weak, nonatomic) IBOutlet UIView *bgView;
@property (weak, nonatomic) IBOutlet UILabel *accountLabel;
@property (weak, nonatomic) IBOutlet UITextField *accountText;
@property (weak, nonatomic) IBOutlet UILabel *pwdLabel;
@property (weak, nonatomic) IBOutlet UITextField *pwdText;
@property (weak, nonatomic) IBOutlet UILabel *pwdAginLabel;
@property (weak, nonatomic) IBOutlet UITextField *pwdAginText;
@property (weak, nonatomic) IBOutlet UILabel *tjrLabel;
@property (weak, nonatomic) IBOutlet UITextField *tjrText;

@property (weak, nonatomic) IBOutlet UIButton *resigterButton;
@property (weak, nonatomic) IBOutlet UIImageView *selectImage;


- (IBAction)clickCloseButtonAction:(id)sender;
- (IBAction)clickResigterButtonAction:(id)sender;
- (IBAction)clickSelectButtonAction:(id)sender;
- (IBAction)clickXYButtonAction:(id)sender;
- (IBAction)clickKFButtonAction:(id)sender;
@end
