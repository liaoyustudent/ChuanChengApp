//
//  AdvertViewController.m
//  ChuanChengApp
//  一手楼盘
//  Created by liaoyu on 2018/11/27.
//  Copyright © 2018年 ChuanCheng. All rights reserved.
//

#import "AdvertViewController.h"
#import "AdvertModel.h"



@interface AdvertViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic, strong) NSMutableArray *AdvertList;
@property (nonatomic, strong) UITableView *AdvertTableView;
@end

@implementation AdvertViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor=[UIColor whiteColor];
    [self GetAdvertList];
    
    //初始化tableview
    CGFloat tableHeight=IS_IPHONE_X?UISCreen_Height-150:UISCreen_Height-100;
    UITableView *tableView=[[UITableView alloc]initWithFrame:CGRectMake(0, StatusBarHeight, UISCreen_Width, tableHeight)];
    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    tableView.delegate=self;
    tableView.dataSource=self;
    self.AdvertTableView=tableView;
    [self.view addSubview:tableView];
    
    //下拉刷新
    tableView.mj_header=[MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(refresh)];
    //上拉加载
    tableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMore)];
    //关闭上拉加载
    [tableView.mj_footer endRefreshingWithNoMoreData];
}

-(void)refresh
{
    [self GetAdvertList];
    [self.AdvertTableView reloadData];
    
}
-(void)loadMore
{
    //暂无内容
}
//获取列表
-(void)GetAdvertList{
    self.AdvertList=[[NSMutableArray alloc]init];
    NSDictionary *Httpheaders=@{@"Authorization":self.AuthorizationStr };
    [HqAFHttpClient starRequestWithHeaders:Httpheaders withURLString:@"/api/LoanAdvert/GetLoanAdvert" withParam:@{@"curr":@1,@"pageSize":@100} requestIsNeedJson:FALSE responseIsNeedJson:TRUE method:Post wihtCompleBlock:^(NSHTTPURLResponse *response, id responseObject) {
        //下拉加载框关闭
        [self.AdvertTableView.mj_header endRefreshing];
        BaseServerModel *result= [BaseServerModel modelWithDictionary:responseObject];
        
        if(result.code==2){
            //登录状态过期
            [MyTools GotoLogin];
        }
        if(result.code==1){
            
            for (NSDictionary *advertdic in result.object) { /** 便是数组 */
                AdvertModel *advert=[AdvertModel modelWithDictionary:advertdic];
                [self.AdvertList addObject:advert];
            }
            
            [self.AdvertTableView reloadData];
        }else{
            UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"获取列表失败" message:result.message preferredStyle:UIAlertControllerStyleAlert];
            UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
            }];
            [alertController addAction:cancelAction];
            [self presentViewController:alertController animated:YES completion:nil];
        }
        
    }];
}

//一个大块
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return  1;
}
//5行
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.AdvertList.count;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 240;
}
//选中
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    //[tableView deselectRowAtIndexPath:indexPath animated:NO];
}


-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    AdvertModel *advert=[[AdvertModel alloc]init];
    advert=[self.AdvertList objectAtIndex:[indexPath row]];
    NSString *time=advert.FCreatTime;
    NSString *ImgUrl= [NSString stringWithFormat:@"/api/Filse/GetAdvertImg?FID=%d",advert.FID ];
    NSString *title=advert.FTitle;
    
    // 0.重用标识
    // 被static修饰的局部变量：只会初始化一次，在整个程序运行过程中，只有一份内存
    static NSString *advertIdentifier = @"advertCell";
    // 1.先根据cell的标识去缓存池中查找可循环利用的cell
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:advertIdentifier];
    // 2.如果cell为nil（缓存池找不到对应的cell）
    if (cell == nil) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:advertIdentifier];
    }

    [cell setFrame:CGRectMake(0, 20, UISCreen_Width, 240)];
    //取消选中效果
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    //自定义的布局
     UIView *cellView=[[UIView alloc]initWithFrame:CGRectMake(15, 0, UISCreen_Width-30, 240)];
    //单元格上的时间
    UIView *timeView=[self LayoutCellTimeWithStr:time];
    [cellView addSubview:timeView];
    //图片
    UIImageView *AdvertImgView=[self LayoutCellImageView:ImgUrl title:title];
    AdvertImgView.layer.cornerRadius=5;
    [cellView addSubview:AdvertImgView];
    
    [cell.contentView addSubview:cellView];
    
    
    return cell;
}

