/************************************************************
 *  * Hyphenate CONFIDENTIAL
 * __________________
 * Copyright (C) 2016 Hyphenate Inc. All rights reserved.
 *
 * NOTICE: All information contained herein is, and remains
 * the property of Hyphenate Inc.
 * Dissemination of this information or reproduction of this material
 * is strictly forbidden unless prior written permission is obtained
 * from Hyphenate Inc.
 */

#import "ChatViewController.h"
#import "IMMessageInfo.h"
#import "GameBiLiInfo.h"
#import "TouZhuViewController.h"
#import "FllowTouZhuViewController.h"
#import "GameRecordListViewController.h"

//#import "ChatGroupDetailViewController.h"
//#import "ChatroomDetailViewController.h"
//#import "UserProfileViewController.h"
//#import "UserProfileManager.h"
//#import "ContactListSelectViewController.h"
//#import "ChatDemoHelper.h"

@interface ChatViewController ()<UIAlertViewDelegate, EaseMessageViewControllerDelegate, EaseMessageViewControllerDataSource,EMClientDelegate,TouZhuViewControllerDelegate,FllowTouZhuViewControllerDelegate>
{
    UIMenuItem *_copyMenuItem;
    UIMenuItem *_deleteMenuItem;
    UIMenuItem *_transpondMenuItem;
    MBProgressHUD *HUD;
    GameCurrentStatueInfo *gameCurrentInfo;
    GameBiLiInfo *gameBiLiInfo;
    NSTimer *timer;
    NSInteger remainTime;
    BOOL isOpemTimer;
    BOOL isClickBack;
}


@property (nonatomic) BOOL isPlayingAudio;

@property (nonatomic) NSMutableDictionary *emotionDic;

@end

@implementation ChatViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.showRefreshHeader = YES;
    self.delegate = self;
    self.dataSource = self;
    
    [[IQKeyboardManager sharedManager] disableToolbarInViewControllerClass:[ChatViewController class]];
    
    
    [[EaseBaseMessageCell appearance] setSendBubbleBackgroundImage:[[UIImage imageNamed:@"chat_sender_bg"] stretchableImageWithLeftCapWidth:5 topCapHeight:35]];
    [[EaseBaseMessageCell appearance] setRecvBubbleBackgroundImage:[[UIImage imageNamed:@"chat_receiver_bg"] stretchableImageWithLeftCapWidth:35 topCapHeight:35]];
    
    NSArray *array = [[NSArray alloc]initWithObjects:[UIImage imageNamed:@"chat_sender_audio_playing_full"], [UIImage imageNamed:@"chat_sender_audio_playing_000"], [UIImage imageNamed:@"chat_sender_audio_playing_001"], [UIImage imageNamed:@"chat_sender_audio_playing_002"], [UIImage imageNamed:@"chat_sender_audio_playing_003"], nil];
    [[EaseBaseMessageCell appearance] setSendMessageVoiceAnimationImages:array];
    NSArray * array1 = [[NSArray alloc] initWithObjects:[UIImage imageNamed:@"chat_receiver_audio_playing_full"],[UIImage imageNamed:@"chat_receiver_audio_playing000"], [UIImage imageNamed:@"chat_receiver_audio_playing001"], [UIImage imageNamed:@"chat_receiver_audio_playing002"], [UIImage imageNamed:@"chat_receiver_audio_playing003"],nil];
    [[EaseBaseMessageCell appearance] setRecvMessageVoiceAnimationImages:array1];
    
    [[EaseBaseMessageCell appearance] setAvatarSize:40.f];
    [[EaseBaseMessageCell appearance] setAvatarCornerRadius:20.f];
    
    [[EaseChatBarMoreView appearance] setMoreViewBackgroundColor:[UIColor colorWithRed:240 / 255.0 green:242 / 255.0 blue:247 / 255.0 alpha:1.0]];
    
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(deleteAllMessages:) name:KNOTIFICATIONNAME_DELETEALLMESSAGE object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(exitGroup) name:@"ExitGroup" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(insertCallMessage:) name:@"insertCallMessage" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handleCallNotification:) name:@"callOutWithChatter" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handleCallNotification:) name:@"callControllerClose" object:nil];
    
    //通过会话管理者获取已收发消息
    [self tableViewDidTriggerHeaderRefresh];
    
    //通知服务器已进入房间
    [self performSelector:@selector(putNotifSeverHasJoinRoom) withObject:nil afterDelay:1];
    
    HUD = [[MBProgressHUD alloc] initWithView:self.view];
    [self.view addSubview:HUD];
    //获取游戏当前信息
    [self getCurrentGameInfoWithIsShow:YES];
    
    //监听进入前后台消息
    [self addObserver];
    
    //设置导航拦
    [self _setupBarButtonItem];
    
    //指导页显示
    if ([ShareManager shareInstance].isShowTouZhuYDY) {
        [self addGuideView];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc
{
    if (self.conversation.type == EMConversationTypeChatRoom)
    {
        //退出聊天室，删除会话
        NSString *chatter = [self.conversation.conversationId copy];
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            EMError *error = nil;
            [[EMClient sharedClient].roomManager leaveChatroom:chatter error:&error];
            if (error !=nil) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Error" message:[NSString stringWithFormat:@"Leave chatroom '%@' failed [%@]", chatter, error.errorDescription] delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
                    [alertView show];
                });
            }
        });
    }
    
    
    [[EMClient sharedClient] removeDelegate:self];
    
    if (timer) {
        //关闭定时器
        [timer invalidate];
        timer = nil;
    }
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)refreshTable
{
    [self.tableView reloadData];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    if (self.conversation.type == EMConversationTypeGroupChat) {
        if ([[self.conversation.ext objectForKey:@"subject"] length])
        {
            self.title = [self.conversation.ext objectForKey:@"subject"];
        }
    }
    
    
    NSDictionary *dict1 = @{@"imageName" : @"icon_xzjl",
                            @"itemName" : @"投注记录"
                            };
    NSDictionary *dict2 = @{@"imageName" : @"icon_wfjs",
                            @"itemName" : @"玩法介绍"
                            };
    NSDictionary *dict3 = @{@"imageName" : @"icon_zst",
                            @"itemName" : @"走势图"
                            };
    NSArray *dataArray = @[dict1,dict2,dict3];
    __weak __typeof(&*self)weakSelf = self;
    /**
     *  创建普通的MenuView，frame可以传递空值，宽度默认120，高度自适应
     */
    [CommonMenuView createMenuWithFrame:CGRectZero target:self dataArray:dataArray itemsClickBlock:^(NSString *str, NSInteger tag) {
        [weakSelf doSomething:(NSString *)str tag:(NSInteger)tag]; // do something
    } backViewTap:^{
    }];

}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    //    [IMUserInfoHelper shareInstance].conversationChatVC = nil;
    [CommonMenuView clearMenu];   // 移除菜单
}

