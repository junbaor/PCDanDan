//
//  KeFuViewController.m
//  PCDanDan
//
//  Created by linqsh on 17/3/6.
//  Copyright © 2017年 vma-lin. All rights reserved.
//

#import "KeFuViewController.h"
#import "KefuMeListTableViewCell.h"
#import "KefuSendListTableViewCell.h"
@implementation RequestListInfo

@end
@implementation KefuMsgListInfo


@end

@interface KeFuViewController ()
{
    MBProgressHUD * HUD;
    BOOL _isInputViewActive;
    NSMutableArray *dataSourceArray;
    NSMutableArray *rquestDatasourceArray;
}

@end

@implementation KeFuViewController

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [[IQKeyboardManager sharedManager] setEnable:NO];
    [IQKeyboardManager sharedManager].enableAutoToolbar = NO;
    
}

-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [[IQKeyboardManager sharedManager] setEnable:YES];
    [IQKeyboardManager sharedManager].enableAutoToolbar = YES;
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initVariable];
    [self leftNavigationItem];
    [self registerKeyBoardNotification];
    [self.navigationController setNavigationBarHidden:NO animated:NO];
    _megTableView.estimatedRowHeight = 44.0f;//推测高度，必须有，可以随便写多少
    _megTableView.rowHeight =UITableViewAutomaticDimension;//iOS8之后默认就是这个值，可以省略
    
    
    [self httpGetRequestList];
    
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (void)initVariable
{
    self.title = @"客服";
    
    _sendButton.layer.masksToBounds =YES;
    _sendButton.layer.cornerRadius = 2;
    
    _textBgView.layer.masksToBounds =YES;
    _textBgView.layer.cornerRadius = 2;
    
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(onTapBlankToHide)];
    tap.numberOfTapsRequired = 1;
    tap.numberOfTouchesRequired = 1;
    [_megTableView addGestureRecognizer:tap];
    
    dataSourceArray = [NSMutableArray array];
    rquestDatasourceArray = [NSMutableArray array];
    HUD = [[MBProgressHUD alloc] initWithView:self.view];
    HUD.labelText = @"加载中...";
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

- (void)onTapBlankToHide
{
    [self resignFirstResponder];
}

- (void)registerKeyBoardNotification
{
    //添加键盘监听
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onKeyboardDidShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onKeyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onKeyboardDidShow:) name:UIKeyboardDidChangeFrameNotification object:nil];
    
}

#pragma mark - http

- (void)httpGetRequestList
{
    [HUD show:YES];
    HttpHelper *helper = [[HttpHelper alloc] init];
    __weak KeFuViewController *weakSelf = self;
    [helper getHttpWithUrlStr:URL_GetKeFuRequestList
                     success:^(NSDictionary *resultDic){
                         [HUD hide:YES];
                         if ([[resultDic objectForKey:@"result_code"] integerValue] == 0) {
                             [weakSelf handleloadResult:resultDic];
                         }else
                         {
                             UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"连接失败" message:[resultDic objectForKey:@"result_desc"]  delegate:self cancelButtonTitle:@"退出" otherButtonTitles:@"重连", nil];
                             alert.tag = 22022;
                             [alert show];
                         }
                     }fail:^(NSString *decretion){
                         [HUD hide:YES];
                         UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"连接失败" message:@"网络出错了"  delegate:self cancelButtonTitle:@"退出" otherButtonTitles:@"重连", nil];
                         alert.tag = 22022;
                         [alert show];
                     }];
    
}