//布局时间
-(UIView*)LayoutCellTimeWithStr:(NSString*) Str{
    //得到字符串的宽高
    CGSize timeSize=[Str boundingRectWithSize:CGSizeMake( UISCreen_Width- 20, CGFLOAT_MAX)
                                       options:NSStringDrawingUsesFontLeading | NSStringDrawingUsesLineFragmentOrigin
                                    attributes:@{NSFontAttributeName:[UIFont fontWithName:@"PingFangSC-Regular" size:12]}
                                       context:nil].size;
    //timeView
    UIView *timeView = [[UIView alloc] initWithFrame:CGRectMake(UISCreen_Width/2-(timeSize.width+10)/2, 20, timeSize.width+10, 25)];
    timeView.backgroundColor = [UIColor colorWithRed:238/255.0 green:238/255.0 blue:238/255.0 alpha:1.0];
    timeView.layer.cornerRadius = 5;
    //设置字体及样式
    UILabel *timeLbl=[[UILabel alloc]initWithFrame:CGRectMake(5, 4, timeSize.width, timeSize.height)];
    NSMutableAttributedString *timestr = [[NSMutableAttributedString alloc] initWithString:Str attributes:@{NSFontAttributeName: [UIFont fontWithName:@"PingFangSC-Regular" size: 12],NSForegroundColorAttributeName: [UIColor colorWithRed:153/255.0 green:153/255.0 blue:153/255.0 alpha:1.0]}];
    timeLbl.attributedText = timestr;
    
    [timeView addSubview:timeLbl];
    
    return  timeView;
}
//布局图片
-(UIImageView*)LayoutCellImageView:(NSString*) imgUrl title:(NSString*) title{
    UIImageView *AdvertImgView=[[UIImageView alloc]initWithFrame:CGRectMake(0, 50, UISCreen_Width-30, 200)];
    AdvertImgView.layer.cornerRadius=5;
    AdvertImgView.clipsToBounds = YES;
    NSString *FullImgUrl=[NSString stringWithFormat:@"%@%@",SERVSER_URL,imgUrl];
    [AdvertImgView sd_setImageWithURL:FullImgUrl placeholderImage:[UIImage imageNamed:@"icon_loading"]];
    
    //标题
    UIView *titleView=[self LayoutTitileView:title];
    [AdvertImgView addSubview:titleView];
    return AdvertImgView;
}

//布局标题
-(UIView*)LayoutTitileView:(NSString*) titleStr{
    UIView *titleView=[[UIView alloc]initWithFrame:CGRectMake(0, 150, UISCreen_Width-30, 50)];
    titleView.backgroundColor = [UIColor colorWithWhite:0.f alpha:0.5];
    titleView.layer.cornerRadius = 7.5;
    
    CGSize titleSize=[titleStr boundingRectWithSize:CGSizeMake( UISCreen_Width- 20, CGFLOAT_MAX)
                                      options:NSStringDrawingUsesFontLeading | NSStringDrawingUsesLineFragmentOrigin
                                   attributes:@{NSFontAttributeName:[UIFont fontWithName:@"PingFangSC-Regular" size:15]}
                                      context:nil].size;
    
    UILabel *titleLbl=[[UILabel alloc]initWithFrame:CGRectMake(UISCreen_Width/2-(titleSize.width+10)/2, 17, titleSize.width, titleSize.height)];
    titleLbl.numberOfLines = 0;
    NSMutableAttributedString *string = [[NSMutableAttributedString alloc] initWithString:titleStr attributes:@{NSFontAttributeName: [UIFont fontWithName:@"PingFangSC-Regular" size: 15],NSForegroundColorAttributeName: [UIColor colorWithRed:255/255.0 green:255/255.0 blue:255/255.0 alpha:1.0]}];
    
    titleLbl.attributedText = string;
    
    [titleView addSubview:titleLbl];
    
    return titleView;
}

@end
