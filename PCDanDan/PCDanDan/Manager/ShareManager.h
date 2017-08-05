//
//  ShareManager.h
//  Matsu
//
//  Created by linqsh on 15/5/12.
//  Copyright (c) 2015年 linqsh. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AssetsLibrary/AssetsLibrary.h>
#import "RealReachability.h"
#import "UserInfo.h"
#import <CoreLocation/CLLocation.h>
#import "PingTaiServerInfo.h"
#import "ShareInfo.h"

typedef void (^selectImage_block_t)(UIImage* image,NSString* imageName);

@interface ShareManager : NSObject<UIImagePickerControllerDelegate,UIActionSheetDelegate,UINavigationControllerDelegate>

+ (ShareManager *)shareInstance;

@property (nonatomic, strong) UserInfo *userinfo;
@property (nonatomic, strong) UnReadMessageNumInfo *unreadMessageInfo;
@property (nonatomic, strong) PingTaiServerInfo *ptkfInfo;
@property (nonatomic, assign) BOOL isShowTouZhuYDY;
@property (nonatomic, assign) BOOL isShowToCZYDY;
@property (nonatomic, assign) BOOL isShowToXZYDY;
/**
 *  添加监听：网络状态变化
 */
- (void)addReachabilityChangedObserver;

/**
 *  获取当前网络状态
 *  0 无网络 1 wwan 2 wifi
 */
- (int)getCurrentReachabilityStatus;

/**
 *  拨打电话
 *
 *  @param phoneNumber 要拨打的号码
 *  @param view        拨号所在的页面
 */
- (void)dialWithPhoneNumber:(NSString *)phoneNumber inView:(UIView *)selfView;

/**
 *  从相册或相机中获取照片
 *
 *  @param vc        需要选择的图片的 UIViewController
 *  @param block     获取到图片后的操作
 */
- (void)selectPictureFromDevice:(UIViewController*)vc
                       isReduce:(BOOL)isreduce
                       isSelect:(BOOL)isSelect
                         isEdit:(BOOL)isedit
                          block:(selectImage_block_t)block;
@end
