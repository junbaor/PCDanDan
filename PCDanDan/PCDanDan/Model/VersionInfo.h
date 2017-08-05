//
//  VersionInfo.h
//  PCDanDan
//
//  Created by linqsh on 17/3/18.
//  Copyright © 2017年 vma-lin. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface VersionInfo : NSObject

@property (nonatomic, strong) NSString *id;
@property (nonatomic, strong) NSString *version_no;//   --新版本的版本号
@property (nonatomic, strong) NSString *update_content;// --更新内容
@property (nonatomic, strong) NSString *version_url;//
@property (nonatomic, strong) NSString *status;//  1强制升级  0可选择性升级

@end
