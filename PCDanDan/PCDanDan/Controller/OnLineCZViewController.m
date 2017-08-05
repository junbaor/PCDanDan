//
//  OnLineCZViewController.m
//  PCDanDan
//
//  Created by xcode.qi on 17/1/17.
//  Copyright © 2017年 li. All rights reserved.
//

#import "OnLineCZViewController.h"
#import "CZQRCodeViewController.h"
//#import "CZTableViewCell.h"
#import <AlipaySDK/AlipaySDK.h>
#import "WXApi.h"
#import "Order.h"
#import "DataSigner.h"

@interface OnLineCZViewController ()<CZQRCodeViewControllerDelegate>
{
     MBProgressHUD *HUD;
}

@end

@implementation OnLineCZViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initVariable];
    [self updateUIShow];
    [self leftNavigationItem];
    
    [self getUserInfo];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)initVariable
{
    
    
    _nextButton.layer.masksToBounds =YES;
    _nextButton.layer.cornerRadius = 5;
    _czMoneyView.layer.masksToBounds =YES;
    _czMoneyView.layer.cornerRadius = 5;
    
    UserInfo * info = [ShareManager shareInstance].userinfo;
    _accountLabel.text = info.account;
    _moneyLabel.text = [NSString stringWithFormat:@"%.2f元宝",info.point];
    CGSize size = [_moneyLabel sizeThatFits:CGSizeMake(MAXFLOAT, 18)];
    _moneyLabelWidth.constant = size.width;
    
    HUD = [[MBProgressHUD alloc] initWithView:self.view];
    [self.view addSubview:HUD];
}

- (void)getUserInfo
{
    __weak OnLineCZViewController *weakSelf = self;
    [HttpMangerHelper  getUserSelfInfoSuccess:^(UserInfo * info) {
        weakSelf.accountLabel.text = info.account;
        weakSelf.moneyLabel.text = [NSString stringWithFormat:@"%.2f元宝",info.point];
        CGSize size = [weakSelf.moneyLabel sizeThatFits:CGSizeMake(MAXFLOAT, 18)];
        weakSelf.moneyLabelWidth.constant = size.width;
    } fail:nil];
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




- (void)updateUIShow
{
    if (_isSelectWX) {
        self.title = @"微信充值";
        _alipayLine.hidden = YES;
        _wxLine.hidden = NO;
        [_alipayButton setTitleColor:RGB(153, 153, 153) forState:UIControlStateNormal];
         [_wxButton setTitleColor:RGB(58, 132, 255) forState:UIControlStateNormal];
        _warnLabel.text = @"微信支付";
        
    }else{
        self.title = @"支付宝充值";
        _alipayLine.hidden = NO;
        _wxLine.hidden = YES ;
        [_wxButton setTitleColor:RGB(153, 153, 153) forState:UIControlStateNormal];
        [_alipayButton setTitleColor:RGB(58, 132, 255) forState:UIControlStateNormal];
        _warnLabel.text = @"支付宝支付";
    }
}

#pragma mark - button action

- (void)clickLeftControlAction:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)clickUpdateButton:(id)sender
{
    _moneyLabel.text = @"获取中...";
    [self getUserInfo];
}

- (IBAction)clickWXButton:(id)sender
{
    _isSelectWX = YES;
    [self updateUIShow];
}

- (IBAction)clickAlipayButton:(id)sender
{
    _isSelectWX = NO;
    [self updateUIShow];
}

- (IBAction)clickNextButton:(id)sender
{
    [Tool hideAllKeyboard];
    
    
    if (_czMoneyText.text.length < 1 || [_czMoneyText.text doubleValue] <=0) {
        [Tool showPromptContent:@"请输入充值金额" onView:self.view];
        return;
    }
    if (_isSelectWX) {
        [Tool showPromptContent:@"暂不支持微信支付" onView:self.view];
        return;
    }
    
    if([_czMoneyText.text doubleValue] < 10)
    {
        [Tool showPromptContent:@"最少充值金额10元" onView:self.view];
        return;
    }
//    [Tool showPromptContent:@"暂不支持支付" onView:self.view];
    [self httpGetOrderWithMoney:_czMoneyText.text];
}

