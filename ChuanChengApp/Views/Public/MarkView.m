//
//  MarkView.m
//  ChuanChengApp
//
//  Created by liaoyu on 2018/11/15.
//  Copyright © 2018年 ChuanCheng. All rights reserved.
//

#import "MarkView.h"
#import "Constant.h"

@interface MarkView()
{
    NSInteger _count;
    NSInteger _currmentIndex;
    NSInteger _Height;
    NSInteger _extendLineWidth;//下划线额外长度
}

@property (nonatomic, strong) NSMutableArray *marksTitle;
@property (nonatomic, assign) CGFloat titlesWidth;
@property (nonatomic, strong) UIView *redLine;
@property (nonatomic, strong) NSMutableArray *redLineWidthArr;
@property (nonatomic, strong) NSMutableArray<UILabel *> *labelsArr;
@property (nonatomic,strong)  UIView *grayLineview;

@end


@implementation MarkView

- (instancetype)initWithFrame:(CGRect)frame marks:(NSArray *)marks {
    return [self initWithFrame:frame marks:marks redLineWidth:100];
}

- (instancetype)initWithFrame:(CGRect)frame marks:(NSArray *)marks redLineWidth:(CGFloat)redLineWidth {
    self = [super initWithFrame:frame];
    if (self) {
        self.cancelAnimated=false;
        _Height=StatusBarHeight;
        _extendLineWidth=16;
        self.marksTitle = marks.mutableCopy;
        self.labelsArr = [NSMutableArray array];
        self.redLineWidthArr = [NSMutableArray arrayWithCapacity:0];
        //[self addUnderLine];
        self.backgroundColor = [UIColor whiteColor];
        _count = marks.count;
        
        CGFloat titleW = 0;
        CGFloat h = 0;
        for (NSString *title in marks) {
            CGSize size=[title boundingRectWithSize:CGSizeMake( UISCreen_Width- 20, CGFLOAT_MAX)
                                            options:NSStringDrawingUsesFontLeading | NSStringDrawingUsesLineFragmentOrigin
                                         attributes:@{NSFontAttributeName:[UIFont fontWithName:@"PingFangSC-Regular" size:16]}
                                            context:nil].size;
            titleW += size.width;
            h = size.height;
            [self.redLineWidthArr addObject:@(size.width)];
        }
        self.titlesWidth = titleW;
        
        CGFloat space = (UISCreen_Width-titleW)/(marks.count+1);
        CGFloat x = space;
        for (int i = 0; i < marks.count; i++) {
            CGFloat w = [self.redLineWidthArr[i] floatValue];
            if (i > 0) {
                x = self.labelsArr[i-1].frame.origin.x+self.labelsArr[i-1].frame.size.width+space;
            }
            UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(x, 0, w, h)];
            label.text = marks[i];
            label.textColor = i == 0 ? [UIColor colorWithRed:110/255.0 green:145/255.0 blue:245/255.0 alpha:1] : [UIColor colorWithRed:51/255.0 green:51/255.0 blue:51/255.0 alpha:1];
            label.font = [UIFont fontWithName:@"PingFangSC-Regular" size:16];
            label.textAlignment = NSTextAlignmentCenter;
            label.adjustsFontSizeToFitWidth = YES;
            label.userInteractionEnabled = YES;
            label.tag = i + 100;
            [self addSubview:label];
            [self.labelsArr addObject:label];
            
            UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapLabel:)];
            [label addGestureRecognizer:tap];
            
            
        }
        //增加底部选中时的蓝线
        UILabel *l = self.labelsArr[0];
        CGFloat w = [self.redLineWidthArr[0] floatValue];
        self.redLine = [[UIView alloc] initWithFrame:CGRectMake(l.frame.origin.x-_extendLineWidth/2, h+10, w+_extendLineWidth, 2)];
        _redLine.backgroundColor = [UIColor colorWithRed:110/255.0 green:145/255.0 blue:245/255.0 alpha:1];
        [self addSubview:_redLine];
        
        //增加最底部灰线
        self.grayLineview = [[UIView alloc] init];
        _grayLineview.frame = CGRectMake(0,h+12,UISCreen_Width,0.5);
        _grayLineview.backgroundColor = [UIColor colorWithRed:238/255.0 green:238/255.0 blue:238/255.0 alpha:1];
        
        self.bottom=h+12;
        [self addSubview:_grayLineview];
    }
    return self;
}

- (void)setIndex:(NSInteger)index {
    _currmentIndex = index;
    
    CGRect frame = self.redLine.frame;
    UILabel *l = self.labelsArr[_currmentIndex];
    frame.origin.x = l.frame.origin.x-_extendLineWidth/2;
    frame.size.width = [self.redLineWidthArr[_currmentIndex] floatValue]+_extendLineWidth;
    
    [UIView animateWithDuration:0.3 animations:^{
        self.redLine.frame = frame;
    }];
    for (UILabel *label in _labelsArr) {
        if (label.tag == (_currmentIndex + 100)) {
            label.textColor = [UIColor colorWithRed:110/255.0 green:145/255.0 blue:245/255.0 alpha:1];
        } else {
            label.textColor = [UIColor colorWithRed:51/255.0 green:51/255.0 blue:51/255.0 alpha:1];
        }
    }
}


- (void)tapLabel:(UITapGestureRecognizer *)tap {
    if (_currmentIndex != (tap.view.tag - 100) ) {
        _currmentIndex = (tap.view.tag - 100);
        
        
        if (self.HandleClick) {
            self.HandleClick(_currmentIndex);
        }
        //[[NSNotificationCenter defaultCenter] postNotificationName:kMarkViewClickKey object:@(_currmentIndex)];
    }
    
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    _currmentIndex = round(scrollView.contentOffset.x/UISCreen_Width);
    
    [self setIndex:_currmentIndex];
}


@end
