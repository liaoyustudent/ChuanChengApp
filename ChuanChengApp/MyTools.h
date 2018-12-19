//
//  MyTools.h
//  ChuanChengApp
//
//  Created by liaoyu on 2018/12/12.
//  Copyright © 2018年 ChuanCheng. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface MyTools : NSObject
//获取当前时间戳
+ (NSString *)currentTimeStr;
//获取当前时间
+ (NSString *)currentDateStr;
// 时间戳转时间,时间戳为13位是精确到毫秒的，10位精确到秒
+ (NSString *)getDateStringWithTimeStr:(NSString *)str;
//字符串转时间戳 如：2017-4-10 17:15:10
+ (NSString *)getTimeStrWithString:(NSString *)str;
@end

NS_ASSUME_NONNULL_END
