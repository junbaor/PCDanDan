//
//  DongTaiViewController.m
//  PCDanDan
//
//  Created by xcode.qi on 17/1/19.
//  Copyright © 2017年 li. All rights reserved.
//


#import "DongTaiViewController.h"
#import "MessageListTableViewCell.h"
#import "BannerListInfo.h"
#import "NoticeListInfo.h"

@interface DongTaiViewController ()<UINavigationControllerDelegate>
{
    BOOL isBannerTwo;
    BOOL isClickMyMessage;
    int pageNum;
    NSMutableArray *dataSourceArray;
    NSMutableArray *bannerInfoArray;
}

@end

@implementation DongTaiViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initVariable];
    [self updateSelectUi];
    [self setTabelViewRefresh];
    
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    __weak DongTaiViewController *weakSelf = self;
    [HttpMangerHelper  getUnReadMessageNumWithSuccess:^(UnReadMessageNumInfo * info) {
        if (info.notice_count > 0) {
            [weakSelf.tabBarController.tabBar showBadgeOnItemIndex:2];
        }else{
            [weakSelf.tabBarController.tabBar hideBadgeOnItemIndex:2];
        }
        
        if (info.my_notice_count > 0) {
            _wdxxNumLabel.hidden = NO;
        }else{
            _wdxxNumLabel.hidden = YES;
        }
        if (info.system_notice_count > 0) {
            _tgxxNumLabel.hidden = NO;
        }else{
            _tgxxNumLabel.hidden = YES;
        }
    } fail:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)initVariable
{
    self.title = @"动态";
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.navigationController.delegate = self;
    self.tabBarController.tabBar.translucent = NO;
    self.navigationController.navigationBar.translucent = NO;
    NSDictionary *attributes = [NSDictionary dictionaryWithObjectsAndKeys:
                                [UIColor whiteColor],
                                NSForegroundColorAttributeName, nil];
    
    [self.navigationController.navigationBar setTitleTextAttributes:attributes];
    self.navigationController.interactivePopGestureRecognizer.delegate = (id)self;
    
    _bannerViewHeight.constant = (FullScreen.size.width-20)*0.436;
    
    _bannerView.delegate = self;
    _bannerView.dataSource = self;
    _bannerView.autoScrollAble = YES;
    _bannerView.direction = CycleDirectionLandscape;
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapBanner:)];
    tap.numberOfTapsRequired = 1;
    [_bannerView addGestureRecognizer:tap];
    
    _bannerView.layer.masksToBounds =YES;
    _bannerView.layer.cornerRadius = 5;
    [_bannerView reloadData];
    
    _wdxxNumLabel.layer.masksToBounds =YES;
    _wdxxNumLabel.layer.cornerRadius = _wdxxNumLabel.height/2;
    _tgxxNumLabel.layer.masksToBounds =YES;
    _tgxxNumLabel.layer.cornerRadius = _tgxxNumLabel.height/2;
    dataSourceArray = [NSMutableArray array];
    
    bannerInfoArray = [NSMutableArray array];
}

- (void)updateSelectUi
{
    [_tgxxButton setTitleColor:RGB(153, 153, 153) forState:UIControlStateNormal];
    [_wdxxButton setTitleColor:RGB(153, 153, 153) forState:UIControlStateNormal];
    _tgxxLine.hidden = YES;
    _wdxxLine.hidden = YES;
    
    if (isClickMyMessage) {
        [_wdxxButton setTitleColor:RGB(58, 132, 255) forState:UIControlStateNormal];
        _wdxxLine.hidden = NO;
    }else{
        [_tgxxButton setTitleColor:RGB(58, 132, 255) forState:UIControlStateNormal];
        _tgxxLine.hidden = NO;
    }
}

#pragma mark - Action

//响应单击方法－跳转广告页面
- (void)tapBanner:(UITapGestureRecognizer *) tap
{
    if (_pageControl.currentPage >= bannerInfoArray.count ) {
        return;
    }
    
    BannerListInfo *info = [bannerInfoArray objectAtIndex:_pageControl.currentPage];
    
    if([info.is_go isEqualToString:@"1"])
    {
        SafariViewController *vc =[[SafariViewController alloc]initWithNibName:@"SafariViewController" bundle:nil];
        vc.title = @"详情";
        vc.urlStr = [NSString stringWithFormat:@"%@%@%@",URL_Server,Wap_Banner,info.id];
        vc.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:vc animated:YES];
    }
}

- (IBAction)clickTGXXBurronAction:(id)sender
{
    isClickMyMessage = NO;
    [self updateSelectUi];
    [_myTableView.mj_header beginRefreshing];
    if (dataSourceArray.count > 0 ) {
        [dataSourceArray removeAllObjects];
        [_myTableView reloadData];
    }
}

- (IBAction)clickMyMessageBurronAction:(id)sender
{
    isClickMyMessage = YES;
    [self updateSelectUi];
    [_myTableView.mj_header beginRefreshing];
    if (dataSourceArray.count > 0 ) {
        [dataSourceArray removeAllObjects];
        [_myTableView reloadData];
    }
}

#pragma mark - http
- (void)httpGetBannerList
{
    HttpHelper *helper = [[HttpHelper alloc] init];
    __weak DongTaiViewController *weakSelf = self;
    [helper getBannerInfoByPlace:@"2"
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
    [_bannerView reloadData];
}


- (void)httpNoticeList
{
    NSString *userId = nil;
    if([ShareManager shareInstance].userinfo.islogin)
    {
        userId = [ShareManager shareInstance].userinfo.id;
    }
    NSString *typeStr = isClickMyMessage == YES?@"2":@"1";
    
    HttpHelper *helper = [[HttpHelper alloc] init];
    __weak DongTaiViewController *weakSelf = self;
    [helper getNoticeListWithPageNo:[NSString stringWithFormat:@"%d",pageNum]
                          page_size:@"20"
                            user_id:userId
                               type:typeStr
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
        if (pageNum != 1) {
            [Tool showPromptContent:@"没有更多数据啦" onView:self.view];
        }
        [_myTableView.mj_footer endRefreshingWithNoMoreData];
    }
    [_myTableView reloadData];
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
    
    if (isBannerTwo) {
        _pageControl.numberOfPages = 2;
    }else{
        _pageControl.numberOfPages = bannerInfoArray.count;
    }
    
    return  bannerInfoArray.count;
    
}

- (void)cycleScrollView:(CycleScrollView *)cycleScrollView didScrollView:(int)index
{
    if (isBannerTwo)
    {
        _pageControl.currentPage = index%2;
        
    }else{
        _pageControl.currentPage = index;
    }
    
}

- (CGRect)frameOfCycleScrollView:(CycleScrollView *)cycleScrollView
{
    return CGRectMake(0, 0, (FullScreen.size.width-20),(FullScreen.size.width-20)*0.436);
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
        
        [weakSelf httpGetBannerList];
        pageNum = 1;
        [weakSelf httpNoticeList];
    }];
    // 设置自动切换透明度(在导航栏下面自动隐藏)
    tableView.mj_header.automaticallyChangeAlpha = YES;
    [tableView.mj_header beginRefreshing];
    
    tableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        [weakSelf httpNoticeList];
        
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



#pragma mark - UINavigationControllerDelegate

- (void)navigationController:(UINavigationController *)navigationController willShowViewController:(UIViewController *)viewController animated:(BOOL)animated
{
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
   
}

- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer
{
    if (self.navigationController.childViewControllers.count == 1) {
        return NO;
    }else{
        return YES;
    }
}


@end
