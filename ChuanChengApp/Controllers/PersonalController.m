//
//  PersonalController.m
//  ChuanChengApp
//  个人管理
//  Created by liaoyu on 2018/12/16.
//  Copyright © 2018年 ChuanCheng. All rights reserved.
//

#import "PersonalController.h"
#import "PersonalModel.h"
#import "CollectionViewController.h"
#import "PrecisePubViewController.h"

@interface PersonalController()<UITableViewDelegate,UITableViewDataSource>{
    CGFloat _tableHeight;
    NSString *_FUserMobile;
}

@property (nonatomic, strong) NSMutableArray *PersonalList;
@property (nonatomic, strong) UITableView *PersonalTableView;
@property (nonatomic, strong) UIView *HeaderView;

@end

@implementation PersonalController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor=[UIColor whiteColor];
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    _tableHeight=IS_IPHONE_X?UISCreen_Height-150:UISCreen_Height-100;
    _FUserMobile=[userDefaults objectForKey:@"FMobile"];
    [self GetPersonnalList];
    //设置下个页面的返回按钮
    UIBarButtonItem *backItem=[[UIBarButtonItem alloc]init];
    backItem.title = @"";
    self.navigationItem.backBarButtonItem = backItem;
    
    //布局头部View
    self.HeaderView=[self LayoutHeaderView];
    [self.view addSubview:self.HeaderView];
    
    //初始化列表
    UITableView *tableView=[[UITableView alloc]initWithFrame:CGRectMake(0, StatusBarHeight+230, UISCreen_Width, _tableHeight)];
    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    tableView.delegate=self;
    tableView.dataSource=self;
    tableView.scrollEnabled = NO;
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
    //联系方式行
    if(indexPath.row==0){
        UIView *MobileView=[[UIView alloc]initWithFrame:CGRectMake(UISCreen_Width-130, 22, 100, 15)];
        UILabel *MobileLbl = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 100, 15)];
        MobileLbl.numberOfLines = 0;
        NSMutableAttributedString *mobileStr = [[NSMutableAttributedString alloc] initWithString:_FUserMobile attributes:@{NSFontAttributeName: [UIFont fontWithName:@"PingFangSC-Regular" size: 15],NSForegroundColorAttributeName: [UIColor colorWithRed:153/255.0 green:153/255.0 blue:153/255.0 alpha:1.0]}];
        MobileLbl.attributedText = mobileStr;
        [MobileView addSubview:MobileLbl];
        
        [cell addSubview:MobileView];
    }
    
    return cell;
}

// 选中了 cell 时触发
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    switch (indexPath.row) {
        case 1:
            [self GotoPrecisePub];
            break;
        case 2://我的收藏
            [self GotoCollectionVc];
            break;
        case 4://退出登录
            [self DoLogOut];
            break;
        default:
            break;
    }
    
    //NSLog(@"选中了第%li个cell", (long)indexPath.row);
}

//布局头部View
-(UIView *)LayoutHeaderView{
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    //背景图片
    UIView *hView=[[UIView alloc]initWithFrame:CGRectMake(0, 0, UISCreen_Width, 200)];
    UIImageView *headerImgBG=[[UIImageView alloc]initWithFrame:CGRectMake(0, 0, UISCreen_Width, 200)];
    headerImgBG.image=[UIImage imageNamed:@"pic_dingbu"];
    headerImgBG.contentMode = UIViewContentModeScaleAspectFill;
    headerImgBG.autoresizingMask = UIViewAutoresizingFlexibleWidth;
    headerImgBG.clipsToBounds  = YES;
    [hView addSubview:headerImgBG];
    
    //联系我们
    UILabel *lbTelLink = [[UILabel alloc] init];
    lbTelLink.frame = CGRectMake(UISCreen_Width-90,StatusBarHeight+7,60,14.5);
    lbTelLink.text = @"联系我们";
    lbTelLink.font = [UIFont fontWithName:@"PingFangSC-Regular" size:15];
    lbTelLink.textColor = [UIColor whiteColor];
    
    UITapGestureRecognizer *singleTapForget =[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(onClickLinkUs)];
    [lbTelLink addGestureRecognizer:singleTapForget];
    [lbTelLink setUserInteractionEnabled:YES];
    [hView addSubview:lbTelLink];
    //头像
    UIImageView *headImg=[[UIImageView alloc]initWithFrame:CGRectMake((UISCreen_Width-77)/2, 100, 70, 70)];
    NSNumber *userID=[userDefaults objectForKey:@"UserId"];
    NSString *headImgUrl=[NSString stringWithFormat:@"/api/Filse/GetPortrait?UserID=%@",userID];
    NSString *FullImgUrl=[NSString stringWithFormat:@"%@%@",SERVSER_URL,headImgUrl];
    [headImg sd_setImageWithURL:FullImgUrl placeholderImage:[UIImage imageNamed:@"ic_touxiangbeijing"]];
    //headImg.image=[UIImage imageNamed:@"ic_touxiangbeijing"];
    headImg.contentMode=UIViewContentModeScaleAspectFill;
    headImg.clipsToBounds=YES;
    headImg.layer.cornerRadius =headImg.frame.size.width / 2 ;
    headImg.layer.borderColor = [UIColor whiteColor].CGColor;
    headImg.layer.borderWidth = 2;
    [hView addSubview:headImg];
    
    return  hView;
}

//我的收藏
-(void)GotoCollectionVc{
    CollectionViewController *collectionVC=[[CollectionViewController alloc]init];
    //跳转到我的收藏列表
    [self.navigationController pushViewController:collectionVC animated:YES];
    
}
//房源管理
-(void)GotoPrecisePub{
    PrecisePubViewController *precisePubVC=[[PrecisePubViewController alloc]init];
    //跳转到房源管理
    [self.navigationController pushViewController:precisePubVC animated:YES];
    
}

//退出登录
-(void)DoLogOut{
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"是否确认退出" message:nil preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *confirmAction = [UIAlertAction actionWithTitle:@"是" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
            NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
            [userDefaults removeObjectForKey:@"pwd"];
            [userDefaults synchronize];
            [MyTools GotoLogin];
    }];
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"否" style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {

    }];
    
    [alertController addAction:confirmAction];
    [alertController addAction:cancelAction];
    dispatch_async(dispatch_get_main_queue(), ^{
        [self presentViewController: alertController animated: YES completion: nil];
    });
    

}

//点击联系我们
-(void)onClickLinkUs{
    NSString *tel=@"057766861727";
    NSMutableString *str=[[NSMutableString alloc]initWithFormat:@"tel:%@",tel];
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:nil message:tel preferredStyle:UIAlertControllerStyleAlert];
    //取消按钮
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
        
    }];
    //呼叫按钮
    UIAlertAction *otherAction = [UIAlertAction actionWithTitle:@"呼叫" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:str] options:@{UIApplicationOpenURLOptionsSourceApplicationKey : @YES}  completionHandler:^(BOOL success) {
            if(!success){
                
            }
        }];
    }];
    [alertController addAction:cancelAction];
    
    [alertController addAction:otherAction];
    
    [self presentViewController:alertController animated:YES completion:nil];
    
}
//隐藏导航栏
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.navigationController.delegate = self;
    self.navController = self.navigationController;
}

@end
