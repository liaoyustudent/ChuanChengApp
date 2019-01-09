//
//  CollectionListModel.h
//  ChuanChengApp
//
//  Created by liaoyu on 2018/12/23.
//  Copyright © 2018年 ChuanCheng. All rights reserved.
//

#import "BaseModel.h"

NS_ASSUME_NONNULL_BEGIN

//我的收藏模型
@interface CollectionListModel : BaseModel
//主键ID
@property (nonatomic, assign) int FID;
//联系方式
@property (nonatomic,copy) NSString *FLinkTel;
//发布时间
@property (nonatomic,copy) NSString *FAddTime;
//内容
@property (nonatomic,copy) NSString *FContent;

@end

NS_ASSUME_NONNULL_END