#pragma mark -
- (void)httpGetOrderWithMoney:(NSString *)money
{
    [HUD show:YES];
    HttpHelper *helper = [[HttpHelper alloc] init];
    __weak OnLineCZViewController  *weakSelf = self;
    [helper getOrderNoWithUserId:[ShareManager shareInstance].userinfo.id
                       total_fee:money
                       success:^(NSDictionary *resultDic){
                           [HUD hide:YES];
                           if ([[resultDic objectForKey:@"result_code"] integerValue] == 0) {
                               [weakSelf handleloadGetOrderResult:resultDic money:money];
                           }else
                           {
                               [HUD hide:YES];
                               [Tool showPromptContent:[resultDic objectForKey:@"result_desc"] onView:self.view];
                           }
                       }fail:^(NSString *decretion){
                           [HUD hide:YES];
                           [Tool showPromptContent:@"网络出错了" onView:self.view];
                       }];
    
}

- (void)handleloadGetOrderResult:(NSDictionary *)resultDic money:(NSString *)money
{
    if (!resultDic) {
        [HUD hide:YES];
        [Tool showPromptContent:@"数据请求失败" onView:self.view];
        return;
    }
    
    NSString *orderStr = [[resultDic objectForKey:@"data"] objectForKey:@"order_no"];
    
    [self httpGetPayUrlWithMoney:money orderNo:orderStr];
//    [self payForAlipayWithOrderInfo:orderStr moneyStr:[money doubleValue]];
    
}


- (void)httpGetPayUrlWithMoney:(NSString *)money orderNo:(NSString *)orderNo
{
    
    HttpHelper *helper = [[HttpHelper alloc] init];
    __weak OnLineCZViewController  *weakSelf = self;
    [helper getPayUrlWithUrl:URL_AiYiPay
                    order_no:orderNo
                         fee:money
                    pay_type:_isSelectWX == YES ?@"2":@"1"
                     success:^(NSDictionary *resultDic){
                         [HUD hide:YES];
                         if ([[resultDic objectForKey:@"result_code"] integerValue] == 0) {
                             [weakSelf handleloadGetUrlResult:resultDic money:money orderNo:orderNo];
                         }else
                         {
                             [Tool showPromptContent:[resultDic objectForKey:@"result_desc"] onView:self.view];
                         }
                     }fail:^(NSString *decretion){
                         [HUD hide:YES];
                         [Tool showPromptContent:@"网络出错了" onView:self.view];
                     }];
    
}

