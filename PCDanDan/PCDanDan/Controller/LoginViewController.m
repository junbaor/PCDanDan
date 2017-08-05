//
//  LoginViewController.m
//  PCDanDan
//
//  Created by xcode.qi on 17/1/19.
//  Copyright © 2017年 li. All rights reserved.
//

#import "LoginViewController.h"
#import "ResigterViewController.h"
#import "ForgetPwdViewController.h"

@interface LoginViewController ()<UINavigationControllerDelegate>

@end

@implementation LoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initVariable];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    // 隐藏导航栏
    [self.navigationController setNavigationBarHidden:YES animated:animated];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)initVariable
{
    _bgView.layer.masksToBounds =YES;
    _bgView.layer.cornerRadius = 5;
    
    _loginButton.layer.masksToBounds =YES;
    _loginButton.layer.cornerRadius = _loginButton.frame.size.height/2;
    
    _accountBgLabel.layer.masksToBounds =YES;
    _accountBgLabel.layer.cornerRadius = _accountBgLabel.frame.size.height/2;
    _pwdBgLabel.layer.masksToBounds =YES;
    _pwdBgLabel.layer.cornerRadius = _pwdBgLabel.frame.size.height/2;
    
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.navigationController.delegate = self;
    self.tabBarController.tabBar.translucent = NO;
    self.navigationController.navigationBar.translucent = NO;
    NSDictionary *attributes = [NSDictionary dictionaryWithObjectsAndKeys:
                                [UIColor whiteColor],
                                NSForegroundColorAttributeName, nil];
    self.navigationController.interactivePopGestureRecognizer.delegate = (id)self;
    [self.navigationController.navigationBar setTitleTextAttributes:attributes];
    [[EMClient sharedClient] logout:NO];
}

#pragma mark - button Action

 - (IBAction)clickCloseButtonAction:(id)sender
{
    [Tool hideAllKeyboard];
    [self dismissViewControllerAnimated:YES completion:nil];
}
 - (IBAction)clickLoginButtonAction:(id)sender
{
    [Tool hideAllKeyboard];
    [self httpLogin];
}
 - (IBAction)clickResigterButtonAction:(id)sender
{
    [Tool hideAllKeyboard];
    ResigterViewController *vc = [[ResigterViewController alloc]initWithNibName:@"ResigterViewController" bundle:nil];
    [self.navigationController pushViewController:vc animated:YES];
}
 - (IBAction)clickForgetPwdButtonAction:(id)sender
{
    [Tool hideAllKeyboard];
    
    ForgetPwdViewController *vc = [[ForgetPwdViewController alloc]initWithNibName:@"ForgetPwdViewController" bundle:nil];
    [self.navigationController pushViewController:vc animated:YES];
}
 - (IBAction)clickWeixinButtonAction:(id)sender
{
    [Tool hideAllKeyboard];
    
//    [Tool showPromptContent:@"暂不支持" onView:self.view];
    
    __weak LoginViewController *weakSelf = self;

    [ShareSDK getUserInfo:SSDKPlatformTypeWechat
           onStateChanged:^(SSDKResponseState state, SSDKUser *user, NSError *error)
     {
         if (state == SSDKResponseStateSuccess)
         {
             
             [weakSelf reloadStateWithType:user];
         }
         else
         {
             if(state == SSDKResponseStateFail)
             {
                 [Tool showPromptContent:@"授权失败" onView:weakSelf.view];
             }
         }
         
     }];
    
}
 - (IBAction)clickQQButtonAction:(id)sender
{
    [Tool hideAllKeyboard];
    
    [Tool showPromptContent:@"暂不支持" onView:self.view];
    
//    __weak LoginViewController *weakSelf = self;
//    [ShareSDK getUserInfo:SSDKPlatformTypeQQ
//           onStateChanged:^(SSDKResponseState state, SSDKUser *user, NSError *error)
//     {
//         if (state == SSDKResponseStateSuccess)
//         {
//             [weakSelf reloadStateWithType:user];
//         }
//         else
//         {
//             if(state == SSDKResponseStateFail)
//             {
//                 [Tool showPromptContent:@"授权失败" onView:weakSelf.view];
//             }
//         }
//         
//     }];
}

