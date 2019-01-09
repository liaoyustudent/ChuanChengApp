//
//  PrecisPubModel.h
//  ChuanChengApp
//
//  Created by liaoyu on 2019/1/3.
//  Copyright © 2019年 ChuanCheng. All rights reserved.
//

#import "BaseModel.h"

NS_ASSUME_NONNULL_BEGIN

//房源管理模型
@interface PrecisPubModel : BaseModel

//主键ID
@property (nonatomic, assign) int FID;

//发布类型
@property (nonatomic, assign) int FPubType;

//楼层
@property (nonatomic,copy) NSString *FStorey;

//备注
@property (nonatomic,copy) NSString *FRemark;

//联系方式
@property (nonatomic,copy) NSString *FLinkTel;

//装修 1.毛坯 2.简装 3.中装 4.精装 5.豪装 6.新装 7.老装
@property (nonatomic, assign) int *FFitment;

//装修名
@property (nonatomic,copy) NSString *FFitmentName;

//新增时间
@property (nonatomic,copy) NSString *FAddTime;

//新增人员id
@property (nonatomic, assign) int *FAddUserID;

//面积
@property (nonatomic,copy) NSString *FArea;

//是否置顶
@property (nonatomic, assign) int *FIsTop;

//小区名称
@property (nonatomic,copy) NSString *FName;

//价格
@property (nonatomic,copy) NSString *FPrice;

@end

NS_ASSUME_NONNULL_END
