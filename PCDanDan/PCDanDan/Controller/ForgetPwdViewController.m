//
//  ForgetPwdViewController.m
//  PCDanDan
//
//  Created by linqsh on 17/2/26.
//  Copyright © 2017年 vma-lin. All rights reserved.
//

#import "ForgetPwdViewController.h"

@interface ForgetPwdViewController ()
{
    NSString *codeIDStr;
    NSTimer *timer;
    NSInteger remainTime;
    MBProgressHUD * HUD;
}

@end

@implementation ForgetPwdViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initVariable];
    [self leftNavigationItem];
    
    [self.navigationController setNavigationBarHidden:NO animated:NO];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)initVariable
{
    self.title = @"找回密码";
    
    _codeButton.layer.borderColor = [RGB(0, 128, 255) CGColor];
    _codeButton.layer.borderWidth = 1.0f;
    _codeButton.layer.masksToBounds =YES;
    _codeButton.layer.cornerRadius = 5;
    
    _sureButton.layer.masksToBounds =YES;
    _sureButton.layer.cornerRadius = 5;
    
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

- (IBAction)clickCodeButtonAction:(id)sender
{
    [Tool hideAllKeyboard];
    [self httGetVerificationCode];
}

- (IBAction)clickSureButtonAction:(id)sender
{
    [Tool hideAllKeyboard];
    
    if ( _nameText.text.length < 1) {
        [Tool showPromptContent:@"请输入您的用户名" onView:self.view];
        return;
    }
    if ( _phoneText.text.length < 1) {
        [Tool showPromptContent:@"请输入手机号" onView:self.view];
        return;
    }
    
    if(![Tool validateMobile:_phoneText.text] )
    {
        [Tool showPromptContent:@"请输入正确手机号" onView:self.view];
        return;
    }
    
    if (_codeText.text.length < 1) {
        [Tool showPromptContent:@"请输入验证码" onView:self.view];
        return;
    }
    if (_pwdText.text.length < 1) {
        [Tool showPromptContent:@"请设置新密码" onView:self.view];
        return;
    }
    if (_pwdText.text.length < 6 || _pwdText.text.length  > 12) {
        [Tool showPromptContent:@"提现由密码（6~12位）数字或字母组成" onView:self.view];
        return;
    }

    
    [self httpFindPwd];
    if (timer) {
        //关闭定时器
        [timer invalidate];
        timer = nil;
    }
    [_codeButton setTitle:@"重新获取" forState:UIControlStateNormal];
    _codeButton.userInteractionEnabled = YES;
}

#pragma mark - http

- (void)httpFindPwd
{
    [HUD show:YES];
    
    HttpHelper *helper = [[HttpHelper alloc] init];
    __weak ForgetPwdViewController *weakSelf = self;
    
    [helper forgetPwdWithAccount:_nameText.text
                          mobile:_phoneText.text
                        password:_pwdText.text
                          msg_id:codeIDStr
                        msg_code:_codeText.text
                            success:^(NSDictionary *resultDic){
                                [HUD hide:YES];
                                if ([[resultDic objectForKey:@"result_code"] integerValue] == 0 && resultDic)  {
                                    [weakSelf handleloadResult:[resultDic objectForKey:@"data"]];
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

- (void)handleloadResult:(NSDictionary *)resultDic
{
    [Tool showPromptContent:@"重置成功" onView:self.view];
    [self performSelector:@selector(clickLeftControlAction:) withObject:nil afterDelay:1.5];
}


- (void)httGetVerificationCode
{
    NSString *phoneStr = _phoneText.text;
    if (!phoneStr || phoneStr.length < 1) {
        [Tool showPromptContent:@"请输入手机号" onView:self.view];
        return;
    }
    if(![Tool validateMobile:phoneStr])
    {
        [Tool showPromptContent:@"请输入合法的手机号" onView:self.view];
        return;
    }
    [HUD show:YES];
    HUD.labelText = @"获取验证码中...";
    
    HttpHelper *helper = [[HttpHelper alloc] init];
    __weak ForgetPwdViewController *weakSelf = self;
    [helper getVerificationCodeByMobile:phoneStr
                                success:^(NSDictionary *resultDic){
                                    [HUD hide:YES];
                                    if ([[resultDic objectForKey:@"result_code"] integerValue] == 0) {
                                        [Tool showPromptContent:@"验证码正在发送至您的手机" onView:self.view];
                                        codeIDStr = [[resultDic objectForKey:@"data"] objectForKey:@"id"];
                                        remainTime = kTimeValue;
                                        [weakSelf handleTimer];
                                        
                                    }else
                                    {
                                        [Tool showPromptContent:[resultDic objectForKey:@"result_desc"] onView:self.view];
                                    }
                                }fail:^(NSString *decretion){
                                    [HUD hide:YES];
                                    [Tool showPromptContent:@"网络出错了" onView:self.view];
                                }];
    
}


#pragma mark - 获取验证码是button的ui变化

- (void)handleTimer
{
    if (remainTime == kTimeValue)
    {
        if (!timer)
        {
            timer = [NSTimer scheduledTimerWithTimeInterval:1.0
                                                     target:self
                                                   selector:@selector(handleTimer)
                                                   userInfo:nil
                                                    repeats:YES];
        }
        
        remainTime = kTimeValue;
        [self updateButtonTitleWithTime:remainTime];
        _codeButton.userInteractionEnabled = NO;
        remainTime--;
    }
    else if (remainTime >= 0)
    {
        [self updateButtonTitleWithTime:remainTime];
        remainTime--;
    }
    else
    {
        [timer invalidate];
        timer = nil;
        [self updateButtonTitleWithTime:remainTime];
        _codeButton.userInteractionEnabled = YES;
    }
}

- (void)updateButtonTitleWithTime:(NSInteger)time
{
    if (time > 0)
    {
        NSString *title = [NSString stringWithFormat:@"%ld秒", (long)time];
        
        [_codeButton setTitle:title forState:UIControlStateNormal];
        [_codeButton setTitle:title forState:UIControlStateHighlighted];
    }
    else
    {
        [_codeButton setTitle:@"重新获取" forState:UIControlStateNormal];
        [_codeButton setTitle:@"重新获取" forState:UIControlStateHighlighted];
    }
}


@end
