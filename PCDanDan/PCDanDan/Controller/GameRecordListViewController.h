//
//  GameRecordListViewController.h
//  PCDanDan
//
//  Created by linqsh on 17/2/21.
//  Copyright © 2017年 vma-lin. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface GameRecordListViewController : UIViewController

@property (weak, nonatomic) IBOutlet UITableView *myTableView;
@property (weak, nonatomic) IBOutlet UILabel *warnLabel;
@property (copy, nonatomic) NSString *roomIdStr;
@property (copy, nonatomic) NSString *gameType;
@property (copy, nonatomic) NSString *beginTimeStr;
@property (copy, nonatomic) NSString *endTimeStr;
@end
