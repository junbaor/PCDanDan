//
//  HomePageViewController.m
//  PCDanDan
//
//  Created by xcode.qi on 17/1/19.
//  Copyright © 2017年 li. All rights reserved.
//

#import "HomePageViewController.h"
#import "BannerTableViewCell.h"
#import "HomepageAllDataTableViewCell.h"
#import "HomePageTypeTableViewCell.h"
#import "MoreViewController.h"
#import "HouseListViewController.h"
#import "HomePageDataInfo.h"
#import "BannerListInfo.h"
#import "ChatViewController.h"
#import "ChongZhiViewController.h"
#import "TiXianViewController.h"
#import "BankBangdingViewController.h"

@interface HomePageViewController ()<UINavigationControllerDelegate>
{
    NSMutableArray *bannerInfoArray;
    HomePageDataInfo *numInfo;
    BOOL isBannerTwo;
    UIButton *moreButton;
}

@end

@implementation HomePageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initVariable];
    [self createUi];
    [self setTabelViewRefresh];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    NSDictionary *dict1 = @{@"imageName" : @"shouye_cz",
                            @"itemName" : @"充值"
                            };
    NSDictionary *dict2 = @{@"imageName" : @"shouye_tx",
                            @"itemName" : @"提现"
                            };
    NSArray *dataArray = @[dict1,dict2];
    __weak __typeof(&*self)weakSelf = self;
    /**
     *  创建普通的MenuView，frame可以传递空值，宽度默认120，高度自适应
     */
    [CommonMenuView createMenuWithFrame:CGRectZero target:self dataArray:dataArray itemsClickBlock:^(NSString *str, NSInteger tag) {
        [self->moreButton setSelected:NO];
        [weakSelf doSomething:(NSString *)str tag:(NSInteger)tag]; // do something
    } backViewTap:^{
        [self->moreButton setSelected:NO];
    }];
}

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    [CommonMenuView clearMenu];
}

- (void)initVariable
{
    self.title = @"游戏大厅";
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.navigationController.delegate = self;
    self.tabBarController.tabBar.translucent = NO;
    self.navigationController.navigationBar.translucent = NO;
    NSDictionary *attributes = [NSDictionary dictionaryWithObjectsAndKeys:
                                [UIColor whiteColor],
                                NSForegroundColorAttributeName, nil];
    
    [self.navigationController.navigationBar setTitleTextAttributes:attributes];
    self.navigationController.interactivePopGestureRecognizer.delegate = (id)self;
    
    bannerInfoArray = [NSMutableArray array];
    
    
}