- (void)handleloadResult:(NSDictionary *)resultDic
{
    if(!resultDic)
    {
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"连接失败" message:@"请求失败了"  delegate:self cancelButtonTitle:@"退出" otherButtonTitles:@"重连", nil];
        alert.tag = 22022;
        [alert show];
        return;
    }
   
    PingTaiServerInfo *info = [[resultDic objectForKey:@"data"] objectByClass:[PingTaiServerInfo class]];
    [ShareManager shareInstance].ptkfInfo = info;
    
    NSArray *resourceArray = [[resultDic objectForKey:@"data"] objectForKey:@"quest_list"];
    
    if (rquestDatasourceArray.count > 0) {
        [rquestDatasourceArray removeAllObjects];
    }
    
    if (resourceArray && resourceArray.count > 0)
    {
        NSString *requestMsg;
        for (NSDictionary *dic in resourceArray)
        {
            RequestListInfo *info = [dic objectByClass:[RequestListInfo class]];
            [rquestDatasourceArray addObject:info];
            if (requestMsg) {
                requestMsg = [NSString stringWithFormat:@"%@\r\n%@（请回复数字%@）",requestMsg,info.title,info.id];
            }else{
                requestMsg = [NSString stringWithFormat:@"%@（请回复数字%@）",info.title,info.id];
            }
        }
        
        KefuMsgListInfo *info = [[KefuMsgListInfo alloc]init];
        info.isKefu = YES;
        info.msg = [NSString stringWithFormat:@"尊敬的会员，您好感谢您使用本平台，为了提供更便捷的服务请使用以下自助功能快捷服务！\r\n\r\n%@",requestMsg];
        info.msg = [NSString stringWithFormat:@"%@\r\n\r\n更多问题请联系24小时在线客服微信号:%@ QQ:%@",info.msg,[ShareManager shareInstance].ptkfInfo.kefu_weixin,[ShareManager shareInstance].ptkfInfo.kefu_qq];
        info.timeStr = [Tool getCurrentTimeWithFormat:@"yyyy-MM-dd HH:mm:ss"];
        [dataSourceArray  addObject:info];
        
        [_megTableView reloadData];
    }
}

#pragma mark - UIAlertViewDelegate

- (void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex
{
    if (alertView.tag== 22022)
    {
        if (buttonIndex == 1) {
            [self httpGetRequestList];
        }else{
            [self.navigationController popViewControllerAnimated:YES];
        }
    }
}

#pragma mark - notification handler

- (void)onKeyboardDidShow:(NSNotification *)notification
{
    if (_isInputViewActive) {
        
        NSDictionary *userInfo = [notification userInfo];
        NSValue* aValue = [userInfo objectForKey:UIKeyboardFrameEndUserInfoKey];
        CGRect keyboardRect = [aValue CGRectValue];
        NSValue *animationDurationValue = [userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey];
        NSTimeInterval animationDuration;
        [animationDurationValue getValue:&animationDuration];
        
        CGFloat ky = keyboardRect.size.height;
        _textViewBottom.constant = ky;
        
       
        
        [UIView animateWithDuration:animationDuration animations:^{
            
            [self.view layoutIfNeeded];
            
            NSIndexPath *indexPath = [NSIndexPath indexPathForRow:dataSourceArray.count - 1 inSection:0];
            if (indexPath.row < [_megTableView numberOfRowsInSection:0])
            {
                [_megTableView scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionBottom animated:YES];

            }
        }];
    }
    
}

- (void)onKeyboardWillHide:(NSNotification *)notification
{
 
    NSDictionary* userInfo = [notification userInfo];
    
    NSValue *animationDurationValue = [userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey];
    NSTimeInterval animationDuration;
    [animationDurationValue getValue:&animationDuration];
    
    _textViewBottom.constant = 0;
    
    [UIView animateWithDuration:0.5 animations:^{
        
        [self.view layoutIfNeeded];
        
        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:dataSourceArray.count - 1 inSection:0];
        if (indexPath.row < [_megTableView numberOfRowsInSection:0])
        {
            [_megTableView scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionBottom animated:YES];
            
        }
        
    }];
    
}

- (BOOL)resignFirstResponder
{
    _isInputViewActive = NO;
    return [_msgText resignFirstResponder];
}


- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    _isInputViewActive = NO;
    [self onClickSend];
    return YES;
}

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    _isInputViewActive = YES;
    return YES;
}

- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    _isInputViewActive = YES;
    
}

-(void)textFieldDidEndEditing:(UITextField *)textField
{
    
}

- (void)textFieldDidBeginEditing
{
    _isInputViewActive = YES;
}



#pragma mark - UITableViewDelegate

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}
//行数
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
    return dataSourceArray.count;
    
}



