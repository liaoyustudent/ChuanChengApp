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

///设置红线高度
- (void)setIndoctorHeight:(CGFloat)indictorHeight;
- (void)scrollViewDidScroll:(UIScrollView *)scrollView;
- (NSInteger)currrentIndex;

///设置标题
- (void)setLabelText:(NSString *)text atIndex:(NSInteger)index;
@property (nonatomic, copy) void(^HandleClick)(NSInteger index);
@property (nonatomic, assign) BOOL cancelAnimated;
@property (assign, nonatomic)int bottom;
@end

NS_ASSUME_NONNULL_END
