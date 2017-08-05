//
//  DuiHuanInfoViewController.m
//  PCDanDan
//
//  Created by xcode.qi on 17/1/19.
//  Copyright © 2017年 li. All rights reserved.
//


#import "DuiHuanInfoViewController.h"

@interface DuiHuanInfoViewController ()
{
    MBProgressHUD * HUD;
}

@end

@implementation DuiHuanInfoViewController
- (void)dealloc
{
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:KQuitLogin object:nil];
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initVariable];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (void)initVariable
{
    _sureButton.layer.masksToBounds =YES;
    _sureButton.layer.cornerRadius = 5;

    _cannelButton.layer.masksToBounds =YES;
    _cannelButton.layer.cornerRadius = 5;

    HUD = [[MBProgressHUD alloc] initWithView:self.view];
    [self.view addSubview:HUD];
    
    [[NSNotificationCenter defaultCenter]addObserver:self
                                            selector:@selector(quitLoginDiss)
                                                name:KQuitLogin
                                              object:nil];
    
    _nameLabel.text = [ShareManager shareInstance].userinfo.real_name;
    _phoneLabel.text = [ShareManager shareInstance].userinfo.mobile;
    
    _moneyLabel.text = [NSString stringWithFormat:@"%.2f元宝",_giftInfo.gift_point];
}

- (void)quitLoginDiss
{
    [self dismissViewControllerAnimated:NO completion:nil];
}

- (IBAction)clickSureButtonAction:(id)sender
{
    
    [Tool hideAllKeyboard];
    if (_numText.text.length < 1) {
        [Tool showPromptContent:@"请输入兑换数量" onView:self.view];
        return;
    }
    if (_giftInfo.gift_point * [_numText.text intValue] > [ShareManager shareInstance].userinfo.point) {
        [Tool showPromptContent:@"您当前余额不足" onView:self.view];
        return;
    }
    if (_addressTextView.text.length < 1) {
        [Tool showPromptContent:@"请输入收货详情地址" onView:self.view];
        return;
    }

    [self httpPutDuiHuanInfo];
}

- (IBAction)clickCloseButtonAction:(id)sender
{
    [Tool hideAllKeyboard];
    [self dismissViewControllerAnimated:YES completion:nil];
    
}

#pragma mark - UITextFieldDelegate

- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    _numText.text = @"";
    _allMoneyLabel.text = @"0元宝";
}

- (void)textFieldDidEndEditing:(UITextField *)textField
{
    if(textField.text.length > 0)
    {
        _allMoneyLabel.text = [NSString stringWithFormat:@"%.2f元宝",_giftInfo.gift_point * [textField.text intValue]];
    }
}

#pragma mark - http

- (void)httpPutDuiHuanInfo
{
    [HUD show:YES];
    HttpHelper *helper = [[HttpHelper alloc] init];
    __weak DuiHuanInfoViewController *weakSelf = self;
    [helper exchangeGiftWithIdStr:_giftInfo.id
                       gift_count:_numText.text
                          address:_addressTextView.text
                          user_id:[ShareManager shareInstance].userinfo.id
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
    [Tool showPromptContent:@"提交申请成功" onView:self.view];
    [ShareManager shareInstance].userinfo.point =  [ShareManager shareInstance].userinfo.point - _giftInfo.gift_point * [_numText.text intValue];
    
    [HttpMangerHelper  getUserSelfInfoSuccess:nil fail:nil];
    
    [self performSelector:@selector(dissmissCurrentVC) withObject:nil afterDelay:1.5];
}


- (void)dissmissCurrentVC
{
    [self dismissViewControllerAnimated:YES completion:nil];
}
@end
