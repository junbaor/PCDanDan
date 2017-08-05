//
//  ShareViewController.m
//  PCDanDan
//
//  Created by xcode.qi on 17/1/17.
//  Copyright © 2017年 li. All rights reserved.
//

#import "ShareViewController.h"
#import "FXListTableViewCell.h"
#import "ShareRuleInfo.h"

@interface ShareViewController ()<UIActionSheetDelegate>
{
    MBProgressHUD * HUD;
    ShareInfo *shareInfo;
    BOOL isRequest;
    ShareRuleInfo *shareRuleInfo;
    BOOL isSelectShare;
    UIButton *shareButton;
}

@end

@implementation ShareViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initVariable];
    
    [self leftNavigationItem];
    [self rightItem];
    [self updateShowUI];
    [self httpGetShareRule];
    
    [HttpMangerHelper  getShareInfoWithSuccess:^(ShareInfo * info) {
        shareInfo = info;
    } fail:^(NSString *description) {
    }];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)initVariable
{
    self.title = @"我要分享";
    _bgViewWidth.constant = FullScreen.size.width;
    _zjkhButton.layer.masksToBounds =YES;
    _zjkhButton.layer.cornerRadius = 2;
    _zjkhButton.layer.borderColor = [RGB(235, 235, 235) CGColor];
    _zjkhButton.layer.borderWidth = 1.0f;
    
    _fxljButton.layer.masksToBounds =YES;
    _fxljButton.layer.cornerRadius = 2;
    _fxljButton.layer.borderColor = [RGB(235, 235, 235) CGColor];
    _fxljButton.layer.borderWidth = 1.0f;
    
    _sureButton.layer.masksToBounds =YES;
    _sureButton.layer.cornerRadius = 3;
    
    _fzButton.layer.masksToBounds =YES;
    _fzButton.layer.cornerRadius = _fzButton.height/2;
    _fzButton.layer.borderColor = [RGB(0, 128, 255) CGColor];
    _fzButton.layer.borderWidth = 1.0f;
    
    [_saveButton setImageEdgeInsets:UIEdgeInsetsMake(6, 4, 6, 6)];
    
    HUD = [[MBProgressHUD alloc] initWithView:self.view];
    [self.view addSubview:HUD];
    
    
    
    NSString * showStr = [NSString stringWithFormat:@"您的分享ID为：<color1>%@</color1>",[ShareManager shareInstance].userinfo.id];
    
    NSDictionary* style = @{@"body":[UIFont systemFontOfSize:11],
                            @"color1":RGB(235, 82, 83)};
    
    _fxidLabel.attributedText = [showStr attributedStringWithStyleBook:style];
    
    
}

- (void)updateShowUI
{
    _shareView.hidden = YES;
    _zjkhView.hidden = YES;
    [_zjkhButton setBackgroundColor:RGB(216, 217, 221)];
    [_fxljButton setBackgroundColor:RGB(216, 217, 221)];
    [_zjkhButton setTitleColor:RGB(53, 53, 53) forState:UIControlStateNormal];
    [_fxljButton setTitleColor:RGB(53, 53, 53) forState:UIControlStateNormal];
    
    if (isSelectShare) {
        shareButton.hidden = NO;
        _shareView.hidden = NO;
        [_fxljButton setBackgroundColor:RGB(232, 235, 238)];
        [_fxljButton setTitleColor:RGB(0, 128, 255) forState:UIControlStateNormal];
    }else{
        shareButton.hidden = YES;
        _zjkhView.hidden = NO;
        [_zjkhButton setBackgroundColor:RGB(232, 235, 238)];
         [_zjkhButton setTitleColor:RGB(0, 128, 255) forState:UIControlStateNormal];
    }
}

- (void)getShareInfo
{
    [HUD show:YES];
    __weak ShareViewController *weakSelf = self;
    [HttpMangerHelper  getShareInfoWithSuccess:^(ShareInfo * info) {
        [HUD hide:YES];
        shareInfo = info;
        isRequest = YES;
        weakSelf.codeImage.image = [Tool generateQRCodeWithStr:[NSString stringWithFormat:@"%@?user_id=%@",info.share_url,[ShareManager shareInstance].userinfo.id]];
        weakSelf.urlLabel.text = [NSString stringWithFormat:@"%@?user_id=%@",info.share_url,[ShareManager shareInstance].userinfo.id];
    } fail:^(NSString *description) {
        [HUD hide:YES];
    }];
}

