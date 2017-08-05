//
//  BannerTableViewCell.h
//  DuoBao
//
//  Created by gthl on 16/2/12.
//  Copyright © 2016年 linqsh. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BannerTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet CycleScrollView *bannerView;

@property (weak, nonatomic) IBOutlet UIPageControl *pageController;


@end