//监听通知

-(void)addObserver
{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handleAppDidBackGround) name:UIApplicationDidEnterBackgroundNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handleAppDidEnterForeground) name:UIApplicationWillEnterForegroundNotification object:nil];
    
    [[NSNotificationCenter defaultCenter]addObserver:self
                                            selector:@selector(quitLoginDiss)
                                                name:kUpdateUserInfo
                                              object:nil];
    
}

//程序进入后台

-(void)handleAppDidBackGround
{
    if (timer) {
        //关闭定时器
        [timer setFireDate:[NSDate distantFuture]];
        isOpemTimer = NO;
        
    }
}

//程序进入前台
-(void)handleAppDidEnterForeground
{
    [self getCurrentGameInfoWithIsShow:YES];
}

- (void)quitLoginDiss
{
    [[EMClient sharedClient].chatManager removeDelegate:self];
    [[EMClient sharedClient].roomManager removeDelegate:self];
    
    if (timer) {
        //关闭定时器
        [timer invalidate];
        timer = nil;
    }
    
    HttpHelper *helper = [[HttpHelper alloc] init];
    __weak EaseMessageViewController *weakSelf = self;
    [helper leaveGameRoomWithRoomId:weakSelf.roomIDStr
                            user_id:[ShareManager shareInstance].userinfo.id
                            success:^(NSDictionary *resultDic) {
                            } fail:^(NSString *description) {
                                
                            }];
    isClickBack = YES;
    
    [CommonMenuView clearMenu];
}

#pragma mark - 新手指导页
- (void)addGuideView {
    NSString *imageName = nil;
    if(FullScreen.size.height <= 480)
    {
        imageName = @"ydy_4";
    }
    else if(FullScreen.size.height == 568)
    {
        imageName = @"ydy_5s";
    }else if(FullScreen.size.height == 667)
    {
        imageName = @"ydy_6s";
    }else{
        imageName = @"ydy_7p";
    }
    
    UIImage *image = [UIImage imageNamed:imageName];
    UIImageView *imageView = [[UIImageView alloc] initWithImage:image];
    imageView.frame = [UIApplication sharedApplication].keyWindow.frame;
    imageView.userInteractionEnabled = YES;
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dismissGuideView:)];
    [imageView addGestureRecognizer:tap];
    
    [[UIApplication sharedApplication].keyWindow addSubview:imageView];
}

- (void)dismissGuideView:(UITapGestureRecognizer*)tap
{
    [ShareManager shareInstance].isShowTouZhuYDY = NO;
    UIImageView *imageview = (UIImageView *)tap.self.view;
    [imageview removeFromSuperview];
}


#pragma mark - 自定义逻辑部分

#pragma mark -http

- (void)putNotifSeverHasJoinRoom
{
    HttpHelper *helper = [[HttpHelper alloc] init];
    [helper putNotifSeverJoinRoomWithRoomId:self.roomIDStr
                                    user_id:[ShareManager shareInstance].userinfo.id
                                    success:^(NSDictionary *resultDic){
                                        
                                    }fail:^(NSString *decretion){
                                        
                                    }];
}

- (void)getGameInfo
{
    if(gameCurrentInfo)
    {
        [self getCurrentGameInfoWithIsShow:NO];
    }else{
        [self getCurrentGameInfoWithIsShow:YES];
    }
}

