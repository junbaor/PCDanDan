//
//  SetTiXianPwdViewController.h
//  PCDanDan
//
//  Created by linqsh on 17/2/26.
//  Copyright © 2017年 vma-lin. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SetTiXianPwdViewController : UIViewController

@property (assign, nonatomic) BOOL isSetPwd;

@property (weak, nonatomic) IBOutlet UILabel *csmmLabel;
@property (weak, nonatomic) IBOutlet UITextField *csmmText;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *txmmTextTop;
@property (weak, nonatomic) IBOutlet UITextField *txmmText;
@property (weak, nonatomic) IBOutlet UITextField *qrmmText;
@property (weak, nonatomic) IBOutlet UIButton *sureButton;

- (IBAction)clickSureButtonAction:(id)sender;

@end
