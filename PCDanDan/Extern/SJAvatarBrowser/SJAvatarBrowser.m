//
//  SJAvatarBrowser.m
//  zhitu
//
//  Created by 陈少杰 on 13-11-1.
//  Copyright (c) 2013年 聆创科技有限公司. All rights reserved.
//

#import "SJAvatarBrowser.h"
static CGRect oldframe;
@implementation SJAvatarBrowser
+(void)showImage:(UIImage *)avatarImage{
    
    UIImage *image=avatarImage;
    UIWindow *window=[UIApplication sharedApplication].keyWindow;
    UIView *backgroundView=[[UIView alloc]initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height)];
    backgroundView.backgroundColor = [UIColor clearColor];
    UIView *shadowView=[[UIView alloc]initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height)];
    oldframe=CGRectMake(0, FullScreen.size.height,FullScreen.size.width,FullScreen.size.height );
    shadowView.backgroundColor=[UIColor clearColor];
    UIImageView *imageView=[[UIImageView alloc]initWithFrame:CGRectMake(oldframe.size.width/2 - oldframe.size.width/3, FullScreen.size.height, oldframe.size.width/1.5, oldframe.size.width/1.5)];
    imageView.backgroundColor = [UIColor whiteColor];
    imageView.image=image;
    imageView.tag=1;
    [backgroundView addSubview:shadowView];
    [backgroundView addSubview:imageView];
    [window addSubview:backgroundView];
    
    UITapGestureRecognizer *tap=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(hideImage:)];
    [backgroundView addGestureRecognizer: tap];
    
    
    [UIView animateWithDuration:0.4 animations:^{
        shadowView.backgroundColor=[UIColor blackColor];
        shadowView.alpha=0.4;
        imageView.frame=CGRectMake(0,0,oldframe.size.width/1.5, oldframe.size.width/1.5);
        imageView.center = shadowView.center;
    } completion:^(BOOL finished) {
        
    }];
}

+(void)hideImage:(UITapGestureRecognizer*)tap{
    UIView *backgroundView=tap.view;
    UIImageView *imageView=(UIImageView*)[tap.view viewWithTag:1];
    [UIView animateWithDuration:0.4 animations:^{
        imageView.frame=oldframe;
        backgroundView.alpha=0;
    } completion:^(BOOL finished) {
        [backgroundView removeFromSuperview];
    }];
}
@end
