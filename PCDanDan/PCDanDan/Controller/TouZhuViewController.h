//
//  TouZhuViewController.h
//  PCDanDan
//
//  Created by xcode.qi on 17/1/17.
//  Copyright © 2017年 li. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GameBiLiInfo.h"


@protocol TouZhuViewControllerDelegate <NSObject>
@optional
- (void)touzhuSuccesss;
- (NSDictionary *)getChoiceNoWithstatue;
@end

@interface TouZhuViewController : UIViewController
@property (nonatomic, assign) id<TouZhuViewControllerDelegate> delegate;
@property (strong, nonatomic) NSString *areaIDStr;
@property (strong, nonatomic) NSString *roomIDStr;
@property (strong, nonatomic) NSString *choiceNo;
@property (assign, nonatomic) double per_max_point;
@property (strong, nonatomic) GameBiLiInfo *gameBiLiInfo;
@property (weak, nonatomic) IBOutlet UIButton *leftButton;
@property (weak, nonatomic) IBOutlet UIButton *rightButton;

@property (weak, nonatomic) IBOutlet UIButton *plsmButton;
@property (weak, nonatomic) IBOutlet UIButton *zxtzButton;
@property (weak, nonatomic) IBOutlet UIButton *sbtzButton;

@property (weak, nonatomic) IBOutlet UIButton *tzButton;

@property (weak, nonatomic) IBOutlet UILabel *moneyLabel;
@property (weak, nonatomic) IBOutlet UITextField *moneyText;

@property (weak, nonatomic) IBOutlet UICollectionView *pageCollectView;
- (IBAction)clickDissButtonAction:(id)sender;
- (IBAction)clickLeftButtonAction:(id)sender;
- (IBAction)clickRightButtonAction:(id)sender;
- (IBAction)clickPLSMButtonAction:(id)sender;
- (IBAction)clickZXTZButtonAction:(id)sender;
- (IBAction)clickSBTZButtonAction:(id)sender;
- (IBAction)clickTZButtonAction:(id)sender;

@end
