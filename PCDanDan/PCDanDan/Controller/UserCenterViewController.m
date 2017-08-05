//
//  UserCenterViewController.m
//  PCDanDan
//
//  Created by xcode.qi on 17/1/17.
//  Copyright © 2017年 li. All rights reserved.
//

#import "UserCenterViewController.h"
#import "UserInfoHeadTableViewCell.h"
#import "UserCenterListTableViewCell.h"
#import "ModifyUserInfoViewController.h"
#import "DuiHuanViewController.h"
#import "MyWallectViewController.h"
#import "SettingViewController.h"
#import "ShareViewController.h"
#import "AboutOurViewController.h"
#import "HuishuiListViewController.h"
#import "BianZhangRecordViewController.h"
#import "GameRecordViewController.h"
#import "MyShouYiViewController.h"

@interface UserCenterViewController ()<UINavigationControllerDelegate,ModifyUserInfoViewControllerDelegate>
{
    NSMutableArray *dataSourceArray;
    NSMutableArray *iconImageArray;
    MBProgressHUD *HUD;
}

@end

@implementation UserCenterViewController

- (void)dealloc
{
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:kReachableNetworkStatusChange object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:kUpdateUserInfo object:nil];
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initVariable];
    [self registerNotif];
    [self updateUserInfoData];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)initVariable
{
    self.title = @"我的";
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.navigationController.delegate = self;
    self.tabBarController.tabBar.translucent = NO;
    self.navigationController.navigationBar.translucent = NO;
    NSDictionary *attributes = [NSDictionary dictionaryWithObjectsAndKeys:
                                [UIColor whiteColor],
                                NSForegroundColorAttributeName, nil];
    
    [self.navigationController.navigationBar setTitleTextAttributes:attributes];
    self.navigationController.interactivePopGestureRecognizer.delegate = (id)self;
    
    dataSourceArray = [NSMutableArray arrayWithObjects:@"礼物兑换",@"钱包",@"我的回水",@"账变记录",@"游戏记录",@"我的收益",@"我要分享",@"设置",@"关于", nil];//
    iconImageArray = [NSMutableArray arrayWithObjects:@"wode_34",@"wode_44",@"wode_56",@"wode_69",@"wode_76",@"wode_75",@"wode_83",@"wode_72",@"wode_79", nil];//
    
    HUD = [[MBProgressHUD alloc] initWithView:self.view];
    [self.view addSubview:HUD];
    
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    // 显示导航栏
    [self.navigationController setNavigationBarHidden:NO animated:animated];
    [_myTableView reloadData];
}


#pragma mark - notif Action
- (void)registerNotif
{
    /**
     *  监听网络状态变化
     */
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(checkNetworkStatus:)
                                                 name:kReachableNetworkStatusChange
                                               object:nil];
    
    //刷新用户信息
    [[NSNotificationCenter defaultCenter]addObserver:self
                                            selector:@selector(updateUserInfoData)
                                                name:kUpdateUserInfo
                                              object:nil];
    
    
}

//网络状态捕捉
- (void)checkNetworkStatus:(NSNotification *)notif
{
    NSDictionary *netInfo = [notif userInfo];
    if(netInfo)
    {
        [self updateUserInfoData];
    }
}

- (void)updateUserInfoData
{
     __weak UserCenterViewController *weakSelf = self;
     [HttpMangerHelper  getUserSelfInfoSuccess:^(UserInfo * info) {
  
        [weakSelf.myTableView reloadData];
    } fail:nil];
}
#pragma mark - action

- (void)clickPhotoButtonAction:(UIButton *)btn
{
    __weak UserCenterViewController *weakSelf = self;
    NSIndexPath *index = [NSIndexPath indexPathForRow:0 inSection:0];
    UserInfoHeadTableViewCell *cell = [_myTableView cellForRowAtIndexPath:index];
    [[ShareManager shareInstance] selectPictureFromDevice:self isReduce:YES isSelect:YES isEdit:YES block:^(UIImage * image,NSString* imageName){
        cell.headPhoto.image = image;
        [weakSelf httpUserInfoWithImage:image];
    }];
}