- (void)getCurrentGameInfoWithIsShow:(BOOL)isShow
{
    //防止退出后 重新开启定时器
    if (isClickBack) {
        return;
    }
    if (isShow) {
        [HUD show:YES];
    }
    
    HttpHelper *helper = [[HttpHelper alloc] init];
    __weak ChatViewController *weakSelf = self;
    //每次开奖后会调用这个
    [helper getDJSAndHistoryWithGameType:self.gameType
                                 user_id:[ShareManager shareInstance].userinfo.id
                                 room_id:self.roomIDStr
                                 success:^(NSDictionary *resultDic){
                                     
                                     if (isShow) {
                                         [HUD hide:YES];
                                     }
                                     if ([[resultDic objectForKey:@"result_code"] integerValue] == 0 && resultDic) {
                                         [weakSelf handleloadGetCurrentInfoResult:resultDic];
                                     }else
                                     {
                                         if(gameCurrentInfo)
                                         {
                                             [weakSelf performSelector:@selector(getGameInfo) withObject:nil afterDelay:2];
                                         }else{
                                             [weakSelf performSelector:@selector(getGameInfo) withObject:nil afterDelay:1];
                                         }
                                     }
                                 }fail:^(NSString *decretion){
                                     if (isShow) {
                                         [HUD hide:YES];
                                     }
                                     if(gameCurrentInfo)
                                     {
                                         [weakSelf performSelector:@selector(getGameInfo) withObject:nil afterDelay:2];
                                     }else{
                                         [weakSelf performSelector:@selector(getGameInfo) withObject:nil afterDelay:1];
                                     }
                                 }];
    
    //更新用户金额信息
    [HttpMangerHelper  getUserSelfInfoSuccess:^(UserInfo * info) {
        [ShareManager shareInstance].userinfo.point = info.point;
    } fail:^(NSString *description) {
        
    }];
}

- (void)handleloadGetCurrentInfoResult:(NSDictionary *)resultDic
{
    if(!resultDic)
    {
        [Tool showPromptContent:@"请求失败" onView:self.view];
        return;
    }
    
    NSDictionary *dic = [resultDic objectForKey:@"data"];
    
    gameCurrentInfo = [dic objectByClass:[GameCurrentStatueInfo class]];
    if(gameCurrentInfo.seconds == 0 && gameCurrentInfo && [gameCurrentInfo.status intValue] !=3)
    {
        if (!isClickBack) {//防止退出后 无限刷新接口
            [self performSelector:@selector(getGameInfo) withObject:nil afterDelay:2];
        }
    }
    
    [self updateHeadViewUI];
    
    NSMutableArray *resourceArray = gameCurrentInfo.open_time;
    NSMutableArray *resultArray = [NSMutableArray array];
    if (resourceArray && resourceArray.count > 0)
    {
        for (NSDictionary *dic in resourceArray)
        {
            GameHistoryListInfo *info = [dic objectByClass:[GameHistoryListInfo class]];
            [resultArray addObject:info];
        }
        gameCurrentInfo.open_time = resultArray;
    }
    
}

- (void)httpGetGameBiLiInfoWithIsShow:(BOOL)isShow
{
    [HUD show:YES];
    HttpHelper *helper = [[HttpHelper alloc] init];
    __weak ChatViewController *weakSelf = self;
    [helper getGameBiliWithGameType:self.gameType
                            area_id:self.areaIDStr
                            success:^(NSDictionary *resultDic){
                                [HUD hide:YES];
                                if ([[resultDic objectForKey:@"result_code"] integerValue] == 0 && resultDic) {
                                    [weakSelf handleloadGetBiLiResult:resultDic isShow:isShow];
                                }else
                                {
                                    UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"获取投注信息失败" message:[NSString stringWithFormat:@"重新获取？[%@]",[resultDic objectForKey:@"result_desc"]]  delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
                                    alert.tag = 22022;
                                    [alert show];
                                }
                            }fail:^(NSString *decretion){
                                [HUD hide:YES];
                                UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"获取投注信息失败" message:@"点击重新获取？？"  delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
                                alert.tag = 22022;
                                [alert show];
                            }];
    
}

- (void)handleloadGetBiLiResult:(NSDictionary *)resultDic isShow:(BOOL)isShow
{
    if(!resultDic)
    {
        [Tool showPromptContent:@"请求失败" onView:self.view];
        return;
    }
    
    NSDictionary *dic = [resultDic objectForKey:@"data"];
    
    gameBiLiInfo = [dic objectByClass:[GameBiLiInfo class]];
    
    NSMutableArray *resourceArray = gameBiLiInfo.da_xiao;
    NSMutableArray *resultArray = [NSMutableArray array];
    if (resourceArray && resourceArray.count > 0)
    {
        for (NSDictionary *dic in resourceArray)
        {
            GameBiLiListInfo *info = [dic objectByClass:[GameBiLiListInfo class]];
            [resultArray addObject:info];
        }
        gameBiLiInfo.da_xiao = resultArray;
    }
    
    resourceArray = gameBiLiInfo.shu_zi;
    resultArray = [NSMutableArray array];
    if (resourceArray && resourceArray.count > 0)
    {
        for (NSDictionary *dic in resourceArray)
        {
            GameBiLiListInfo *info = [dic objectByClass:[GameBiLiListInfo class]];
            [resultArray addObject:info];
        }
        gameBiLiInfo.shu_zi = resultArray;
    }
    
    resourceArray = gameBiLiInfo.te_shu;
    resultArray = [NSMutableArray array];
    if (resourceArray && resourceArray.count > 0)
    {
        for (NSDictionary *dic in resourceArray)
        {
            GameBiLiListInfo *info = [dic objectByClass:[GameBiLiListInfo class]];
            [resultArray addObject:info];
        }
        gameBiLiInfo.te_shu = resultArray;
    }
    if (isShow) {
        [self showTouZhuBiLiInfoViewControl];
    }
}

