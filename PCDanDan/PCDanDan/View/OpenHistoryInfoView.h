//
//  OpenHistoryInfoView.h
//  PCDanDan
//
//  Created by xcode.qi on 17/1/17.
//  Copyright © 2017年 li. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol OpenHistoryInfoViewDelegate <NSObject>
@optional
- (void)closeHistoryView;
@end

@interface OpenHistoryInfoView : UIView<UITableViewDataSource,UITableViewDelegate>

@property (strong, nonatomic) NSMutableArray *dataSourceArray;
- (void)updateTableViewCellList;

+ (instancetype)initHistoryInfoViewWithFrame:(CGRect)frame;
@property (nonatomic, assign) id<OpenHistoryInfoViewDelegate> delegate;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
//@property (strong, nonatomic) UITableView *tableView;
@property (weak, nonatomic) IBOutlet UILabel *warnLabel;
- (IBAction)clickBgButtonAction:(id)sender;
@end
