//
//  PrecisePubViewController.m
//  ChuanChengApp
//
//  Created by liaoyu on 2019/1/2.
//  Copyright © 2019年 ChuanCheng. All rights reserved.
//

#import "PrecisePubViewController.h"
#import "PrecisPubModel.h"

@interface PrecisePubViewController()<UITableViewDelegate,UITableViewDataSource>{
    NSInteger _pageIndex;//当前页
    NSInteger _pageSize;//每页行数
}

@property (nonatomic, strong) NSMutableArray *precisePubList;
@property (nonatomic, strong) UITableView *precisePubTableView;
@end

@implementation PrecisePubViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor=[UIColor colorWithRed:247/255.0 green:247/255.0 blue:247/255.0 alpha:1.0];
    self.navigationItem.title=@"房源管理";
    
    //初始化分页相关参数
    [self InitPageParam];
    //获取初始化列表
    [self GetTableList];
    
    //初始化tableview
    CGFloat tableHeight=IS_IPHONE_X?UISCreen_Height-150:UISCreen_Height-100;
    UITableView *tableView=[[UITableView alloc]initWithFrame:CGRectMake(0, StatusBarHeight+40, UISCreen_Width, tableHeight)];
    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    tableView.delegate=self;
    tableView.dataSource=self;
    tableView.estimatedRowHeight =0;
    tableView.estimatedSectionHeaderHeight =0;
    tableView.estimatedSectionFooterHeight =0;
    self.precisePubTableView=tableView;
    [self.view addSubview:tableView];
    
    //下拉刷新
    self.precisePubTableView.mj_header=[MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(refresh)];
    //上拉加载
    self.precisePubTableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMore)];
    
}

//初始化分页相关参数
-(void)InitPageParam{
    _pageIndex=1;
    _pageSize=20;
    self.precisePubList=[[NSMutableArray alloc]init];
    [self.precisePubTableView.mj_footer resetNoMoreData];
}

//获取列表
-(void)GetTableList{
    
    NSDictionary *Httpheaders=@{@"Authorization":self.AuthorizationStr };
    
    [HqAFHttpClient starRequestWithHeaders:Httpheaders withURLString:@"/api/PrecisePub/GetPrecisePub" withParam:@{@"curr":[NSString stringWithFormat:@"%d",_pageIndex],@"pageSize":[NSString stringWithFormat:@"%d",_pageSize]} requestIsNeedJson:FALSE responseIsNeedJson:TRUE method:Post wihtCompleBlock:^(NSHTTPURLResponse *response, id responseObject) {
        //下拉加载框关闭
        [self.precisePubTableView.mj_header endRefreshing];
        BaseServerModel *result= [BaseServerModel modelWithDictionary:responseObject];
        
        if(result.code==2){
            //登录状态过期
            [MyTools GotoLogin];
        }
        if(result.code==1){
            PageModel *pageInfo=[PageModel modelWithDictionary:result.page];
            if(pageInfo.hasNextPage){
                _pageIndex++;
            }
            else{
                //关闭上拉加载
                [self.precisePubTableView.mj_footer endRefreshingWithNoMoreData];
            }
            for (NSDictionary *precisPubdic in result.object) { /** 便是数组 */
                PrecisPubModel *precisPub=[PrecisPubModel modelWithDictionary:precisPubdic];
                [self.precisePubList addObject:precisPub];
            }
            [self.precisePubTableView reloadData];
        }else{
            UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"获取列表失败" message:result.message preferredStyle:UIAlertControllerStyleAlert];
            UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
            }];
            [alertController addAction:cancelAction];
            [self presentViewController:alertController animated:YES completion:nil];
        }
        
    }];
}

-(void)refresh
{
    //初始化分页相关参数
    [self InitPageParam];
    //获取初始列表
    [self GetTableList];
    
    [self.precisePubTableView reloadData];
    
}
-(void)loadMore
{
    //获取列表
    [self GetTableList];
    
    [self.precisePubTableView reloadData];
}