- (void)showTouZhuBiLiInfoViewControl
{
    TouZhuViewController *vc = [[TouZhuViewController alloc]initWithNibName:@"TouZhuViewController" bundle:nil];
    vc.delegate = self;
    self.definesPresentationContext = YES; //self is presenting view controller
    vc.roomIDStr = self.roomIDStr;
    vc.gameBiLiInfo = gameBiLiInfo;
    vc.choiceNo = gameCurrentInfo.game_num;
    vc.areaIDStr = self.areaIDStr;
    vc.per_max_point = gameCurrentInfo.per_max_point;
    vc.view.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.3];
    if ([[UIDevice currentDevice].systemVersion floatValue] < 8.0)
    {
        self.view.window.rootViewController.modalPresentationStyle = UIModalPresentationCurrentContext;//半透明全靠这句了
    }
    vc.modalPresentationStyle = UIModalPresentationOverCurrentContext;
    UIViewController * rootViewController = [UIApplication sharedApplication].keyWindow.rootViewController;
    [rootViewController presentViewController:vc animated:YES completion:nil];
    
}
#pragma mark - UIAlertViewDelegate

- (void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex
{
    if (alertView.tag== 22022)
    {
        if (buttonIndex == 1) {
            [self httpGetGameBiLiInfoWithIsShow:YES];
        }
    }
}

#pragma mark - 头部信息控制模块
- (void)updateHeadViewUI
{
    //1正常 2封盘 3停售
    if ([gameCurrentInfo.status intValue] == 1 || [gameCurrentInfo.status intValue] == 2) {
        
        if ([gameCurrentInfo.status intValue] == 2){
            self.headView.timeLabel.text = @"封盘中";
        }
        remainTime = gameCurrentInfo.seconds;
        
        [self handleTimer];
        
    }else{
        self.headView.timeLabel.text = @"已停售";
    }
    
    self.headView.moneyLabel.text = [NSString stringWithFormat:@"%.2f元宝",gameCurrentInfo.point];
    
    NSString * showStr = [NSString stringWithFormat:@"距离 <color1>%@</color1> 期截止",gameCurrentInfo.game_num];
    
    NSDictionary* style = @{@"color1":RGB(58, 132, 255)};
    
    self.headView.numLabel.attributedText = [showStr attributedStringWithStyleBook:style];
    
    if (gameCurrentInfo.first_result.id.length > 0 && ![gameCurrentInfo.first_result.id isEqualToString:@"<null>"]) {
        showStr = [NSString stringWithFormat:@"第 <color1>%@</color1> 期",gameCurrentInfo.first_result.game_num];
        NSDictionary* style1 = @{@"color1":HuangSColor};
        self.headView.qsLabel.attributedText = [showStr attributedStringWithStyleBook:style1];
        
        self.headView.typeLabel.text =[NSString stringWithFormat:@"（%@）",gameCurrentInfo.first_result.result_type];
        
        NSArray * array = [gameCurrentInfo.first_result.game_result_desc componentsSeparatedByString:@"+"];
        if (array.count >= 3) {
            
            self.headView.oneLabel.text = [array objectAtIndex:0];
            self.headView.twoLabel.text = [array objectAtIndex:1];
            NSArray * array1 = [[array objectAtIndex:2] componentsSeparatedByString:@"="];
            
            if (array1.count >= 2) {
                self.headView.threeLabel.text = [array1 objectAtIndex:0];
                self.headView.fourLabel.text = [array1 objectAtIndex:1];
                //color  1红 2绿 3蓝 4无
                if ([gameCurrentInfo.first_result.color intValue] == 1) {
                    self.headView.fourLabel.backgroundColor = HongSColor;
                }else if ([gameCurrentInfo.first_result.color intValue] == 2) {
                    self.headView.fourLabel.backgroundColor = LvSColor;
                }else if ([gameCurrentInfo.first_result.color intValue] == 3) {
                    self.headView.fourLabel.backgroundColor = LanSColor;
                }else{
                    self.headView.fourLabel.backgroundColor = HuiSColor;
                }
            }
            
            return ;
        }
        
        
    }
    
    showStr = @"第 <color1>--</color1> 期";
    self.headView.oneLabel.text = @"?";
    
    self.headView.twoLabel.text = @"?";
    
    self.headView.threeLabel.text = @"?";
    
    self.headView.fourLabel.text = @"?";
    self.headView.fourLabel.backgroundColor = HuiSColor;
    self.headView.typeLabel.text = @"";
    
    self.headView.qsLabel.attributedText = [showStr attributedStringWithStyleBook:style];
    
}

- (void)clickHistoryAction:(id)sender
{
    [super clickHistoryAction:sender];
    self.historyView.dataSourceArray = gameCurrentInfo.open_time;
    [self.historyView updateTableViewCellList];
}

- (void)clickCheckMoneyAction:(id)sender
{
    [super clickCheckMoneyAction:sender];
    self.headView.moneyLabel.text = @"获取中...";
    __weak ChatViewController *weakSelf = self;
    [HttpMangerHelper  getUserSelfInfoSuccess:^(UserInfo * info) {
        weakSelf.headView.moneyLabel.text = [NSString stringWithFormat:@"%.2f元宝",info.point];
    } fail:^(NSString *description) {
        weakSelf.headView.moneyLabel.text = @"获取失败,请重试";
    }];
}

#pragma mark - 计时器

- (void)handleTimer
{
    if(isClickBack)
    {
        if (timer) {
            //关闭定时器
            [timer invalidate];
            timer = nil;
        }
        return;
    }
    if (!timer && remainTime > 0)
    {
        timer = [NSTimer scheduledTimerWithTimeInterval:1.0
                                                 target:self
                                               selector:@selector(handleTimer)
                                               userInfo:nil
                                                repeats:YES];
        [[NSRunLoop currentRunLoop] addTimer:timer forMode:UITrackingRunLoopMode];
        isOpemTimer = YES;
    }else{
        
        if (remainTime > 0 ) {
            if(!isOpemTimer)
            {
                isOpemTimer = YES;
                //开启定时器
                [timer setFireDate:[NSDate distantPast]];
                
            }
            remainTime = remainTime-1;
            //1正常 2封盘 3停售
            if ([gameCurrentInfo.status intValue] == 1)
            {
                [self updateHeadViewTimeWithTime:remainTime];
            }
        }else{
            
            if (timer) {
                if(isOpemTimer)
                {
                    //关闭定时器
                    [timer setFireDate:[NSDate distantFuture]];
                    self.headView.timeLabel.text = @"封盘中";
                    gameCurrentInfo.status = @"2";
                    isOpemTimer = NO;
                    [self getCurrentGameInfoWithIsShow:NO];
                }
            }
        }
    }
    
}

- (void)updateHeadViewTimeWithTime:(NSInteger)time
{
    
    NSUInteger min  = time/60;//分
    NSUInteger second = time%60;//秒
    if (second>9)
    {
        if ([gameCurrentInfo.status intValue] == 1)
        {
            self.headView.timeLabel.text = [NSString stringWithFormat:@"%lu分 %lu秒",(unsigned long)min,(unsigned long)second];
        }else{
            self.headView.timeLabel.text = [NSString stringWithFormat:@"封:%lu分 %lu秒",(unsigned long)min,(unsigned long)second];
        }
        
    }
    else{
        if ([gameCurrentInfo.status intValue] == 1)
        {
            self.headView.timeLabel.text = [NSString stringWithFormat:@"%lu分 0%lu秒",(unsigned long)min,(unsigned long)second];
        }else{
            self.headView.timeLabel.text = [NSString stringWithFormat:@"封:%lu分 0%lu秒",(unsigned long)min,(unsigned long)second];
        }
        
        
    }
    
}

#pragma mark - setup subviews

- (void)_setupBarButtonItem
{
    UIControl *leftItemControl = [[UIControl alloc] initWithFrame:CGRectMake(0, 0, 20, 44)];
    [leftItemControl addTarget:self action:@selector(backAction) forControlEvents:UIControlEventTouchUpInside];
    
    UIImageView *back = [[UIImageView alloc] initWithFrame:CGRectMake(0, 13, 18, 18)];
    back.image = [UIImage imageNamed:@"shouye_85.png"];
    [leftItemControl addSubview:back];
    
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:leftItemControl];
    
    
    UIView *rightItemView = [[UIView alloc] initWithFrame:CGRectMake(0, 2, 80, 40)];
    rightItemView.backgroundColor = [UIColor clearColor];
    
    UIButton *btnKFItem = [[UIButton alloc] initWithFrame:CGRectMake(0, 2, 40, rightItemView.frame.size.height)];
    [btnKFItem setImage:PublicImage(@"shouye_81") forState:UIControlStateNormal];
    [btnKFItem setImageEdgeInsets:UIEdgeInsetsMake(9, 14, 11, 5)];
    [btnKFItem addTarget:self action:@selector(clickKFButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    [rightItemView addSubview:btnKFItem];
    
    UIButton * btnMoreItem = [[UIButton alloc] initWithFrame:CGRectMake(40, 2, 40, rightItemView.frame.size.height)];
    
    [btnMoreItem setImage:PublicImage(@"shouye_83") forState:UIControlStateNormal];
    [btnMoreItem setImageEdgeInsets:UIEdgeInsetsMake(10, 7, 10, 13)];
    [btnMoreItem addTarget:self action:@selector(clickMoreButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    [rightItemView addSubview:btnMoreItem];
    
    UIBarButtonItem *rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:rightItemView];
    
    UIBarButtonItem *negativeSpacer = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace
                                                                                    target:nil
                                                                                    action:nil];
    negativeSpacer.width = -15;
    self.navigationItem.rightBarButtonItems = @[negativeSpacer, rightBarButtonItem];
    
    
}



#pragma mark - EaseMessageViewControllerDelegate

- (BOOL)messageViewController:(EaseMessageViewController *)viewController
   canLongPressRowAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;
}

- (BOOL)messageViewController:(EaseMessageViewController *)viewController
   didLongPressRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    id object = [self.dataArray objectAtIndex:indexPath.row];
    if (![object isKindOfClass:[NSString class]]) {
        
        
        id<IMessageModel> model = object;
        NSDictionary* resultDic = [Tool dictionaryWithJsonString:model.text];
        IMMessageInfo *info = [resultDic objectByClass:[IMMessageInfo class]];
        if (info) {
            //下注信息
            if ([info.notice_type intValue] ==2) {
                [self.chatToolbar endEditing:YES];
                if (![info.im_account isEqualToString:[ShareManager shareInstance].userinfo.im_account]) {
                    
                    //1正常 2封盘 3停售
                    if ([gameCurrentInfo.status integerValue] == 1) {
                        if ([gameCurrentInfo.game_num isEqualToString:info.game_count]) {
                            FllowTouZhuViewController *vc = [[FllowTouZhuViewController alloc]initWithNibName:@"FllowTouZhuViewController" bundle:nil];
                            vc.touzhuInfo = info;
                            vc.delegate = self;
                            vc.roomIDStr = self.roomIDStr;
                            vc.areaIDStr = self.areaIDStr;
                            self.definesPresentationContext = YES; //self is presenting view controller
                            vc.view.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.5];
                            if ([[UIDevice currentDevice].systemVersion floatValue] < 8.0)
                            {
                                self.view.window.rootViewController.modalPresentationStyle = UIModalPresentationCurrentContext;//半透明全靠这句了
                            }
                            vc.modalPresentationStyle = UIModalPresentationOverCurrentContext;
                            UIViewController * rootViewController = [UIApplication sharedApplication].keyWindow.rootViewController;
                            [rootViewController presentViewController:vc animated:YES completion:nil];
                        }else{
                            UIAlertView *alert = [[UIAlertView alloc]initWithTitle:nil message:@"只能跟投当前期" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
                            [alert show];
                        }
                        
                    }else if ([gameCurrentInfo.status intValue] == 2)
                    {
                        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:nil message:@"已封盘，停止下注" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
                        [alert show];
                    }else  if ([gameCurrentInfo.status intValue] == 3){
                        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:nil message:@"停售期间暂不支持投注" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
                        [alert show];
                    }
                    
                }
                
                
                //                [Tool showPromptContent:@"敬请期待" onView:self.view];
            }
        }
        
        //        EaseMessageCell *cell = (EaseMessageCell *)[self.tableView cellForRowAtIndexPath:indexPath];
        //        [cell becomeFirstResponder];
        //        self.menuIndexPath = indexPath;
        //        [self _showMenuViewController:cell.bubbleView andIndexPath:indexPath messageType:cell.model.bodyType];
    }
    return NO;
}

