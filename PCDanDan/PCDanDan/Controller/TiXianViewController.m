//
//  TiXianViewController.m
//  PCDanDan
//
//  Created by xcode.qi on 17/1/17.
//  Copyright © 2017年 li. All rights reserved.
//

#import "TiXianViewController.h"
#import "TXWarnInfo.h"

@interface TiXianViewController ()
{
    MBProgressHUD * HUD;
    TXWarnInfo *warnInfo;
}

@end

@implementation TiXianViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initVariable];
    [self leftNavigationItem];
    [self updateShowUI];
    [self httpGetTiXinWarnInfo];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)initVariable
{
    self.title = @"提现";
    _bgviewWidth.constant = FullScreen.size.width;
    
    _sureButton.layer.masksToBounds =YES;
    _sureButton.layer.cornerRadius = 5;
    
    _accountView.layer.masksToBounds =YES;
    _accountView.layer.cornerRadius = 5;
    
    _warn1View.layer.masksToBounds =YES;
    _warn1View.layer.cornerRadius = 5;
    
    _warn2View.layer.masksToBounds =YES;
    _warn2View.layer.cornerRadius = 5;
    
    HUD = [[MBProgressHUD alloc] initWithView:self.view];
    [self.view addSubview:HUD];
}

- (void)updateShowUI
{
    UserInfo *info = [ShareManager shareInstance].userinfo;
    _nameLabel.text = [NSString stringWithFormat:@"%@(%@)",info.real_name,info.bank_no];
    _bankNameLabel.text = info.bank_name;
    CGSize size = [_bankNameLabel sizeThatFits:CGSizeMake(MAXFLOAT, 18)];
    _bankNameLabelWidth.constant = size.width;
    
    _yueLabel.text = [NSString stringWithFormat:@"您的余额为%.2f元宝",info.point];
    NSString * showStr = nil;
    NSString * showStr1 = nil;
    if (!warnInfo) {
        showStr = [NSString stringWithFormat:@"每日<color1>--</color1>次免费提现机会，当日剩余<color1>--</color1>次"];
        showStr1 = [NSString stringWithFormat:@"超过则每次收取<color1>-％</color1>手续费"];
        _zdtxWarnLabel.text = @"最低提现金额--元宝";
    }else{
        showStr = [NSString stringWithFormat:@"每日<color1>%d</color1>次免费提现机会，当日剩余<color1>%d</color1>次",warnInfo.tixian_free_count,warnInfo.free_count];
        showStr1 = [NSString stringWithFormat:@"超过则每次收取<color1>%.0f％</color1>手续费",warnInfo.tixian_bili*100];
        _zdtxWarnLabel.text = [NSString stringWithFormat:@"最低提现金额%.0f元宝",warnInfo.tixian_min_fee];
    }
    
    NSDictionary* style = @{@"body":[UIFont systemFontOfSize:12],
                        @"color1":RGB(235, 82, 83)};

    _txcsLabel.attributedText = [showStr attributedStringWithStyleBook:style];

    
    
    _sxfLabel.attributedText = [showStr1 attributedStringWithStyleBook:style];
    
    
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
    
    if (_moneyText.text.length < 1) {
        [Tool showPromptContent:@"请输入提现元宝数" onView:self.view];
        return;
    }
    if ([_moneyText.text intValue] < 100) {
        [Tool showPromptContent:@"最低提现金额100元宝" onView:self.view];
        return;
    }
    if ([_moneyText.text intValue] > [ShareManager shareInstance].userinfo.point) {
        [Tool showPromptContent:[NSString stringWithFormat:@"您最多可提现%.0f元宝", [ShareManager shareInstance].userinfo.point] onView:self.view];
        return;
    }
    if (_pwdText.text.length < 1) {
        [Tool showPromptContent:@"请输入提现密码" onView:self.view];
        return;
    }
    [self httpPutTiXinInfo];
}

#pragma mark - http

- (void)httpPutTiXinInfo
{
    [HUD show:YES];
    HttpHelper *helper = [[HttpHelper alloc] init];
    __weak TiXianViewController *weakSelf = self;
    [helper putTXInfoWithUserId:[ShareManager shareInstance].userinfo.id
                            fee:_moneyText.text
           withdrawals_password:_pwdText.text
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
    [ShareManager shareInstance].userinfo.point = [ShareManager shareInstance].userinfo.point-[_moneyText.text intValue];
    [HttpMangerHelper  getUserSelfInfoSuccess:nil fail:nil];
    
    [self performSelector:@selector(clickLeftControlAction:) withObject:nil afterDelay:1.5];
}


- (void)httpGetTiXinWarnInfo
{
    [HUD show:YES];
    HttpHelper *helper = [[HttpHelper alloc] init];
    __weak TiXianViewController *weakSelf = self;
    [helper getTXWarnInfoWithUserId:[ShareManager shareInstance].userinfo.id
                        success:^(NSDictionary *resultDic){
                            [HUD hide:YES];
                            if ([[resultDic objectForKey:@"result_code"] integerValue] == 0 && resultDic)
                            {
                                [weakSelf handleloadGetTiXinWarnInfoResult:resultDic];
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

- (void)handleloadGetTiXinWarnInfoResult:(NSDictionary *)resultDic
{
    NSDictionary *dic = [resultDic objectForKey:@"data"];
    
    warnInfo = [dic objectByClass:[TXWarnInfo class]];
 
    [self updateShowUI];
}

@end
