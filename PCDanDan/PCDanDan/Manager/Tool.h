//
//  Tool.h
//  Matsu
//
//  Created by linqsh on 15/5/13.
//  Copyright (c) 2015年 linqsh. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "CommonDefine.h"

@interface Tool : NSObject


/**
 *  显示提示信息
 *
 *  @param content  提示内容
 *  @param selfView 提示信息所在的页面
 */
+ (void)showPromptContent:(NSString *)content onView:(UIView *)selfView;


/**
 *  16进制颜色值转RGB
 *
 *  @param hexString 16进制字符串色值
 *
 *  @return RGB色值
 */
+ (UIColor *)colorWithHexString:(NSString *)hexString;

/**
 *  保存图片到document
 */
+ (void)saveImage:(UIImage *)tempImage WithName:(NSString *)imageName;

/**
 *  压缩图片
 */
+ (UIImage*)imageWithImageSimple:(UIImage*)image scaledToSize:(CGSize)newSize;

/**
 *  获取公共图片
 */
+ (UIImage *)imageInPublic:(NSString *)imageName;

/**
 *  获取连接的wifi的信息
 */
+ (NSDictionary *)wifiInfo;


/**
 *  全屏查看图片
 */
+ (void)FullScreenToSeePicture:(UIImage*)image;

/**
 *  获取当前时间
 *  @param dateFormatString 时间格式
 */
+ (NSString *)getCurrentTimeWithFormat:(NSString *)dateFormatString;

/*
 * 检查手机号是否合法
 *
 */

+ (BOOL)isMobileNumberClassification:(NSString*)phone;


/**
 *  统一收起键盘
 */
+ (void)hideAllKeyboard;


/**
 *  存储当前账号信息，本地只保存一次，覆盖逻辑
 */
+ (void)saveUserInfoToDB:(BOOL)islogin;

/**
 *  指定大小压缩图片
 */
+ (UIImage *)scaleToSize:(UIImage *)img size:(CGSize)size;


/**
 * label 自适应字体大小
 */
+ (void)setFontSizeThatFits:(UILabel*)label;

/**
 *  32位MD5加密
 *
 *  @param string           加密字符串
 *  @param LetterCaseOption 加密选项 {UpperLetter:大写；LowerLetter:小写}
 *
 *  @return 加密后的字符串
 */
+ (NSString *)encodeUsingMD5ByString:(NSString *)srcString
                    letterCaseOption:(LetterCaseOption)letterCaseOption;


/*
 * 时间戳转为时间字符串
 *
 */
+ (NSString *)timeStringToDateSting:(NSString *)timestr format:(NSString *)format;

/**
 *  判断号码是否是合法手机号
 *
 *  @param checkString 号码
 *
 *  @return 判断结果
 */
+ (BOOL)validateMobile:(NSString *)checkString;

/**
 *  判断是否输入的金额是否合法
 *
 *  @param checkString 号码
 *
 *  @return 判断结果
 */
+ (BOOL)isPureFloat:(NSString *)string;

/**
 *  随机生成字符串
 *
 *  @param checkString 号码
 *
 *  @return 判断结果
 */
+ (NSString *)randomlyGeneratedStrWithLength:(NSInteger)lenght;

/**
 *  发送短信
 *
 *  @param viewController 从哪个viewConotroller弹出的短信窗口
 *  @param recipients     收件人
 *  @param content        短信内容
 */
+ (void)sendMessageByViewController:(UIViewController *)viewController
                         recipients:(NSArray *)recipients
                            content:(NSString *)content;
/*
 * 校验身份证
 *
 */
+(BOOL)checkIdentityCardNo:(NSString*)cardNo;


/**
 *  注入本地JavaScript代码
 */
+ (void)injectLocalJavaScript:(UIWebView *)webview jsFileName:(NSString *)jsFileName;


/*
 * 分享
 *
 */
+ (void)shareMessageToOtherApp:(NSString *)description
                      titleStr:(NSString *)titleStr
                      shareUrl:(NSString *)shareUrl;



/**
 *  类型转换，将 NSString 类型转换成 NSDictionary 类型
 *
 *  @param responseString 网络应答的字符串
 *
 *  @return 字典
 */
+ (NSDictionary *)dictionaryWithJsonString:(NSString *)jsonString;

/*
 *
 * 获取控件大小
 *
 */

+ (CGSize)getStrSize:(NSString *)textStr andTexFont:(UIFont *)font andMaxSize:(CGSize)maxSize;

/*
 *
 * 计算缓存大小
 *
 */
+ (CGFloat)folderSize;

/*
 *
 * 清楚缓存大小
 *
 */
+ (void)removeCache;

/**
 *  生成二维码
 *
 *  @param qrCodeString 二维码字符串
 *
 *  @return 二维码图片
 */
+ (UIImage *)generateQRCodeWithStr:(NSString *)qrCodeString;

/*
 *
 * 返回首页
 *
 */
+ (void)gotoHomePage;

@end