//一个大块
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return  1;
}
//5行
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.precisePubList.count;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    
//    PrecisPubModel *precisPub=[[PrecisPubModel alloc]init];
//    precisPub=[self.precisePubList objectAtIndex:[indexPath row]];
//    NSString *FRemark=precisPub.FRemark;
//
//    CGSize contentSize=[FRemark boundingRectWithSize:CGSizeMake( UISCreen_Width- 50, CGFLOAT_MAX)
//                                              options:NSStringDrawingUsesFontLeading | NSStringDrawingUsesLineFragmentOrigin
//                                           attributes:@{NSFontAttributeName:[UIFont fontWithName:@"PingFangSC-Regular" size:15]}
//                                              context:nil].size;
//    return contentSize.height+180;
    return 190;
}


//渲染单元
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    // 0.重用标识
    // 被static修饰的局部变量：只会初始化一次，在整个程序运行过程中，只有一份内存
    static NSString *collectionifier = @"precisPubCell";
    // 1.先根据cell的标识去缓存池中查找可循环利用的cell
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:collectionifier];
    // 2.如果cell为nil（缓存池找不到对应的cell）
    if (cell == nil) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:collectionifier];
    }
    else{
        while ([cell.contentView.subviews lastObject] != nil) {
            [(UIView*)[cell.contentView.subviews lastObject] removeFromSuperview];  //删除并进行重新分配
        }
    }
    
    cell.backgroundColor=[UIColor colorWithRed:247/255.0 green:247/255.0 blue:247/255.0 alpha:1.0];
    [cell setFrame:CGRectMake(0, 20, UISCreen_Width, 240)];
    //取消选中效果
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    PrecisPubModel *model=[[PrecisPubModel alloc]init];
    model=[self.precisePubList objectAtIndex:[indexPath row]];
    
    UIView *cellView=[[UIView alloc]initWithFrame:CGRectMake(0, 0, UISCreen_Width, 180)];
    cellView.backgroundColor=[UIColor whiteColor];
    [cell.contentView addSubview:cellView];
    //小区名称
    UILabel *FNameTitle=[[UILabel alloc]initWithFrame:CGRectMake(25, 17, 50, 15)];
    FNameTitle.text=@"小区：";
    FNameTitle.font=[UIFont fontWithName:@"PingFangSC-Regular" size:15];
    FNameTitle.textColor=[UIColor colorWithRed:153/255.0 green:153/255.0 blue:153/255.0 alpha:1.0];
    [cellView addSubview:FNameTitle];
    UILabel *FNameLbl=[[UILabel alloc]initWithFrame:CGRectMake(75, 17, UISCreen_Width/2-75, 15)];
    FNameLbl.text=model.FName;
    FNameLbl.font=[UIFont fontWithName:@"PingFangSC-Regular" size:15];
    FNameLbl.textColor=[UIColor colorWithRed:51/255.0 green:51/255.0 blue:51/255.0 alpha:1.0];
    [cellView addSubview:FNameLbl];
    //装修
    UILabel *FitmentTitle=[[UILabel alloc]initWithFrame:CGRectMake(UISCreen_Width/2, 17, 50, 15)];
    FitmentTitle.text=@"装修：";
    FitmentTitle.font=[UIFont fontWithName:@"PingFangSC-Regular" size:15];
    FitmentTitle.textColor=[UIColor colorWithRed:153/255.0 green:153/255.0 blue:153/255.0 alpha:1.0];
    [cellView addSubview:FitmentTitle];
    UILabel *FitmentLbl=[[UILabel alloc]initWithFrame:CGRectMake(UISCreen_Width/2+50, 17, UISCreen_Width/2-75, 15)];
    FitmentLbl.text=model.FFitmentName;
    FitmentLbl.font=[UIFont fontWithName:@"PingFangSC-Regular" size:15];
    FitmentLbl.textColor=[UIColor colorWithRed:51/255.0 green:51/255.0 blue:51/255.0 alpha:1.0];
    [cellView addSubview:FitmentLbl];
    //面积
    UILabel *FAreaTitle=[[UILabel alloc]initWithFrame:CGRectMake(25, 41, 50, 15)];
    FAreaTitle.text=@"面积：";
    FAreaTitle.font=[UIFont fontWithName:@"PingFangSC-Regular" size:15];
    FAreaTitle.textColor=[UIColor colorWithRed:153/255.0 green:153/255.0 blue:153/255.0 alpha:1.0];
    [cellView addSubview:FAreaTitle];
    UILabel *FAreaLbl=[[UILabel alloc]initWithFrame:CGRectMake(75, 41, UISCreen_Width/2-75, 15)];
    FAreaLbl.text=model.FArea;
    FAreaLbl.font=[UIFont fontWithName:@"PingFangSC-Regular" size:15];
    FAreaLbl.textColor=[UIColor colorWithRed:51/255.0 green:51/255.0 blue:51/255.0 alpha:1.0];
    [cellView addSubview:FAreaLbl];
    //楼层
    UILabel *FStoreyTitle=[[UILabel alloc]initWithFrame:CGRectMake(UISCreen_Width/2, 41, 50, 15)];
    FStoreyTitle.text=@"楼层：";
    FStoreyTitle.font=[UIFont fontWithName:@"PingFangSC-Regular" size:15];
    FStoreyTitle.textColor=[UIColor colorWithRed:153/255.0 green:153/255.0 blue:153/255.0 alpha:1.0];
    [cellView addSubview:FStoreyTitle];
    UILabel *FStoreyLbl=[[UILabel alloc]initWithFrame:CGRectMake(UISCreen_Width/2+50, 41, UISCreen_Width/2-75, 15)];
    FStoreyLbl.text=model.FStorey;
    FStoreyLbl.font=[UIFont fontWithName:@"PingFangSC-Regular" size:15];
    FStoreyLbl.textColor=[UIColor colorWithRed:51/255.0 green:51/255.0 blue:51/255.0 alpha:1.0];
    [cellView addSubview:FStoreyLbl];
    //价格
    UILabel *FPriceTitle=[[UILabel alloc]initWithFrame:CGRectMake(25, 65, 50, 15)];
    FPriceTitle.text=@"价格：";
    FPriceTitle.font=[UIFont fontWithName:@"PingFangSC-Regular" size:15];
    FPriceTitle.textColor=[UIColor colorWithRed:153/255.0 green:153/255.0 blue:153/255.0 alpha:1.0];
    [cellView addSubview:FPriceTitle];
    UILabel *FPriceLbl=[[UILabel alloc]initWithFrame:CGRectMake(75, 65, UISCreen_Width/2-75, 15)];
    FPriceLbl.text=model.FPrice;
    FPriceLbl.font=[UIFont fontWithName:@"PingFangSC-Regular" size:15];
    FPriceLbl.textColor=[UIColor colorWithRed:51/255.0 green:51/255.0 blue:51/255.0 alpha:1.0];
    [cellView addSubview:FPriceLbl];
    //联系电话
    UILabel *FTelLinkTitle=[[UILabel alloc]initWithFrame:CGRectMake(25, 100, 75, 15)];
    FTelLinkTitle.text=@"联系电话：";
    FTelLinkTitle.font=[UIFont fontWithName:@"PingFangSC-Regular" size:15];
    FTelLinkTitle.textColor=[UIColor colorWithRed:153/255.0 green:153/255.0 blue:153/255.0 alpha:1.0];
    [cellView addSubview:FTelLinkTitle];
    UILabel *FTelLinkLbl=[[UILabel alloc]initWithFrame:CGRectMake(100, 100, 125, 15)];
    FTelLinkLbl.text=model.FLinkTel;
    FTelLinkLbl.font=[UIFont fontWithName:@"PingFangSC-Regular" size:15];
    FTelLinkLbl.textColor=[UIColor colorWithRed:51/255.0 green:51/255.0 blue:51/255.0 alpha:1.0];
    [cellView addSubview:FTelLinkLbl];
    //分割线
    UIView *splitView = [[UIView alloc] init];
    splitView.frame = CGRectMake(18,133,UISCreen_Width-36,0.5);
    splitView.backgroundColor = [UIColor colorWithRed:232/255.0 green:232/255.0 blue:235/255.0 alpha:1];
    [cellView addSubview:splitView];
    //修改按钮
    UIView *EditView = [[UIView alloc] init];
    EditView.frame = CGRectMake(UISCreen_Width-180,142,75,28);
    EditView.layer.cornerRadius = 14;
    EditView.layer.borderWidth=1;
    EditView.layer.borderColor=[[UIColor colorWithRed:153/255.0 green:153/255.0 blue:153/255.0 alpha:1.0] CGColor];
    UILabel *EditLbl=[[UILabel alloc]initWithFrame:CGRectMake(24, 7, 30, 15)];
    EditLbl.text=@"修改";
    EditLbl.font=[UIFont fontWithName:@"PingFangSC-Regular" size:15];
    EditLbl.textColor=[UIColor colorWithRed:51/255.0 green:51/255.0 blue:51/255.0 alpha:1.0];
    EditLbl.tag=[indexPath row];
    [EditView addSubview:EditLbl];
    //修改点击事件注册
    UITapGestureRecognizer *singleTapEdit =[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(onClickEdit:)];
    [EditView addGestureRecognizer:singleTapEdit];
    [EditView setUserInteractionEnabled:YES];
    [cellView addSubview:EditView];
    //更新按钮
    UIView *ReloadView = [[UIView alloc] init];
    ReloadView.frame = CGRectMake(UISCreen_Width-90,142,75,28);
    ReloadView.layer.cornerRadius = 14;
    ReloadView.layer.borderWidth=1;
    ReloadView.layer.borderColor=[[UIColor colorWithRed:153/255.0 green:153/255.0 blue:153/255.0 alpha:1.0] CGColor];
    UILabel *ReloadLbl=[[UILabel alloc]initWithFrame:CGRectMake(24, 7, 30, 15)];
    ReloadLbl.text=@"更新";
    ReloadLbl.font=[UIFont fontWithName:@"PingFangSC-Regular" size:15];
    ReloadLbl.textColor=[UIColor colorWithRed:51/255.0 green:51/255.0 blue:51/255.0 alpha:1.0];
    ReloadLbl.tag=[indexPath row];
    [ReloadView addSubview:ReloadLbl];
    //更新点击事件注册
    UITapGestureRecognizer *singleTapReload =[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(onClickReload:)];
    [ReloadView addGestureRecognizer:singleTapReload];
    [ReloadView setUserInteractionEnabled:YES];
    [cellView addSubview:ReloadView];
    
    return cell;
}