- (void)messageViewController:(EaseMessageViewController *)viewController
  didSelectAvatarMessageModel:(id<IMessageModel>)messageModel
{
    //    UserProfileViewController *userprofile = [[UserProfileViewController alloc] initWithUsername:messageModel.message.from];
    //    [self.navigationController pushViewController:userprofile animated:YES];
}

#pragma mark - EaseMessageViewControllerDataSource

- (id<IMessageModel>)messageViewController:(EaseMessageViewController *)viewController
                           modelForMessage:(EMMessage *)message
{
    id<IMessageModel> model = nil;
    model = [[EaseMessageModel alloc] initWithMessage:message];
    model.avatarImage = [UIImage imageNamed:@"EaseUIResource.bundle/user"];
    model.failImageName = @"imageDownloadFail";
    
    NSDictionary* resultDic = [Tool dictionaryWithJsonString:model.text];
    IMMessageInfo *info = [resultDic objectByClass:[IMMessageInfo class]];
    if (info) {
        
        if ([info.notice_type intValue] ==3 || [info.notice_type intValue] ==4 || [info.notice_type intValue] ==5)
        {
            if(gameCurrentInfo)
            {
                dispatch_async(dispatch_get_main_queue(), ^{
                    [self getGameInfo];
                    //                   [self performSelector:@selector(getGameInfo) withObject:nil afterDelay:2];
                });
            }
        }
    }
    return model;
}

