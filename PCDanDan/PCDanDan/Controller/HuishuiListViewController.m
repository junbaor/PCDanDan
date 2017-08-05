//
//  HuishuiListViewController.m
//  PCDanDan
//
//  Created by xcode.qi on 17/1/19.
//  Copyright © 2017年 li. All rights reserved.
//

#import "HuishuiListViewController.h"
#import "HuishuiListTableViewCell.h"
#import "HuiShuiListInfo.h"

@interface HuishuiListViewController ()
{
    int selectType;//1 初级 2 中级 3 高级
    NSMutableArray *dataSourceArray;
    int pageNo;
}

@end

@implementation HuishuiListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initVariable];
    [self leftNavigationItem];
    [self setTabelViewRefresh];
    [self updateShowUIButton];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)initVariable
{
    self.title = @"我的回水";
    dataSourceArray = [NSMutableArray array];
    selectType = 1;
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

- (void)updateShowUIButton
{
    
    [_cjButton setBackgroundColor:RGB(200, 200, 200)];
    [_cjButton setTitleColor:RGB(85, 85, 85) forState:UIControlStateNormal];
    [_zjButton setBackgroundColor:RGB(200, 200, 200)];
    [_zjButton setTitleColor:RGB(85, 85, 85) forState:UIControlStateNormal];
    [_gjButton setBackgroundColor:RGB(200, 200, 200)];
    [_gjButton setTitleColor:RGB(85, 85, 85) forState:UIControlStateNormal];
    
    switch (selectType) {
        case 1:
        {
            [_cjButton setBackgroundColor:RGB(239, 249, 255)];
            [_cjButton setTitleColor:RGB(58, 132, 255) forState:UIControlStateNormal];
        }
            break;
        case 2:
        {
            [_zjButton setBackgroundColor:RGB(239, 249, 255)];
            [_zjButton setTitleColor:RGB(58, 132, 255) forState:UIControlStateNormal];
        }
            break;
            
        default:
        {
            [_gjButton setBackgroundColor:RGB(239, 249, 255)];
            [_gjButton setTitleColor:RGB(58, 132, 255) forState:UIControlStateNormal];
        }
            break;
    }
}

#pragma mark -Button Action

- (void)clickLeftControlAction:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)clickRuleButtonAction:(id)sender
{
    SafariViewController *vc = [[SafariViewController alloc]initWithNibName:@"SafariViewController" bundle:nil];
    vc.title = @"回水规则";
    vc.urlStr = [NSString stringWithFormat:@"%@%@",URL_Server,Wap_HuiShuiGuiZe];
    [self.navigationController pushViewController:vc animated:YES];
}

- (IBAction)clickCJButtonAction:(id)sender
{
    selectType =1;
    [self updateShowUIButton];
    [_myTableView.mj_header beginRefreshing];
}

- (IBAction)clickZJButtonAction:(id)sender
{
    selectType =2;
    [self updateShowUIButton];
    [_myTableView.mj_header beginRefreshing];
}

- (IBAction)clickGJButtonAction:(id)sender
{
    selectType =3;
    [self updateShowUIButton];
    [_myTableView.mj_header beginRefreshing];
}

#pragma mark -http

- (void)httpGetRecordList
{
    HttpHelper *helper = [[HttpHelper alloc] init];
    __weak HuishuiListViewController *weakSelf = self;
    [helper getHuiShuiRecordWithIdStr:[ShareManager shareInstance].userinfo.id
                              page_no:[NSString stringWithFormat:@"%d",pageNo]
                            page_size:@"30"
                                 type:[NSString stringWithFormat:@"%d",selectType]
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
            HuiShuiListInfo *info = [dic objectByClass:[HuiShuiListInfo class]];
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
    return 48;
}


//创建并显示每行的内容
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    HuishuiListTableViewCell *cell = nil;
    cell = [tableView dequeueReusableCellWithIdentifier:@"HuishuiListTableViewCell"];
    if (cell == nil)
    {
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"HuishuiListTableViewCell" owner:nil options:nil];
        cell = [nib objectAtIndex:0];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    
    
    
    HuiShuiListInfo *info = [dataSourceArray objectAtIndex:indexPath.row];
    cell.timeLabel.text =  [Tool timeStringToDateSting:info.create_time format:@"yyyy-MM-dd"];
    cell.moneyLabel.text = [NSString stringWithFormat:@"%.2f元宝",info.hui_shui_point];
    cell.biliLabel.text = [NSString stringWithFormat:@"回水%.0f％",info.bili*100.0];
    if ([info.status intValue] == 0) {
        cell.statueLabel.text = @"待回水";
    }else if([info.status intValue] ==1)
    {
        cell.statueLabel.text = @"已回水";
    }else if ([info.status intValue] == 2)
    {
        cell.statueLabel.text = @"未满足";
    }else{
        cell.statueLabel.text = @"--";
    }
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
