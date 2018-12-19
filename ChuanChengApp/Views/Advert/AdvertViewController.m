//
//  AdvertViewController.m
//  ChuanChengApp
//
//  Created by liaoyu on 2018/12/2.
//  Copyright © 2018年 ChuanCheng. All rights reserved.
//

#import "AdvertViewController.h"
#import "Constant.h"


@interface AdvertViewController ()<UITableViewDelegate,UITableViewDataSource>

@end

@implementation AdvertViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    UITableView *AdvertTable=[[UITableView alloc]initWithFrame:CGRectMake(0, StatusBarHeight, UISCreen_Width, UISCreen_Height)];
    AdvertTable.delegate=self;
    AdvertTable.dataSource=self;
    [self.view addSubview:AdvertTable];
}

//一个大块
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return  1;
}
//5行
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 5;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    NSString *time=@"2018-11-11 09:42";
    /*CGSize timeSize=[time boundingRectWithSize:CGSizeMake( UISCreen_Width- 20, CGFLOAT_MAX)
                                    options:NSStringDrawingUsesFontLeading | NSStringDrawingUsesLineFragmentOrigin
                                 attributes:@{NSFontAttributeName:[UIFont fontWithName:@"PingFangSC-Regular" size:16]}
                                    context:nil].size;*/
    
    UITableViewCell *cell=[[UITableViewCell alloc]initWithFrame:CGRectMake(0, 20, UISCreen_Width, 240)];
    
    
    
    /*
    UIView *cellView=[[UIView alloc]initWithFrame:CGRectMake(15, 0, UISCreen_Width-30, 240)];
    UIView *timeView = [[UIView alloc] initWithFrame:CGRectMake(UISCreen_Width/2-timeSize.width/2, 0, timeSize.width, 20)];
    [cellView addSubview:timeView];
    [cell addSubview:cellView];
    */
    return cell;
}

@end
