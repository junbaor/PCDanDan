//
//  MyPhoneViewController.h
//  PCDanDan
//
//  Created by linqsh on 17/2/26.
//  Copyright © 2017年 vma-lin. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MyPhoneViewController : UIViewController
@property (weak, nonatomic) IBOutlet UILabel *phoneLabel;
@property (weak, nonatomic) IBOutlet UIButton *sureButton;
- (IBAction)clickSureButtonAction:(id)sender;
@end
