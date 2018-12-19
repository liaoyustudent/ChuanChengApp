//
//  AdvertModel.h
//  ChuanChengApp
//
//  Created by liaoyu on 2018/12/11.
//  Copyright © 2018年 ChuanCheng. All rights reserved.
//

#import "BaseModel.h"

@interface AdvertModel : BaseModel

@property (nonatomic, assign) int FID;
@property (nonatomic,copy) NSString *FTitle;
@property (nonatomic,copy) NSString *FCreatTime;

@end


