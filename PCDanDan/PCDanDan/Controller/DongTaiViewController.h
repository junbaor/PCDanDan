//
//  DongTaiViewController.h
//  PCDanDan
//
//  Created by xcode.qi on 17/1/19.
//  Copyright © 2017年 li. All rights reserved.
//


#import <UIKit/UIKit.h>

@interface DongTaiViewController : UIViewController
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *bannerViewHeight;
@property (weak, nonatomic) IBOutlet CycleScrollView *bannerView;
@property (weak, nonatomic) IBOutlet UIPageControl *pageControl;
@property (weak, nonatomic) IBOutlet UITableView *myTableView;

@property (weak, nonatomic) IBOutlet UIButton *tgxxButton;
@property (weak, nonatomic) IBOutlet UILabel *tgxxNumLabel;
@property (weak, nonatomic) IBOutlet UILabel *wdxxNumLabel;
@property (weak, nonatomic) IBOutlet UIButton *wdxxButton;
@property (weak, nonatomic) IBOutlet UILabel *tgxxLine;
@property (weak, nonatomic) IBOutlet UILabel *wdxxLine;

- (IBAction)clickTGXXBurronAction:(id)sender;
- (IBAction)clickMyMessageBurronAction:(id)sender;
@end