//修改点击事件
-(void)onClickEdit:(id)sender{
    UITapGestureRecognizer *tap = (UITapGestureRecognizer *)sender;
    
    int tag = tap.view.tag; // 标示
    PrecisPubModel *model=[[PrecisPubModel alloc]init];
    model=[self.precisePubList objectAtIndex:tag];
    int FID=model.FID;
    NSLog(@"修改了：%d",FID);
}
//更新点击事件
-(void)onClickReload:(id)sender{
    UITapGestureRecognizer *tap = (UITapGestureRecognizer *)sender;
    
    int tag = tap.view.tag; // 标示
    PrecisPubModel *model=[[PrecisPubModel alloc]init];
    model=[self.precisePubList objectAtIndex:tag];
    int FID=model.FID;
    NSLog(@"更新了：%d",FID);
    
    NSString *FullUrl=[NSString stringWithFormat:@"/api/PrecisePub/TopPrecisePub?FID=%d",FID];
    NSDictionary *Httpheaders=@{@"Authorization":self.AuthorizationStr };
    [HqAFHttpClient starRequestWithHeaders:Httpheaders withURLString:FullUrl withParam:@{} requestIsNeedJson:FALSE responseIsNeedJson:TRUE method:Get wihtCompleBlock:^(NSHTTPURLResponse *response, id responseObject) {
        //下拉加载框关闭
        [self.precisePubTableView.mj_header endRefreshing];
        BaseServerModel *result= [BaseServerModel modelWithDictionary:responseObject];

        if(result.code==2){
            //登录状态过期
            [MyTools GotoLogin];
        }
        if(result.code==1){
            [self AlertTips:@"操作成功"];
        }else{
            [self AlertTips:result.message];
        }

    }];
    
}

@end
