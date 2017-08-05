//
//  MyPhoneViewController.m
//  PCDanDan
//
//  Created by linqsh on 17/2/26.
//  Copyright © 2017年 vma-lin. All rights reserved.
//

#import "MyPhoneViewController.h"

@interface MyPhoneViewController ()

@end

@implementation MyPhoneViewController

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
    self.title = @"手机绑定";
    
    _sureButton.layer.masksToBounds =YES;
    _sureButton.layer.cornerRadius = 5;
    _phoneLabel.layer.masksToBounds =YES;
    _phoneLabel.layer.cornerRadius = 5;
    
    _phoneLabel.text = [NSString stringWithFormat:@"手机号码：%@",[ShareManager shareInstance].userinfo.mobile];
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
    [self.navigationController popViewControllerAnimated:YES];
}
 

@end
