//
//  AlipayAccountListViewController.m
//  PCDanDan
//
//  Created by xcode.qi on 17/1/19.
//  Copyright © 2017年 li. All rights reserved.
//

#import "AlipayAccountListViewController.h"
#import "AlipayAccountListTableViewCell.h"
#import "BankAccountLabelTableViewCell.h"
#import "AlipayZZViewController.h"
#import "BankZZViewController.h"
#import "ZhuanZhangAccountInfo.h"

@interface AlipayAccountListViewController ()
{
    NSMutableArray *dataSourceArray;
}

@end

@implementation AlipayAccountListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initVariable];
    [self leftNavigationItem];
    [self setTabelViewRefresh];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)initVariable
{
    if (_isAlipayAccount) {
        self.title = @"支付宝转账";
    }else{
        self.title = @"微信转账";
    }
    
    dataSourceArray = [NSMutableArray array];
}

- (void)leftNavigationItem
{
    UIControl *leftItemControl = [[UIControl alloc] initWithFrame:CGRectMake(0, 0, 20, 44)];
    [leftItemControl addTarget:self action:@selector(clickLeftControlAction:) forControlEvents:UIControlEventTouchUpInside];
    
    UIImageView *back = [[UIImageView alloc] initWithFrame:CGRectMake(0, 13, 18, 18)];
    back.image = [UIImage imageNamed:@"shouye_85.png"];
    [leftItemControl addSubview:back];
    
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:leftItemControl];
}


#pragma mark - button action

- (void)clickLeftControlAction:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}


- (void)httpAccountList
{
    HttpHelper *helper = [[HttpHelper alloc] init];
    __weak AlipayAccountListViewController *weakSelf = self;
    [helper getZhuanZhangAccountListWithType: _isAlipayAccount == YES?@"2":@"3"
                                     success:^(NSDictionary *resultDic){
                                         [weakSelf hideRefresh];
                                         if ([[resultDic objectForKey:@"result_code"] integerValue] == 0) {
                                             [weakSelf handleloadResult:resultDic];
                                         }else
                                    {
                                        [Tool showPromptContent:[resultDic objectForKey:@"result_desc"] onView:self.view];
                                    }
                                     }fail:^(NSString *decretion){
                                         [weakSelf hideRefresh];
                                         [Tool showPromptContent:@"网络出错了" onView:self.view];
                                     }];
    
}

- (void)handleloadResult:(NSDictionary *)resultDic
{
    
    NSArray *resourceArray = [resultDic objectForKey:@"data"];
    
    if (dataSourceArray.count > 0) {
        [dataSourceArray removeAllObjects];
    }
    
    if (resourceArray && resourceArray.count > 0)
    {
        _warnLabel.hidden = YES;
        for (NSDictionary *dic in resourceArray)
        {
            ZhuanZhangAccountInfo *info = [dic objectByClass:[ZhuanZhangAccountInfo class]];
            [dataSourceArray addObject:info];
        }
     
    }else{
        _warnLabel.hidden = NO;
    }
    [_myTableView reloadData];
}



#pragma mark - UITableViewDelegate

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}
//行数
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
    return dataSourceArray.count;
    
}

//设置cell的行高
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
//    if (_isAlipayAccount) {
        return 68;
//    }else{
//        return 100;
//    }
}


//创建并显示每行的内容
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
//    if (_isAlipayAccount) {
        AlipayAccountListTableViewCell *cell = nil;
        cell = [tableView dequeueReusableCellWithIdentifier:@"AlipayAccountListTableViewCell"];
        if (cell == nil)
        {
            NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"AlipayAccountListTableViewCell" owner:nil options:nil];
            cell = [nib objectAtIndex:0];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
        }
        
        ZhuanZhangAccountInfo *info = [dataSourceArray objectAtIndex:indexPath.row];
        cell.accountLabel.text = info.account;
        cell.nameLabel.text = info.real_name;
        return cell;
//    }else{
//        BankAccountLabelTableViewCell *cell = nil;
//        cell = [tableView dequeueReusableCellWithIdentifier:@"BankAccountLabelTableViewCell"];
//        if (cell == nil)
//        {
//            NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"BankAccountLabelTableViewCell" owner:nil options:nil];
//            cell = [nib objectAtIndex:0];
//            cell.selectionStyle = UITableViewCellSelectionStyleNone;
//        }
//        
//        ZhuanZhangAccountInfo *info = [dataSourceArray objectAtIndex:indexPath.row];
//        cell.bankName.text = info.bank_name;
//        cell.nameLabel.text = info.real_name;
//        CGSize size = [cell.nameLabel sizeThatFits:CGSizeMake(MAXFLOAT, 18)];
//        cell.nameLabelWidth.constant = size.width;
//        
//        cell.bankDetail.text = info.open_card_address;
//        cell.bankAccount.text = info.account;
//        
//        return cell;
//
//    }
    
    
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
     ZhuanZhangAccountInfo *info = [dataSourceArray objectAtIndex:indexPath.row];
    if (_isAlipayAccount) {
        AlipayZZViewController *vc = [[AlipayZZViewController alloc]initWithNibName:@"AlipayZZViewController" bundle:nil];
        vc.accountInfo = info;
        [self.navigationController pushViewController:vc animated:YES];

    }else{
        BankZZViewController *vc = [[BankZZViewController alloc]initWithNibName:@"BankZZViewController" bundle:nil];
        vc.accountInfo = info;
        [self.navigationController pushViewController:vc animated:YES];
    }
}


#pragma mark - tableview 上下拉刷新

- (void)setTabelViewRefresh
{
    __unsafe_unretained UITableView *tableView = self.myTableView;
    __unsafe_unretained __typeof(self) weakSelf = self;
    // 下拉刷新
    tableView.mj_header= [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        
        [weakSelf httpAccountList];
    }];
    // 设置自动切换透明度(在导航栏下面自动隐藏)
    tableView.mj_header.automaticallyChangeAlpha = YES;
    [tableView.mj_header beginRefreshing];
    
}

- (void)hideRefresh
{
    
    if([_myTableView.mj_footer isRefreshing])
    {
        [_myTableView.mj_footer endRefreshing];
    }
    if([_myTableView.mj_header isRefreshing])
    {
        [_myTableView.mj_header endRefreshing];
    }
}



@end
