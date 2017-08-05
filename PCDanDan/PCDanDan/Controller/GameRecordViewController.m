//
//  GameRecordViewController.m
//  PCDanDan
//
//  Created by xcode.qi on 17/1/19.
//  Copyright © 2017年 li. All rights reserved.
//

#import "GameRecordViewController.h"
#import "LqsDatePickerViewController.h"
#import "GameRecordListViewController.h"

@interface GameRecordViewController ()<UIActionSheetDelegate,LqsDatePickerViewControllerDelegate>
{
    BOOL isSelectEndTime;
}

@end

@implementation GameRecordViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initVariable];
    [self leftNavigationItem];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)initVariable
{
    self.title = @"游戏记录";
    _sureButton.layer.masksToBounds =YES;
    _sureButton.layer.cornerRadius = 5;
    
    _beginLabel.text = [Tool getCurrentTimeWithFormat:@"yyyy-MM-dd"];
    _endLabel.text = [Tool getCurrentTimeWithFormat:@"yyyy-MM-dd"];
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

#pragma mark -Button Action

- (void)clickLeftControlAction:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)clickTypeAction:(id)sender
{
    UIActionSheet *actionSheet = [[UIActionSheet alloc]
                                  initWithTitle:@"游戏类型"
                                  delegate:self
                                  cancelButtonTitle:@"取消"
                                  destructiveButtonTitle:nil
                                  otherButtonTitles:nil];
    actionSheet.actionSheetStyle = UIActionSheetStyleDefault;
    [actionSheet addButtonWithTitle :@"全部"];
    [actionSheet addButtonWithTitle :@"北京28"];
    [actionSheet addButtonWithTitle :@"加拿大28"];
    [actionSheet showInView:self.view];

}
- (IBAction)clickBeginAction:(id)sender
{
    isSelectEndTime = NO;
    LqsDatePickerViewController *vc = [LqsDatePickerViewController new];
    vc.titleName = @"请选择开始时间";
    vc.dateShowMode = UIDatePickerModeDate;
    vc.isDecending = NO;//只能选择小于当前的时间
    self.definesPresentationContext = YES; //self is presenting view controller
    vc.view.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.2];
    vc.delegate = self;
    if ([[UIDevice currentDevice].systemVersion floatValue] < 8.0)
    {
        self.view.window.rootViewController.modalPresentationStyle = UIModalPresentationCurrentContext;//半透明全靠这句了
    }
    vc.modalPresentationStyle = UIModalPresentationOverCurrentContext;
    UIViewController * rootViewController = [UIApplication sharedApplication].keyWindow.rootViewController;
    [rootViewController presentViewController:vc animated:YES completion:nil];
}
- (IBAction)clickEndAction:(id)sender
{
    isSelectEndTime = YES;
    LqsDatePickerViewController *vc = [LqsDatePickerViewController new];
    vc.titleName = @"请选择结束时间";
    vc.dateShowMode = UIDatePickerModeDate;
    vc.isDecending = NO;//只能选择小于当前的时间
    self.definesPresentationContext = YES; //self is presenting view controller
    vc.view.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.2];
    vc.delegate = self;
    if ([[UIDevice currentDevice].systemVersion floatValue] < 8.0)
    {
        self.view.window.rootViewController.modalPresentationStyle = UIModalPresentationCurrentContext;//半透明全靠这句了
    }
    vc.modalPresentationStyle = UIModalPresentationOverCurrentContext;
    UIViewController * rootViewController = [UIApplication sharedApplication].keyWindow.rootViewController;
    [rootViewController presentViewController:vc animated:YES completion:nil];
}

- (IBAction)clickSureAction:(id)sender
{
    NSString *beginTimeStr = [_beginLabel.text stringByReplacingOccurrencesOfString:@"-" withString:@""];
    NSString *endTimeStr = [_endLabel.text stringByReplacingOccurrencesOfString:@"-" withString:@""];
    
    if ([beginTimeStr integerValue] > [endTimeStr integerValue]) {
        [Tool showPromptContent:@"结束时间不可早于开始时间" onView:self.view];
        return;
    }
    
    GameRecordListViewController *vc = [[GameRecordListViewController alloc]initWithNibName:@"GameRecordListViewController" bundle:nil];
    if ([_typeLabel.text isEqualToString:@"全部"]) {
        vc.gameType = @"0";
    }else if ([_typeLabel.text isEqualToString:@"北京28"]) {
        vc.gameType = @"1";
    }else{
       vc.gameType = @"2";
    }
    vc.beginTimeStr = _beginLabel.text;
    vc.endTimeStr = _endLabel.text;
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark - LqsDatePickerViewControllerDelegate

- (void)rsponeSelectResult:(NSDate*)result
{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd"];
    NSString *timeStr = [dateFormatter stringFromDate:result];
    if (isSelectEndTime) {
        _endLabel.text = timeStr;
    }else{
        _beginLabel.text =  timeStr;
    }
}

#pragma mark - UIActionSheetDelegate
-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 0) {
        return;
    }
    else{
        if(buttonIndex == 1)
        {
           _typeLabel.text = @"全部";
            
        }else if(buttonIndex == 2){
            
            _typeLabel.text = @"北京28";
        }else{
           _typeLabel.text = @"加拿大28";
        }
        
    }
}

@end
