//
//  HuishuiListViewController.h
//  PCDanDan
//
//  Created by xcode.qi on 17/1/19.
//  Copyright © 2017年 li. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HuishuiListViewController : UIViewController

@property (weak, nonatomic) IBOutlet UITableView *myTableView;
@property (weak, nonatomic) IBOutlet UIButton *cjButton;
@property (weak, nonatomic) IBOutlet UIButton *zjButton;
@property (weak, nonatomic) IBOutlet UIButton *gjButton;
@property (weak, nonatomic) IBOutlet UILabel *warnLabel;

- (IBAction)clickRuleButtonAction:(id)sender;
- (IBAction)clickCJButtonAction:(id)sender;
- (IBAction)clickZJButtonAction:(id)sender;
- (IBAction)clickGJButtonAction:(id)sender;
@end
