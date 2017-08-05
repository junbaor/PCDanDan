//
//  BangDingPhoneViewController.h
//  PCDanDan
//
//  Created by linqsh on 17/2/26.
//  Copyright © 2017年 vma-lin. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BangDingPhoneViewController : UIViewController
@property (weak, nonatomic) IBOutlet UITextField *phoneText;
@property (weak, nonatomic) IBOutlet UITextField *codeText;
@property (weak, nonatomic) IBOutlet UIButton *codeButton;
@property (weak, nonatomic) IBOutlet UIButton *sureButton;

- (IBAction)clickCodeButtonAction:(id)sender;
- (IBAction)clickSureButtonAction:(id)sender;
@end
