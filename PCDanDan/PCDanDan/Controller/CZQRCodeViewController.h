//
//  CZQRCodeViewController.h
//  PCDanDan
//
//  Created by xcode.qi on 17/1/19.
//  Copyright © 2017年 li. All rights reserved.
//


#import <UIKit/UIKit.h>
@protocol CZQRCodeViewControllerDelegate <NSObject>
@optional

- (void)payCZQRCodePaySuccess;

@end

@interface CZQRCodeViewController : UIViewController
@property (assign, nonatomic) BOOL isSelectWX;
@property (strong, nonatomic) NSString *orderQRImageStr;
@property (strong, nonatomic) NSString *orderNo;
@property (strong, nonatomic) NSString *moneyStr;
@property (nonatomic, assign) id<CZQRCodeViewControllerDelegate> delegate;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *bgViewWidth;
@property (weak, nonatomic) IBOutlet UILabel *payTypeWarn;
@property (weak, nonatomic) IBOutlet UILabel *orderNum;
@property (weak, nonatomic) IBOutlet UILabel *moneyLabel;
@property (weak, nonatomic) IBOutlet UIImageView *qrcodeImage;
@property (weak, nonatomic) IBOutlet UIButton *backButton;
@property (weak, nonatomic) IBOutlet UIButton *payButton;
@property (weak, nonatomic) IBOutlet UIButton *hasPayButton;

@property (weak, nonatomic) IBOutlet UILabel *oneLabel;
@property (weak, nonatomic) IBOutlet UILabel *twoLabel;
@property (weak, nonatomic) IBOutlet UILabel *threeLabel;
@end