- (NSArray*)emotionFormessageViewController:(EaseMessageViewController *)viewController
{
    NSMutableArray *emotions = [NSMutableArray array];
    for (NSString *name in [EaseEmoji allEmoji]) {
        EaseEmotion *emotion = [[EaseEmotion alloc] initWithName:@"" emotionId:name emotionThumbnail:name emotionOriginal:name emotionOriginalURL:@"" emotionType:EMEmotionDefault];
        [emotions addObject:emotion];
    }
    EaseEmotion *temp = [emotions objectAtIndex:0];
    EaseEmotionManager *managerDefault = [[EaseEmotionManager alloc] initWithType:EMEmotionDefault emotionRow:3 emotionCol:7 emotions:emotions tagImage:[UIImage imageNamed:temp.emotionId]];
    
    NSMutableArray *emotionGifs = [NSMutableArray array];
    _emotionDic = [NSMutableDictionary dictionary];
    NSArray *names = @[@"icon_002",@"icon_007",@"icon_010",@"icon_012",@"icon_013",@"icon_018",@"icon_019",@"icon_020",@"icon_021",@"icon_022",@"icon_024",@"icon_027",@"icon_029",@"icon_030",@"icon_035",@"icon_040"];
    int index = 0;
    for (NSString *name in names) {
        index++;
        EaseEmotion *emotion = [[EaseEmotion alloc] initWithName:[NSString stringWithFormat:@"[示例%d]",index] emotionId:[NSString stringWithFormat:@"em%d",(1000 + index)] emotionThumbnail:[NSString stringWithFormat:@"%@_cover",name] emotionOriginal:[NSString stringWithFormat:@"%@",name] emotionOriginalURL:@"" emotionType:EMEmotionGif];
        [emotionGifs addObject:emotion];
        [_emotionDic setObject:emotion forKey:[NSString stringWithFormat:@"em%d",(1000 + index)]];
    }
    EaseEmotionManager *managerGif= [[EaseEmotionManager alloc] initWithType:EMEmotionGif emotionRow:2 emotionCol:4 emotions:emotionGifs tagImage:[UIImage imageNamed:@"icon_002_cover"]];
    
    return @[managerDefault,managerGif];
}