- (void)leftNavigationItem
{
    UIControl *leftItemControl = [[UIControl alloc] initWithFrame:CGRectMake(0, 0, 20, 44)];
    [leftItemControl addTarget:self action:@selector(clickLeftButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    
    UIImageView *back = [[UIImageView alloc] initWithFrame:CGRectMake(0, 13, 18, 18)];
    back.image = [UIImage imageNamed:@"shouye_85.png"];
    [leftItemControl addSubview:back];
    
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:leftItemControl];
}

- (void)rightItem
{
    UIView *rightItemView = [[UIView alloc] initWithFrame:CGRectMake(0, 8, 40, 40)];
    
    shareButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 40, 40)];
    [shareButton setImageEdgeInsets:UIEdgeInsetsMake(11, 10, 9, 10)];
    [shareButton setImage:[UIImage imageNamed:@"wode_share"] forState:UIControlStateNormal];
    [shareButton addTarget:self action:@selector(clickShareButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    [rightItemView addSubview:shareButton];
    
    UIBarButtonItem *rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:rightItemView];
    
    UIBarButtonItem *negativeSpacer = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace
                                                                                    target:nil
                                                                                    action:nil];
    negativeSpacer.width = -15;
    self.navigationItem.rightBarButtonItems = @[negativeSpacer, rightBarButtonItem];
}

#pragma mark - http

- (void)httpGetShareRule
{
    [HUD show:YES];
    HttpHelper *helper = [[HttpHelper alloc] init];
    __weak ShareViewController *weakSelf = self;
    [helper getHttpWithUrlStr:URL_GetShareRule
                      success:^(NSDictionary *resultDic){
                          [HUD hide:YES];
                          if ([[resultDic objectForKey:@"result_code"] integerValue] == 0) {
                              [weakSelf handleloadResult:resultDic];
                          }else
                          {
                              [Tool showPromptContent:[resultDic objectForKey:@"result_desc"] onView:self.view];
                          }
                      }fail:^(NSString *decretion){
                          [HUD hide:YES];
                          
                          [Tool showPromptContent:@"网络出错了" onView:self.view];
                          
                      }];
    
}

- (void)handleloadResult:(NSDictionary *)resultDic
{
    if(!resultDic)
    {
        [Tool showPromptContent:@"请求失败" onView:self.view];
        return;
    }
    
    shareRuleInfo = [[resultDic objectForKey:@"data"] objectByClass:[ShareRuleInfo class]];

    _tiaojianLabel.text = [NSString stringWithFormat:@"1、条件：VIP分享所发展的用户每天投注满%d次；",shareRuleInfo.num];
    NSMutableArray *array = [NSMutableArray array];
    for (NSDictionary *dic in shareRuleInfo.bili_list) {
        ShareRuleListInfo *info1 =  [dic objectByClass:[ShareRuleListInfo class]];
        [array addObject:info1];
    }

    shareRuleInfo.bili_list = array;
    [_tableView reloadData];
}


