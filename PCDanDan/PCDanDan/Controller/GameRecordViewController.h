//
//  GameRecordViewController.h
//  PCDanDan
//
//  Created by xcode.qi on 17/1/19.
//  Copyright © 2017年 li. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface GameRecordViewController : UIViewController
@property (weak, nonatomic) IBOutlet UILabel *typeLabel;
@property (weak, nonatomic) IBOutlet UILabel *beginLabel;
@property (weak, nonatomic) IBOutlet UILabel *endLabel;

@property (weak, nonatomic) IBOutlet UIButton *sureButton;

- (IBAction)clickTypeAction:(id)sender;
- (IBAction)clickBeginAction:(id)sender;
- (IBAction)clickEndAction:(id)sender;
- (IBAction)clickSureAction:(id)sender;
@end
