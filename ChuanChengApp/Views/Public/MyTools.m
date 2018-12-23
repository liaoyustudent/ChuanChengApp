//
//  MyTools.m
//  ChuanChengApp
//
//  Created by liaoyu on 2018/12/23.
//  Copyright © 2018年 ChuanCheng. All rights reserved.
//

#import "MyTools.h"

@implementation MyTools

+(void)GotoLogin{
    
    ViewController *vc=[[ViewController alloc]init];
    [self restoreRootViewController:vc];
}


// 登陆后淡入淡出更换rootViewController
+ (void)restoreRootViewController:(UIViewController *)rootViewController
{
    typedef void (^Animation)(void);
    UIWindow* window = [UIApplication sharedApplication].keyWindow;
    
    rootViewController.modalTransitionStyle = UIModalTransitionStyleCoverVertical;
    Animation animation = ^{
        BOOL oldState = [UIView areAnimationsEnabled];
        [UIView setAnimationsEnabled:NO];
        [UIApplication sharedApplication].delegate.window.rootViewController = rootViewController;
        [UIView setAnimationsEnabled:oldState];
    };
    
    [UIView transitionWithView:window
                      duration:0.5f
                       options:UIViewAnimationOptionTransitionFlipFromBottom
                    animations:animation
                    completion:nil];
}

@end
