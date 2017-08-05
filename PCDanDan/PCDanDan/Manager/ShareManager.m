//
//  ShareManager.m
//  Matsu
//
//  Created by linqsh on 15/5/12.
//  Copyright (c) 2015年 linqsh. All rights reserved.
//

#import "ShareManager.h"

@implementation ShareManager
{
    UIWebView *callPhoneWebview;
    selectImage_block_t toolblock;
    UIViewController *viewControoler;
    NSString*  filename;
    BOOL isReduce;
    BOOL isEdit;
}

static ShareManager *managerSingleton;

+ (ShareManager *)shareInstance
{
    if (!managerSingleton)
    {
        @synchronized(self) {
            managerSingleton = [[ShareManager alloc] init];
            
        }
    }
    
    return managerSingleton;
}

/**
 *  获取当前网络状态
 *  0 无网络 1 wwan 2 wifi
 */
- (int)getCurrentReachabilityStatus
{
    ReachabilityStatus status = [GLobalRealReachability currentReachabilityStatus];
    NSLog(@"Initial reachability status:%@",@(status));
    
    if (status == RealStatusNotReachable)
    {
        return 0;
    }
    
    if (status == RealStatusViaWiFi)
    {
        return 2;
    }
    
    if (status == RealStatusViaWWAN)
    {
        return 1;
    }
    
    return 0;
}



/**
 *  添加监听：网络状态变化
 */
- (void)addReachabilityChangedObserver
{
    
    [GLobalRealReachability startNotifier];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(reachabilityChanged:)
                                                 name:kRealReachabilityChangedNotification
                                               object:nil];
}

/**
 *  网络状态变化通知
 */
- (void)reachabilityChanged:(NSNotification *)notification
{
    
    RealReachability *reachability = (RealReachability *)notification.object;
    ReachabilityStatus status = [reachability currentReachabilityStatus];
    ReachabilityStatus previousStatus = [reachability previousReachabilityStatus];
    NSLog(@"networkChanged, currentStatus:%@, previousStatus:%@", @(status), @(previousStatus));
    
    if (status == RealStatusNotReachable)
    {
        NSLog(@"Network Unreachable");
       [[NSNotificationCenter defaultCenter] postNotificationName:kReachableNetworkStatusChange object:nil userInfo:nil];
    }
    
    if (status == RealStatusViaWiFi)
    {
        NSDictionary *netInfo = [NSDictionary dictionaryWithObject:@"Wifi" forKey:@"NetworkStatus"];
        [[NSNotificationCenter defaultCenter] postNotificationName:kReachableNetworkStatusChange object:nil userInfo:netInfo]; //wifi网络
    }
    
    if (status == RealStatusViaWWAN)
    {
        NSDictionary *netInfo = [NSDictionary dictionaryWithObject:@"WWAN" forKey:@"NetworkStatus"];
        [[NSNotificationCenter defaultCenter] postNotificationName:kReachableNetworkStatusChange object:nil userInfo:netInfo]; //基站网络
    }
    
}

/**
 *  拨打电话
 *
 *  @param phoneNumber 要拨打的号码
 *  @param view        拨号所在的页面
 */
- (void)dialWithPhoneNumber:(NSString *)phoneNumber inView:(UIView *)selfView
{
    
    if (!callPhoneWebview) {
        callPhoneWebview = [[UIWebView alloc] init];
    }
    
    if (![callPhoneWebview isDescendantOfView:selfView]) {
        [selfView addSubview:callPhoneWebview];
    }
    
    
    NSString *urlString = [NSString stringWithFormat:@"tel://%@", phoneNumber];
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:urlString]];
    [callPhoneWebview loadRequest:request];
}



#pragma mark 从相册或相机中获取照片
/**
 *  从相册或相机中获取照片
 *
 *  @param vc        需要选择的图片的 UIViewController
 *  @param block     获取到图片后的操作
 */
