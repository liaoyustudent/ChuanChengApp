//
//  CollectionViewController.m
//  ChuanChengApp
//  我的收藏
//  Created by liaoyu on 2018/12/23.
//  Copyright © 2018年 ChuanCheng. All rights reserved.
//

#import "CollectionViewController.h"
#import "CollectionListModel.h"

@interface CollectionViewController ()<UITableViewDelegate,UITableViewDataSource>{
    NSInteger _pageIndex;//当前页
    NSInteger _pageSize;//每页行数
    UITableViewCell *selectCell;//长按选中行
}
@property (nonatomic, strong) NSMutableArray *collectionList;
@property (nonatomic, strong) UITableView *collectionTableView;

@end

@implementation CollectionViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor=[UIColor colorWithRed:247/255.0 green:247/255.0 blue:247/255.0 alpha:1.0];
    self.navigationItem.title=@"我的收藏";
    
    
    //初始化分页相关参数
    [self InitPageParam];
    //获取初始列表
    [self GetCollectionList];
    
    //初始化tableview
    CGFloat tableHeight=IS_IPHONE_X?UISCreen_Height-150:UISCreen_Height-100;
    UITableView *tableView=[[UITableView alloc]initWithFrame:CGRectMake(0, StatusBarHeight+40, UISCreen_Width, tableHeight)];
    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    tableView.delegate=self;
    tableView.dataSource=self;
    tableView.estimatedRowHeight =0;
    tableView.estimatedSectionHeaderHeight =0;
    tableView.estimatedSectionFooterHeight =0;
    self.collectionTableView=tableView;
    [self.view addSubview:tableView];
    
    //下拉刷新
    self.collectionTableView.mj_header=[MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(refresh)];
    //上拉加载
    self.collectionTableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMore)];
    
    
}

//初始化分页相关参数
-(void)InitPageParam{
    _pageIndex=1;
    _pageSize=20;
    self.collectionList=[[NSMutableArray alloc]init];
    [self.collectionTableView.mj_footer resetNoMoreData];
}

