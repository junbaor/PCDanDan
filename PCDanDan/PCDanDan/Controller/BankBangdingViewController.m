//
//  BankBangdingViewController.m
//  PCDanDan
//
//  Created by linqsh on 17/2/26.
//  Copyright © 2017年 vma-lin. All rights reserved.
//

#import "BankBangdingViewController.h"

@interface BankBangdingViewController ()
{
    MBProgressHUD * HUD;
}
@end

@implementation BankBangdingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initVariable];
    [self leftNavigationItem];
    [self updateShowUIWithInfo:[ShareManager shareInstance].userinfo];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)initVariable
{
    self.title = @"银行卡";
    
    _sureButton.layer.masksToBounds =YES;
    _sureButton.layer.cornerRadius = 5;
    
    HUD = [[MBProgressHUD alloc] initWithView:self.view];
    [self.view addSubview:HUD];
}

- (void)updateShowUIWithInfo:(UserInfo *)info
{
    if ([ShareManager shareInstance].userinfo.bank_no.length > 0 && ![[ShareManager shareInstance].userinfo.bank_no isEqualToString:@"<null>"] )
    {
        _accountText.text = info.bank_no;
    }
    if ([ShareManager shareInstance].userinfo.real_name.length > 0 && ![[ShareManager shareInstance].userinfo.real_name isEqualToString:@"<null>"] )
    {
        _nameText.text = info.real_name;
    }
    if ([ShareManager shareInstance].userinfo.bank_name.length > 0 && ![[ShareManager shareInstance].userinfo.bank_name isEqualToString:@"<null>"] )
    {
        _bankNameText.text = info.bank_name;
    }
    
    if ([ShareManager shareInstance].userinfo.open_card_address.length > 0 && ![[ShareManager shareInstance].userinfo.open_card_address isEqualToString:@"<null>"] )
    {
        _addressText.text = info.open_card_address;
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
    if ( _nameText.text.length < 1) {
        [Tool showPromptContent:@"请输入开户名" onView:self.view];
        return;
    }
    if ( _bankNameText.text.length < 1) {
        [Tool showPromptContent:@"请输入银行名称" onView:self.view];
        return;
    }
    if ( _accountText.text.length < 1) {
        [Tool showPromptContent:@"请输入开户账号" onView:self.view];
        return;
    }
    if ( _addressText.text.length < 1) {
        [Tool showPromptContent:@"请输入开户地址" onView:self.view];
        return;
    }
    if ( _pwdText.text.length < 1) {
        [Tool showPromptContent:@"请输入提现密码" onView:self.view];
        return;
    }
    [self httpBangdingBank];
    
}

#pragma mark - http

- (void)httpBangdingBank
{
    [HUD show:YES];
    HttpHelper *helper = [[HttpHelper alloc] init];
    __weak BankBangdingViewController *weakSelf = self;
    [helper bangdingBankWithUserId:[ShareManager shareInstance].userinfo.id
              withdrawals_password:_pwdText.text
                         real_name:_nameText.text
                         bank_name:_bankNameText.text
                           bank_no:_accountText.text
                 open_card_address:_addressText.text
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
    [Tool showPromptContent:@"操作成功" onView:self.view];
    [ShareManager shareInstance].userinfo.bank_no =  _accountText.text;
    [ShareManager shareInstance].userinfo.real_name = _nameText.text;
    [ShareManager shareInstance].userinfo.bank_name = _bankNameText.text;
    [ShareManager shareInstance].userinfo.open_card_address = _addressText.text;
    
    [HttpMangerHelper  getUserSelfInfoSuccess:nil fail:nil];
    
    [self performSelector:@selector(clickLeftControlAction:) withObject:nil afterDelay:1.5];
}
@end
