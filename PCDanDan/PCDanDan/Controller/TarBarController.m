//
//  TarBarController.m
//  YCSH
//
//  Created by xcode.qi on 17/1/17.
//  Copyright © 2017年 li. All rights reserved.
//

#import "TarBarController.h"
#import "HomePageViewController.h"
#import "ChongZhiViewController.h"
#import "UserCenterViewController.h"
#import "DongTaiViewController.h"
#import "VersionInfo.h"


@interface TarBarController ()<UITabBarControllerDelegate,EMClientDelegate>
{
    NSInteger selectIndex;
    HomePageViewController *homepageVc;
    ChongZhiViewController *czVc;
    DongTaiViewController *dtVc;
    UserCenterViewController * personVc;
    UIButton *scanButton;
    VersionInfo *versionInfo ;
}

@end

@implementation TarBarController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initTabBar];
    [self getUnreadMessageInfo];
    [self getUserInfo];
   
    [[NSNotificationCenter defaultCenter]addObserver:self
                                            selector:@selector(loginSucess)
                                                name:kLoginSuccessStatue
                                              object:nil];
    
    
    [self performSelector:@selector(httpCheckVerison) withObject:nil afterDelay:3];
}

- (void)loginSucess
{
    [self getUnreadMessageInfo];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)initTabBar
{
    [[EMClient sharedClient] addDelegate:self delegateQueue:nil];
    // 首页
    homepageVc = [[HomePageViewController alloc] initWithNibName:@"HomePageViewController" bundle:nil];
    UINavigationController *homePageNav = [[UINavigationController alloc] initWithRootViewController:homepageVc];
    
    czVc = [[ChongZhiViewController alloc] initWithNibName:@"ChongZhiViewController" bundle:nil];
    UINavigationController *czNav = [[UINavigationController alloc] initWithRootViewController:czVc];
    
    dtVc = [[DongTaiViewController alloc] initWithNibName:@"DongTaiViewController" bundle:nil];
    UINavigationController *dtNav = [[UINavigationController alloc] initWithRootViewController:dtVc];
    
    personVc = [[UserCenterViewController alloc]initWithNibName:@"UserCenterViewController" bundle:nil];
    UINavigationController *personNav = [[UINavigationController alloc] initWithRootViewController:personVc];
    
    
    self.viewControllers = [NSArray arrayWithObjects:homePageNav, czNav,dtNav,personNav,nil];
    self.delegate = self;
    
    
    //获取tabBarItem
    UITabBarItem *oneItem = [self.tabBar.items objectAtIndex:0];
    UITabBarItem *twoItem = [self.tabBar.items objectAtIndex:1];
    UITabBarItem *threeItem = [self.tabBar.items objectAtIndex:2];
    UITabBarItem *fourItem = [self.tabBar.items objectAtIndex:3];
    
    
    //设置tabBarItem背景图标
    [self setTabBarItem:oneItem withNormalImageName:@"shouye_49" andSelectedImageName:@"shouye_51" andTitle:@"首页"];
    [self setTabBarItem:twoItem withNormalImageName:@"shouye_53" andSelectedImageName:@"shouye_55"  andTitle:@"充值"];
    
    [self setTabBarItem:threeItem withNormalImageName:@"shouye_57" andSelectedImageName:@"shouye_59" andTitle:@"动态"];
    
    [self setTabBarItem:fourItem withNormalImageName:@"shouye_61" andSelectedImageName:@"shouye_64" andTitle:@"我的"];
    
    NSDictionary *dict = [NSDictionary dictionaryWithObjectsAndKeys:[UIColor grayColor],NSForegroundColorAttributeName, nil];
    [oneItem setTitleTextAttributes:dict forState:UIControlStateNormal];
    [twoItem setTitleTextAttributes:dict forState:UIControlStateNormal];
    [threeItem setTitleTextAttributes:dict forState:UIControlStateNormal];
    [fourItem setTitleTextAttributes:dict forState:UIControlStateNormal];
    
    NSDictionary *dict2 = [NSDictionary dictionaryWithObjectsAndKeys:RGB(58, 132, 255),
                           NSForegroundColorAttributeName,nil];
    [oneItem setTitleTextAttributes:dict2 forState:UIControlStateSelected];
    [twoItem setTitleTextAttributes:dict2 forState:UIControlStateSelected];
    [threeItem setTitleTextAttributes:dict2 forState:UIControlStateSelected];
    [fourItem setTitleTextAttributes:dict2 forState:UIControlStateSelected];
    
    
}


#pragma mark 设置tabBarItem默认图标和选中图标