- (void)createUi
{
    UIControl *leftItemControl = [[UIControl alloc] initWithFrame:CGRectMake(0, 0, 20, 44)];
    [leftItemControl addTarget:self action:@selector(clickLeftControlAction:) forControlEvents:UIControlEventTouchUpInside];
    
    UIImageView *back = [[UIImageView alloc] initWithFrame:CGRectMake(0, 12, 20, 20)];
    back.image = [UIImage imageNamed:@"shouye_77.png"];
    [leftItemControl addSubview:back];
    
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:leftItemControl];
    
    
    
    UIView *rightItemView = [[UIView alloc] initWithFrame:CGRectMake(0, 8, 80, 40)];
    
    UIButton *kefuButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 40, 40)];
    [kefuButton setImageEdgeInsets:UIEdgeInsetsMake(9, 14, 11, 5)];
    [kefuButton setImage:[UIImage imageNamed:@"shouye_81"] forState:UIControlStateNormal];
    [kefuButton addTarget:self action:@selector(clickKefuButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    [rightItemView addSubview:kefuButton];
    
    moreButton = [[UIButton alloc] initWithFrame:CGRectMake(40, 0, 40, 40)];
    [moreButton setImageEdgeInsets:UIEdgeInsetsMake(9, 7, 10, 13)];
    [moreButton setImage:[UIImage imageNamed:@"shouye_83"] forState:UIControlStateNormal];
    [moreButton setImage:[UIImage imageNamed:@"shouye_75"] forState:UIControlStateSelected];
    [moreButton addTarget:self action:@selector(clickMoreListButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    [rightItemView addSubview:moreButton];
    
    
    UIBarButtonItem *rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:rightItemView];
    
    UIBarButtonItem *negativeSpacer = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace
                                                                                    target:nil
                                                                                    action:nil];
    negativeSpacer.width = -15;
    self.navigationItem.rightBarButtonItems = @[negativeSpacer, rightBarButtonItem];
}


#pragma mark - http

- (void)httpGetHomePageData
{
    HttpHelper *helper = [[HttpHelper alloc] init];
    __weak HomePageViewController *weakSelf = self;
    [helper getHomePageDataWithSuccess:^(NSDictionary *resultDic){

         if ([[resultDic objectForKey:@"result_code"] integerValue] == 0) {
             [weakSelf handleloadResult:resultDic];
         }else
         {
             [Tool showPromptContent:[resultDic objectForKey:@"result_desc"] onView:self.view];
         }
     }fail:^(NSString *decretion){

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
    
    numInfo = [[resultDic objectForKey:@"data"] objectByClass:[HomePageDataInfo class]];

    [_myTableView reloadData];
}



- (void)httpGetBannerList
{
    HttpHelper *helper = [[HttpHelper alloc] init];
    __weak HomePageViewController *weakSelf = self;
    [helper getBannerInfoByPlace:@"1"
                         success:^(NSDictionary *resultDic){
                             [self hideRefresh];
                             if ([[resultDic objectForKey:@"result_code"] integerValue] == 0) {
                                 [weakSelf handleloadGetBannerListResult:resultDic];
                             }else
                             {
                                 [Tool showPromptContent:[resultDic objectForKey:@"result_desc"] onView:self.view];
                             }
                         }fail:^(NSString *decretion){
                             [self hideRefresh];
                             [Tool showPromptContent:@"网络出错了" onView:self.view];
                         }];
    
}

- (void)handleloadGetBannerListResult:(NSDictionary *)resultDic
{
    if(!resultDic)
    {
        [Tool showPromptContent:@"请求失败" onView:self.view];
        return;
    }
    
    //banner
    NSArray *resourceArray = [resultDic objectForKey:@"data"];
    if (bannerInfoArray.count > 0) {
        [bannerInfoArray removeAllObjects];
    }
    if (resourceArray && resourceArray.count > 0)
    {
        for (NSDictionary *dic in resourceArray)
        {
            BannerListInfo *info = [dic objectByClass:[BannerListInfo class]];
            [bannerInfoArray addObject:info];
        }
        if (bannerInfoArray.count == 2) {
            isBannerTwo = YES;
            [bannerInfoArray addObject:[bannerInfoArray objectAtIndex:0]];
            [bannerInfoArray addObject:[bannerInfoArray objectAtIndex:1]];
        }else{
            isBannerTwo = NO;
        }
        
    }
    [_myTableView reloadData];
}



#pragma mark - button action

- (void)clickLeftControlAction:(id)sender
{
    if(![HttpMangerHelper islogin])
    {
        [HttpMangerHelper loginWithAnimated:YES viewController:nil];
        return;
    }
    
    
    
    MoreViewController *vc = [[MoreViewController alloc]initWithNibName:@"MoreViewController" bundle:nil];
    
    UINavigationController *nav = [[UINavigationController alloc]initWithRootViewController:vc];
    
    [self presentViewController:nav animated:YES completion:nil];
}

- (void)clickKefuButtonAction:(id)sender
{
    
    KeFuViewController *vc =[[KeFuViewController alloc]initWithNibName:@"KeFuViewController" bundle:nil];
    vc.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:vc animated:YES];
}

//响应单击方法－跳转广告页面
- (void)tapBanner:(UITapGestureRecognizer *) tap
{
   
    
    BannerTableViewCell *cell = objc_getAssociatedObject(tap, "cell");
    if (cell.pageController.currentPage >= bannerInfoArray.count ) {
        return;
    }
    
    BannerListInfo *info = [bannerInfoArray objectAtIndex:cell.pageController.currentPage];
    
    if([info.is_go isEqualToString:@"1"])
    {
        SafariViewController *vc =[[SafariViewController alloc]initWithNibName:@"SafariViewController" bundle:nil];
        vc.title = @"详情";
        vc.urlStr = [NSString stringWithFormat:@"%@%@%@",URL_Server,Wap_Banner,info.id];
        vc.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:vc animated:YES];
    }
    
}

- (void)clickXY28ButtonAction:(id)sender
{
    if(![HttpMangerHelper islogin])
    {
        [HttpMangerHelper loginWithAnimated:YES viewController:nil];
        return;
    }
    HouseListViewController *vc = [[HouseListViewController alloc]initWithNibName:@"HouseListViewController" bundle:nil];
    vc.hidesBottomBarWhenPushed = YES;
    vc.title = @"北京28";
    vc.gameType = @"1";
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)clickXY28SMButtonAction:(id)sender
{
    SafariViewController *vc = [[SafariViewController alloc]initWithNibName:@"SafariViewController" bundle:nil];
    vc.title = @"北京28玩法说明";
    vc.urlStr = [NSString stringWithFormat:@"%@%@",URL_Server,Wap_BJWFSM];
    vc.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)clickJND28ButtonAction:(id)sender
{
    if(![HttpMangerHelper islogin])
    {
        [HttpMangerHelper loginWithAnimated:YES viewController:nil];
        return;
    }
    HouseListViewController *vc = [[HouseListViewController alloc]initWithNibName:@"HouseListViewController" bundle:nil];
    vc.hidesBottomBarWhenPushed = YES;
    vc.title = @"加拿大28";
    vc.gameType = @"2";
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)clickJND28SMButtonAction:(id)sender
{
    SafariViewController *vc = [[SafariViewController alloc]initWithNibName:@"SafariViewController" bundle:nil];
    vc.title = @"加拿大28玩法说明";
    vc.urlStr = [NSString stringWithFormat:@"%@%@",URL_Server,Wap_JNDWFSM];
    vc.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)clickMoreListButtonAction:(UIButton *)btn
{
    [moreButton setSelected:YES];
    [CommonMenuView showMenuAtPoint:CGPointMake(self.navigationController.view.width - 25, 50)];
}

#pragma mark -- CommonMenuView 回调事件(自定义)
- (void)doSomething:(NSString *)str tag:(NSInteger)tag{
    
    [CommonMenuView hidden];
    
    switch (tag){
        case 1:
        {
            if(![HttpMangerHelper islogin])
            {
                [HttpMangerHelper loginWithAnimated:YES viewController:nil];
                return;
            }
            
            ChongZhiViewController *vc = [[ChongZhiViewController alloc]initWithNibName:@"ChongZhiViewController" bundle:nil];
            vc.isPush = YES;
            vc.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:vc animated:YES];
        }
            break;
        case 2:
        {
            if(![HttpMangerHelper islogin])
            {
                [HttpMangerHelper loginWithAnimated:YES viewController:nil];
                return;
            }
            
            if(![HttpMangerHelper isBangDingPhone])
            {
                __weak HomePageViewController *ws = self;
                UIAlertView *alert = [UIAlertView bk_showAlertViewWithTitle:@"提示" message:@"为了您的资金安全，请绑定手机号" cancelButtonTitle:@"确定" otherButtonTitles:nil handler:^(UIAlertView *alertView, NSInteger buttonIndex) {
                    [HttpMangerHelper gotoBangDingWithAnimated:YES viewController:ws];
                }];
                [alert show];
            }else{
                if(![HttpMangerHelper isSetTiXianPwd])
                {
                    __weak HomePageViewController *ws = self;
                    UIAlertView *alert = [UIAlertView bk_showAlertViewWithTitle:@"提示" message:@"请先设置提现密码" cancelButtonTitle:@"确定" otherButtonTitles:nil handler:^(UIAlertView *alertView, NSInteger buttonIndex) {
                        [HttpMangerHelper setTiXianPwdWithAnimated:YES viewController:ws];
                    }];
                    [alert show];
                }else{
                    
                    if ([ShareManager shareInstance].userinfo.bank_no.length > 0 && ![[ShareManager shareInstance].userinfo.bank_no isEqualToString:@"<null>"] ) {
                        TiXianViewController *vc = [[TiXianViewController alloc]initWithNibName:@"TiXianViewController" bundle:nil];
                        vc.hidesBottomBarWhenPushed = YES;
                        [self.navigationController pushViewController:vc animated:YES];
                        
                    }else{
                        
                        __weak HomePageViewController *ws = self;
                        UIAlertView *alert = [UIAlertView bk_showAlertViewWithTitle:@"提示" message:@"您未绑定银行卡，请先绑定银行卡" cancelButtonTitle:@"确定" otherButtonTitles:nil handler:^(UIAlertView *alertView, NSInteger buttonIndex) {
                            BankBangdingViewController *vc = [[BankBangdingViewController alloc]initWithNibName:@"BankBangdingViewController" bundle:nil];
                            vc.hidesBottomBarWhenPushed = YES;
                            [ws.navigationController pushViewController:vc animated:YES];
                        }];
                        [alert show];
                        
                    }
                }
            }
            
        }
            break;
            
        default:
            break;
    }
    
    
}


