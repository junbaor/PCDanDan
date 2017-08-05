//
//  AboutOurViewController.h
//  PCDanDan
//
//  Created by xcode.qi on 17/1/19.
//  Copyright © 2017年 li. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AboutOurViewController : UIViewController
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *bgViewWidth;
@property (weak, nonatomic) IBOutlet UILabel *gwLabel;
@property (weak, nonatomic) IBOutlet UILabel *qqLabel;
@property (weak, nonatomic) IBOutlet UILabel *weixinLabel;

@property (weak, nonatomic) IBOutlet UILabel *banbenhaoLabel;
@property (weak, nonatomic) IBOutlet UIButton *fz1Button;
@property (weak, nonatomic) IBOutlet UIButton *fz2Button;
@property (weak, nonatomic) IBOutlet UIButton *fz3Button;

@property (weak, nonatomic) IBOutlet UIButton *shareButton;
@property (weak, nonatomic) IBOutlet UIImageView *codeImage;


- (IBAction)clicCopyType:(id)sender;
- (IBAction)clicShareAction:(id)sender;
@end
