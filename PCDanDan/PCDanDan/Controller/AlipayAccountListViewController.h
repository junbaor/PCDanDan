//
//  AlipayAccountListViewController.h
//  PCDanDan
//
//  Created by xcode.qi on 17/1/19.
//  Copyright © 2017年 li. All rights reserved.
//


#import <UIKit/UIKit.h>

@interface AlipayAccountListViewController : UIViewController
@property (assign, nonatomic) BOOL isAlipayAccount;
@property (weak, nonatomic) IBOutlet UITableView *myTableView;
@property (weak, nonatomic) IBOutlet UILabel *warnLabel;
@end