#pragma mark - UITableViewDelegate

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}
//行数
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
    return 3;
    
}

//设置cell的行高
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 0) {
        return (FullScreen.size.width-20)*0.436+10;
    }else if(indexPath.row == 1){
        return 96;
        
    }else{
        if (FullScreen.size.width > 375) {
            return FullScreen.size.width*0.83;
        }else{
            return FullScreen.size.width*0.78;
        }
        
    }
}


//创建并显示每行的内容
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 0) {
        
        BannerTableViewCell *cell = nil;
        cell = [tableView dequeueReusableCellWithIdentifier:@"BannerTableViewCell"];
        if (cell == nil)
        {
            NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"BannerTableViewCell" owner:nil options:nil];
            cell = [nib objectAtIndex:0];
            cell.bannerView.delegate = self;
            cell.bannerView.dataSource = self;
            cell.bannerView.autoScrollAble = YES;
            cell.bannerView.tag = 100;
            cell.bannerView.direction = CycleDirectionLandscape;
            objc_setAssociatedObject(cell.bannerView, "cell", cell, OBJC_ASSOCIATION_ASSIGN);
            UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapBanner:)];
            tap.numberOfTapsRequired = 1;
            objc_setAssociatedObject(tap, "cell", cell, OBJC_ASSOCIATION_ASSIGN);
            [cell.bannerView addGestureRecognizer:tap];
            
            cell.bannerView.layer.masksToBounds =YES;
            cell.bannerView.layer.cornerRadius = 5;
            
            
        }
        //设点点击选择的颜色(无)
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        [cell.bannerView reloadData];
        return cell;
    }else if(indexPath.row == 1){
        
        HomepageAllDataTableViewCell *cell = nil;
        cell = [tableView dequeueReusableCellWithIdentifier:@"HomepageAllDataTableViewCell"];
        if (cell == nil)
        {
            NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"HomepageAllDataTableViewCell" owner:nil options:nil];
            cell = [nib objectAtIndex:0];
        }
        if(numInfo)
        {
            cell.moneyLabel.text = [NSString stringWithFormat:@"%.0f元宝",numInfo.point];
            cell.peopleNumLabel.text = [NSString stringWithFormat:@"%.0f人",numInfo.user_count];
            cell.numLabel.text = [NSString stringWithFormat:@"%.0f",numInfo.bili*100];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
        }
        
        return cell;
    }else{
        
        HomePageTypeTableViewCell *cell = nil;
        cell = [tableView dequeueReusableCellWithIdentifier:@"HomePageTypeTableViewCell"];
        if (cell == nil)
        {
            NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"HomePageTypeTableViewCell" owner:nil options:nil];
            cell = [nib objectAtIndex:0];
        }
        [cell.xy28Button addTarget:self action:@selector(clickXY28ButtonAction:) forControlEvents:UIControlEventTouchUpInside];
        [cell.xy28SMButton addTarget:self action:@selector(clickXY28SMButtonAction:) forControlEvents:UIControlEventTouchUpInside];
        
        [cell.jnd28Button addTarget:self action:@selector(clickJND28ButtonAction:) forControlEvents:UIControlEventTouchUpInside];
        [cell.jnd28SMButton addTarget:self action:@selector(clickJND28SMButtonAction:) forControlEvents:UIControlEventTouchUpInside];
        
        cell.selectionStyle = UITableViewCellSelectionStyleNone;

        return cell;
    }
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    
}

