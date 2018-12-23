//
//  MarkView.h
//  ChuanChengApp
//
//  Created by liaoyu on 2018/11/15.
//  Copyright © 2018年 ChuanCheng. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface MarkView : UIView
//根据标题初始化
-(instancetype)initWithFrame:(CGRect)frame marks:(NSArray *)marks;

///设置下标
- (void)setIndex:(NSInteger)index;

- (void)scrollViewDidScroll:(UIScrollView *)scrollView;


@property (nonatomic, copy) void(^HandleClick)(NSInteger index);
@property (nonatomic, assign) BOOL cancelAnimated;
@property (assign, nonatomic)int bottom;
@end

NS_ASSUME_NONNULL_END
