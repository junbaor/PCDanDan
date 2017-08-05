//
//  ModifyUserInfoViewController.h
//  PCDanDan
//
//  Created by xcode.qi on 17/1/19.
//  Copyright © 2017年 li. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol ModifyUserInfoViewControllerDelegate <NSObject>
@optional
- (void)modiftyUserInfoSuccesss;

@end

@interface ModifyUserInfoViewController : UIViewController
@property (nonatomic, assign) id<ModifyUserInfoViewControllerDelegate> delegate;
@property (weak, nonatomic) IBOutlet UILabel *accountLabel;
@property (weak, nonatomic) IBOutlet UITextField *nickName;
@property (weak, nonatomic) IBOutlet UITextField *signLabel;
@property (weak, nonatomic) IBOutlet UIButton *sureButton;

- (IBAction)clickSureButtonAction:(id)sender;
@end
