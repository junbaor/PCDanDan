//
//  MoreViewController.m
//  PCDanDan
//
//  Created by xcode.qi on 17/1/19.
//  Copyright © 2017年 li. All rights reserved.
//

#import "MoreViewController.h"
#import "MyWallectViewController.h"
#import "ChongZhiViewController.h"
#import "TiXianViewController.h"
#import "BankBangdingViewController.h"
#import "MyMessageListViewController.h"

@interface MoreViewController ()<UINavigationControllerDelegate>

@end

@implementation MoreViewController
- (void)dealloc
{
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:KQuitLogin object:nil];
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initVariable];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    // 隐藏导航栏
    [self.navigationController setNavigationBarHidden:YES animated:animated];
    
    __weak MoreViewController *weakSelf = self;
    [HttpMangerHelper  getUserSelfInfoSuccess:^(UserInfo * info) {
        weakSelf.moneyLabel.text = [NSString stringWithFormat:@"%.2f元宝",info.point];
        [weakSelf.headImage sd_setImageWithURL:[NSURL URLWithString:info.user_photo] placeholderImage:PublicImage(@"shouye_160.png")];
        
    } fail:nil];
    
    [HttpMangerHelper  getUnReadMessageNumWithSuccess:^(UnReadMessageNumInfo * info) {
        if (info.my_notice_count > 0) {
            weakSelf.warnLabel.hidden = NO;
        }else{
            weakSelf.warnLabel.hidden = YES;
        }
    } fail:nil];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillAppear:animated];
    // 显示导航栏
    [self.navigationController setNavigationBarHidden:NO animated:animated];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.

}

- (void)initVariable
{
    self.navigationController.delegate = self;
    self.navigationController.navigationBar.translucent = NO;
    NSDictionary *attributes = [NSDictionary dictionaryWithObjectsAndKeys:
                                [UIColor whiteColor],
                                NSForegroundColorAttributeName, nil];
    
    [self.navigationController.navigationBar setTitleTextAttributes:attributes];
    self.navigationController.interactivePopGestureRecognizer.delegate = (id)self;
    
    _warnLabel.layer.masksToBounds =YES;
    _warnLabel.layer.cornerRadius = _warnLabel.height/2;
    
    _czButtonAction.layer.masksToBounds =YES;
    _czButtonAction.layer.cornerRadius = 5;
    
    _txButtonAction.layer.masksToBounds =YES;
    _txButtonAction.layer.cornerRadius = 5;
    
    _headImage.layer.masksToBounds =YES;
    _headImage.layer.cornerRadius = _headImage.frame.size.height/2;
    
    [[NSNotificationCenter defaultCenter]addObserver:self
                                            selector:@selector(quitLoginDiss)
                                                name:KQuitLogin
                                              object:nil];
    
}

- (void)quitLoginDiss
{
    [self dismissViewControllerAnimated:NO completion:nil];
}



#pragma mark - button action

- (IBAction)clickCZButtonAction:(id)sender
{
    
    ChongZhiViewController *vc = [[ChongZhiViewController alloc]initWithNibName:@"ChongZhiViewController" bundle:nil];
    vc.isPush = YES;
    [self.navigationController pushViewController:vc animated:YES];
}

- (IBAction)clickTXButtonAction:(id)sender
{
    if(![HttpMangerHelper isBangDingPhone])
    {
        __weak MoreViewController *ws = self;
        UIAlertView *alert = [UIAlertView bk_showAlertViewWithTitle:@"提示" message:@"为了您的资金安全，请绑定手机号" cancelButtonTitle:@"确定" otherButtonTitles:nil handler:^(UIAlertView *alertView, NSInteger buttonIndex) {
            [HttpMangerHelper gotoBangDingWithAnimated:YES viewController:ws];
        }];
        [alert show];
    }else{
        if(![HttpMangerHelper isSetTiXianPwd])
        {
            __weak MoreViewController *ws = self;
            UIAlertView *alert = [UIAlertView bk_showAlertViewWithTitle:@"提示" message:@"请先设置提现密码" cancelButtonTitle:@"确定" otherButtonTitles:nil handler:^(UIAlertView *alertView, NSInteger buttonIndex) {
                [HttpMangerHelper setTiXianPwdWithAnimated:YES viewController:ws];
            }];
            [alert show];
        }else{
            
            if ([ShareManager shareInstance].userinfo.bank_no.length > 0 && ![[ShareManager shareInstance].userinfo.bank_no isEqualToString:@"<null>"] ) {
                TiXianViewController *vc = [[TiXianViewController alloc]initWithNibName:@"TiXianViewController" bundle:nil];
                [self.navigationController pushViewController:vc animated:YES];
                
            }else{
                
                __weak MoreViewController *ws = self;
                UIAlertView *alert = [UIAlertView bk_showAlertViewWithTitle:@"提示" message:@"您未绑定银行卡，请先绑定银行卡" cancelButtonTitle:@"确定" otherButtonTitles:nil handler:^(UIAlertView *alertView, NSInteger buttonIndex) {
                    BankBangdingViewController *vc = [[BankBangdingViewController alloc]initWithNibName:@"BankBangdingViewController" bundle:nil];
                    [ws.navigationController pushViewController:vc animated:YES];
                }];
                [alert show];
                
            }
        }
    }
    
}

- (IBAction)clickWallectButtonAction:(id)sender
{
    MyWallectViewController *vc = [[MyWallectViewController alloc]initWithNibName:@"MyWallectViewController" bundle:nil];
    [self.navigationController pushViewController:vc animated:YES];
    
}

- (IBAction)clickMessageButtonAction:(id)sender
{
    MyMessageListViewController *vc = [[MyMessageListViewController alloc]initWithNibName:@"MyMessageListViewController" bundle:nil];
    [self.navigationController pushViewController:vc animated:YES];
}

- (IBAction)clickCloseButtonAction:(id)sender
{
    [self dismissViewControllerAnimated:YES completion:nil];
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
