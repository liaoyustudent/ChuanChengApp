//
//  BaseModel.h
//  ChuanChengApp
//
//  Created by liaoyu on 2018/11/23.
//  Copyright © 2018年 ChuanCheng. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface BaseModel : NSObject
+ (id)modelWithDictionary:(NSDictionary *)dic; /** 这是公用的过滤接口数据的方法 */
+ (id)modelwithJsonString:(NSString *)jsonStr;
@end

NS_ASSUME_NONNULL_END