//获取列表
-(void)GetCollectionList{
    
    NSDictionary *Httpheaders=@{@"Authorization":self.AuthorizationStr };
    
    [HqAFHttpClient starRequestWithHeaders:Httpheaders withURLString:@"/api/Collections/GetCollections" withParam:@{@"curr":[NSString stringWithFormat:@"%d",_pageIndex],@"pageSize":[NSString stringWithFormat:@"%d",_pageSize]} requestIsNeedJson:FALSE responseIsNeedJson:TRUE method:Post wihtCompleBlock:^(NSHTTPURLResponse *response, id responseObject) {
        //下拉加载框关闭
        [self.collectionTableView.mj_header endRefreshing];
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
                [self.collectionTableView.mj_footer endRefreshingWithNoMoreData];
            }
            for (NSDictionary *collectiondic in result.object) { /** 便是数组 */
                CollectionListModel *collection=[CollectionListModel modelWithDictionary:collectiondic];
                [self.collectionList addObject:collection];
            }
            [self.collectionTableView reloadData];
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
    [self GetCollectionList];
    
    [self.collectionTableView reloadData];
    
}
-(void)loadMore
{
    //获取列表
    [self GetCollectionList];
    
    [self.collectionTableView reloadData];
}

//一个大块
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return  1;
}
//5行
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.collectionList.count;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    
    CollectionListModel *collection=[[CollectionListModel alloc]init];
    collection=[self.collectionList objectAtIndex:[indexPath row]];
    NSString *FContent=collection.FContent;
    
    CGSize contentSize=[FContent boundingRectWithSize:CGSizeMake( UISCreen_Width- 50, CGFLOAT_MAX)
                                              options:NSStringDrawingUsesFontLeading | NSStringDrawingUsesLineFragmentOrigin
                                           attributes:@{NSFontAttributeName:[UIFont fontWithName:@"PingFangSC-Regular" size:15]}
                                              context:nil].size;
    return contentSize.height+100;
}
//选中
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    //[tableView deselectRowAtIndexPath:indexPath animated:NO];
}
//渲染单元
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    // 0.重用标识
    // 被static修饰的局部变量：只会初始化一次，在整个程序运行过程中，只有一份内存
    static NSString *collectionifier = @"collectionCell";
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
    
    CollectionListModel *collection=[[CollectionListModel alloc]init];
    collection=[self.collectionList objectAtIndex:[indexPath row]];
    NSString *FContent=collection.FContent;
    NSString *FTelLink=collection.FLinkTel;
    
    CGSize contentSize=[FContent boundingRectWithSize:CGSizeMake( UISCreen_Width- 50, CGFLOAT_MAX)
                                      options:NSStringDrawingUsesFontLeading | NSStringDrawingUsesLineFragmentOrigin
                                   attributes:@{NSFontAttributeName:[UIFont fontWithName:@"PingFangSC-Regular" size:15]}
                                      context:nil].size;
    
    UIView *cellView=[[UIView alloc]initWithFrame:CGRectMake(0, 0, UISCreen_Width, contentSize.height+90)];
    cellView.backgroundColor=[UIColor whiteColor];
    [cell.contentView addSubview:cellView];
    //收藏内容
    UILabel *ContentLbl=[[UILabel alloc]initWithFrame:CGRectMake(25, 26, UISCreen_Width- 50, contentSize.height)];
    ContentLbl.numberOfLines = 0;
    NSMutableAttributedString *contentStr = [[NSMutableAttributedString alloc] initWithData:[FContent dataUsingEncoding:NSUnicodeStringEncoding]  options:@{ NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType } documentAttributes:nil error:nil];
    
    [contentStr addAttribute:NSFontAttributeName value:[UIFont fontWithName:@"PingFangSC-Regular" size: 15] range:NSMakeRange(0, contentStr.length)];
    ContentLbl.attributedText=contentStr;
    [cellView addSubview:ContentLbl];
    //联系电话
    UIView *telView=[[UIView alloc]initWithFrame:CGRectMake(25, contentSize.height+50, UISCreen_Width-50, 15)];
    UILabel *telLbl=[[UILabel alloc]initWithFrame:CGRectMake(0, 0, 200, 15)];
    telLbl.numberOfLines=0;
    NSString *telStr=[NSString stringWithFormat:@"联系电话:  %@",FTelLink];
    NSMutableAttributedString *telAtStr = [[NSMutableAttributedString alloc] initWithString:telStr attributes:@{NSFontAttributeName: [UIFont fontWithName:@"PingFangSC-Regular" size: 15],NSForegroundColorAttributeName: [UIColor colorWithRed:51/255.0 green:51/255.0 blue:51/255.0 alpha:1.0]}];
    telLbl.attributedText=telAtStr;
    UILabel *clickTelLbl=[[UILabel alloc]initWithFrame:CGRectMake(UISCreen_Width-100, 0, 60, 15)];
    clickTelLbl.numberOfLines=0;
    NSMutableAttributedString *clickTelAtrStr = [[NSMutableAttributedString alloc] initWithString:@"点击拨打" attributes:@{NSFontAttributeName: [UIFont fontWithName:@"PingFangSC-Regular" size: 15],NSForegroundColorAttributeName: [UIColor colorWithRed:110/255.0 green:145/255.0 blue:245/255.0 alpha:1.0]}];
    clickTelLbl.attributedText=clickTelAtrStr;
    clickTelLbl.tag=[indexPath row];
    [telView addSubview:clickTelLbl];
    
    UITapGestureRecognizer *singleTapForget =[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(onClickLinkTel:)];
    [clickTelLbl addGestureRecognizer:singleTapForget];
    [clickTelLbl setUserInteractionEnabled:YES];
    
    [telView addSubview:telLbl];
    [cell.contentView addSubview:telView];
    
    
    if (cell.gestureRecognizers.count ==0) {
        UILongPressGestureRecognizer *longPre = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(display:)];
        [cell addGestureRecognizer:longPre];
    }
    
    return cell;
}
//长按事件
-(void)display:(UILongPressGestureRecognizer *)longPre{
    
    if (longPre.state ==UIGestureRecognizerStateBegan) {
        UITableViewCell *cell = (UITableViewCell *)longPre.view;
        selectCell=cell;
        [cell becomeFirstResponder];
        UIMenuItem *item1 = [[UIMenuItem alloc]initWithTitle:@"复制"action:@selector(copyAction:)];
        UIMenuController *menu = [UIMenuController sharedMenuController];
        [menu setMenuItems:@[item1]];
        [menu setTargetRect:cell.frame inView:self.collectionTableView];
        [menu setMenuVisible:YES animated:YES];
    }
    
}
//复制
-(void)copyAction:(id)sender{
    NSInteger index= [[self.collectionTableView indexPathForCell:selectCell] row];
    CollectionListModel *collection=[[CollectionListModel alloc]init];
    collection=[self.collectionList objectAtIndex:index];
    NSString *FContent=collection.FContent;
    
    NSMutableAttributedString *contentStr = [[NSMutableAttributedString alloc] initWithData:[FContent dataUsingEncoding:NSUnicodeStringEncoding]  options:@{ NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType } documentAttributes:nil error:nil];
    
    [contentStr addAttribute:NSFontAttributeName value:[UIFont fontWithName:@"PingFangSC-Regular" size: 15] range:NSMakeRange(0, contentStr.length)];
    UIPasteboard *pasteBoard=[UIPasteboard generalPasteboard];
    [pasteBoard setString:[contentStr string]];
}
-(BOOL)canPerformAction:(SEL)action withSender:(id)sender
{
    return action==@selector(copyAction:);
}


