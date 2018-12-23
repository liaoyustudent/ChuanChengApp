//
//  MyTools.h
//  ChuanChengApp
//
//  Created by liaoyu on 2018/12/23.
//  Copyright © 2018年 ChuanCheng. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ViewController.h"

NS_ASSUME_NONNULL_BEGIN

@interface MyTools : NSObject

//跳转到j登录页
+(void)GotoLogin;

//淡入淡出跳转页面
+(void)restoreRootViewController:(UIViewController *)rootViewController;

@end

NS_ASSUME_NONNULL_END
