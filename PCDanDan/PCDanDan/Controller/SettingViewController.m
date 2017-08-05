//
//  SettingViewController.m
//  PCDanDan
//
//  Created by xcode.qi on 17/1/17.
//  Copyright © 2017年 li. All rights reserved.
//

#import "SettingViewController.h"
#import "UserCenterListTableViewCell.h"
#import "BankBangdingViewController.h"
#import "SetTiXianPwdViewController.h"
#import "BangDingPhoneViewController.h"
#import "MyPhoneViewController.h"
#import "ModifyLoginPwdViewController.h"

@interface SettingViewController ()
{
    NSMutableArray *dataSourceArray;
    NSMutableArray *iconImageArray;
    float huancunSize;
  
}

@end

@implementation SettingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initVariable];
    [self leftNavigationItem];
    [self getHuanCunSize];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)initVariable
{
    self.title = @"设置";
    dataSourceArray = [NSMutableArray arrayWithObjects:@"绑定银行卡", @"修改密码", @"提现密码",@"手机绑定",@"清除缓存",@"退出",nil];
    iconImageArray = [NSMutableArray arrayWithObjects:@"wode_31", @"wode_41",@"wode_53",@"wode_66",@"wode_74",@"wode_82",nil];
    
    
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

- (void)getHuanCunSize
{
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        huancunSize = [Tool folderSize];
        dispatch_async(dispatch_get_main_queue(), ^{
            [_myTableView reloadData];
        });
    });
}

- (void)removeHuancun
{
    MBProgressHUD * HUD = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    HUD.labelText = @"清理中...";
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        [Tool removeCache];
        dispatch_async(dispatch_get_main_queue(), ^{
            [HUD hide:YES];
            [Tool showPromptContent:@"清理成功" onView:self.view];
            [self getHuanCunSize];
        });
    });

}

#pragma mark - button action

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
    return 53;
}


//创建并显示每行的内容
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
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
    if(indexPath.row == 4)
    {
        cell.iconTitle.text = [NSString stringWithFormat:@"%@（%.2fM）",cell.iconTitle.text,huancunSize];
    }
    return cell;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    switch (indexPath.row) {
        case 0 :
        {
            if(![HttpMangerHelper isBangDingPhone])
            {
                __weak SettingViewController *ws = self;
                UIAlertView *alert = [UIAlertView bk_showAlertViewWithTitle:@"提示" message:@"为了您的资金安全，请绑定手机号" cancelButtonTitle:@"确定" otherButtonTitles:nil handler:^(UIAlertView *alertView, NSInteger buttonIndex) {
                    [HttpMangerHelper gotoBangDingWithAnimated:YES viewController:ws];
                }];
                [alert show];
            }else{
                if(![HttpMangerHelper isSetTiXianPwd])
                {
                    __weak SettingViewController *ws = self;
                    UIAlertView *alert = [UIAlertView bk_showAlertViewWithTitle:@"提示" message:@"请先设置提现密码" cancelButtonTitle:@"确定" otherButtonTitles:nil handler:^(UIAlertView *alertView, NSInteger buttonIndex) {
                        [HttpMangerHelper setTiXianPwdWithAnimated:YES viewController:ws];
                    }];
                    [alert show];
                }else{
                    
                    BankBangdingViewController *vc = [[BankBangdingViewController alloc]initWithNibName:@"BankBangdingViewController" bundle:nil];
                    [self.navigationController pushViewController:vc animated:YES];
                }
            }
        }
            break;
        case 1:
        {
            ModifyLoginPwdViewController *vc = [[ModifyLoginPwdViewController alloc]initWithNibName:@"ModifyLoginPwdViewController" bundle:nil];
            [self.navigationController pushViewController:vc animated:YES];
        }
            break;
        case 2:
        {
            SetTiXianPwdViewController *vc = [[SetTiXianPwdViewController alloc]initWithNibName:@"SetTiXianPwdViewController" bundle:nil];
            [self.navigationController pushViewController:vc animated:YES];
        }
            break;
       
        case 3:
        {
            if(![HttpMangerHelper isBangDingPhone])
            {
                [HttpMangerHelper gotoBangDingWithAnimated:YES viewController:self];
            }else{
                MyPhoneViewController *vc = [[MyPhoneViewController alloc]initWithNibName:@"MyPhoneViewController" bundle:nil];
                [self.navigationController pushViewController:vc animated:YES];
            }
        }
            break;
        case 4:
        {
            [self cleanCacheAndCookie];
            if(huancunSize > 0)
            {
                UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"您确定要清除缓存吗？" message:nil delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
                [alert show];
            }else{
                [Tool showPromptContent:@"暂无缓存可清理" onView:self.view];
            }
            
        }
            break;
        
        case 5:
        {
            [[EMClient sharedClient] logout:NO];
            [Tool saveUserInfoToDB:NO];
            [ShareSDK cancelAuthorize:SSDKPlatformTypeWechat];
            [self.navigationController popToRootViewControllerAnimated:NO];
            UITabBarController *tabBarController = (UITabBarController *)[UIApplication sharedApplication].keyWindow.rootViewController;
            [tabBarController setSelectedIndex:0];
            [HttpMangerHelper loginWithAnimated:YES viewController:nil];
            
        }
            break;
            
        default:
            [Tool showPromptContent:@"敬请期待" onView:self.view];
            break;
    }
}
#pragma mark - UIAlertViewDelegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 1) {
        
        
        [self removeHuancun];
        
    }
}

/**清除缓存和cookie*/
- (void)cleanCacheAndCookie{
    //清除cookies
    NSHTTPCookie *cookie;
    NSHTTPCookieStorage *storage = [NSHTTPCookieStorage sharedHTTPCookieStorage];
    for (cookie in [storage cookies]){
        [storage deleteCookie:cookie];
    }
    //清除UIWebView的缓存
    [[NSURLCache sharedURLCache] removeAllCachedResponses];
    NSURLCache * cache = [NSURLCache sharedURLCache];
    [cache removeAllCachedResponses];
    [cache setDiskCapacity:0];
    [cache setMemoryCapacity:0];
}

@end
