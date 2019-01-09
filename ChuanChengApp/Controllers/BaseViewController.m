//
//  BaseViewController.m
//  ChuanChengApp
//  基类
//  Created by liaoyu on 2018/12/23.
//  Copyright © 2018年 ChuanCheng. All rights reserved.
//

#import "BaseViewController.h"
@interface BaseViewController ()<UINavigationControllerDelegate>{
    
}

@end

@implementation BaseViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    self.tokenKey=[userDefaults objectForKey:@"TOKEN_KEY"];
    self.AuthorizationStr=[NSString stringWithFormat:@"%@%@",@"Bearer ",self.tokenKey];
}


- (void)navigationController:(UINavigationController*)navigationController willShowViewController:(UIViewController*)viewController animated:(BOOL)animated
{
    if(viewController == self){
        [self.navController setNavigationBarHidden:YES animated:animated];
    }else{
        //不在本页时，显示真正的nav bar
        [self.navController setNavigationBarHidden:NO animated:animated];
        //当不显示本页时，要么就push到下一页，要么就被pop了，那么就将delegate设置为nil，防止出现BAD ACCESS
        //之前将这段代码放在viewDidDisappear和dealloc中，这两种情况可能已经被pop了，self.navigationController为nil，这里采用手动持有navigationController的引用来解决
        if(self.navController.delegate == self){
            //如果delegate是自己才设置为nil，因为viewWillAppear调用的比此方法较早，其他controller如果设置了delegate就可能会被误伤
            self.navController.delegate = nil;
        }
    }
}

//自动消失的弹窗消息
-(void)AlertTips:(NSString *)tipStr{
    //声明一个label对象
    UILabel *tiplabel = [[UILabel alloc]initWithFrame:CGRectMake(UISCreen_Width/2-60, UISCreen_Height/2-15, 120, 30)];
    //设置提示内容
    [tiplabel setText:tipStr];
    tiplabel.backgroundColor = [UIColor blackColor];
    tiplabel.alpha =0.5;
    tiplabel.layer.cornerRadius=5;
    tiplabel.layer.masksToBounds = YES;
    tiplabel.textAlignment = NSTextAlignmentCenter;
    tiplabel.textColor = [UIColor whiteColor];
    [self.view addSubview:tiplabel];
    
    //设置时间和动画效果
    [UIView animateWithDuration:2.0 animations:^{
        tiplabel.alpha =0.0;
    } completion:^(BOOL finished) {
        //删除弹窗
        [tiplabel removeFromSuperview];
    }];
    
}


@end