- (BOOL)isEmotionMessageFormessageViewController:(EaseMessageViewController *)viewController
                                    messageModel:(id<IMessageModel>)messageModel
{
    BOOL flag = NO;
    if ([messageModel.message.ext objectForKey:MESSAGE_ATTR_IS_BIG_EXPRESSION]) {
        return YES;
    }
    return flag;
}

- (EaseEmotion*)emotionURLFormessageViewController:(EaseMessageViewController *)viewController
                                      messageModel:(id<IMessageModel>)messageModel
{
    NSString *emotionId = [messageModel.message.ext objectForKey:MESSAGE_ATTR_EXPRESSION_ID];
    EaseEmotion *emotion = [_emotionDic objectForKey:emotionId];
    if (emotion == nil) {
        emotion = [[EaseEmotion alloc] initWithName:@"" emotionId:emotionId emotionThumbnail:@"" emotionOriginal:@"" emotionOriginalURL:@"" emotionType:EMEmotionGif];
    }
    return emotion;
}

- (NSDictionary*)emotionExtFormessageViewController:(EaseMessageViewController *)viewController
                                        easeEmotion:(EaseEmotion*)easeEmotion
{
    return @{MESSAGE_ATTR_EXPRESSION_ID:easeEmotion.emotionId,MESSAGE_ATTR_IS_BIG_EXPRESSION:@(YES)};
}

#pragma mark - EaseMob

#pragma mark - EMClientDelegate

- (void)didLoginFromOtherDevice
{
    if ([self.imagePicker.mediaTypes count] > 0 && [[self.imagePicker.mediaTypes objectAtIndex:0] isEqualToString:(NSString *)kUTTypeMovie]) {
        [self.imagePicker stopVideoCapture];
    }
}

- (void)didRemovedFromServer
{
    if ([self.imagePicker.mediaTypes count] > 0 && [[self.imagePicker.mediaTypes objectAtIndex:0] isEqualToString:(NSString *)kUTTypeMovie]) {
        [self.imagePicker stopVideoCapture];
    }
}

#pragma mark - action

- (void)backAction
{
    [self quitLoginDiss];
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)clickKFButtonAction:(id)sender
{
    KeFuViewController *vc =[[KeFuViewController alloc]initWithNibName:@"KeFuViewController" bundle:nil];
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)clickMoreButtonAction:(id)sender
{
    
    [CommonMenuView showMenuAtPoint:CGPointMake(self.navigationController.view.width - 25, 50)];
}

- (void)transpondMenuAction:(id)sender
{
    
}

- (void)copyMenuAction:(id)sender
{
    
}

- (void)deleteMenuAction:(id)sender
{
    
}

- (void)didTouZhuButtonAction:(UIButton *)btn
{
    [super didTouZhuButtonAction:btn];
    
    //1正常 2封盘 3停售
    if ([gameCurrentInfo.status intValue] == 1)
    {
        if (gameBiLiInfo) {
            [self showTouZhuBiLiInfoViewControl];
        }else{
            [self httpGetGameBiLiInfoWithIsShow:YES];
        }
        
    }else if ([gameCurrentInfo.status intValue] == 2)
    {
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:nil message:@"已封盘，停止下注" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alert show];
    }else if ([gameCurrentInfo.status intValue] == 3){
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:nil message:@"停售期间暂不支持投注" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alert show];
    }
    
    
}
#pragma mark -- TouZhuViewControllerDelegate <NSObject>

