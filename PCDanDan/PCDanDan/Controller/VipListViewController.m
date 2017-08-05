//
//  VipListViewController.m
//  PCDanDan
//
//  Created by xcode.qi on 17/1/17.
//  Copyright © 2017年 li. All rights reserved.
//

#import "VipListViewController.h"
#import "VipListCollectionViewCell.h"
#import "VipHouseListInfo.h"
#import "ChatViewController.h"

@interface VipListViewController ()
{
    NSMutableArray *dataSourceArray;
    MBProgressHUD *HUD;
}

@end

@implementation VipListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initVariable];
    [self leftNavigationItem];
    [self setTabelViewRefresh];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)initVariable
{
    self.title = @"房间列表";
    [_collectView registerClass:[VipListCollectionViewCell class] forCellWithReuseIdentifier:@"VipListCollectionViewCell"];
    
    dataSourceArray = [NSMutableArray array];
    
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

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self performSelector:@selector(httpGetHouseList) withObject:nil afterDelay:1];
}

- (void)clickLeftControlAction:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark -http

- (void)httpGetHouseList
{
    HttpHelper *helper = [[HttpHelper alloc] init];
    __weak VipListViewController *weakSelf = self;
    [helper getGameHouseListWithType:_gameType
                             area_id:_areaId
                                 success:^(NSDictionary *resultDic){
                                     [self hideRefresh];
                                     if ([[resultDic objectForKey:@"result_code"] integerValue] == 0) {
                                         [weakSelf handleloadResult:resultDic];
                                     }else
                                     {
                                         [Tool showPromptContent:[resultDic objectForKey:@"result_desc"] onView:self.view];
                                     }
                                 }fail:^(NSString *decretion){
                                     [self hideRefresh];
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
    
    NSArray *resourceArray = [resultDic objectForKey:@"data"];
    if (dataSourceArray.count > 0) {
        [dataSourceArray removeAllObjects];
    }
    if (resourceArray && resourceArray.count > 0)
    {
        
        for (NSDictionary *dic in resourceArray)
        {
            VipHouseListInfo *info = [dic objectByClass:[VipHouseListInfo class]];
            [dataSourceArray addObject:info];
        }
    }
    if (dataSourceArray.count > 0) {
        _warnLabel.hidden = YES;
    }else{
        _warnLabel.hidden = NO;
    }
    [_collectView reloadData];
}


- (void)httpUpdateUserInfoWithNickName:(NSString *)name
{
    [HUD show:YES];
    HttpHelper *helper = [[HttpHelper alloc] init];
    __weak VipListViewController *weakSelf = self;
    [helper updateUserInfoWithUserId:[ShareManager shareInstance].userinfo.id
                          user_photo:nil
                           nick_name:name
                             signStr:nil
                                 sex:nil
                              mobile:nil
                withdrawals_password:nil
                        old_password:nil
                            password:nil
                              msg_id:nil
                            msg_code:nil
                             success:^(NSDictionary *resultDic){
                                 [HUD hide:YES];
                                 if ([[resultDic objectForKey:@"result_code"] integerValue] == 0 && resultDic)
                                 {
                                     [weakSelf handleloadUpdateResult:resultDic nickName:name];
                                 }else
                                 {
                                     if(!resultDic)
                                     {
                                         [Tool showPromptContent:@"请求失败" onView:self.view];
                                     }else{
                                         
                                         [Tool showPromptContent:[resultDic objectForKey:@"result_desc"] onView:self.view];
                                     }
                                 }
                             }fail:^(NSString *decretion){
                                 [HUD hide:YES];
                                 [Tool showPromptContent:@"网络出错了" onView:self.view];
                             }];
    
}

- (void)handleloadUpdateResult:(NSDictionary *)resultDic nickName:(NSString *)name
{
    [Tool showPromptContent:@"设置成功，请重新点击房间" onView:self.view];
    
    [ShareManager shareInstance].userinfo.nick_name = name;
    [Tool saveUserInfoToDB:YES];
}


#pragma mark - UICollectionViewDataSource,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return dataSourceArray.count;
}

- (CGFloat)minimumInteritemSpacing {
    return 0;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    VipListCollectionViewCell *cell = (VipListCollectionViewCell *)[collectionView dequeueReusableCellWithReuseIdentifier:@"VipListCollectionViewCell" forIndexPath:indexPath];
    if (FullScreen.size.width > 375) {
        cell.numLabelHeight.constant = 36;
    }else{
        cell.numLabelHeight.constant = 30;
    }
    NSString *nameStr = [NSString stringWithFormat:@"VIP房间%d",(int)indexPath.row+1];
    cell.numLabel.text = nameStr;
    
    cell.peopleView .layer.masksToBounds =YES;
    cell.peopleView .layer.cornerRadius = cell.peopleView.frame.size.height/2;
    
    if (indexPath.row%4 == 0) {
        cell.bgImage.image = [UIImage imageNamed:@"shouye_36"];
    }else if (indexPath.row%4 == 1)
    {
        cell.bgImage.image = [UIImage imageNamed:@"shouye_38"];
    }else if (indexPath.row%4 == 2)
    {
        cell.bgImage.image = [UIImage imageNamed:@"shouye_32"];
    }else{
       cell.bgImage.image = [UIImage imageNamed:@"shouye_34"];
    }
    
    VipHouseListInfo *info = [dataSourceArray objectAtIndex:indexPath.row];
    cell.numLabel.text = [NSString stringWithFormat:@"%@",info.room_name];
    cell.peopleNumLabel.text = [NSString stringWithFormat:@"%.0f人",info.people_count];
    
    return cell;
    
}

//定义每个UICollectionView 的大小
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return CGSizeMake(collectionView.frame.size.width/2,(collectionView.frame.size.width/2-25)*1.4+24);
    
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section
{
    return 0.0f;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section
{
    return 0.0f;
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    return UIEdgeInsetsMake(0, 0, 0, 0);
}


//UICollectionView被选中时调用的方法
-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    [collectionView deselectItemAtIndexPath:indexPath animated:YES];
    
//   [Tool showPromptContent:@"敬请期待" onView:self.view];
    if ([ShareManager shareInstance].userinfo.nick_name.length > 0 && ![[ShareManager shareInstance].userinfo.nick_name isEqualToString:@"<null>"]) {
        VipHouseListInfo *info = [dataSourceArray objectAtIndex:indexPath.row];
        if (![info.password isEqualToString:@"-1"]) {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"请输入房间密码" message:@"" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
            [alert setAlertViewStyle:UIAlertViewStylePlainTextInput];
            UITextField *txtName = [alert textFieldAtIndex:0];
            txtName.placeholder = @"请输入房间密码";
            txtName.secureTextEntry = YES;
            alert.tag = indexPath.row+1000000;
            [alert show];
            
        }else{
            [self initIMChatWithIndex:indexPath.row pwdStr:nil];
        }
    }else{
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"请设置用户昵称昵称" message:@"" delegate:self cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
        [alert setAlertViewStyle:UIAlertViewStylePlainTextInput];
        UITextField *txtName = [alert textFieldAtIndex:0];
        txtName.placeholder = @"请设置用户昵称";
        alert.tag = 111111;
        [alert show];
    }
    
}



- (void)initIMChatWithIndex:(NSInteger)index pwdStr:(NSString *)pwdStr
{
        [HUD show:YES];
        VipHouseListInfo *info = [dataSourceArray objectAtIndex:index];
        NSLog(@"%@",[ShareManager shareInstance].userinfo.im_account);
        if([EMClient sharedClient].isLoggedIn && [[EMClient sharedClient].currentUsername isEqualToString:[ShareManager shareInstance].userinfo.im_account] )
        {
            HttpHelper *helper = [[HttpHelper alloc] init];
            __weak VipListViewController *weakSelf = self;
            [helper joinGameRoomWithRoomId:info.id
                                   user_id:[ShareManager shareInstance].userinfo.id
                                  password:[info.password isEqualToString:@"-1"] ?nil:pwdStr
                                   success:^(NSDictionary *resultDic){
                                       [HUD hide:YES];
                                       if ([[resultDic objectForKey:@"result_code"] integerValue] == 0) {
                                           VipHouseListInfo *info = [dataSourceArray objectAtIndex:index];
                                           ChatViewController *chatController = [[ChatViewController alloc] initWithConversationChatter:info.im_gourp_id conversationType:EMConversationTypeGroupChat];
                                           chatController.title = info.room_name;
                                           chatController.gameType = _gameType;
                                           chatController.roomIDStr = info.id;
                                           chatController.areaIDStr = _areaId;
                                           [weakSelf.navigationController pushViewController:chatController animated:YES];
                                       }else
                                       {
                                           [Tool showPromptContent:[resultDic objectForKey:@"result_desc"] onView:self.view];
                                       }
                                   }fail:^(NSString *decretion){
                                       
                                       [HUD hide:YES];
                                       [Tool showPromptContent:@"网络出错了" onView:self.view];
                                   }];
        }else{
            [[EMClient sharedClient] logout:NO];
            dispatch_async(dispatch_get_global_queue(0, 0), ^{
                    EMError *error = [[EMClient sharedClient] loginWithUsername:[ShareManager shareInstance].userinfo.im_account password:@"123456"];
                    if (!error)
                    {
                        
                        dispatch_async(dispatch_get_main_queue(), ^{
                            [[EMClient sharedClient].options setIsAutoLogin:YES];
                            HttpHelper *helper = [[HttpHelper alloc] init];
                            __weak VipListViewController *weakSelf = self;
                            [helper joinGameRoomWithRoomId:info.id
                                                   user_id:[ShareManager shareInstance].userinfo.id
                                                  password:[info.password isEqualToString:@"-1"] ?nil:pwdStr
                                                   success:^(NSDictionary *resultDic){
                                                       [HUD hide:YES];
                                                       if ([[resultDic objectForKey:@"result_code"] integerValue] == 0) {
                                                           VipHouseListInfo *info = [dataSourceArray objectAtIndex:index];
                                                           ChatViewController *chatController = [[ChatViewController alloc] initWithConversationChatter:info.im_gourp_id conversationType:EMConversationTypeGroupChat];
                                                           chatController.title = info.room_name;
                                                           chatController.gameType = _gameType;
                                                           chatController.roomIDStr = info.id;
                                                           chatController.areaIDStr = _areaId;
                                                           [weakSelf.navigationController pushViewController:chatController animated:YES];
                                                       }else
                                                       {
                                                           [Tool showPromptContent:[resultDic objectForKey:@"result_desc"] onView:self.view];
                                                       }
                                                   }fail:^(NSString *decretion){
                                                       
                                                       [HUD hide:YES];
                                                       [Tool showPromptContent:@"网络出错了" onView:self.view];
                                                   }];
                        });
                    }else{
                        dispatch_async(dispatch_get_main_queue(), ^{
                            [HUD hide:YES];
                            NSLog(@"error:%@",error.errorDescription);
                            NSString *message = [NSString stringWithFormat:@"IM登录失败(%@)",error.errorDescription];
                            UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"提示" message:message delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
                            [alert show];
                        });
                    }
            });
         }
    
}
#pragma mark - UIAlertViewDelegate

#pragma mark - UIAlertViewDelegate

-(void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex{
    if ( alertView.tag == 111111) {
        UITextField *txt = [alertView textFieldAtIndex:0];
        [self httpUpdateUserInfoWithNickName:txt.text];
    }
    if (alertView.tag >= 1000000) {
        if (buttonIndex == 1) {
            UITextField *txt = [alertView textFieldAtIndex:0];
            [self initIMChatWithIndex:alertView.tag-1000000 pwdStr:txt.text];
        }
    }
}

- (BOOL)alertViewShouldEnableFirstOtherButton:(UIAlertView *)alertView
{
    if (alertView.tag == 111111) {
        UITextField *txt = [alertView textFieldAtIndex:0];
        if (txt.text.length < 1) {
            return NO;
        }else{
            return YES;
        }
    }else if (alertView.tag >= 1000000) {
        UITextField *txt = [alertView textFieldAtIndex:0];
        if (txt.text.length < 1) {
            return NO;
        }else{
            return YES;
        }
    }else{
        return YES;
    }
    
}

#pragma mark - tableview 上下拉刷新

- (void)setTabelViewRefresh
{
    __unsafe_unretained UICollectionView *collect = self.collectView;
    __unsafe_unretained __typeof(self) weakSelf = self;
    // 下拉刷新
    collect.mj_header= [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        
        [weakSelf httpGetHouseList];
    }];
    // 设置自动切换透明度(在导航栏下面自动隐藏)
    collect.mj_header.automaticallyChangeAlpha = YES;
    [collect.mj_header beginRefreshing];
}

- (void)hideRefresh
{
    
    if([_collectView.mj_footer isRefreshing])
    {
        [_collectView.mj_footer endRefreshing];
    }
    if([_collectView.mj_header isRefreshing])
    {
        [_collectView.mj_header endRefreshing];
    }
}
@end