#pragma mark - CycleScrollViewDataSource

- (UIView *)cycleScrollView:(CycleScrollView *)cycleScrollView viewAtPage:(NSInteger)page
{
    UIImageView *imageView = [[UIImageView alloc] init];
    imageView.contentMode = UIViewContentModeScaleToFill;
    imageView.userInteractionEnabled = YES;
    
    if(page >= bannerInfoArray.count)
    {
        imageView.image = PublicImage(@"");
        return imageView;
    }
    
    BannerListInfo *bannerInfo = [bannerInfoArray objectAtIndex:page];
    NSString *url = bannerInfo.banner_imgurl;
    [imageView sd_setImageWithURL:[NSURL URLWithString:url] placeholderImage:nil];
    
    return imageView;
}

- (NSInteger)numberOfViewsInCycleScrollView:(CycleScrollView *)cycleScrollView
{
    BannerTableViewCell *cell = objc_getAssociatedObject(cycleScrollView, "cell");
    if (isBannerTwo) {
        cell.pageController.numberOfPages = 2;
    }else{
        cell.pageController.numberOfPages = bannerInfoArray.count;
    }
    return  bannerInfoArray.count;
}

- (void)cycleScrollView:(CycleScrollView *)cycleScrollView didScrollView:(int)index
{
    BannerTableViewCell *cell = objc_getAssociatedObject(cycleScrollView, "cell");
    if (isBannerTwo)
    {
        cell.pageController.currentPage = index%2;
        
    }else{
        cell.pageController.currentPage = index;
    }
}

- (CGRect)frameOfCycleScrollView:(CycleScrollView *)cycleScrollView
{
    return CGRectMake(0, 0, (FullScreen.size.width-20),(FullScreen.size.width-20)*0.436);
}


#pragma mark - tableview 上下拉刷新

- (void)setTabelViewRefresh
{
    __unsafe_unretained UITableView *tableView = self.myTableView;
    __unsafe_unretained __typeof(self) weakSelf = self;
    // 下拉刷新
    tableView.mj_header= [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        
        [weakSelf httpGetHomePageData];
        [weakSelf httpGetBannerList];
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

- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer
{
    if (self.navigationController.childViewControllers.count == 1) {
        return NO;
    }else{
        if ([self.navigationController.topViewController isKindOfClass:[ChatViewController class]]) {
            return NO;
        }else{
            return YES;
        }
    }
}

#pragma mark - UINavigationControllerDelegate

- (void)navigationController:(UINavigationController *)navigationController willShowViewController:(UIViewController *)viewController animated:(BOOL)animated
{
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
}

@end
