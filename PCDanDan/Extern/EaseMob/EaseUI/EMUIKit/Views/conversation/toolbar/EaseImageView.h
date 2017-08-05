/************************************************************
 *  * Hyphenate CONFIDENTIAL
 * __________________
 * Copyright (C) 2016 Hyphenate Inc. All rights reserved.
 *
 * NOTICE: All information contained herein is, and remains
 * the property of Hyphenate Inc.
 * Dissemination of this information or reproduction of this material
 * is strictly forbidden unless prior written permission is obtained
 * from Hyphenate Inc.
 */


#import <UIKit/UIKit.h>

@interface EaseImageView : UIView

@property (strong, nonatomic) UIImageView *imageView;

@property (strong, nonatomic) UIImage *image;

@property (assign, nonatomic) NSInteger badge;

@property (assign,nonatomic) BOOL showBadge;

@property (assign,nonatomic) CGFloat imageCornerRadius UI_APPEARANCE_SELECTOR;

@property (assign,nonatomic) CGFloat badgeSize UI_APPEARANCE_SELECTOR;

@property (strong, nonatomic) UIFont *badgeFont UI_APPEARANCE_SELECTOR;

@property (strong,nonatomic) UIColor *badgeTextColor UI_APPEARANCE_SELECTOR;

@property (strong,nonatomic) UIColor *badgeBackgroudColor UI_APPEARANCE_SELECTOR;

@end
