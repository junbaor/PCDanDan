//
//  ShareViewController.h
//  PCDanDan
//
//  Created by xcode.qi on 17/1/17.
//  Copyright © 2017年 li. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ShareViewController : UIViewController
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *bgViewWidth;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *bgViewHeight;
@property (weak, nonatomic) IBOutlet UIButton *zjkhButton;
@property (weak, nonatomic) IBOutlet UIButton *fxljButton;

@property (weak, nonatomic) IBOutlet UIView *zjkhView;
@property (weak, nonatomic) IBOutlet UITextField *yhmText;
@property (weak, nonatomic) IBOutlet UITextField *pwdText;
@property (weak, nonatomic) IBOutlet UITextField *surePwdText;
@property (weak, nonatomic) IBOutlet UIButton *sureButton;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UILabel *tiaojianLabel;

@property (weak, nonatomic) IBOutlet UIView *shareView;
@property (weak, nonatomic) IBOutlet UIImageView *codeImage;
@property (weak, nonatomic) IBOutlet UILabel *urlLabel;
@property (weak, nonatomic) IBOutlet UIButton *fzButton;
@property (weak, nonatomic) IBOutlet UIButton *saveButton;
@property (weak, nonatomic) IBOutlet UILabel *fxidLabel;

- (IBAction)clickZJKHButtonAction:(id)sender;
- (IBAction)clickFXLJButtonAction:(id)sender;
- (IBAction)clickSureButtonAction:(id)sender;
- (IBAction)clickCopyButtonAction:(id)sender;
- (IBAction)clickSaveButtonAction:(id)sender;
@end
