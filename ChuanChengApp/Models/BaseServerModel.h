//
//  BaseServerModel.h
//  ChuanChengApp
//
//  Created by liaoyu on 2018/11/25.
//  Copyright © 2018年 ChuanCheng. All rights reserved.
//

#import "BaseModel.h"

@interface BaseServerModel : BaseModel

@property (nonatomic, copy) NSDictionary *object;
@property (nonatomic, copy) NSMutableDictionary *extendObject;
@property (nonatomic, copy) NSMutableDictionary *handelEntity;
@property (nonatomic, assign) int code;
@property (nonatomic,assign) bool IsReOperational;
@property (nonatomic,copy) NSString *message;
@property (nonatomic, copy) NSMutableDictionary *page;
@end

