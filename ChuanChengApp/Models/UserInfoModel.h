//
//  UserInfoModel.h
//  ChuanChengApp
//
//  Created by liaoyu on 2018/12/20.
//  Copyright © 2018年 ChuanCheng. All rights reserved.
//

#import "BaseModel.h"

NS_ASSUME_NONNULL_BEGIN
//用户信息模型
@interface UserInfoModel : BaseModel
//用户id
@property (nonatomic, assign) int UserId;
//昵称
@property (nonatomic,copy) NSString *UserName;
//头像地址
@property (nonatomic,copy) NSString *FImgUrl;
//是否是VIP
@property (nonatomic,copy) NSString *IsVIP;
//联系方式
@property (nonatomic,copy) NSString *FMobile;
@end

NS_ASSUME_NONNULL_END