- (void)selectPictureFromDevice:(UIViewController*)vc isReduce:(BOOL)isreduce isSelect:(BOOL)isSelect isEdit:(BOOL)isedit block:(selectImage_block_t)block
{
    viewControoler = vc;
    toolblock = block;
    isReduce = isreduce;
    isEdit = isedit;
    if (isSelect) {
        UIActionSheet *actionSheet = [[UIActionSheet alloc]
                                      initWithTitle:nil
                                      delegate:self
                                      cancelButtonTitle:@"取消"
                                      destructiveButtonTitle:nil
                                      otherButtonTitles:@"拍照", @"从相册获取",nil];
        actionSheet.actionSheetStyle = UIActionSheetStyleDefault;
        [actionSheet showInView:vc.view];
    }else{
        
        [self addCarema:nil];
    }
    
}

//打开相机
- (void)addCarema:(id)sender
{
    //判断是否可以打开相机，模拟器此功能无法使用
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
        
        UIImagePickerController * picker = [[UIImagePickerController alloc]init];
        picker.delegate = self;
        picker.allowsEditing = isEdit;  //是否可编辑
        //摄像头
        picker.sourceType = UIImagePickerControllerSourceTypeCamera;
        [viewControoler presentViewController:picker  animated:YES completion:nil];
        
    }else{
        
        //如果没有提示用户
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error" message:@"你没有摄像头" delegate:nil cancelButtonTitle:@"Drat!" otherButtonTitles:nil];
        [alert show];
    }
}

//打开相册
- (void)openPicLibrary:(id)sender
{
    //相册是可以用模拟器打开的
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypePhotoLibrary]) {
        
        UIImagePickerController * picker = [[UIImagePickerController alloc]init];
        picker.delegate = self;
        picker.allowsEditing = isEdit;//是否可以编辑
        
        //打开相册选择照片
        picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        [viewControoler presentViewController:picker  animated:YES completion:nil];
        
    }else{
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error" message:@"你没有摄像头" delegate:nil cancelButtonTitle:@"Drat!" otherButtonTitles:nil];
        [alert show];
    }
}

// UIImagePickerControllerDelegate

-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    UIImage* immageOfSelect = nil;
    if (isReduce) {
        
        immageOfSelect = [info objectForKey:UIImagePickerControllerEditedImage];
    }else{
        // 得到图片
        immageOfSelect = [info objectForKey:UIImagePickerControllerOriginalImage];
    }
    NSData *data = UIImageJPEGRepresentation(immageOfSelect,0.5);
    immageOfSelect = [UIImage imageWithData:data];
    
    //照片来源于摄像头
    if (picker.sourceType == UIImagePickerControllerSourceTypeCamera)
    {
        filename = @"image.jpg";
        toolblock(immageOfSelect,filename);
    }
    else
    {
        NSURL *imageURL = [info valueForKey:UIImagePickerControllerReferenceURL];
        ALAssetsLibraryAssetForURLResultBlock resultblock = ^(ALAsset *myasset)
        {
            ALAssetRepresentation *representation = [myasset defaultRepresentation];
            filename = [representation filename];
            NSLog(@"fileName : %@",filename);
            toolblock(immageOfSelect,filename);
        };
        ALAssetsLibrary* assetslibrary = [[ALAssetsLibrary alloc] init];
        [assetslibrary assetForURL:imageURL
                       resultBlock:resultblock
                      failureBlock:nil];
    }
    
    [picker dismissViewControllerAnimated:YES completion:nil];
    
    
}

//点击Cancel按钮后执行方法
-(void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [picker dismissViewControllerAnimated:YES completion:nil];
}

-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingImage:(UIImage *)image editingInfo:(NSDictionary *)editingInfo
{
    [picker dismissViewControllerAnimated:YES completion:nil];
}



// UIActionSheetDelegate

-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 0) { //拍照
        [self addCarema:nil];
        
    }else if (buttonIndex == 1){//从相册获取
        [self openPicLibrary:nil];
    }
}




@end
