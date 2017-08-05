//
//  HouseListViewController.m
//  PCDanDan
//
//  Created by xcode.qi on 17/1/19.
//  Copyright © 2017年 li. All rights reserved.
//

#import "HouseListViewController.h"
#import "HouseListTableViewCell.h"
#import "VipListViewController.h"
#import "HouseAreaListInfo.h"
#import "ChongZhiViewController.h"

@interface HouseListViewController ()
{
    NSMutableArray *dataSourceArray;
}

@end

@implementation HouseListViewController

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

- (void)httpGetHouseAreaList
{
    HttpHelper *helper = [[HttpHelper alloc] init];
    __weak HouseListViewController *weakSelf = self;
    [helper getGameHouseAreaListWithType:_gameType
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
    
    //banner
    NSArray *resourceArray = [resultDic objectForKey:@"data"];
    if (dataSourceArray.count > 0) {
        [dataSourceArray removeAllObjects];
    }
    if (resourceArray && resourceArray.count > 0)
    {
        for (NSDictionary *dic in resourceArray)
        {
            HouseAreaListInfo *info = [dic objectByClass:[HouseAreaListInfo class]];
            [dataSourceArray addObject:info];
        }
    }
    if (dataSourceArray.count > 0) {
        _warnLabel.hidden = YES;
    }else{
        _warnLabel.hidden = NO;
    }
    [_myTableView reloadData];
}


#pragma mark -Action

- (void)clickLeftControlAction:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)clickPeiLvButtonAction:(UIButton *)btn
{
    HouseAreaListInfo *info = [dataSourceArray objectAtIndex:btn.tag];
    SafariViewController *vc = [[SafariViewController alloc]initWithNibName:@"SafariViewController" bundle:nil];
    vc.title = @"赔率说明";
    vc.urlStr = [NSString stringWithFormat:@"%@%@%@",URL_Server,Wap_PeiLvShuoMing,info.id];
    [self.navigationController pushViewController:vc animated:YES];
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
    return FullScreen.size.width*0.43;
}


//创建并显示每行的内容
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    HouseListTableViewCell *cell = nil;
    cell = [tableView dequeueReusableCellWithIdentifier:@"HouseListTableViewCell"];
    if (cell == nil)
    {
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"HouseListTableViewCell" owner:nil options:nil];
        cell = [nib objectAtIndex:0];
    }
    if (indexPath.row%3 == 0) {
        cell.bgImage.image = [UIImage imageNamed:@"shouye_03"];
        [cell.plButton setImage:[UIImage imageNamed:@"shouye_192"] forState:UIControlStateNormal];
        cell.houseType.text = @"初级房";
    }else if (indexPath.row%3 == 1) {
        cell.bgImage.image = [UIImage imageNamed:@"shouye_05"];
        [cell.plButton setImage:[UIImage imageNamed:@"shouye_190"] forState:UIControlStateNormal];
        cell.houseType.text = @"中级房";
    }else{
        cell.bgImage.image = [UIImage imageNamed:@"shouye_07"];
        [cell.plButton setImage:[UIImage imageNamed:@"shouye_194"] forState:UIControlStateNormal];
        cell.houseType.text = @"高级房";
        
    }
    
    HouseAreaListInfo *info = [dataSourceArray objectAtIndex:indexPath.row];
    cell.houseType.text = info.area_name;
    cell.housDetail.text = [NSString stringWithFormat:@"(%@)",info.feedback_desc];
    cell.peopleNum.text = [NSString stringWithFormat:@"%.0f人",info.people_count];
    CGSize size = [cell.peopleNum sizeThatFits:CGSizeMake(MAXFLOAT, 20)];
    cell.peopleNumWidth.constant = size.width+10;
    
    cell.plButton.tag = indexPath.row;
    [cell.plButton addTarget:self action:@selector(clickPeiLvButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
   
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    HouseAreaListInfo *info = [dataSourceArray objectAtIndex:indexPath.row];
    if ([ShareManager shareInstance].userinfo.point < info.min_point) {
        UIAlertView *alert = [UIAlertView bk_showAlertViewWithTitle:@"提示" message:[NSString stringWithFormat:@"进入%@最低需要%.0f余额，您不满足进入的条件，请充值后再来，点击前往充值",info.area_name,info.min_point] cancelButtonTitle:@"取消" otherButtonTitles:@[@"确认"] handler:^(UIAlertView *alertView, NSInteger buttonIndex) {
            if (buttonIndex == 1) {
                ChongZhiViewController *vc = [[ChongZhiViewController alloc]initWithNibName:@"ChongZhiViewController" bundle:nil];
                vc.isPush = YES;
                [self.navigationController pushViewController:vc animated:YES];
            }
        }];
        [alert show];
    }else{
        VipListViewController *vc = [[VipListViewController alloc]initWithNibName:@"VipListViewController" bundle:nil];
        vc.gameType = _gameType;
        vc.areaId = info.id;
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
        
        [weakSelf httpGetHouseAreaList];
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
