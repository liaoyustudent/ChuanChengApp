//
//  AdvertModel.h
//  ChuanChengApp
//
//  Created by liaoyu on 2018/12/11.
//  Copyright © 2018年 ChuanCheng. All rights reserved.
//

#import "BaseModel.h"
//首页文章列表模型
@interface AdvertModel : BaseModel

@property (nonatomic, assign) int FID;
@property (nonatomic,copy) NSString *FTitle;
@property (nonatomic,copy) NSString *FCreatTime;

@end