#pragma mark - http
- (void)httpUserInfoWithImage:(UIImage *)headPhotoImage
{
    [HUD show:YES];
    HttpHelper *helper = [[HttpHelper alloc] init];
    __weak UserCenterViewController *weakSelf = self;
    [helper postImageHttpWithImage:headPhotoImage
                           success:^(NSDictionary *resultDic){
                               if ([[resultDic objectForKey:@"result_code"] integerValue] == 0 && resultDic)
                               {
                                   [weakSelf handleloadPostImageResult:resultDic];
                               }else{
                                   [HUD hide:YES];
                                   [Tool showPromptContent:[resultDic objectForKey:@"result_desc"] onView:self.view];
                               }
                               
                           }fail:^(NSString *decretion){
                               [HUD hide:YES];
                               [Tool showPromptContent:@"网络出错了" onView:self.view];
                           }];
    
}

- (void)handleloadPostImageResult:(NSDictionary *)resultDic
{
    if([[resultDic objectForKey:@"data"] isKindOfClass:[NSString class]])
    {
        NSString* imageUrlStr = [resultDic objectForKey:@"data"];
        [self httpUpdateUserInfoWithPhoto:imageUrlStr];
    }else{
        [HUD hide:YES];
        [Tool showPromptContent:@"图片上传失败" onView:self.view];
    }
    
}

- (void)httpUpdateUserInfoWithPhoto:(NSString *)imageUrlStr
{
    HttpHelper *helper = [[HttpHelper alloc] init];
    __weak UserCenterViewController *weakSelf = self;
    [helper updateUserInfoWithUserId:[ShareManager shareInstance].userinfo.id
                          user_photo:imageUrlStr
                           nick_name:nil
                             signStr:nil
                                 sex:nil
                              mobile:nil
                withdrawals_password:nil
                        old_password:nil
                            password:nil
                              msg_id:nil
                            msg_code:nil
                             success:^(NSDictionary *resultDic){
                                 if ([[resultDic objectForKey:@"result_code"] integerValue] == 0 && resultDic)
                                 {
                                     [weakSelf handleloadUpdateResult:resultDic];
                                 }else
                                 {
                                     [HUD hide:YES];
                                     if(!resultDic)
                                     {
                                         [Tool showPromptContent:@"请求失败" onView:self.view];
                                     }else{
                                         
                                         [Tool showPromptContent:[resultDic objectForKey:@"result_desc"] onView:self.view];
                                     }
                                 }
                             }fail:^(NSString *decretion){
                                 [HUD hide:YES];
                                 [Tool showPromptContent:@"网络出错了" onView:self.view];
                             }];
    
}

- (void)handleloadUpdateResult:(NSDictionary *)resultDic
{
    __weak UserCenterViewController *weakSelf = self;
    [HttpMangerHelper  getUserSelfInfoSuccess:^(UserInfo * info) {
        [HUD hide:YES];
        [weakSelf.myTableView reloadData];
    } fail:^(NSString *description) {
        [HUD hide:YES];
    }];
}


#pragma mark - UITableViewDelegate

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}
//行数
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 0) {
        return 1;
    }else{
         return dataSourceArray.count;
    }
   
    
}

//设置cell的行高
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        return 130;
    }else{
        return 53;
    }
}


