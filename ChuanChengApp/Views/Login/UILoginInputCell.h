//
//  UILoginInputCell.h
//  ChuanChengApp
//
//  Created by liaoyu on 2018/11/19.
//  Copyright © 2018年 ChuanCheng. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UILoginInputCell : UIView
{
    NSString *_cellText;
}

-(UILoginInputCell *)initWithPoint:(CGPoint)point placeholder:(NSString *)placeholder picName:(NSString*)picName;


@property (nonatomic,strong) UITextField *CellTextField;
@end

NS_ASSUME_NONNULL_END
