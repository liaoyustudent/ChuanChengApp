//
//  PersonalController.m
//  ChuanChengApp
//
//  Created by liaoyu on 2018/12/16.
//  Copyright © 2018年 ChuanCheng. All rights reserved.
//

#import "PersonalController.h"
#import "Constant.h"
#import "PersonalModel.h"

@interface PersonalController()<UITableViewDelegate,UITableViewDataSource>{
    CGFloat _tableHeight;
}

@property (nonatomic, strong) NSMutableArray *PersonalList;
@property (nonatomic, strong) UITableView *PersonalTableView;
@property (nonatomic, strong) UIView *HeaderView;

@end

@implementation PersonalController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor=[UIColor whiteColor];
    _tableHeight=IS_IPHONE_X?UISCreen_Height-150:UISCreen_Height-100;
    [self GetPersonnalList];
    
    //布局头部View
    self.HeaderView=[self LayoutHeaderView];
    [self.view addSubview:self.HeaderView];
    
    //初始化列表
    UITableView *tableView=[[UITableView alloc]initWithFrame:CGRectMake(0, StatusBarHeight+230, UISCreen_Width, _tableHeight)];
    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    tableView.delegate=self;
    tableView.dataSource=self;
    self.PersonalTableView=tableView;
    [self.view addSubview:tableView];
    
}

//获取列表
-(void)GetPersonnalList{
    self.PersonalList=[[NSMutableArray alloc]init];
    //联系电话
    PersonalModel *telModel=[[PersonalModel alloc]init];
    telModel.FTitle=@"联系电话";
    telModel.FController=@"";
    [self.PersonalList addObject:telModel];
    //房源管理
    PersonalModel *houseManager=[[PersonalModel alloc]init];
    houseManager.FTitle=@"房源管理";
    houseManager.FController=@"";
    [self.PersonalList addObject:houseManager];
    //我的收藏
    PersonalModel *collection=[[PersonalModel alloc]init];
    collection.FTitle=@"我的收藏";
    collection.FController=@"";
    [self.PersonalList addObject:collection];
    //修改密码
    PersonalModel *modifyPwd=[[PersonalModel alloc]init];
    modifyPwd.FTitle=@"修改密码";
    modifyPwd.FController=@"";
    [self.PersonalList addObject:modifyPwd];
    //退出登录
    PersonalModel *logOff=[[PersonalModel alloc]init];
    logOff.FTitle=@"退出登录";
    logOff.FController=@"";
    [self.PersonalList addObject:logOff];
}

//一个大块
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return  1;
}
//5行
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.PersonalList.count;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 55;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    // 0.重用标识
    // 被static修饰的局部变量：只会初始化一次，在整个程序运行过程中，只有一份内存
    static NSString *personalIdentifier = @"personalCell";
    // 1.先根据cell的标识去缓存池中查找可循环利用的cell
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:personalIdentifier];
    // 2.如果cell为nil（缓存池找不到对应的cell）
    if (cell == nil) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:personalIdentifier];
    }
    //设置标题
    PersonalModel *model= [_PersonalList objectAtIndex:[indexPath row]];
    UILabel *titleLbl=[[UILabel alloc]initWithFrame:CGRectMake(37, 22, 100, 15)];
    titleLbl.text=model.FTitle;
    NSMutableAttributedString *attrStr = [[NSMutableAttributedString alloc] initWithString:model.FTitle attributes:@{NSFontAttributeName: [UIFont fontWithName:@"PingFangSC-Regular" size: 15],NSForegroundColorAttributeName: [UIColor colorWithRed:51/255.0 green:51/255.0 blue:51/255.0 alpha:1.0]}];
    titleLbl.attributedText=attrStr;
    [cell.contentView addSubview:titleLbl];
    
    //初始化分割线
    UIView *viewSpace = [[UIView alloc] init];
    viewSpace.frame = CGRectMake(31,54,UISCreen_Width-2*31,0.5);
    viewSpace.backgroundColor = [UIColor colorWithRed:232/255.0 green:232/255.0 blue:235/255.0 alpha:1];
    [cell.contentView addSubview:viewSpace];
    
    //没有控制器可以跳转，取消选中效果,且没有箭头
    if([[model.FController stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]] length]==0 ){
        //取消选中效果
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    else{
        //右侧箭头
        UIImageView *arrowImage=[[UIImageView alloc]initWithFrame:CGRectMake(UISCreen_Width-40, 20, 8, 15)];
        arrowImage.image=[UIImage imageNamed:@"ic_Back"];
        [cell.contentView addSubview:arrowImage];
    }
    
    return cell;
}

//布局头部View
-(UIView *)LayoutHeaderView{
    UIView *hView=[[UIView alloc]initWithFrame:CGRectMake(0, StatusBarHeight+40, UISCreen_Width, 200)];
    UIImageView *headerImgBG=[[UIImageView alloc]initWithFrame:CGRectMake(0, 0, UISCreen_Width, 200)];
    headerImgBG.image=[UIImage imageNamed:@"pic_dingbu"];
    headerImgBG.contentMode = UIViewContentModeScaleAspectFill;
    headerImgBG.autoresizingMask = UIViewAutoresizingFlexibleWidth;
    headerImgBG.clipsToBounds  = YES;
    [hView addSubview:headerImgBG];
    
    UIImageView *headImg=[[UIImageView alloc]initWithFrame:CGRectMake((UISCreen_Width-77)/2, 100, 77, 77)];
    headImg.image=[UIImage imageNamed:@"ic_touxiangbeijing"];
    headImg.contentMode=UIViewContentModeScaleAspectFill;
    headImg.clipsToBounds=YES;
    [hView addSubview:headImg];
    
    return  hView;
}

@end
