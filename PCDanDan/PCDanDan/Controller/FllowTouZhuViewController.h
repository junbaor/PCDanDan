//
//  FllowTouZhuViewController.h
//  PCDanDan
//
//  Created by xcode.qi on 17/1/19.
//  Copyright © 2017年 li. All rights reserved.
//


#import <UIKit/UIKit.h>
#import "IMMessageInfo.h"

@protocol FllowTouZhuViewControllerDelegate <NSObject>
@optional
- (void)fllowTouZhuSuccesss;

@end

@interface FllowTouZhuViewController : UIViewController
@property (strong, nonatomic) IMMessageInfo *touzhuInfo;
@property (strong, nonatomic) NSString *areaIDStr;
@property (strong, nonatomic) NSString *roomIDStr;
@property (nonatomic, assign) id<FllowTouZhuViewControllerDelegate> delegate;
@property (weak, nonatomic) IBOutlet UIView *bgView;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *numLabel;
@property (weak, nonatomic) IBOutlet UILabel *typeLabel;
@property (weak, nonatomic) IBOutlet UILabel *moneyLabel;
@property (weak, nonatomic) IBOutlet UIButton *sureButton;
@property (weak, nonatomic) IBOutlet UIButton *cannelButton;

- (IBAction)clickSureButtonAction:(id)sender;
- (IBAction)clickCannelButtonAction:(id)sender;
@end
