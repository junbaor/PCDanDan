//
//  BankZZViewController.m
//  PCDanDan
//
//  Created by xcode.qi on 17/1/19.
//  Copyright © 2017年 li. All rights reserved.
//


#import "BankZZViewController.h"

@interface BankZZViewController ()<UIActionSheetDelegate>
{
    MBProgressHUD * HUD;
}
@end

@implementation BankZZViewController

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
    self.title = @"微信转账";
    _bgViewWidth.constant = FullScreen.size.width;
    _commonButton.layer.masksToBounds =YES;
    _commonButton.layer.cornerRadius = 5;
    
    _skTitleLabel.layer.masksToBounds =YES;
    _skTitleLabel.layer.cornerRadius = 5;
    
    _skInfoView.layer.masksToBounds =YES;
    _skInfoView.layer.cornerRadius = 5;
    _skInfoView.layer.borderColor = [RGB(146, 186, 248) CGColor];
    _skInfoView.layer.borderWidth = 1.0f;
    
    _fz1Button.layer.masksToBounds =YES;
    _fz1Button.layer.cornerRadius = 4;
    _fz1Button.layer.borderColor = [RGB(170, 205, 253) CGColor];
    _fz1Button.layer.borderWidth = 1.0f;
    
    _fz2Button.layer.masksToBounds =YES;
    _fz2Button.layer.cornerRadius = 4;
    _fz2Button.layer.borderColor = [RGB(170, 205, 253) CGColor];
    _fz2Button.layer.borderWidth = 1.0f;
    
     _skrLabel.text = [NSString stringWithFormat:@"收款户名：%@",_accountInfo.real_name];
    _accountLabel.text =  [NSString stringWithFormat:@"收款账号：%@",_accountInfo.account];
    
    HUD = [[MBProgressHUD alloc] initWithView:self.view];
    [self.view addSubview:HUD];
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

- (IBAction)clicCopyType:(id)sender
{
    NSString *str = nil;
    UIButton *btn = (UIButton *)sender;
    switch (btn.tag) {
        case 1:
            str = _accountInfo.real_name;
            break;
        case 2:
            str = _accountInfo.account;
            break;
        case 3:
            str = _accountInfo.open_card_address;
            break;
        default:
            break;
    }
    if (str) {
        UIPasteboard *pasteboard = [UIPasteboard generalPasteboard];
        pasteboard.string = str;
        [Tool showPromptContent:@"复制成功" onView:self.view];
    }
}

- (IBAction)clickSureButtonAction:(id)sender
{
    [Tool hideAllKeyboard];
    
    if (_wxNickNameText.text.length < 1) {
        [Tool showPromptContent:@"请填写您此次转账使用的微信昵称" onView:self.view];
        return;
    }
    if (_wxAccountText.text.length < 1) {
        [Tool showPromptContent:@"请填写您此次转账使用的微信账号" onView:self.view];
        return;
    }
    if (_moneyText.text.length < 1) {
        [Tool showPromptContent:@"请填写您此次转账的金额" onView:self.view];
        return;
    }
    if ([_moneyText.text doubleValue ] < 100 || [_moneyText.text doubleValue ] > 50000) {
        [Tool showPromptContent:@"转账金额为100～50000元" onView:self.view];
        return;
    }
    [self httpPutZhuanZhangInfo];
}

#pragma mark - http

- (void)httpPutZhuanZhangInfo
{
    
    [HUD show:YES];
    HttpHelper *helper = [[HttpHelper alloc] init];
    __weak BankZZViewController *weakSelf = self;
    [helper addZhuanZhangRecordInfoWithAccount:_wxAccountText.text
                                  account_type:@"3"
                                     real_name:_wxNickNameText.text
                                     bank_name:nil
                                         point:_moneyText.text
                                       user_id:[ShareManager shareInstance].userinfo.id
                                      add_type:nil
                                    account_id:_accountInfo.id
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
    [Tool showPromptContent:@"提交成功" onView:self.view];
    [self performSelector:@selector(clickLeftControlAction:) withObject:nil afterDelay:1.5];
}





@end
