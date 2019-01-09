//
//  PageModel.h
//  ChuanChengApp
//
//  Created by liaoyu on 2018/12/23.
//  Copyright © 2018年 ChuanCheng. All rights reserved.
//

#import "BaseModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface PageModel : BaseModel
//当前页
@property (nonatomic, assign) int currentPage;
//是否有下一页
@property (nonatomic, assign) BOOL hasNextPage;
//总页数
@property (nonatomic, assign) int totalRecords;

@end

NS_ASSUME_NONNULL_END
