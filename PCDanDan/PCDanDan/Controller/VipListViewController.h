//
//  VipListViewController.h
//  PCDanDan
//
//  Created by xcode.qi on 17/1/17.
//  Copyright © 2017年 li. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface VipListViewController : UIViewController
@property (strong, nonatomic) NSString *gameType;//1北京28   2加拿大28
@property (strong, nonatomic) NSString *areaId;
@property (weak, nonatomic) IBOutlet UICollectionView *collectView;
@property (weak, nonatomic) IBOutlet UILabel *warnLabel;
@end