- (void)dissCurrentVC
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

-(void)reloadStateWithType:(SSDKUser*)user{
    //现实授权信息，包括授权ID、授权有效期等。
    NSString *typeStr = nil;
    
    if (user.platformType == SSDKPlatformTypeWechat) {
        typeStr = @"2";
    }else{
        typeStr = @"3";
    }
    
    [self httpOtherLoginWithId:[user uid]
                     band_type:typeStr
                     nick_name:[user nickname]
                    user_photo:[user icon]];
    
}


#pragma mark - http

- (void)httpLogin
{
    
    if ( _accountText.text.length < 1) {
        [Tool showPromptContent:@"请输入账号" onView:self.view];
        return;
    }
    
    if ( _accountText.text.length < 6 || _accountText.text.length > 12) {
        [Tool showPromptContent:@"账号为6~12位数字或字母" onView:self.view];
        return;
    }
    
    if (_pwdText.text.length < 1) {
        [Tool showPromptContent:@"请输入密码" onView:self.view];
        return;
    }
    
    MBProgressHUD * HUD = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    HUD.labelText = @"登录中...";
    
    HttpHelper *helper = [[HttpHelper alloc] init];
    __weak LoginViewController *weakSelf = self;
    [helper loginWithAccount:_accountText.text
                    password:_pwdText.text
             registration_id:nil
                     success:^(NSDictionary *resultDic){
                         [HUD hide:YES];
                         if ([[resultDic objectForKey:@"result_code"] integerValue] == 0) {
                             [weakSelf handleloadResult:resultDic];
                         }else
                         {
                             
                             [Tool showPromptContent:[resultDic objectForKey:@"result_desc"] onView:self.view];
                         }
                     }fail:^(NSString *decretion){
                         [HUD hide:YES];
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
    [[NSNotificationCenter defaultCenter] postNotificationName:kLoginSuccessStatue object:nil];
    [Tool showPromptContent:@"登录成功" onView:self.view];
    UserInfo *info = [[resultDic objectForKey:@"data"] objectByClass:[UserInfo class]];
    [ShareManager shareInstance].userinfo = info;
    [ShareManager shareInstance].userinfo.password = _pwdText.text;
    [Tool saveUserInfoToDB:YES];
    
    [self performSelector:@selector(dissCurrentVC) withObject:nil afterDelay:1.5];
}

//第三方登录
- (void)httpOtherLoginWithId:(NSString *)band_id
                   band_type:(NSString *)band_type
                   nick_name:(NSString *)nick_name
                  user_photo:(NSString *)user_photo
{
    MBProgressHUD * HUD = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    HUD.labelText = @"登录中...";
    
    HttpHelper *helper = [[HttpHelper alloc] init];
    __weak LoginViewController *weakSelf = self;
    [helper loginOfThirdWithBandId:band_id
                         band_type:band_type
                   registration_id:nil
                         nick_name:nick_name
                        user_photo:user_photo
                           success:^(NSDictionary *resultDic){
                               [HUD hide:YES];
                               if ([[resultDic objectForKey:@"result_code"] integerValue] == 0) {
                                   [weakSelf handleloadOtherLoginResult:resultDic];
                               }else
                               {
                                   [HUD hide:YES];
                                   [Tool showPromptContent:[resultDic objectForKey:@"desc"] onView:self.view];
                               }
                           }fail:^(NSString *decretion){
                               [HUD hide:YES];
                               [Tool showPromptContent:@"网络出错了" onView:self.view];
                           }];
    
}

//微信登录成功
- (void)handleloadOtherLoginResult:(NSDictionary *)resultDic
{
    if(!resultDic)
    {
        [Tool showPromptContent:@"接口请求失败" onView:self.view];
        return;
    }
    [[NSNotificationCenter defaultCenter] postNotificationName:kLoginSuccessStatue object:nil];
    [Tool showPromptContent:@"登录成功" onView:self.view];
    UserInfo *info = [[resultDic objectForKey:@"data"] objectByClass:[UserInfo class]];
    [ShareManager shareInstance].userinfo = info;
    [Tool saveUserInfoToDB:YES];
    [self performSelector:@selector(dissCurrentVC) withObject:nil afterDelay:1.5];
    
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