- (void)httpResigter
{
    
    if ( _yhmText.text.length < 1) {
        [Tool showPromptContent:@"请输入用户名" onView:self.view];
        return;
    }
    
    if ( _yhmText.text.length < 6 || _yhmText.text.length > 12) {
        [Tool showPromptContent:@"用户名为6~12位数字或字母" onView:self.view];
        return;
    }
    
    if (_pwdText.text.length < 1) {
        [Tool showPromptContent:@"请输入密码" onView:self.view];
        return;
    }
    if ( _pwdText.text.length < 6 || _pwdText.text.length > 12) {
        [Tool showPromptContent:@"密码为6~12位数字或字母" onView:self.view];
        return;
    }
    
    if (_surePwdText.text.length < 1) {
        [Tool showPromptContent:@"请确认密码" onView:self.view];
        return;
    }
    
    if (![_pwdText.text isEqualToString:_surePwdText.text]) {
        [Tool showPromptContent:@"两次密码输入不一致" onView:self.view];
        return;
    }
    
    [HUD show:YES];
    
    HttpHelper *helper = [[HttpHelper alloc] init];
    __weak ShareViewController *weakSelf = self;
    [helper resigterAccountWithAccount:_yhmText.text
                              password:_pwdText.text
                                  code:[ShareManager shareInstance].userinfo.id
                       registration_id:nil
                               success:^(NSDictionary *resultDic){
                                   [HUD hide:YES];
                                   if ([[resultDic objectForKey:@"result_code"] integerValue] == 0) {
                                       [weakSelf handleloadResigterResult:resultDic];
                                   }else
                                   {
                                       [Tool showPromptContent:[resultDic objectForKey:@"result_desc"] onView:self.view];
                                   }
                               }fail:^(NSString *decretion){
                                   [HUD hide:YES];
                                   [Tool showPromptContent:@"网络出错了" onView:self.view];
                               }];
    
}

- (void)handleloadResigterResult:(NSDictionary *)resultDic
{
    if(!resultDic)
    {
        [Tool showPromptContent:@"请求失败" onView:self.view];
        return;
    }
    [Tool showPromptContent:@"注册成功" onView:self.view];
    
}


#pragma mark - Action

- (void)clickLeftButtonAction:(id)sender
{
    [Tool hideAllKeyboard];
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)clickShareButtonAction:(id)sender
{
    [Tool hideAllKeyboard];
//    [Tool showPromptContent:@"暂不支持" onView:self.view];
    
    if ([WXApi isWXAppInstalled] )//|| [QQApiInterface isQQInstalled]
    {
        if (shareInfo) {
            shareInfo.share_url = @"http://www.pcgg28.com/pcdd-wap/views/module/share/regist.html";
            [Tool shareMessageToOtherApp:shareInfo.share_content titleStr:shareInfo.share_title shareUrl:[NSString stringWithFormat:@"%@?user_id=%@",shareInfo.share_url,[ShareManager shareInstance].userinfo.id]];
        }else{
            [Tool showPromptContent:@"获取分享数据失败" onView:self.view];
        }
        
    }else{
        [Tool showPromptContent:@"您未安装微信客户端" onView:self.view];//、QQ
    }
}


- (IBAction)clickZJKHButtonAction:(id)sender
{
    [Tool hideAllKeyboard];
    isSelectShare = NO;
    [self updateShowUI];
    if(!shareRuleInfo)
    {
        [self httpGetShareRule];
    }
}

- (IBAction)clickFXLJButtonAction:(id)sender
{
    [Tool hideAllKeyboard];
     isSelectShare = YES;
    [self updateShowUI];
    if(!isRequest)
    {
        [self getShareInfo];
    }
}

- (IBAction)clickSureButtonAction:(id)sender
{
    [Tool hideAllKeyboard];
    [self httpResigter];
}

- (IBAction)clickCopyButtonAction:(id)sender
{
    UIPasteboard *pasteboard = [UIPasteboard generalPasteboard];
    pasteboard.string = _urlLabel.text;
    [Tool showPromptContent:@"复制成功" onView:self.view];
}

- (IBAction)clickSaveButtonAction:(id)sender
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

#pragma mark - UITableViewDelegate

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}
//行数
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
    return shareRuleInfo.bili_list.count;
    
}

//设置cell的行高
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 35;
}


//创建并显示每行的内容
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    FXListTableViewCell *cell = nil;
    cell = [tableView dequeueReusableCellWithIdentifier:@"FXListTableViewCell"];
    if (cell == nil)
    {
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"FXListTableViewCell" owner:nil options:nil];
        cell = [nib objectAtIndex:0];
    }
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    ShareRuleListInfo *info = [shareRuleInfo.bili_list objectAtIndex:indexPath.row];
    cell.oneLabel.text = info.level;
    cell.twoLabel.text = [NSString stringWithFormat:@"%@~%@",info.start_point,info.end_point];
    cell.threeLabel.text = info.get_point;
    return cell;
    
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    
}


@end