- (BOOL)tabBarController:(UITabBarController *)tabBarController shouldSelectViewController:(UIViewController *)viewController
{
    NSInteger index = [tabBarController.viewControllers indexOfObject:viewController];

    
    if(index != 0)
    {
        if(![HttpMangerHelper islogin])
        {
            [HttpMangerHelper loginWithAnimated:YES viewController:nil];
            return NO;
        }
    }
    if(index == 3)
    {
        [[NSNotificationCenter defaultCenter] postNotificationName:kUpdateUserInfo object:nil];
    }
    [self getUnreadMessageInfo];
    [self getKefuInfo];
   
    [self httpCheckVerison];
    
    return YES;
}
- (void)setTabBarItem:(UITabBarItem *) tabBarItem withNormalImageName:(NSString *)normalImageName andSelectedImageName:(NSString *)selectedImageName andTitle:(NSString *)title
{
    [tabBarItem setImage:[[UIImage imageNamed:normalImageName] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]];
    [tabBarItem setSelectedImage:[[UIImage imageNamed:selectedImageName] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]];
    [tabBarItem setTitle:title];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    //改变tabbar 线条颜色
    CGRect rect = CGRectMake(0, 0, self.tabBar.frame.size.width, 1);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context,
                                   RGB(240, 240, 240).CGColor);
    CGContextFillRect(context, rect);
    UIImage *img = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    [self.tabBar setShadowImage:img];
    [self.tabBar setBackgroundImage:[[UIImage alloc]init]];
    self.tabBar.backgroundColor = [UIColor whiteColor];
}

- (void)getUnreadMessageInfo
{
    if([ShareManager shareInstance].userinfo && [ShareManager shareInstance].userinfo.islogin)
    {
        __weak TarBarController *weakSelf = self;
        [HttpMangerHelper  getUnReadMessageNumWithSuccess:^(UnReadMessageNumInfo * info) {
            if (info.notice_count > 0) {
//                NSArray *tabBarItems = weakSelf.tabBar.items;
                
//                UITabBarItem *personCenterTabBarItem = [tabBarItems objectAtIndex:2];
                [weakSelf.tabBar showBadgeOnItemIndex:2];
//                personCenterTabBarItem.badgeValue = [NSString stringWithFormat:@"%.0f",info.notice_count];//显示消息条数为 2
            }else{
                [weakSelf.tabBar hideBadgeOnItemIndex:2];
            }
        } fail:nil];
    }
}

- (void)getKefuInfo
{
    [HttpMangerHelper  getPTInfoWithSuccess:^(PingTaiServerInfo * info) {
    } fail:nil];
}

- (void)getUserInfo
{
    if([ShareManager shareInstance].userinfo && [ShareManager shareInstance].userinfo.islogin)
    {
        [HttpMangerHelper  getUserSelfInfoSuccess:^(UserInfo * info) {
        } fail:nil];
    }
}

- (void)httpCheckVerison
{
    NSDictionary *infoDictionary = [[NSBundle mainBundle] infoDictionary];
    NSString *appCurVersion = [infoDictionary objectForKey:@"CFBundleShortVersionString"];
    HttpHelper *helper = [[HttpHelper alloc] init];
    [helper checkVersionWithClientNo:appCurVersion
                             success:^(NSDictionary *resultDic){
                                 
                                 if ([[resultDic objectForKey:@"result_code"] integerValue] == 0) {
                                     if(![[resultDic objectForKey:@"data"] isKindOfClass:[NSString class]])
                                     {
                                         versionInfo = [[resultDic objectForKey:@"data"] objectByClass:[VersionInfo class]];
                                         NSString *verNew = [versionInfo.version_no stringByReplacingOccurrencesOfString:@"." withString:@""];
                                         NSString *verCurrent = [appCurVersion stringByReplacingOccurrencesOfString:@"." withString:@""];
                                         if ([verNew integerValue] > [verCurrent integerValue]) {
                                             if([versionInfo.status intValue] == 0)//选择性升级
                                             {
                                                 UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"版本提示" message:versionInfo.update_content delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
                                                 alert.tag = 1020;
                                                 [alert show];
                                             }else{
                                                 UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"版本提示" message:versionInfo.update_content delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
                                                 alert.tag = 2010;
                                                 [alert show];
                                             }
                                         }
                                     }
                                 }
                             }fail:^(NSString *decretion){
                                 
                             }];
}

#pragma mark -UIAlertViewDelegate

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (alertView.tag == 1020)//选择性升级
    {
        if (buttonIndex == 1) {
            
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:versionInfo.version_url]];
        }
    }else if (alertView.tag == 2010)//强制升级
    {
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:versionInfo.version_url]];
    }
}

- (void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex
{
    if (alertView.tag == 2010)//强制升级
    {
        UIWindow *window =  [UIApplication sharedApplication].keyWindow;
        [UIView animateWithDuration:1.0f animations:^{
            
            window.alpha = 0;
            
            window.frame = CGRectMake(0, window.bounds.size.width, 0, 0);
            
        } completion:^(BOOL finished) {
            
            exit(0);
        }];
    }
    if (alertView.tag == 1000 ) {
        [self quitLogin];
    }
}

#pragma mark - EMClientDelegate

- (void)_clearHelper
{
    //    self.conversationListVC = nil;
    [[EMClient sharedClient] logout:NO];
    [[NSNotificationCenter defaultCenter] postNotificationName:KQuitLogin object:nil];
}


- (void)didLoginFromOtherDevice
{
    [self _clearHelper];
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"提示" message:@"您的帐号在其他设备登录，请重新登陆！" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
    alertView.tag = 1000;
    [alertView show];
    
}

- (void)didRemovedFromServer
{
    [self _clearHelper];
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"提示" message:@"您的帐号被平台移除了，如有疑问请联系平台" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
    alertView.tag = 1000;
    [alertView show];
}

- (void)quitLogin
{
    
    [Tool saveUserInfoToDB:NO];
    [Tool gotoHomePage];
    
    [HttpMangerHelper loginWithAnimated:YES viewController:nil];
}

@end
