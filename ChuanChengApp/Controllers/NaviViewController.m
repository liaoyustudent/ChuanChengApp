//
//  NaviViewController.m
//  ChuanChengApp
//
//  Created by liaoyu on 2018/12/2.
//  Copyright © 2018年 ChuanCheng. All rights reserved.
//

#import "NaviViewController.h"
#import "AdvertViewController.h"
#import "PersonalController.h"

@interface NaviViewController ()

@end

@implementation NaviViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    AdvertViewController *vc2 = [[AdvertViewController alloc] init];
    //[vc2.view addSubview:AdvertTable];
    UINavigationController *navOne=[[UINavigationController alloc]initWithRootViewController:vc2];
    navOne.title = @"一手楼盘";
    navOne.tabBarItem.image=[[UIImage imageNamed:@"ic_shouyeblack"]imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    navOne.tabBarItem.selectedImage=[[UIImage imageNamed:@"ic_shouye"]imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    UIViewController *vc3 = [[UIViewController alloc] init];
    vc3.tabBarItem.image=[[UIImage imageNamed:@"ic_qipao"]imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    vc3.tabBarItem.imageInsets = UIEdgeInsetsMake(-10, 0, 10, 0);
    
    
    
    PersonalController *personnalController=[[PersonalController alloc]init];
    UINavigationController *navPersonnal=[[UINavigationController alloc]initWithRootViewController:personnalController];
    navPersonnal.tabBarItem.image=[[UIImage imageNamed:@"ic_me"]imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    navPersonnal.tabBarItem.selectedImage=[[UIImage imageNamed:@"ic_meblack"]imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    navPersonnal.title = @"个人管理";
    
    UITabBarController *tabBarCtrl = [[UITabBarController alloc] init];
    tabBarCtrl.view.backgroundColor = [UIColor whiteColor];
    tabBarCtrl.viewControllers = @[navOne, vc3, navPersonnal];
    [UIApplication sharedApplication].delegate.window.rootViewController= tabBarCtrl;
    // 取到分栏控制器的分栏
    UITabBar *tabBar = tabBarCtrl.tabBar;
    // 设置分栏的风格
    tabBar.barStyle = UIBarStyleDefault;
    
    [tabBar setBarTintColor:[UIColor colorWithRed:247/255.0 green:247/255.0 blue:247/255.0 alpha:1.0]];
    // 是否透明
    tabBar.translucent = NO;
    [tabBar setBackgroundImage:[UIImage new]];
    [tabBar setShadowImage:[UIImage new]];
    [tabBar setBackgroundColor:[UIColor grayColor]];
}



@end