- (BOOL)canBecomeFirstResponder{
    
    return YES;//注意这个一定要写
    
}

/**
 *  只要实现了这个方法，左滑出现Delete按钮的功能就有了
 *  点击了“左滑出现的Delete按钮”会调用这个方法
 */
//IOS9前自定义左滑多个按钮需实现此方法
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSDictionary *Httpheaders=@{@"Authorization":self.AuthorizationStr };
    CollectionListModel *collection=[_collectionList objectAtIndex:[indexPath row]];
    
    [HqAFHttpClient starRequestWithHeaders:Httpheaders withURLString:@"/api/Collections/DelCollection" withParam:@{@"FColID":[NSString stringWithFormat:@"%d",collection.FID]} requestIsNeedJson:FALSE responseIsNeedJson:TRUE method:Get wihtCompleBlock:^(NSHTTPURLResponse *response, id responseObject) {
        BaseServerModel *result= [BaseServerModel modelWithDictionary:responseObject];
        
        if(result.code==2){
            //登录状态过期
            [MyTools GotoLogin];
        }
        if(result.code==1){
            // 删除模型
            [self.collectionList removeObjectAtIndex:indexPath.row];
            // 刷新
            [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationLeft];
        }else{
            UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"删除失败" message:result.message preferredStyle:UIAlertControllerStyleAlert];
            UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
            }];
            [alertController addAction:cancelAction];
            [self presentViewController:alertController animated:YES completion:nil];
        }
        
    }];
    
    
}

/**
 *  修改Delete按钮文字为“删除”
 */
- (NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return @"删除";
}

//点击拨打
-(void)onClickLinkTel:(id)sender{
    UITapGestureRecognizer *tap = (UITapGestureRecognizer *)sender;
    
    int tag = tap.view.tag; // 标示
    CollectionListModel *collection=[[CollectionListModel alloc]init];
    collection=[self.collectionList objectAtIndex:tag];
    NSString *FTelLink=collection.FLinkTel;
    
    NSString *tel=FTelLink;
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




@end
