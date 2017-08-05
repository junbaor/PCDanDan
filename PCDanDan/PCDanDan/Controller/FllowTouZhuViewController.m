//
//  FllowTouZhuViewController.m
//  PCDanDan
//
//  Created by xcode.qi on 17/1/19.
//  Copyright © 2017年 li. All rights reserved.
//


#import "FllowTouZhuViewController.h"

@interface FllowTouZhuViewController ()
{
    MBProgressHUD *HUD;
}

@end

@implementation FllowTouZhuViewController
- (void)dealloc
{
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:KQuitLogin object:nil];
    
}
- (void)viewDidLoad {
    [super viewDidLoad];
    [self initVariable];
    
    [[NSNotificationCenter defaultCenter]addObserver:self
                                            selector:@selector(quitLoginDiss)
                                                name:KQuitLogin
                                              object:nil];
    
}

- (void)quitLoginDiss
{
    [self dismissViewControllerAnimated:NO completion:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)initVariable
{
    _bgView.layer.masksToBounds =YES;
    _bgView.layer.cornerRadius = 5;
    _sureButton.layer.masksToBounds =YES;
    _sureButton.layer.cornerRadius = 3;
    _cannelButton.layer.masksToBounds =YES;
    _cannelButton.layer.cornerRadius = 3;
    
    HUD = [[MBProgressHUD alloc] initWithView:self.view];
    HUD.labelText = @"下注中...";
    [self.view addSubview:HUD];
    
    NSDictionary* style = @{@"body":[UIFont systemFontOfSize:13],
                            @"color1":RGB(58, 132, 255)};
    NSString * nameStr = [NSString stringWithFormat:@"玩家：<color1>%@</color1>",_touzhuInfo.nick_name];
    _nameLabel.attributedText = [nameStr attributedStringWithStyleBook:style];
    
    NSString * numStr = [NSString stringWithFormat:@"期数：<color1>%@</color1>",_touzhuInfo.game_count];
    _numLabel.attributedText = [numStr attributedStringWithStyleBook:style];
    
    NSString * typeStr = [NSString stringWithFormat:@"类型：<color1>%@</color1>",_touzhuInfo.game_type];
    _typeLabel.attributedText = [typeStr attributedStringWithStyleBook:style];
    
    NSString * moneyStr = [NSString stringWithFormat:@"金额：<color1>%.0f元宝</color1>",_touzhuInfo.point];
    _moneyLabel.attributedText = [moneyStr attributedStringWithStyleBook:style];
}

#pragma mark - action

 - (IBAction)clickSureButtonAction:(id)sender
{
    [self putXiaZhuInfo];
}

 - (IBAction)clickCannelButtonAction:(id)sender
{
    [self dismissViewControllerAnimated:YES completion:nil];
}


#pragma mark -http

- (void)putXiaZhuInfo
{
    [HUD show:YES];
    HttpHelper *helper = [[HttpHelper alloc] init];
    __weak FllowTouZhuViewController *weakSelf = self;
    [helper putXiaZhuInfoWithRoomId:_roomIDStr
                            user_id:[ShareManager shareInstance].userinfo.id
                          choice_no:_touzhuInfo.game_count
                              point:[NSString stringWithFormat:@"%.0f",_touzhuInfo.point]
                            bili_id:_touzhuInfo.bili_id
                            area_id:_areaIDStr
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
    if([self.delegate respondsToSelector:@selector(fllowTouZhuSuccesss)])
    {
        [self.delegate fllowTouZhuSuccesss];
    }
    
    [Tool showPromptContent:@"下注成功" onView:self.view];
    [self performSelector:@selector(clickCannelButtonAction:) withObject:nil afterDelay:1.5];
}
@end
