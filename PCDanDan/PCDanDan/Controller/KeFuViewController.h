//
//  KeFuViewController.h
//  PCDanDan
//
//  Created by linqsh on 17/3/6.
//  Copyright © 2017年 vma-lin. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RequestListInfo : NSObject
    @property (nonatomic, strong) NSString *content;
    @property (nonatomic, strong) NSString *create_time;
    @property (nonatomic, strong) NSString *id ;
    @property (nonatomic, strong) NSString *title;
@end

@interface KefuMsgListInfo : NSObject

@property (assign, nonatomic) BOOL isKefu;
@property (nonatomic, strong) NSString *msg;
@property (nonatomic, strong) NSString *timeStr;

@end

@interface KeFuViewController : UIViewController
@property (weak, nonatomic) IBOutlet UITableView *megTableView;
@property (weak, nonatomic) IBOutlet UIView *textBgView;
@property (weak, nonatomic) IBOutlet UITextField *msgText;
@property (weak, nonatomic) IBOutlet UIButton *sendButton;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *textViewBottom;
@property (weak, nonatomic) IBOutlet UIView *msgView;

- (IBAction)clickSendButtonAction:(id)sender;
@end
