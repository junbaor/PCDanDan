//
//  SafariViewController.m
//  YCSH
//
//  Created by linqsh on 15/12/6.
//  Copyright © 2015年 linqsh. All rights reserved.
//

#import "SafariViewController.h"
#import "NJKWebViewProgressView.h"
#import "NJKWebViewProgress.h"


@interface SafariViewController ()<UIWebViewDelegate>
{
    MBProgressHUD *HUD;
}

@end

@implementation SafariViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initVariable];
    [self leftNavigationItem];
    [self.navigationController setNavigationBarHidden:NO animated:NO];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
}

- (void)initVariable
{
    if (_isPresent) {
        self.navigationController.navigationBar.translucent = NO;
        NSDictionary *attributes = [NSDictionary dictionaryWithObjectsAndKeys:
                                    [UIColor whiteColor],
                                    NSForegroundColorAttributeName, nil];
        
        [self.navigationController.navigationBar setTitleTextAttributes:attributes];

    }
     _webView.scrollView.bounces = NO;
    _webView.delegate = self;
    HUD = [[MBProgressHUD alloc] initWithView:self.view];
    HUD.labelText = @"加载中...";
    [self.view addSubview:HUD];
    _webView.hidden = YES;
    
    _urlStr = [_urlStr stringByAddingPercentEscapesUsingEncoding: NSUTF8StringEncoding];
    NSURL *url = [NSURL URLWithString:[_urlStr stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
    
    NSURLRequest *request = [[NSURLRequest alloc] initWithURL:url];
    NSLog(@"url == %@",request);
    [HUD show:YES];
    [_webView loadRequest:request];
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


#pragma mark - Button Action

- (void)clickLeftControlAction:(id)sender
{
//    if (_webView.canGoBack ) {
//        [_webView goBack];//返回前一画面
//    }else{
        if (_isPresent)
        {
            [self dismissViewControllerAnimated:YES completion:nil];
        }else{
            [self.navigationController popViewControllerAnimated:YES];
        }
        
//    }
}
#pragma mark - UIWebViewDelegate

- (void)webViewDidStartLoad:(UIWebView *)webView
{
    
}
- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    [self performSelector:@selector(showWeb) withObject:nil afterDelay:0.3];
}
- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error
{
    NSLog(@"didFailLoadWithError:%@",error);
    [self performSelector:@selector(showWeb) withObject:nil afterDelay:0.3];
}

- (void)showWeb
{
    [HUD hide:YES];
    _webView.hidden = NO;
}

@end