- (void)handleloadGetUrlResult:(NSDictionary *)resultDic money:(NSString *)money orderNo:(NSString *)orderNo
{
    if (!resultDic) {
        [Tool showPromptContent:@"数据请求失败" onView:self.view];
        return;
    }
    
    NSString *urlStr = [resultDic objectForKey:@"data"];
    CZQRCodeViewController *vc = [[CZQRCodeViewController alloc]initWithNibName:@"CZQRCodeViewController" bundle:nil];
    vc.isSelectWX = _isSelectWX;
    vc.orderNo = orderNo;
    vc.moneyStr = money;
    vc.orderQRImageStr = urlStr;
    vc.delegate = self;
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark - CZQRCodeViewControllerDelegate 

- (void)payCZQRCodePaySuccess
{
    [self getUserInfo];
}


#pragma mark - Alipay
/**
 *  支付宝支付
 *
 *  @param orderId         支付宝订单信息
 */
- (void)payForAlipayWithOrderInfo:(NSString *)orderNo moneyStr:(double)realMoney
{
    /*=============需要填写商户app申请的=============*/
    NSString *partner = AliPayId;
    NSString *seller = AliPayAccount;
    NSString *privateKey = AliPayPrivateKey;
    /*============================================*/
    /*
     *生成订单信息及签名
     */
    
    NSDictionary *infoDictionary = [[NSBundle mainBundle] infoDictionary];
    // app名称
    NSString *app_Name = [infoDictionary objectForKey:@"CFBundleDisplayName"];
    
    //将商品信息赋予AlixPayOrder的成员变量
    Order *order = [[Order alloc] init];
    order.partner = partner;
    order.seller = seller;
    order.tradeNO = orderNo; //订单ID（由商家自行制定）
    order.productName = app_Name;
    order.productDescription = app_Name; //商品描述
    order.amount = [NSString stringWithFormat:@"%.2f",realMoney]; //商品价格
    order.notifyURL = [NSString stringWithFormat:@"%@%@",URL_Server,AliPayNotifyURL]; //回调URL
    
    order.service = @"mobile.securitypay.pay";
    order.paymentType = @"1";
    order.inputCharset = @"utf-8";
    order.itBPay = @"30m";
    order.showUrl = @"m.alipay.com";
    
    //应用注册scheme,在AlixPayDemo-Info.plist定义URL types
    NSString *appScheme = AppScheme;
    
    //将商品信息拼接成字符串
    NSString *orderSpec = [order description];
    NSLog(@"orderSpec = %@",orderSpec);
    
    //获取私钥并将商户信息签名,外部商户可以根据情况存放私钥和签名,只需要遵循RSA签名规范,并将签名字符串base64编码和UrlEncode
    id<DataSigner> signer = CreateRSADataSigner(privateKey);
    NSString *signedString = [signer signString:orderSpec];
    
    //将签名成功字符串格式化为订单字符串,请严格按照该格式
    NSString *orderString = nil;
    if (signedString != nil) {
        orderString = [NSString stringWithFormat:@"%@&sign=\"%@\"&sign_type=\"%@\"",
                       orderSpec, signedString, @"RSA"];
        __weak OnLineCZViewController *weakSelf = self;
        [[AlipaySDK defaultService] payOrder:orderString fromScheme:appScheme callback:^(NSDictionary *resultDic) {
            NSLog(@"reslut = %@",resultDic);
            NSString *resultStatue = (NSString *)[resultDic objectForKey:@"resultStatus"];
            
            NSDictionary *resultInfo = [NSDictionary dictionaryWithObjectsAndKeys:resultStatue, @"resCode", nil];
            [weakSelf handlePayResultNotification:resultInfo];
        }];
    }
}

/**
 *  处理支付结果
 */
- (void)handlePayResultNotification:(NSDictionary *)userInfo
{
    NSString *message = nil;
    NSString *resultCode = (NSString*)[userInfo objectForKey:@"resCode"];
    if ([resultCode isEqualToString:@"00"] ||[resultCode isEqualToString:@"9000"]) {
        
        
        [Tool showPromptContent:@"支付成功" onView:self.view];
        _czMoneyText.text = @"";
        [self getUserInfo];
        
    }
    else if ([resultCode isEqualToString:@"01"] || [resultCode isEqualToString:@"4000"])
    {
        message = @"很遗憾，您此次支付失败，请您重新支付！";
        [Tool showPromptContent:message onView:self.view];
        
    }else if([resultCode isEqualToString:@"02"] || [resultCode isEqualToString:@"6001"]){
        message = @"您已取消了支付操作！";
        [Tool showPromptContent:message onView:self.view];
        
    }else if([resultCode isEqualToString:@"8000"]){
        message =  @"正在处理中,请稍候查看！若有疑问可咨询管理员";
        UIAlertView *alter = [[UIAlertView alloc] initWithTitle:@"支付提示" message:message delegate:nil cancelButtonTitle:@"确认" otherButtonTitles:nil];
        [alter show];
        
    }else if([resultCode isEqualToString:@"6002"]){
        message = @"网络连接出错，请您重新支付！";
        [Tool showPromptContent:message onView:self.view];
    }
    
}


@end
