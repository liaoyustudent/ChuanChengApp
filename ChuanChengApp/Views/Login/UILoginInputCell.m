//
//  UILoginInputCell.m
//  ChuanChengApp
//
//  Created by liaoyu on 2018/11/19.
//  Copyright © 2018年 ChuanCheng. All rights reserved.
//

#import "UILoginInputCell.h"
#import "Constant.h"
@interface UILoginInputCell(){
    
    
}
@end

@implementation UILoginInputCell

-(id)initWithPoint:(CGPoint)point placeholder:(NSString *)placeholder picName:(NSString*)picName{
    
    self= [super initWithFrame:CGRectMake(point.x, point.y, UISCreen_Width, 50)];
    if(self){
        //图片初始化
        UIImage *leftImg = [UIImage imageNamed:picName];
        UIImageView *leftImgView=[[UIImageView alloc]initWithFrame:CGRectMake(35, 27, leftImg.size.width, leftImg.size.height)];
        [leftImgView setImage:leftImg];
        [self addSubview:leftImgView];
        //输入框初始化
        UITextField *txtfield=[[UITextField alloc]initWithFrame:CGRectMake(65, 27, self.frame.size.width-63, 20)];
        txtfield.placeholder=placeholder;
        txtfield.font=[UIFont fontWithName:@"PingFang-SC-Regular" size:15];
        txtfield.keyboardType=UIKeyboardTypeDefault;
        [self addSubview:txtfield];
        self.CellTextField=txtfield;
        //初始化分割线
        UIView *viewSpace = [[UIView alloc] init];
        viewSpace.frame = CGRectMake(31,70,UISCreen_Width-2*31,0.5);
        viewSpace.backgroundColor = [UIColor colorWithRed:232/255.0 green:232/255.0 blue:235/255.0 alpha:1];
        [self addSubview:viewSpace];
    }
    
    return  self;
}

-(void)setCellText:(NSString *)text{
    _cellText=text;
    if(_CellTextField){
        _CellTextField.text=text;
    }
}
-(NSString *)cellText{
    NSString *text=@"";
    if(_CellTextField){
        text=_CellTextField.text;
    }
    return text;
}

@end