//创建并显示每行的内容
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    KefuMsgListInfo *info = [dataSourceArray objectAtIndex:indexPath.row];
    
    if (info.isKefu) {
        KefuSendListTableViewCell  *cell = nil;
        cell = [tableView dequeueReusableCellWithIdentifier:@"KefuSendListTableViewCell"];
        if (cell == nil)
        {
            NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"KefuSendListTableViewCell" owner:nil options:nil];
            cell = [nib objectAtIndex:0];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
        }

        cell.timeLabel.text= info.timeStr;
        cell.msgTextLabel.text = info.msg;
        
        return cell;
    }else{
        KefuMeListTableViewCell *cell = nil;
        cell = [tableView dequeueReusableCellWithIdentifier:@"KefuMeListTableViewCell"];
        if (cell == nil)
        {
            NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"KefuMeListTableViewCell" owner:nil options:nil];
            cell = [nib objectAtIndex:0];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            cell.photoImage.layer.masksToBounds =YES;
            cell.photoImage.layer.cornerRadius = cell.photoImage.height/2;
        }
        cell.msgTextLabel.text =  info.msg;
        cell.timeLabel.text= info.timeStr;
        UserInfo *info1 = [ShareManager shareInstance].userinfo;
        [cell.photoImage sd_setImageWithURL:[NSURL URLWithString:info1.user_photo] placeholderImage:PublicImage(@"wode_24.png")];
        
        return cell;
    }
    
    
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    
}

#pragma mark - Action

- (void)clickLeftControlAction:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)clickSendButtonAction:(id)sender
{
    
    [self onClickSend];
}

- (void)onClickSend
{
    [self resignFirstResponder];
    if (_msgText.text.length > 0) {
        KefuMsgListInfo *info = [[KefuMsgListInfo alloc]init];
        info.isKefu = NO;
        info.timeStr = [Tool getCurrentTimeWithFormat:@"yyyy-MM-dd HH:mm:ss"];
        info.msg = _msgText.text;
        [dataSourceArray  addObject:info];
        [self showReply];
        
        [self autoReplyWithText:info.msg];
        
        
    }

    _msgText.text = nil;
    
}


- (void)autoReplyWithText:(NSString *)textStr
{
    KefuMsgListInfo *info = [[KefuMsgListInfo alloc]init];
    info.isKefu = YES;
    if ([Tool isPureFloat:textStr] && textStr.length == 1 && [textStr intValue] >0 && [textStr intValue]<=9) {
        for (RequestListInfo *info1 in rquestDatasourceArray) {
            if ([info1.id intValue] == [textStr intValue]) {
                info.msg = info1.content;
                info.timeStr = [Tool getCurrentTimeWithFormat:@"yyyy-MM-dd HH:mm:ss"];
            }
        }
    }
    else{
        info.timeStr = [Tool getCurrentTimeWithFormat:@"yyyy-MM-dd HH:mm:ss"];
        info.msg = [NSString stringWithFormat:@"请联系我的24小时在线客服微信号:%@ QQ:%@",[ShareManager shareInstance].ptkfInfo.kefu_weixin,[ShareManager shareInstance].ptkfInfo.kefu_qq];
    }
    
    
    [dataSourceArray  addObject:info];
    [self performSelector:@selector(showReply) withObject:nil afterDelay:1];
}

- (void)showReply
{
    [_megTableView beginUpdates];
    NSIndexPath *index = [NSIndexPath indexPathForRow:dataSourceArray.count-1 inSection:0];
    [_megTableView insertRowsAtIndexPaths:@[index] withRowAnimation:UITableViewRowAnimationBottom];
    [_megTableView endUpdates];
    
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:dataSourceArray.count - 1 inSection:0];
    if (indexPath.row < [_megTableView numberOfRowsInSection:0])
    {
        [_megTableView scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionBottom animated:YES];
        
    }
}

- (NSString *)getcurrenttime
{
    NSDate *senddate = [NSDate date];
    
    NSLog(@"date1时间戳 = %ld",time(NULL));
    NSString *date2 = [NSString stringWithFormat:@"%ld", (long)[senddate timeIntervalSince1970]];
    return date2;
}

@end
