//
//  MyMessageListViewController.m
//  PCDanDan
//
//  Created by linqsh on 17/2/26.
//  Copyright © 2017年 vma-lin. All rights reserved.
//

#import "MyMessageListViewController.h"
#import "MessageListTableViewCell.h"
#import "NoticeListInfo.h"

@interface MyMessageListViewController ()
{
    NSMutableArray *dataSourceArray;
    int pageNum;
}

@end

@implementation MyMessageListViewController

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
    self.title = @"我的消息";
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

#pragma mark - action
- (void)clickLeftControlAction:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)httpNoticeList
{
    NSString *userId = nil;
    if([ShareManager shareInstance].userinfo.islogin)
    {
        userId = [ShareManager shareInstance].userinfo.id;
    }
    HttpHelper *helper = [[HttpHelper alloc] init];
    __weak MyMessageListViewController *weakSelf = self;
    [helper getNoticeListWithPageNo:[NSString stringWithFormat:@"%d",pageNum]
                          page_size:@"20"
                            user_id:userId
                               type:@"2"
                            success:^(NSDictionary *resultDic){
                                [weakSelf hideRefresh];
                                if ([[resultDic objectForKey:@"result_code"] integerValue] == 0) {
                                    [weakSelf handleloadZiXunListResult:resultDic];
                                }else
                                {
                                    [Tool showPromptContent:[resultDic objectForKey:@"result_desc"] onView:self.view];
                                }
                            }fail:^(NSString *decretion){
                                [weakSelf hideRefresh];
                                [Tool showPromptContent:@"网络出错了" onView:self.view];
                            }];
    
}

- (void)handleloadZiXunListResult:(NSDictionary *)resultDic
{
    
    NSArray *resourceArray = [resultDic objectForKey:@"data"];
    
    if (dataSourceArray.count > 0 && pageNum == 1) {
        [dataSourceArray removeAllObjects];
    }
    _warnLabel.hidden = YES;
    if (resourceArray && resourceArray.count > 0)
    {
        
        for (NSDictionary *dic in resourceArray)
        {
            NoticeListInfo *info = [dic objectByClass:[NoticeListInfo class]];
            [dataSourceArray addObject:info];
        }
        [_myTableView.mj_footer resetNoMoreData];
        pageNum++;
    }else{
        if (pageNum == 1)
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
    return 40;
}


//创建并显示每行的内容
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    MessageListTableViewCell *cell = nil;
    cell = [tableView dequeueReusableCellWithIdentifier:@"MessageListTableViewCell"];
    if (cell == nil)
    {
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"MessageListTableViewCell" owner:nil options:nil];
        cell = [nib objectAtIndex:0];
        
        cell.warnLabel.layer.masksToBounds =YES;
        cell.warnLabel.layer.cornerRadius = cell.warnLabel.frame.size.height/2;
    }
    
    //    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    NoticeListInfo *info = [dataSourceArray objectAtIndex:indexPath.row];
    if ([info.status intValue] == 0) {
        cell.warnLabel.hidden = NO;
    }else{
        cell.warnLabel.hidden = YES;
    }
    cell.titleLabel.text = info.title;
    cell.timeLabel.text = [Tool timeStringToDateSting:info.create_time format:@"yyyy-MM-dd"];
    return cell;
    
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
     NoticeListInfo *info = [dataSourceArray objectAtIndex:indexPath.row];
    info.status = @"1";
    [_myTableView reloadData];
    
    SafariViewController *vc = [[SafariViewController alloc]initWithNibName:@"SafariViewController" bundle:nil];
    vc.title = @"详情";
    vc.urlStr = [NSString stringWithFormat:@"%@%@notice_id=%@&user_id=%@",URL_Server,Wap_MessageDetail,info.id,[ShareManager shareInstance].userinfo.id];
    vc.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:vc animated:YES];
}


#pragma mark - tableview 上下拉刷新

- (void)setTabelViewRefresh
{
    __unsafe_unretained UITableView *tableView = self.myTableView;
    __unsafe_unretained __typeof(self) weakSelf = self;
    // 下拉刷新
    tableView.mj_header= [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        
        pageNum = 1;
        [weakSelf httpNoticeList];
    }];
    // 设置自动切换透明度(在导航栏下面自动隐藏)
    tableView.mj_header.automaticallyChangeAlpha = YES;
    [tableView.mj_header beginRefreshing];
    
    tableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        [weakSelf hideRefresh];
        
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