//创建并显示每行的内容
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        UserInfoHeadTableViewCell *cell = nil;
        cell = [tableView dequeueReusableCellWithIdentifier:@"UserInfoHeadTableViewCell"];
        if (cell == nil)
        {
            NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"UserInfoHeadTableViewCell" owner:nil options:nil];
            cell = [nib objectAtIndex:0];
            
            cell.headPhoto.layer.masksToBounds =YES;
            cell.headPhoto.layer.cornerRadius = cell.headPhoto.frame.size.height/2;
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
        }
        
        UserInfo *info = [ShareManager shareInstance].userinfo;
        
        [cell.headPhoto sd_setImageWithURL:[NSURL URLWithString:info.user_photo] placeholderImage:PublicImage(@"wode_24.png")];
        if (info.nick_name.length > 0 && ![info.nick_name isEqualToString:@"<null>"]) {
            cell.nickName.text = info.nick_name;
        }else{
            cell.nickName.text = @"点击设置昵称";
        }
        
        if (info.personal_sign.length > 0 && ![info.personal_sign isEqualToString:@"<null>"]) {
            cell.signLabel.text = info.personal_sign;
        }else{
            cell.signLabel.text = @"这个人很懒，没有签名";
        }
        [cell.photoButton addTarget:self action:@selector(clickPhotoButtonAction:) forControlEvents:UIControlEventTouchUpInside];
        return cell;
    }else{
        
        UserCenterListTableViewCell *cell = nil;
        cell = [tableView dequeueReusableCellWithIdentifier:@"UserCenterListTableViewCell"];
        if (cell == nil)
        {
            NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"UserCenterListTableViewCell" owner:nil options:nil];
            cell = [nib objectAtIndex:0];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
        }
        
        cell.iconImage.image = [UIImage imageNamed:[iconImageArray objectAtIndex:indexPath.row]];
        cell.iconTitle.text = [dataSourceArray objectAtIndex:indexPath.row];
        
        return cell;
    }
    
    
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    if (indexPath.section == 0) {
        ModifyUserInfoViewController *vc = [[ModifyUserInfoViewController alloc]initWithNibName:@"ModifyUserInfoViewController" bundle:nil];
        vc.hidesBottomBarWhenPushed = YES;
        vc.delegate = self;
        [self.navigationController pushViewController:vc animated:YES];
    }else{
        switch (indexPath.row) {
            case 0:
            {
                DuiHuanViewController *vc = [[DuiHuanViewController alloc]initWithNibName:@"DuiHuanViewController" bundle:nil];
                vc.hidesBottomBarWhenPushed = YES;
                [self.navigationController pushViewController:vc animated:YES];
            }
                break;
            case 1:
            {
                MyWallectViewController  *vc = [[MyWallectViewController alloc]initWithNibName:@"MyWallectViewController" bundle:nil];
                vc.hidesBottomBarWhenPushed = YES;
                [self.navigationController pushViewController:vc animated:YES];
            }
                break;
            case 2:
            {
                HuishuiListViewController *vc = [[HuishuiListViewController alloc]initWithNibName:@"HuishuiListViewController" bundle:nil];
                vc.hidesBottomBarWhenPushed = YES;
                [self.navigationController pushViewController:vc animated:YES];
            }
                break;
            case 3:
            {
                BianZhangRecordViewController *vc = [[BianZhangRecordViewController alloc]initWithNibName:@"BianZhangRecordViewController" bundle:nil];
                vc.hidesBottomBarWhenPushed = YES;
                [self.navigationController pushViewController:vc animated:YES];
            }
                break;
            case 4:
            {
                GameRecordViewController *vc = [[GameRecordViewController alloc]initWithNibName:@"GameRecordViewController" bundle:nil];
                vc.hidesBottomBarWhenPushed = YES;
                [self.navigationController pushViewController:vc animated:YES];
            }
                break;
            case 5:
            {
                MyShouYiViewController *vc = [[MyShouYiViewController alloc]initWithNibName:@"MyShouYiViewController" bundle:nil];
                vc.hidesBottomBarWhenPushed = YES;
                [self.navigationController pushViewController:vc animated:YES];
            }
                break;
            case 6:
            {
                ShareViewController *vc = [[ShareViewController alloc]initWithNibName:@"ShareViewController" bundle:nil];
                vc.hidesBottomBarWhenPushed = YES;
                [self.navigationController pushViewController:vc animated:YES];
            }
                break;
            case 7:
            {
                SettingViewController *vc = [[SettingViewController alloc]initWithNibName:@"SettingViewController" bundle:nil];
                vc.hidesBottomBarWhenPushed = YES;
                [self.navigationController pushViewController:vc animated:YES];
            }
                break;
            case 8:
            {
                AboutOurViewController *vc = [[AboutOurViewController alloc]initWithNibName:@"AboutOurViewController" bundle:nil];
                vc.hidesBottomBarWhenPushed = YES;
                [self.navigationController pushViewController:vc animated:YES];
            }
                break;
            default:
                [Tool showPromptContent:@"敬请期待" onView:self.view];
                break;
        }
    }
}

#pragma mark - ModifyUserInfoViewControllerDelegate

- (void)modiftyUserInfoSuccesss
{
    [_myTableView reloadData];
    [self updateUserInfoData];
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
