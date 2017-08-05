//
//  SetTiXianPwdViewController.m
//  PCDanDan
//
//  Created by linqsh on 17/2/26.
//  Copyright © 2017年 vma-lin. All rights reserved.
//

#import "SetTiXianPwdViewController.h"

@interface SetTiXianPwdViewController ()
{
    MBProgressHUD * HUD;
}

@end

@implementation SetTiXianPwdViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initVariable];
    [self leftNavigationItem];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)initVariable
{
    self.title = @"提现密码";
    
    _sureButton.layer.masksToBounds =YES;
    _sureButton.layer.cornerRadius = 5;
    
    HUD = [[MBProgressHUD alloc] initWithView:self.view];
    [self.view addSubview:HUD];
    
    if (_isSetPwd) {
        _csmmText.hidden = YES;
        _csmmLabel.hidden = YES;
        _txmmTextTop.constant = 29;
    }
    
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

#pragma mark - button action

- (void)clickLeftControlAction:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)clickSureButtonAction:(id)sender
{
    [Tool hideAllKeyboard];
    
    if (!_isSetPwd)
    {
        if ( _csmmText.text.length < 1) {
            [Tool showPromptContent:@"请输入初始密码" onView:self.view];
            return;
        }
    }
   
    if (_txmmText.text.length < 1) {
        [Tool showPromptContent:@"请设置提现密码" onView:self.view];
        return;
    }
    
    if (![_txmmText.text isEqualToString:_qrmmText.text]) {
        [Tool showPromptContent:@"两次密码输入不一致" onView:self.view];
        return;
    }
    
    if (_txmmText.text.length < 6 || _txmmText.text.length  > 12) {
        [Tool showPromptContent:@"提现由密码（6~12位）数字或字母组成" onView:self.view];
        return;
    }
    [self httpUpdateUserInfo];
}

#pragma mark - http

- (void)httpUpdateUserInfo
{
    NSString *pwdNew = _txmmText.text;
    NSString *pwdOld = nil;
    if (!_isSetPwd) {
        pwdOld = _csmmText.text;
    }
    [HUD show:YES];
    HttpHelper *helper = [[HttpHelper alloc] init];
    __weak SetTiXianPwdViewController *weakSelf = self;
    [helper updateUserInfoWithUserId:[ShareManager shareInstance].userinfo.id
                          user_photo:nil
                           nick_name:nil
                             signStr:nil
                                 sex:nil
                              mobile:nil
                withdrawals_password:pwdNew
                        old_password:pwdOld
                            password:nil
                              msg_id:nil
                            msg_code:nil
                             success:^(NSDictionary *resultDic){
                                 [HUD hide:YES];
                                 if ([[resultDic objectForKey:@"result_code"] integerValue] == 0 && resultDic)
                                 {
                                     [weakSelf handleloadUpdateResult:resultDic];
                                 }else
                                 {
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
     if (!_isSetPwd)
     {
         [Tool showPromptContent:@"修改成功" onView:self.view];
     }else{
         [Tool showPromptContent:@"设置成功" onView:self.view];
     }
    
    
    [HttpMangerHelper  getUserSelfInfoSuccess:nil fail:nil];
    [ShareManager shareInstance].userinfo.withdrawals_password = _txmmText.text;
    [Tool saveUserInfoToDB:YES];
    
    [self performSelector:@selector(clickLeftControlAction:) withObject:nil afterDelay:1.5];
}


@end