- (NSDictionary *)getChoiceNoWithstatue
{
    
    if (gameCurrentInfo) {
        
        NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:gameCurrentInfo.game_num,@"chiceNo",gameCurrentInfo.status,@"statue", nil];
        return dic;
    }
    return nil;
    
}

- (void)touzhuSuccesss
{
    __weak ChatViewController *weakSelf = self;
    [HttpMangerHelper  getUserSelfInfoSuccess:^(UserInfo * info) {
        weakSelf.headView.moneyLabel.text = [NSString stringWithFormat:@"%.2f元宝",info.point];
    } fail:^(NSString *description) {
        
    }];
}

#pragma mark -- FllowTouZhuViewControllerDelegate

- (void)fllowTouZhuSuccesss
{
    __weak ChatViewController *weakSelf = self;
    [HttpMangerHelper  getUserSelfInfoSuccess:^(UserInfo * info) {
        weakSelf.headView.moneyLabel.text = [NSString stringWithFormat:@"%.2f元宝",info.point];
    } fail:^(NSString *description) {
        
    }];
}


#pragma mark -- CommonMenuView 回调事件(自定义)
- (void)doSomething:(NSString *)str tag:(NSInteger)tag{
    
    switch (tag){
        case 1:
        {
            GameRecordListViewController *vc = [[GameRecordListViewController alloc]initWithNibName:@"GameRecordListViewController" bundle:nil];
            vc.roomIdStr = self.roomIDStr;
            vc.gameType = self.gameType;
            [self.navigationController pushViewController:vc animated:YES];
        }
            break;
        case 2:
        {
            SafariViewController *vc = [[SafariViewController alloc]initWithNibName:@"SafariViewController" bundle:nil];
            vc.title = @"玩法介绍";
            if ([self.gameType integerValue] == 1) {
                vc.urlStr = [NSString stringWithFormat:@"%@%@",URL_Server,Wap_BJWFSM];
            }else{
                vc.urlStr = [NSString stringWithFormat:@"%@%@",URL_Server,Wap_JNDWFSM];
            }
            
            [self.navigationController pushViewController:vc animated:YES];
            
            
        }
            break;
        case 3:
        {
            SafariViewController *vc = [[SafariViewController alloc]initWithNibName:@"SafariViewController" bundle:nil];
            vc.title = @"走势图";
            vc.urlStr = [NSString stringWithFormat:@"%@%@%@",URL_Server,Wap_ZouShiTu,self.gameType];
            [self.navigationController pushViewController:vc animated:YES];
        }
            break;
        default:
            break;
    }
    [CommonMenuView hidden];
    
}

#pragma mark - notification
- (void)exitGroup
{
    [self.navigationController popToViewController:self animated:NO];
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)insertCallMessage:(NSNotification *)notification
{
    id object = notification.object;
    if (object) {
        EMMessage *message = (EMMessage *)object;
        [self addMessageToDataSource:message progress:nil];
        [[EMClient sharedClient].chatManager importMessages:@[message]];
    }
}

- (void)handleCallNotification:(NSNotification *)notification
{
    id object = notification.object;
    if ([object isKindOfClass:[NSDictionary class]]) {
        //开始call
        self.isViewDidAppear = NO;
    } else {
        //结束call
        self.isViewDidAppear = YES;
    }
}

#pragma mark - private

- (void)_showMenuViewController:(UIView *)showInView
                   andIndexPath:(NSIndexPath *)indexPath
                    messageType:(EMMessageBodyType)messageType
{
    if (self.menuController == nil) {
        self.menuController = [UIMenuController sharedMenuController];
    }
    
    if (_deleteMenuItem == nil) {
        _deleteMenuItem = [[UIMenuItem alloc] initWithTitle:NSLocalizedString(@"delete", @"Delete") action:@selector(deleteMenuAction:)];
    }
    
    if (_copyMenuItem == nil) {
        _copyMenuItem = [[UIMenuItem alloc] initWithTitle:NSLocalizedString(@"copy", @"Copy") action:@selector(copyMenuAction:)];
    }
    
    if (_transpondMenuItem == nil) {
        _transpondMenuItem = [[UIMenuItem alloc] initWithTitle:NSLocalizedString(@"transpond", @"Transpond") action:@selector(transpondMenuAction:)];
    }
    
    if (messageType == EMMessageBodyTypeText) {
        [self.menuController setMenuItems:@[_copyMenuItem, _deleteMenuItem]];
    } else if (messageType == EMMessageBodyTypeImage){
        [self.menuController setMenuItems:@[_deleteMenuItem]];
    } else {
        [self.menuController setMenuItems:@[_deleteMenuItem]];
    }
    [self.menuController setTargetRect:showInView.frame inView:showInView.superview];
    [self.menuController setMenuVisible:YES animated:YES];
}



@end
