//
//  AboutOurViewController.m
//  PCDanDan
//
//  Created by xcode.qi on 17/1/19.
//  Copyright © 2017年 li. All rights reserved.
//


#import "AboutOurViewController.h"

@interface AboutOurViewController ()<UIActionSheetDelegate>
{
    MBProgressHUD * HUD;
    ShareInfo *shareInfo;
}

@end

@implementation AboutOurViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initVariable];
    [self leftNavigationItem];
    [self getPTInfo];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)initVariable
{
    self.title = @"关于";
    
    _bgViewWidth.constant = FullScreen.size.width;
    
    _fz1Button.layer.masksToBounds =YES;
    _fz1Button.layer.cornerRadius = 4;
    _fz1Button.layer.borderColor = [RGB(170, 205, 253) CGColor];
    _fz1Button.layer.borderWidth = 1.0f;
    
    _fz2Button.layer.masksToBounds =YES;
    _fz2Button.layer.cornerRadius = 4;
    _fz2Button.layer.borderColor = [RGB(170, 205, 253) CGColor];
    _fz2Button.layer.borderWidth = 1.0f;
    
    _fz3Button.layer.masksToBounds =YES;
    _fz3Button.layer.cornerRadius = 4;
    _fz3Button.layer.borderColor = [RGB(170, 205, 253) CGColor];
    _fz3Button.layer.borderWidth = 1.0f;
    
    _shareButton.layer.masksToBounds =YES;
    _shareButton.layer.cornerRadius = _shareButton.frame.size.height/2;
    
    _banbenhaoLabel.layer.masksToBounds =YES;
    _banbenhaoLabel.layer.cornerRadius = _banbenhaoLabel.frame.size.height/2;
    
    HUD = [[MBProgressHUD alloc] initWithView:self.view];
    [self.view addSubview:HUD];
    
    NSDictionary *infoDictionary = [[NSBundle mainBundle] infoDictionary];
    NSString *appCurVersion = [infoDictionary objectForKey:@"CFBundleShortVersionString"];
    _banbenhaoLabel.text = [NSString stringWithFormat:@"当前版本号:%@",appCurVersion];
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

- (void)getPTInfo
{
    [HUD show:YES];
    __weak AboutOurViewController *weakSelf = self;
    [HttpMangerHelper  getPTInfoWithSuccess:^(PingTaiServerInfo * info) {
        [weakSelf getShareInfo];
        weakSelf.gwLabel.text = [NSString stringWithFormat:@"平台官网：%@",info.kefu_guanwang];
        weakSelf.qqLabel.text = [NSString stringWithFormat:@"客服QQ：%@",info.kefu_qq];
         weakSelf.weixinLabel.text = [NSString stringWithFormat:@"客服微信：%@",info.kefu_weixin];
    } fail:^(NSString *description) {
        [weakSelf getShareInfo];
    }];
    
}

- (void)getShareInfo
{
    [HUD show:YES];
    __weak AboutOurViewController *weakSelf = self;
    [HttpMangerHelper  getShareInfoWithSuccess:^(ShareInfo * info) {
        [HUD hide:YES];
        shareInfo = info;
        weakSelf.codeImage.image = [Tool generateQRCodeWithStr:[NSString stringWithFormat:@"%@?user_id=%@",info.share_url,[ShareManager shareInstance].userinfo.id]];
    } fail:^(NSString *description) {
        [HUD hide:YES];
    }];
}


#pragma mark - button action

- (void)clickLeftControlAction:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)clicCopyType:(id)sender
{
    NSString *str = nil;
    UIButton *btn = (UIButton *)sender;
    switch (btn.tag) {
        case 1:
            str = [ShareManager shareInstance].ptkfInfo.kefu_guanwang;
            break;
        case 2:
            str = [ShareManager shareInstance].ptkfInfo.kefu_qq;
            break;
        case 3:
            str = [ShareManager shareInstance].ptkfInfo.kefu_weixin;
            break;
        default:
            break;
    }
    if (str) {
        UIPasteboard *pasteboard = [UIPasteboard generalPasteboard];
        pasteboard.string = str;
        [Tool showPromptContent:@"复制成功" onView:self.view];
    }
}

- (IBAction)clicShareAction:(id)sender
{
    
    UIActionSheet *actionSheet = [[UIActionSheet alloc]
                                  initWithTitle:nil
                                  delegate:self
                                  cancelButtonTitle:@"取消"
                                  destructiveButtonTitle:nil
                                  otherButtonTitles:nil];
    actionSheet.actionSheetStyle = UIActionSheetStyleDefault;
    
    [actionSheet addButtonWithTitle :@"保存二维码"];
    [actionSheet showInView:self.view];
    
}

#pragma mark - UIActionSheetDelegate

- (void)actionSheet:(UIActionSheet *)actionSheet didDismissWithButtonIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 0) {
        return;
    }else{
        [self loadImageFinished:_codeImage.image];
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
    }else{
        [Tool showPromptContent:@"保持二维码成功" onView:self.view];
    }
    
    
}

@end
