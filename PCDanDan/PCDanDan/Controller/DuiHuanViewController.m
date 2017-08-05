//
//  DuiHuanViewController.m
//  PCDanDan
//
//  Created by xcode.qi on 17/1/19.
//  Copyright © 2017年 li. All rights reserved.
//


#import "DuiHuanViewController.h"
#import "GoodsListTableViewCell.h"
#import "DuiHuanInfoViewController.h"
#import "BankBangdingViewController.h"
#import "GiftListInfo.h"
#import "DuiHuanRecordListViewController.h"

@interface DuiHuanViewController ()
{
    NSMutableArray *dataSourceArray;
    int pageNo;
}

@end

@implementation DuiHuanViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initVariable];
    [self setNavigationItem];
    [self setTabelViewRefresh];
 
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (void)initVariable
{
    self.title = @"礼品兑换";
    dataSourceArray = [NSMutableArray array];
    
}

- (void)setNavigationItem
{
    UIControl *leftItemControl = [[UIControl alloc] initWithFrame:CGRectMake(0, 0, 20, 44)];
    [leftItemControl addTarget:self action:@selector(clickLeftControlAction:) forControlEvents:UIControlEventTouchUpInside];
    
    UIImageView *back = [[UIImageView alloc] initWithFrame:CGRectMake(0, 13, 18, 18)];
    back.image = [UIImage imageNamed:@"shouye_85.png"];
    [leftItemControl addSubview:back];
    
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:leftItemControl];
    
    UIView *rightItemView = [[UIView alloc] initWithFrame:CGRectMake(0, 8, 65, 44)];
    
    UIButton *jiluButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 65, 44)];
    [jiluButton setTitleEdgeInsets:UIEdgeInsetsMake(8, 0, 8,8)];
    [jiluButton setTitle:@"兑换纪录" forState:UIControlStateNormal];
    [jiluButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    jiluButton.titleLabel.font = [UIFont systemFontOfSize:13];
    [jiluButton addTarget:self action:@selector(clickRecordButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    [rightItemView addSubview:jiluButton];
    
    UIBarButtonItem *rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:rightItemView];
    
    UIBarButtonItem *negativeSpacer = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace
                                                                                    target:nil
                                                                                    action:nil];
    negativeSpacer.width = -15;
    self.navigationItem.rightBarButtonItems = @[negativeSpacer, rightBarButtonItem];
}



#pragma mark - button action

- (void)clickLeftControlAction:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)clickRecordButtonAction:(id)sender
{
    DuiHuanRecordListViewController *vc = [[DuiHuanRecordListViewController alloc]initWithNibName:@"DuiHuanRecordListViewController" bundle:nil];
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)clickDuiHuanButtonAction:(UIButton *)btn
{
    if(![HttpMangerHelper isBangDingPhone])
    {
        __weak DuiHuanViewController *ws = self;
        UIAlertView *alert = [UIAlertView bk_showAlertViewWithTitle:@"提示" message:@"为了您的资金安全，请绑定手机号" cancelButtonTitle:@"确定" otherButtonTitles:nil handler:^(UIAlertView *alertView, NSInteger buttonIndex) {
            [HttpMangerHelper gotoBangDingWithAnimated:YES viewController:ws];
        }];
        [alert show];
    }else{
        if(![HttpMangerHelper isSetTiXianPwd])
        {
            __weak DuiHuanViewController *ws = self;
            UIAlertView *alert = [UIAlertView bk_showAlertViewWithTitle:@"提示" message:@"请先设置提现密码" cancelButtonTitle:@"确定" otherButtonTitles:nil handler:^(UIAlertView *alertView, NSInteger buttonIndex) {
                [HttpMangerHelper setTiXianPwdWithAnimated:YES viewController:ws];
            }];
            [alert show];
        }else{
            
            if ([ShareManager shareInstance].userinfo.bank_no.length > 0 && ![[ShareManager shareInstance].userinfo.bank_no isEqualToString:@"<null>"] ) {
                
                GiftListInfo *info = [dataSourceArray objectAtIndex:btn.tag];
                DuiHuanInfoViewController *vc = [[DuiHuanInfoViewController alloc]initWithNibName:@"DuiHuanInfoViewController" bundle:nil];
                vc.giftInfo = info;
                self.definesPresentationContext = YES; //self is presenting view controller
                //    vc.delegate = self;
                vc.view.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.4];
                if ([[UIDevice currentDevice].systemVersion floatValue] < 8.0)
                {
                    self.view.window.rootViewController.modalPresentationStyle = UIModalPresentationCurrentContext;//半透明全靠这句了
                }
                vc.modalPresentationStyle = UIModalPresentationOverCurrentContext;
                UIViewController * rootViewController = [UIApplication sharedApplication].keyWindow.rootViewController;
                [rootViewController presentViewController:vc animated:YES completion:nil];
            }else{
                
                __weak DuiHuanViewController *ws = self;
                UIAlertView *alert = [UIAlertView bk_showAlertViewWithTitle:@"提示" message:@"您未绑定银行卡，请先绑定银行卡" cancelButtonTitle:@"确定" otherButtonTitles:nil handler:^(UIAlertView *alertView, NSInteger buttonIndex) {
                    BankBangdingViewController *vc = [[BankBangdingViewController alloc]initWithNibName:@"BankBangdingViewController" bundle:nil];
                    [ws.navigationController pushViewController:vc animated:YES];
                }];
                [alert show];
                
            }
        }
    }
    
    
}

#pragma mark -http

- (void)httpGetGiftList
{
    HttpHelper *helper = [[HttpHelper alloc] init];
    __weak DuiHuanViewController *weakSelf = self;
    [helper getGiftListInfoWithPage_no:[NSString stringWithFormat:@"%d",pageNo]
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
            GiftListInfo *info = [dic objectByClass:[GiftListInfo class]];
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
    return 100;
}


//创建并显示每行的内容
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    GoodsListTableViewCell *cell = nil;
    cell = [tableView dequeueReusableCellWithIdentifier:@"GoodsListTableViewCell"];
    if (cell == nil)
    {
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"GoodsListTableViewCell" owner:nil options:nil];
        cell = [nib objectAtIndex:0];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.duihuanButton.layer.masksToBounds =YES;
        cell.duihuanButton.layer.cornerRadius = 5;
    }
    GiftListInfo *info = [dataSourceArray objectAtIndex:indexPath.row];
    
    NSString *url = info.gift_photo;
    [cell.goodsImage sd_setImageWithURL:[NSURL URLWithString:url] placeholderImage:nil];
    cell.goodsName.text = info.gift_name;
    cell.moneyLabel.text = [NSString stringWithFormat:@"%.2f元宝",info.gift_point];
    cell.duihuanButton.tag = indexPath.row;
    [cell.duihuanButton addTarget:self action:@selector(clickDuiHuanButtonAction:) forControlEvents:UIControlEventTouchUpInside];
   
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
        [weakSelf httpGetGiftList];
    }];
    // 设置自动切换透明度(在导航栏下面自动隐藏)
    tableView.mj_header.automaticallyChangeAlpha = YES;
    [tableView.mj_header beginRefreshing];
    
    tableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        [weakSelf httpGetGiftList];
        
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
