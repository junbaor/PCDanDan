//
//  ModifyUserInfoViewController.m
//  PCDanDan
//
//  Created by xcode.qi on 17/1/19.
//  Copyright © 2017年 li. All rights reserved.
//
#import "ModifyUserInfoViewController.h"

@interface ModifyUserInfoViewController ()
{
     MBProgressHUD *HUD;
}

@end

@implementation ModifyUserInfoViewController

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
    self.title = @"修改资料";
    _sureButton.layer.masksToBounds =YES;
    _sureButton.layer.cornerRadius = 5;
    
    HUD = [[MBProgressHUD alloc] initWithView:self.view];
    [self.view addSubview:HUD];
    
    UserInfo *info = [ShareManager shareInstance].userinfo;
    _accountLabel.text = info.account;
   
    if (info.nick_name.length > 0 && ![info.nick_name isEqualToString:@"<null>"]) {
        _nickName.text = info.nick_name;
    }
    
    if (info.personal_sign.length > 0 && ![info.personal_sign isEqualToString:@"<null>"]) {
       _signLabel.text = info.personal_sign;
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


#pragma mark - Action

- (void)clickLeftControlAction:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)clickSureButtonAction:(id)sender
{
    [Tool hideAllKeyboard];
    if (_nickName.text.length > 0 || _signLabel.text.length > 0) {
        [self httpUpdateUserInfoWithNickName:_nickName.text signStr:_signLabel.text];
    }else{
        [Tool showPromptContent:@"请输入要修改的内容" onView:self.view];
    }
}

#pragma mark - http

- (void)httpUpdateUserInfoWithNickName:(NSString *)name
                               signStr:(NSString *)signStr
{
    [HUD show:YES];
    HttpHelper *helper = [[HttpHelper alloc] init];
    __weak ModifyUserInfoViewController *weakSelf = self;
    [helper updateUserInfoWithUserId:[ShareManager shareInstance].userinfo.id
                          user_photo:nil
                           nick_name:name
                             signStr:signStr
                                 sex:nil
                              mobile:nil
                withdrawals_password:nil
                        old_password:nil
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
    [Tool showPromptContent:@"修改成功" onView:self.view];
    
    [ShareManager shareInstance].userinfo.nick_name = _nickName.text;
    [ShareManager shareInstance].userinfo.personal_sign = _signLabel.text;
    [Tool saveUserInfoToDB:YES];
    
    if([self.delegate respondsToSelector:@selector(modiftyUserInfoSuccesss)])
    {
        [self.delegate modiftyUserInfoSuccesss];
    }

    [self performSelector:@selector(clickLeftControlAction:) withObject:nil afterDelay:1.5];
}


@end
