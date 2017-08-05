//
//  ModifyLoginPwdViewController.h
//  PCDanDan
//
//  Created by linqsh on 17/2/26.
//  Copyright © 2017年 vma-lin. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ModifyLoginPwdViewController : UIViewController
@property (weak, nonatomic) IBOutlet UITextField *ymmText;
@property (weak, nonatomic) IBOutlet UITextField *xmmText;
@property (weak, nonatomic) IBOutlet UITextField *zcqrText;
@property (weak, nonatomic) IBOutlet UIButton *sureButton;
- (IBAction)clickSureButtonAction:(id)sender;
@end
