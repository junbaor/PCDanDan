//
//  MyBankCardViewController.m
//  PCDanDan
//
//  Created by linqsh on 17/2/26.
//  Copyright © 2017年 vma-lin. All rights reserved.
//

#import "MyBankCardViewController.h"
#import "BankBangdingViewController.h"

@interface MyBankCardViewController ()
{
    MBProgressHUD * HUD;
}

@end

@implementation MyBankCardViewController

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

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [HUD show:YES];
    __weak MyBankCardViewController *weakSelf = self;
     [HttpMangerHelper  getUserSelfInfoSuccess:^(UserInfo *info) {
         [HUD hide:YES];
         [weakSelf updateShowUIWithInfo:info];
     } fail:^(NSString *description) {
         [HUD hide:YES];
     }];
}

- (void)initVariable
{
    self.title = @"银行卡";
    _changeButton.layer.masksToBounds =YES;
    _changeButton.layer.cornerRadius = 5;
    
    HUD = [[MBProgressHUD alloc] initWithView:self.view];
    [self.view addSubview:HUD];
    
}

- (void)updateShowUIWithInfo:(UserInfo *)info
{
    _nameLabel.text = info.real_name;
    _backLabel.text = info.bank_name;
    _accontLabel.text = info.bank_no;
    _addressLabel.text = info.open_card_address;
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

- (IBAction)clickChangeButtonAction:(id)sender
{
    BankBangdingViewController *vc = [[BankBangdingViewController alloc]initWithNibName:@"BankBangdingViewController" bundle:nil];
    [self.navigationController pushViewController:vc animated:YES];
}
@end
