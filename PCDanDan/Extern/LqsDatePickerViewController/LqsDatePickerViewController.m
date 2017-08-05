//
//  LqsDatePickerViewController.m
//  Esport
//
//  Created by linqsh on 15/5/30.
//  Copyright (c) 2015年 linqsh. All rights reserved.
//

#import "LqsDatePickerViewController.h"

static const NSString *kMinimumBirthdayYear = @"1850";
static const NSString *kMaxBirthdayYear = @"2078";

@interface LqsDatePickerViewController ()

@end

@implementation LqsDatePickerViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    
    _titleNameLabel.text = _titleName;
    
    _datePicker.datePickerMode = _dateShowMode;
    
//    self.view.layer.borderColor = [UIColor whiteColor].CGColor;
    
    NSLocale *chineseLocale = [NSLocale localeWithLocaleIdentifier:@"zh_cn"]; //创建一个中文的地区对象
    [_datePicker setLocale:chineseLocale]; //将这个地区对象给UIDatePicker设置上
    
    if (_limitTime) {
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        dateFormatter.dateFormat = @"yyyy-MM-dd";
        [self.datePicker setDate:[dateFormatter dateFromString:_limitTime] animated:NO];

    }

}

- (IBAction)datePickerValueChanged:(id)sender
{
    static NSDateFormatter *dateFormatter = nil;
    dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm"];
    if (_isDecending) {//只能选择大于当前时间
        if ([self.datePicker.date compare:[NSDate date]] == NSOrderedAscending) {
            [self.datePicker setDate:[NSDate date] animated:YES];
        }
    }else{
        //不可大于当前时间
        if ([self.datePicker.date compare:[NSDate date]] == NSOrderedDescending) {
            [self.datePicker setDate:[NSDate date] animated:YES];
        }
    }
   
    
////    时间判断，不能大于当前时间
//    NSString *currentDateString = [dateFormatter stringFromDate:[NSDate date]];
//    NSString *minimumDateString = [NSString stringWithFormat:@"%@%@", kMinimumBirthdayYear, [currentDateString substringFromIndex:4]];
//    NSDate *minimumDate = [dateFormatter dateFromString:minimumDateString];
//    NSDate *datePickerDate = self.datePicker.date ;
//    NSComparisonResult result = [datePickerDate compare:minimumDate];
//    
//    if (result == NSOrderedAscending) {
//        
//        [self.datePicker setDate:minimumDate animated:YES];
//    }
}

- (IBAction)clickCannelAction:(id)sender
{
    [self dismissViewControllerAnimated:YES completion:nil];
}
- (IBAction)clickSetButtonAction:(id)sender
{
    [self dismissViewControllerAnimated:YES completion:^{
       [self.delegate rsponeSelectResult:self.datePicker.date];
    }];
}

@end
