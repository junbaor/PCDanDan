//
//  CZQRCodeViewController.m
//  PCDanDan
//
//  Created by xcode.qi on 17/1/19.
//  Copyright © 2017年 li. All rights reserved.
//


#import "CZQRCodeViewController.h"

@interface CZQRCodeViewController ()
{
    MBProgressHUD *HUD;
}

@end

@implementation CZQRCodeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initVariable];
    [self leftNavigationItem];
    
    [HUD show:YES];
    
    __weak CZQRCodeViewController *weakSelf = self;
    [_qrcodeImage sd_setImageWithURL:[NSURL URLWithString:_orderQRImageStr] placeholderImage:PublicImage(@"wode_03.png") completed:^(UIImage *image, NSError *error, EMSDImageCacheType cacheType, NSURL *imageURL) {
        if (error) {
            [HUD hide:YES];
            [Tool showPromptContent:@"加载异常，请重试" onView:weakSelf.view];
            [weakSelf performSelector:@selector(clickLeftControlAction:) withObject:nil afterDelay:1.5];
        }else{
            [HUD hide:YES];
        }
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)initVariable
{
    
    _bgViewWidth.constant = FullScreen.size.width;
    _backButton.layer.masksToBounds =YES;
    _backButton.layer.cornerRadius = 5;
    _payButton.layer.masksToBounds =YES;
    _payButton.layer.cornerRadius = 5;
    _hasPayButton.layer.masksToBounds =YES;
    _hasPayButton.layer.cornerRadius = 5;
    
    if (_isSelectWX) {
        self.title = @"微信充值";
        _payTypeWarn.text = @"微信支付扫描信息";
        _oneLabel.text = @"1.点“立即充值”将自动为您截屏并保存到相册，同时打开微信";
        _twoLabel.text = @"2.请在微信中打开扫一扫";
    }else{
        self.title = @"支付宝充值";
        _payTypeWarn.text = @"支付宝支付扫描信息";
        _oneLabel.text = @"1.点“立即充值”将自动为您截屏并保存到相册，同时打开支付宝";
        _twoLabel.text = @"2.请在支付宝中打开扫一扫";
    }
    
    _orderNum.text = [NSString stringWithFormat:@"订单号：%@",_orderNo];
    _moneyLabel.text = [NSString stringWithFormat:@"充值金额：%@元",_moneyStr];
    
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

- (IBAction)clickSBYButtonAction:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}
- (IBAction)clickLJCZButtonAction:(id)sender
{
    NSString *str = nil;
    if (_isSelectWX) {
        str = @"将为您保持二维码，并打开微信，是否立即充值？";
    }else{
        str = @"将为您保持二维码，并打开支付宝，是否立即充值？";
    }
    UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"提示" message:str delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
    [alert show];
}

- (IBAction)clickWYZFButtonAction:(id)sender
{
    [self checkIsPaySuccess];
}

#pragma mark - UIAlertViewDelegate
- (void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 1) {
        [self loadImageFinished:_qrcodeImage.image];
        if(_isSelectWX)
        {
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"weixin://"]];
        }else{
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"alipay://"]];
        }
    }
}

- (void)loadImageFinished:(UIImage *)image
{
    UIImageWriteToSavedPhotosAlbum(image, self, @selector(image:didFinishSavingWithError:contextInfo:), (__bridge void *)self);
}

- (void)image:(UIImage *)image didFinishSavingWithError:(NSError *)error contextInfo:(void *)contextInfo
{
    if (error) {
        [Tool showPromptContent:@"保持二维码失败" onView:self.view];
    }
    
    
}

#pragma mark - http

- (void)checkIsPaySuccess
{
    [HUD show:YES];
    HttpHelper *helper = [[HttpHelper alloc] init];
    __weak CZQRCodeViewController  *weakSelf = self;
    [helper checkIsPaySuccessWithOrder_no:_orderNo
                                  user_id:[ShareManager shareInstance].userinfo.id
                                  success:^(NSDictionary *resultDic){
                                      [HUD hide:YES];
                                      if ([[resultDic objectForKey:@"result_code"] integerValue] == 0) {
                                          [weakSelf handleloadCheckResult:resultDic];
                                      }else
                                      {
                                          [Tool showPromptContent:[resultDic objectForKey:@"result_desc"] onView:self.view];
                                      }
                                  }fail:^(NSString *decretion){
                                      [HUD hide:YES];
                                      [Tool showPromptContent:@"网络出错了" onView:self.view];
                                  }];
    
}

- (void)handleloadCheckResult:(NSDictionary *)resultDic
{
    if (!resultDic) {
        [HUD hide:YES];
        [Tool showPromptContent:@"数据请求失败" onView:self.view];
        return;
    }
    
    if ([[resultDic objectForKey:@"data"] intValue] == 1) {
        if([self.delegate respondsToSelector:@selector(payCZQRCodePaySuccess)]){
            
            [self.delegate payCZQRCodePaySuccess];
        }
        [Tool showPromptContent:@"您已支付成功" onView:self.view];
        [self performSelector:@selector(clickLeftControlAction:) withObject:nil afterDelay:1.5];
    }else{
        [Tool showPromptContent:@"您尚未支付" onView:self.view];
    }
    
    
    
}



@end
