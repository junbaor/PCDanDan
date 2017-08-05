//
//  ResigterViewController.m
//  PCDanDan
//
//  Created by xcode.qi on 17/1/17.
//  Copyright © 2017年 li. All rights reserved.
//

#import "ResigterViewController.h"

@interface ResigterViewController ()
{
    BOOL isNoAgreeXY;
}

@end

@implementation ResigterViewController

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
    
    _resigterButton.layer.masksToBounds =YES;
    _resigterButton.layer.cornerRadius = _resigterButton.frame.size.height/2;
    _accountLabel.layer.masksToBounds =YES;
    _accountLabel.layer.cornerRadius = _accountLabel.frame.size.height/2;
    _pwdLabel.layer.masksToBounds =YES;
    _pwdLabel.layer.cornerRadius = _pwdLabel.frame.size.height/2;
    _pwdAginLabel.layer.masksToBounds =YES;
    _pwdAginLabel.layer.cornerRadius = _pwdAginLabel.frame.size.height/2;
    _tjrLabel.layer.masksToBounds =YES;
    _tjrLabel.layer.cornerRadius = _tjrLabel.frame.size.height/2;
    
}


#pragma mark - action

- (IBAction)clickCloseButtonAction:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)clickResigterButtonAction:(id)sender
{
    [Tool hideAllKeyboard];
    [self httpResigter];
}
- (IBAction)clickSelectButtonAction:(id)sender
{
     [Tool hideAllKeyboard];
    if (isNoAgreeXY) {
        isNoAgreeXY = NO;
        _selectImage.image = PublicImage(@"denglu_20");
    }else{
        isNoAgreeXY = YES;
        _selectImage.image = PublicImage(@"denglu_22");
    }
}
- (IBAction)clickXYButtonAction:(id)sender
{
     [Tool hideAllKeyboard];
    SafariViewController *vc = [[SafariViewController alloc]initWithNibName:@"SafariViewController" bundle:nil];
    vc.title = @"注册协议";
    vc.urlStr = [NSString stringWithFormat:@"%@%@",URL_Server,Wap_YongHuXieYi];
    [self.navigationController pushViewController:vc animated:YES];
}

- (IBAction)clickKFButtonAction:(id)sender
{
     [Tool hideAllKeyboard];
    KeFuViewController *vc =[[KeFuViewController alloc]initWithNibName:@"KeFuViewController" bundle:nil];
    vc.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:vc animated:YES];}

- (void)dissCurrentVC
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - http

- (void)httpResigter
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
    if ( _pwdText.text.length < 6 || _pwdText.text.length > 12) {
        [Tool showPromptContent:@"密码为6~12位数字或字母" onView:self.view];
        return;
    }
    
    if (_pwdAginText.text.length < 1) {
        [Tool showPromptContent:@"请确认密码" onView:self.view];
        return;
    }

    if (![_pwdText.text isEqualToString:_pwdAginText.text]) {
        [Tool showPromptContent:@"两次密码输入不一致" onView:self.view];
        return;
    }
    
    if (isNoAgreeXY) {
        [Tool showPromptContent:@"请您仔细阅读并同意注册协议" onView:self.view];
        return;
    }
    NSString *recommendStr = _tjrText.text;
    if (recommendStr.length < 1) {
        recommendStr = nil;
    }
    
    MBProgressHUD * HUD = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    HUD.labelText = @"注册中...";
    
    HttpHelper *helper = [[HttpHelper alloc] init];
    __weak ResigterViewController *weakSelf = self;
    [helper resigterAccountWithAccount:_accountText.text
                              password:_pwdText.text
                                  code:recommendStr
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
    [Tool showPromptContent:@"登录成功" onView:self.view];
    UserInfo *info = [[resultDic objectForKey:@"data"] objectByClass:[UserInfo class]];
    [ShareManager shareInstance].userinfo = info;
    
    [ShareManager shareInstance].userinfo.password = _pwdText.text;
    [Tool saveUserInfoToDB:YES];
    
    [self performSelector:@selector(dissCurrentVC) withObject:nil afterDelay:1.5];
}

@end
