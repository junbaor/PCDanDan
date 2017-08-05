//
//  MyWallectViewController.m
//  PCDanDan
//
//  Created by xcode.qi on 17/1/19.
//  Copyright © 2017年 li. All rights reserved.
//

#import "MyWallectViewController.h"
#import "UserCenterListTableViewCell.h"
#import "CZRecordListViewController.h"
#import "TXRecordListViewController.h"
#import "ChongZhiViewController.h"
#import "MyBankCardViewController.h"
#import "BankBangdingViewController.h"
#import "TiXianViewController.h"

@interface MyWallectViewController ()
{
    NSMutableArray *dataSourceArray;
    NSMutableArray *iconImageArray;
}

@end

@implementation MyWallectViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initVariable];
    [self leftNavigationItem];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    __weak MyWallectViewController *weakSelf = self;
    [HttpMangerHelper  getUserSelfInfoSuccess:^(UserInfo * info) {
        weakSelf.moneyLabel.text = [NSString stringWithFormat:@"%.2f元宝",info.point];
        
    } fail:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)initVariable
{
    self.title = @"钱包";
    dataSourceArray = [NSMutableArray arrayWithObjects:@"我的银行卡", @"充值", @"提现",@"充值记录",@"提现记录",nil];
    iconImageArray = [NSMutableArray arrayWithObjects:@"wode_31", @"wode_51",@"wode_43",@"wode_69",@"wode_75",nil];
 
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

//设置cell的行高
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 53;
}


//创建并显示每行的内容
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UserCenterListTableViewCell *cell = nil;
    cell = [tableView dequeueReusableCellWithIdentifier:@"UserCenterListTableViewCell"];
    if (cell == nil)
    {
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"UserCenterListTableViewCell" owner:nil options:nil];
        cell = [nib objectAtIndex:0];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    
    cell.iconImage.image = [UIImage imageNamed:[iconImageArray objectAtIndex:indexPath.row]];
    cell.iconTitle.text = [dataSourceArray objectAtIndex:indexPath.row];
    
    return cell;
    
    
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    switch (indexPath.row) {
        case 0:
        {
            if(![HttpMangerHelper isBangDingPhone])
            {
                __weak MyWallectViewController *ws = self;
                UIAlertView *alert = [UIAlertView bk_showAlertViewWithTitle:@"提示" message:@"为了您的资金安全，请绑定手机号" cancelButtonTitle:@"确定" otherButtonTitles:nil handler:^(UIAlertView *alertView, NSInteger buttonIndex) {
                    [HttpMangerHelper gotoBangDingWithAnimated:YES viewController:ws];
                }];
                [alert show];
            }else{
                if(![HttpMangerHelper isSetTiXianPwd])
                {
                    __weak MyWallectViewController *ws = self;
                    UIAlertView *alert = [UIAlertView bk_showAlertViewWithTitle:@"提示" message:@"请先设置提现密码" cancelButtonTitle:@"确定" otherButtonTitles:nil handler:^(UIAlertView *alertView, NSInteger buttonIndex) {
                        [HttpMangerHelper setTiXianPwdWithAnimated:YES viewController:ws];
                    }];
                    [alert show];
                }else{
                    
                    if ([ShareManager shareInstance].userinfo.bank_no.length > 0 && ![[ShareManager shareInstance].userinfo.bank_no isEqualToString:@"<null>"] ) {
                        MyBankCardViewController *vc = [[MyBankCardViewController alloc]initWithNibName:@"MyBankCardViewController" bundle:nil];
                        [self.navigationController pushViewController:vc animated:YES];
                        
                        
                    }else{
                  
                        __weak MyWallectViewController *ws = self;
                        UIAlertView *alert = [UIAlertView bk_showAlertViewWithTitle:@"提示" message:@"您未绑定银行卡，请先绑定银行卡" cancelButtonTitle:@"确定" otherButtonTitles:nil handler:^(UIAlertView *alertView, NSInteger buttonIndex) {
                            BankBangdingViewController *vc = [[BankBangdingViewController alloc]initWithNibName:@"BankBangdingViewController" bundle:nil];
                            [ws.navigationController pushViewController:vc animated:YES];
                        }];
                        [alert show];

                    }
                }
            }
        }
            break;
        case 1:
        {
            ChongZhiViewController *vc = [[ChongZhiViewController alloc]initWithNibName:@"ChongZhiViewController" bundle:nil];
            vc.isPush = YES;
            [self.navigationController pushViewController:vc animated:YES];
        }
            break;
        case 2:
        {
            if(![HttpMangerHelper isBangDingPhone])
            {
                __weak MyWallectViewController *ws = self;
                UIAlertView *alert = [UIAlertView bk_showAlertViewWithTitle:@"提示" message:@"为了您的资金安全，请绑定手机号" cancelButtonTitle:@"确定" otherButtonTitles:nil handler:^(UIAlertView *alertView, NSInteger buttonIndex) {
                    [HttpMangerHelper gotoBangDingWithAnimated:YES viewController:ws];
                }];
                [alert show];
            }else{
                if(![HttpMangerHelper isSetTiXianPwd])
                {
                    __weak MyWallectViewController *ws = self;
                    UIAlertView *alert = [UIAlertView bk_showAlertViewWithTitle:@"提示" message:@"请先设置提现密码" cancelButtonTitle:@"确定" otherButtonTitles:nil handler:^(UIAlertView *alertView, NSInteger buttonIndex) {
                        [HttpMangerHelper setTiXianPwdWithAnimated:YES viewController:ws];
                    }];
                    [alert show];
                }else{
                    
                    if ([ShareManager shareInstance].userinfo.bank_no.length > 0 && ![[ShareManager shareInstance].userinfo.bank_no isEqualToString:@"<null>"] ) {
                        TiXianViewController *vc = [[TiXianViewController alloc]initWithNibName:@"TiXianViewController" bundle:nil];
                        [self.navigationController pushViewController:vc animated:YES];
                        
                    }else{
                        
                        __weak MyWallectViewController *ws = self;
                        UIAlertView *alert = [UIAlertView bk_showAlertViewWithTitle:@"提示" message:@"您未绑定银行卡，请先绑定银行卡" cancelButtonTitle:@"确定" otherButtonTitles:nil handler:^(UIAlertView *alertView, NSInteger buttonIndex) {
                            BankBangdingViewController *vc = [[BankBangdingViewController alloc]initWithNibName:@"BankBangdingViewController" bundle:nil];
                            [ws.navigationController pushViewController:vc animated:YES];
                        }];
                        [alert show];
                        
                    }
                }
            }

        }
            break;
        case 3:
        {
            CZRecordListViewController *vc = [[CZRecordListViewController alloc]initWithNibName:@"CZRecordListViewController" bundle:nil];
            [self.navigationController pushViewController:vc animated:YES];
        }
            break;
        case 4:
        {
            TXRecordListViewController *vc = [[TXRecordListViewController alloc]initWithNibName:@"TXRecordListViewController" bundle:nil];
            [self.navigationController pushViewController:vc animated:YES];
        }
            break;
        default:
            [Tool showPromptContent:@"敬请期待" onView:self.view];
            break;
    }
}

@end
