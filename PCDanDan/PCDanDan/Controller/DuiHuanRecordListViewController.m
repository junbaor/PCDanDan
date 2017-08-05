//
//  DuiHuanRecordListViewController.m
//  PCDanDan
//
//  Created by linqsh on 17/2/26.
//  Copyright © 2017年 vma-lin. All rights reserved.
//

#import "DuiHuanRecordListViewController.h"
#import "DuiHuanRecordTableViewCell.h"
#import "DuiHuanRecordInfo.h"

@interface DuiHuanRecordListViewController ()
{
    NSMutableArray *dataSourceArray;
    int pageNo;
}

@end

@implementation DuiHuanRecordListViewController

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
    self.title = @"兑换记录";
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

#pragma mark - Action

- (void)clickLeftControlAction:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark -http

- (void)httpGetRecordList
{
    HttpHelper *helper = [[HttpHelper alloc] init];
    __weak DuiHuanRecordListViewController *weakSelf = self;
    [helper getExchangeGiftRecordWithIdStr:[ShareManager shareInstance].userinfo.id
                                   page_no:[NSString stringWithFormat:@"%d",pageNo]
                                 page_size:@"30"
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
            DuiHuanRecordInfo *info = [dic objectByClass:[DuiHuanRecordInfo class]];
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
    return 155;
}


//创建并显示每行的内容
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    DuiHuanRecordTableViewCell *cell = nil;
    cell = [tableView dequeueReusableCellWithIdentifier:@"DuiHuanRecordTableViewCell"];
    if (cell == nil)
    {
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"DuiHuanRecordTableViewCell" owner:nil options:nil];
        cell = [nib objectAtIndex:0];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    DuiHuanRecordInfo *info = [dataSourceArray objectAtIndex:indexPath.row];
    
    cell.nameLabel.text = info.gift_name;
    cell.moneyLabel.text = [NSString stringWithFormat:@"%.2f元宝",info.gift_point];
    cell.numLabel.text = info.gift_count;
    cell.allMoneyLabel.text = [NSString stringWithFormat:@"%.2f元宝",info.point];
    if ([info.status intValue] == 0) {
        cell.statueLabel.text = @"待处理";
    }else {
        cell.statueLabel.text = @"已处理";
    }
    cell.timeLabel.text =  [Tool timeStringToDateSting:info.create_time format:@"yyyy-MM-dd HH:mm:ss"];
    return cell;
    
    
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
