//
//  LqsDatePickerViewController.h
//  Esport
//
//  Created by linqsh on 15/5/30.
//  Copyright (c) 2015年 linqsh. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol LqsDatePickerViewControllerDelegate <NSObject>
@optional

- (void)rsponeSelectResult:(NSDate *)result;


@end

@interface LqsDatePickerViewController : UIViewController

@property (strong,nonatomic)  NSString *limitTime;
@property (assign,nonatomic)  BOOL isDecending;//是否大于当前时间
@property (nonatomic, assign) id<LqsDatePickerViewControllerDelegate> delegate;

@property (assign,nonatomic) UIDatePickerMode dateShowMode;//显示的时间格式

@property (strong,nonatomic)  NSString *titleName;

@property (weak, nonatomic) IBOutlet UILabel *titleNameLabel;

@property (nonatomic, assign) UIStatusBarStyle previousStatusBarStyle;

@property (weak, nonatomic) IBOutlet UIDatePicker *datePicker;


- (IBAction)datePickerValueChanged:(id)sender;
- (IBAction)clickCannelAction:(id)sender;
- (IBAction)clickSetButtonAction:(id)sender;

@end
