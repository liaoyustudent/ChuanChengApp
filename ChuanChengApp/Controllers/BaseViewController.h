//
//  BaseViewController.h
//  ChuanChengApp
//
//  Created by liaoyu on 2018/12/23.
//  Copyright © 2018年 ChuanCheng. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Constant.h"
#import "UIImageView+WebCache.h"
#import "MyTools.h"
#import "HqAFHttpClient.h"
#import "MJRefresh.h"
#import "UIScrollView+MJRefresh.h"
#import "BaseServerModel.h"
#import "PageModel.h"
#import <QuartzCore/QuartzCore.h>

@interface BaseViewController : UIViewController
//token
@property (nonatomic, strong) NSString *tokenKey;
@property (nonatomic,strong) NSString *AuthorizationStr;
@property(nonatomic,weak) UINavigationController *navController;

//自动消失的弹窗消息
-(void)AlertTips:(NSString *)tipStr;
@end


