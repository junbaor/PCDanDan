//
//  HouseListViewController.h
//  PCDanDan
//
//  Created by xcode.qi on 17/1/19.
//  Copyright © 2017年 li. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HouseListViewController : UIViewController
@property (strong, nonatomic) NSString *gameType;//1北京28   2加拿大28
@property (weak, nonatomic) IBOutlet UILabel *warnLabel;
@property (weak, nonatomic) IBOutlet UITableView *myTableView;
@end
