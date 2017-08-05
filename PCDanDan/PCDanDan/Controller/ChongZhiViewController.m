//
//  ChongZhiViewController.m
//  PCDanDan
//
//  Created by xcode.qi on 17/1/19.
//  Copyright © 2017年 li. All rights reserved.
//


#import "ChongZhiViewController.h"
#import "OnLineCZViewController.h"
#import "AlipayAccountListViewController.h"
#import "ZhuanZhangRecordListViewController.h"

@interface ChongZhiViewController ()<UINavigationControllerDelegate>
{
    BOOL  isSelectWeiXinPay;
}

@end

@implementation ChongZhiViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initVariable];
    [self createUi];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    if ([ShareManager shareInstance].isShowToCZYDY) {
        [ShareManager shareInstance].isShowToCZYDY = NO;
        [self addGuideView];
    }
}

- (void)initVariable
{
    self.title = @"充值";
    if (!_isPush) {
        self.automaticallyAdjustsScrollViewInsets = NO;
        self.navigationController.delegate = self;
        self.tabBarController.tabBar.translucent = NO;
        self.navigationController.navigationBar.translucent = NO;
        NSDictionary *attributes = [NSDictionary dictionaryWithObjectsAndKeys:
                                    [UIColor whiteColor],
                                    NSForegroundColorAttributeName, nil];
        
        [self.navigationController.navigationBar setTitleTextAttributes:attributes];
        self.navigationController.interactivePopGestureRecognizer.delegate = (id)self;
    }else{
        [self leftNavigationItem];
    }
    _bgViewWidth.constant = FullScreen.size.width;
}

- (void)createUi
{
    _payButton.layer.masksToBounds =YES;
    _payButton.layer.cornerRadius = 5;
    
    _recordButton.layer.masksToBounds =YES;
    _recordButton.layer.cornerRadius = 4;
    _recordButton.layer.borderColor = [[UIColor colorWithRed:58.0/255.0 green:132.0/255.0 blue:1 alpha:0.7] CGColor];
    _recordButton.layer.borderWidth = 1.0f;
    
    _kefuButton.layer.masksToBounds =YES;
    _kefuButton.layer.cornerRadius = 4;
    _kefuButton.layer.borderColor = [[UIColor colorWithRed:58.0/255.0 green:132.0/255.0 blue:1 alpha:0.7] CGColor];;
    _kefuButton.layer.borderWidth = 1.0f;
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

#pragma mark - 新手指导页
- (void)addGuideView {
    
    NSString *imageName = nil;
    if(FullScreen.size.height <= 568)
    {
        imageName = @"cz_1136";
    }else if(FullScreen.size.height == 667)
    {
        imageName = @"cz_1334";
    }else{
        imageName = @"cz_2208";
    }
    
    UIImage *image = [UIImage imageNamed:imageName];
    UIImageView *ydyImageView = [[UIImageView alloc] initWithImage:image];
    ydyImageView.frame = [UIApplication sharedApplication].keyWindow.frame;
    ydyImageView.userInteractionEnabled = YES;
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dismissGuideView:)];
    [ydyImageView addGestureRecognizer:tap];
    
    [[UIApplication sharedApplication].keyWindow addSubview:ydyImageView];
}

- (void)dismissGuideView:(UITapGestureRecognizer*)tap
{
    UIImageView *imageview = (UIImageView *)tap.self.view;
    [imageview removeFromSuperview];
}



#pragma mark - Button Action

- (void)clickLeftControlAction:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)clickAlipayButtonAction:(id)sender
{
    isSelectWeiXinPay = NO;
    _alipayImage.image = [UIImage imageNamed:@"cz_17"];
    _weixinImage.image = [UIImage imageNamed:@"cz_19"];
}

- (IBAction)clickWeixinButtonAction:(id)sender
{
    isSelectWeiXinPay = YES;
    _alipayImage.image = [UIImage imageNamed:@"cz_19"];
    _weixinImage.image = [UIImage imageNamed:@"cz_17"];
}

- (IBAction)clickPayButtonAction:(id)sender
{
    OnLineCZViewController *vc = [[OnLineCZViewController alloc]initWithNibName:@"OnLineCZViewController" bundle:nil];
    vc.isSelectWX = isSelectWeiXinPay;
    vc.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:vc animated:YES];
}

- (IBAction)clickAlipayZZButtonAction:(id)sender
{
    AlipayAccountListViewController *vc = [[AlipayAccountListViewController alloc]initWithNibName:@"AlipayAccountListViewController" bundle:nil];
    vc.hidesBottomBarWhenPushed = YES;
    vc.isAlipayAccount = YES;
    [self.navigationController pushViewController:vc animated:YES];
}

- (IBAction)clickBlankZZButtonAction:(id)sender
{
    AlipayAccountListViewController *vc = [[AlipayAccountListViewController alloc]initWithNibName:@"AlipayAccountListViewController" bundle:nil];
    vc.hidesBottomBarWhenPushed = YES;
    vc.isAlipayAccount = NO;
    [self.navigationController pushViewController:vc animated:YES];
}

- (IBAction)clickRecordButtonAction:(id)sender
{
    ZhuanZhangRecordListViewController *vc = [[ZhuanZhangRecordListViewController alloc]initWithNibName:@"ZhuanZhangRecordListViewController" bundle:nil];
     vc.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:vc animated:YES];
}

- (IBAction)clickKefuButtonAction:(id)sender
{
    KeFuViewController *vc =[[KeFuViewController alloc]initWithNibName:@"KeFuViewController" bundle:nil];
    vc.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark - UINavigationControllerDelegate

- (void)navigationController:(UINavigationController *)navigationController willShowViewController:(UIViewController *)viewController animated:(BOOL)animated
{
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
   
    
}

- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer
{
    if (self.navigationController.childViewControllers.count == 1) {
        return NO;
    }else{
        return YES;
    }
}


@end
