//
//  SafariViewController.h
//  YCSH
//
//  Created by linqsh on 15/12/6.
//  Copyright © 2015年 linqsh. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SafariViewController : UIViewController
@property (assign, nonatomic) BOOL isPresent;
@property (weak, nonatomic) IBOutlet UIWebView *webView;
@property (strong, nonatomic) NSString * urlStr;
@end
