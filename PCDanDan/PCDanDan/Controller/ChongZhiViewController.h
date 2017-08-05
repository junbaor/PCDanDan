//
//  ChongZhiViewController.h
//  PCDanDan
//
//  Created by xcode.qi on 17/1/19.
//  Copyright © 2017年 li. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ChongZhiViewController : UIViewController

@property (assign, nonatomic) BOOL isPush;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *bgViewWidth;
@property (weak, nonatomic) IBOutlet UIImageView *alipayImage;
@property (weak, nonatomic) IBOutlet UIImageView *weixinImage;
@property (weak, nonatomic) IBOutlet UIButton *payButton;
@property (weak, nonatomic) IBOutlet UIButton *recordButton;
@property (weak, nonatomic) IBOutlet UIButton *kefuButton;

- (IBAction)clickAlipayButtonAction:(id)sender;
- (IBAction)clickWeixinButtonAction:(id)sender;
- (IBAction)clickPayButtonAction:(id)sender;

- (IBAction)clickAlipayZZButtonAction:(id)sender;
- (IBAction)clickBlankZZButtonAction:(id)sender;
- (IBAction)clickRecordButtonAction:(id)sender;
- (IBAction)clickKefuButtonAction:(id)sender;

@end
