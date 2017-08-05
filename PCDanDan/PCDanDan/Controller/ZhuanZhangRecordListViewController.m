//
//  ZhuanZhangRecordListViewController.m
//  PCDanDan
//
//  Created by linqsh on 17/2/26.
//  Copyright © 2017年 vma-lin. All rights reserved.
//

#import "ZhuanZhangRecordListViewController.h"
#import "ZZRecordInfo.h"
#import "ZZRecordBankListTableViewCell.h"
#import "ZZRecordListTableViewCell.h"
#import "ZZRecordInfo.h"

@interface ZhuanZhangRecordListViewController ()
{
    NSMutableArray *dataSourceArray;
    int pageNo;
}

@end

@implementation ZhuanZhangRecordListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initVariable];
    [self leftNavigationItem];
    [self  setTabelViewRefresh];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)initVariable
{
    self.title = @"转账记录";
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

#pragma mark -http

- (void)httpGetRecordList
{
    HttpHelper *helper = [[HttpHelper alloc] init];
    __weak ZhuanZhangRecordListViewController *weakSelf = self;
    [helper zzRecordListInfoWithUserId:[ShareManager shareInstance].userinfo.id
                               page_no:[NSString stringWithFormat:@"%d",pageNo]
                             page_size:@"20"
                          account_type:nil
                              success:^(NSDictionary *resultDic){
                                  [self hideRefresh];
                                  if ([[resultDic objectForKey:@"result_code"] integerValue] == 0) {
                                      [weakSelf handleloadResult:resultDic];
                                  }else
                                  {
                                      [Tool showPromptContent:[resultDic objectForKey:@"result_desc"] onView:self.view];
                                  }
                              }fail:^(NSString *decretion){
                                  [self hideRefresh];
                                  [Tool showPromptContent:@"网络出错了" onView:self.view];
                              }];
}

- (void)handleloadResult:(NSDictionary *)resultDic
{
    if(!resultDic)
    {
        [Tool showPromptContent:@"请求失败" onView:self.view];
        return;
    }
    
    _warnLabel.hidden = YES;
    
    NSArray *resourceArray = [resultDic objectForKey:@"data"];
    if (dataSourceArray.count > 0 && pageNo == 1) {
        [dataSourceArray removeAllObjects];
    }
    if (resourceArray && resourceArray.count > 0)
    {
        for (NSDictionary *dic in resourceArray)
        {
            ZZRecordInfo *info = [dic objectByClass:[ZZRecordInfo class]];
            [dataSourceArray addObject:info];
        }
        [_myTableView.mj_footer resetNoMoreData];
        pageNo++;
    }else{
        [_myTableView.mj_footer endRefreshingWithNoMoreData];
        if (pageNo == 1)
        {
            if (dataSourceArray.count > 0) {
                _warnLabel.hidden = YES;
            }else{
                _warnLabel.hidden = NO;
            }
        }else{
            [Tool showPromptContent:@"没有更多数据了" onView:self.view];
        }
    }
    
    [_myTableView reloadData];
}


#pragma mark -Button Action

- (void)clickLeftControlAction:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
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
     ZZRecordInfo *info = [dataSourceArray objectAtIndex:indexPath.row];
    //1银行卡  2支付宝
    if ([info.account_type integerValue] == 1) {
        return 290;
    }else{
        return 215;
    }
}


//创建并显示每行的内容
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    ZZRecordInfo *info = [dataSourceArray objectAtIndex:indexPath.row];
    NSString *statueStr = nil;
    // 0待确认 1确认收到  2未收到
    if([info.status intValue] == 0)
    {
        statueStr = @"待确认";
    }else if ([info.status intValue] == 1){
        statueStr = @"已到账";
    }else{
       statueStr = @"未收到";
    }
    //1银行卡  2支付宝 3微信
    if ([info.account_type integerValue] == 1) {
        ZZRecordBankListTableViewCell *cell = nil;
        cell = [tableView dequeueReusableCellWithIdentifier:@"ZZRecordBankListTableViewCell"];
        if (cell == nil)
        {
            NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"ZZRecordBankListTableViewCell" owner:nil options:nil];
            cell = [nib objectAtIndex:0];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
        }
        cell.typeLabel.text = @"银行卡转账";
        cell.statueLabel.text = statueStr;
        cell.yhLabel.text = info.account_info.bank_name;
        cell.skrLabel.text = info.account_info.real_name;
        cell.fhhLabel.text = info.account_info.open_card_address;
        cell.zhLabel.text = info.account_info.account;
        cell.skrxmLabel.text = info.real_name;
        cell.zfzhLabel.text = info.account;
        cell.ckjeLabel.text = [NSString stringWithFormat:@"%.2f元",info.point];
        cell.cksjLabel.text =  [Tool timeStringToDateSting:info.create_time format:@"yyyy-MM-dd HH:mm:ss"];
        cell.ckfsLabel.text =  info.add_type;
        return cell;
    }else{
        ZZRecordListTableViewCell *cell = nil;
        cell = [tableView dequeueReusableCellWithIdentifier:@"ZZRecordListTableViewCell"];
        if (cell == nil)
        {
            NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"ZZRecordListTableViewCell" owner:nil options:nil];
            cell = [nib objectAtIndex:0];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
        }
        if ([info.account_type integerValue] == 2)
        {
            cell.typeLabel.text = @"支付宝";
            cell.statueLabel.text = statueStr;
            cell.skhmLabel.text = info.account_info.real_name;
            cell.skzhLabel.text = info.account_info.account;
            cell.zfhmLabel.text = info.real_name;
            cell.zfzhLabel.text = info.account;
            cell.zfjeLabel.text = [NSString stringWithFormat:@"%.2f元",info.point];
            cell.cksjLabel.text =  [Tool timeStringToDateSting:info.create_time format:@"yyyy-MM-dd HH:mm:ss"];
        }else{
            cell.typeLabel.text = @"微信";
            cell.statueLabel.text = statueStr;
            cell.skhmLabel.text = info.account_info.real_name;
            cell.skzhLabel.text = info.account_info.account;
            cell.zfhmLabel.text = info.real_name;
            cell.zfzhLabel.text = info.account;
            cell.zfjeLabel.text = [NSString stringWithFormat:@"%.2f元",info.point];
            cell.cksjLabel.text =  [Tool timeStringToDateSting:info.create_time format:@"yyyy-MM-dd HH:mm:ss"];
        }
        
        return cell;
    }
    
    
    
    return nil;
    
    
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    
}

#pragma mark - tableview 上下拉刷新

- (void)setTabelViewRefresh
{
    __unsafe_unretained UITableView *tableView = self.myTableView;
    __unsafe_unretained __typeof(self) weakSelf = self;
    // 下拉刷新
    tableView.mj_header= [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        
        pageNo = 1;
        [weakSelf httpGetRecordList];
    }];
    // 设置自动切换透明度(在导航栏下面自动隐藏)
    tableView.mj_header.automaticallyChangeAlpha = YES;
    [tableView.mj_header beginRefreshing];
    
    tableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        [weakSelf httpGetRecordList];
        
    }];
    tableView.mj_footer.automaticallyHidden = YES;
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
