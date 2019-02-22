//
//  PrecisePubEditViewController.m
//  ChuanChengApp
//
//  Created by liaoyu on 2019/1/15.
//  Copyright © 2019年 ChuanCheng. All rights reserved.
//

#import "PrecisePubEditViewController.h"
#import "PrecisPubModel.h"

@interface PrecisePubEditViewController ()<UITextFieldDelegate,UIPickerViewDelegate,UIPickerViewDataSource>{
    //底部域
    UIView *bottomView;
    //装修枚举
    NSArray *arrayFFitment;
    //出租按钮
    UIButton *btnRentOut;
    //出售按钮
    UIButton *btnSale;
    //发布类型
    int FType;
    //小区名称
    UITextField *txtFName;
    //面积
    UITextField *txtFArea;
    //价格
    UITextField *txtFPrice;
    //楼层
    UITextField *txtFStorey;
    //装修
    int FFitment;
    NSString *hidFFitment;
    UITextField *txtFFitment;
    //备注
    UITextField *txtFRemark;
    //电话
    UITextField *txtFMobile;
    //置顶
    UISwitch *swtFIsTop;
    //保存按钮
    UIButton *btnSave;
}

@property (strong, nonatomic) UIPickerView *pickerFFitment;
@end

@implementation PrecisePubEditViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor=[UIColor colorWithRed:247/255.0 green:247/255.0 blue:247/255.0 alpha:1.0];
    self.navigationItem.title=@"精准发布";
    //初始化基础数据
    [self initBase];
    //初始化类型页签
    [self initTypeTab];
    //初始化输入域
    [self initInputArea];
    //初始化备注域
    [self initRemarkArea];
    //初始化底部
    [self initBottomArea];
    //修改时初始化数据
    if(_FID>0){
        [self initModifyData];
    }
    
    
    //点击空白收起键盘
    UITapGestureRecognizer *tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(fingerTapped:)];
    //设置成NO表示当前控件响应后会传播到其他控件上，默认为YES。
    tapGestureRecognizer.cancelsTouchesInView = NO;
    //将触摸事件添加到当前view
    [self.view addGestureRecognizer:tapGestureRecognizer];
}
//初始化基础数据
-(void)initBase{
    arrayFFitment=[[NSArray alloc]initWithObjects:@{@"key":@"0",@"value":@"请选择"},@{@"key":@"1",@"value":@"毛坯"},@{@"key":@"2",@"value":@"简装"},@{@"key":@"3",@"value":@"中装"},@{@"key":@"4",@"value":@"精装"},@{@"key":@"5",@"value":@"豪装"},@{@"key":@"6",@"value":@"新装"},@{@"key":@"7",@"value":@"老装"}, nil];
    FFitment=0;
    
    
}
//修改时初始化数据
-(void)initModifyData{
    NSDictionary *Httpheaders=@{@"Authorization":self.AuthorizationStr };
    
    [HqAFHttpClient starRequestWithHeaders:Httpheaders withURLString:@"/api/PrecisePub/GetPrecisePubInfo" withParam:@{@"FID":[NSString stringWithFormat:@"%d",_FID]} requestIsNeedJson:FALSE responseIsNeedJson:TRUE method:Get wihtCompleBlock:^(NSHTTPURLResponse *response, id responseObject) {
        
        BaseServerModel *result= [BaseServerModel modelWithDictionary:responseObject];
        
        if(result.code==2){
            //登录状态过期
            [MyTools GotoLogin];
        }
        if(result.code==1){
            PrecisPubModel *info=[PrecisPubModel modelWithDictionary:result.object];
            if(info.FID>0){
                //出租or出售
                if(info.FPubType==1){
                    [self DoRentOut];
                }else{
                    [self DoSale];
                }
                //小区名称
                txtFName.text=info.FName;
                //面积
                txtFArea.text=info.FArea;
                //价格
                txtFPrice.text=info.FPrice;
                //楼层
                NSNumber *FStorey= [NSNumber numberWithLong: info.FStorey];
                txtFStorey.text=[NSString stringWithFormat:@"%d",info.FStoreyInt];
                //装修
                FFitment=info.FFitment;
                hidFFitment=info.FFitmentName;
                txtFFitment.text=info.FFitmentName;
                //备注
                txtFRemark.text=info.FRemark;
                //电话
                txtFMobile.text=info.FLinkTel;
                //置顶发布
                swtFIsTop.on=info.FIsTop==1;
                //校验表单
                [self CheckForm];
            }
            
        }else{
            UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"失败" message:result.message preferredStyle:UIAlertControllerStyleAlert];
            UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
            }];
            [alertController addAction:cancelAction];
            [self presentViewController:alertController animated:YES completion:nil];
        }
        
    }];
    
}

//初始化类型页签
-(void)initTypeTab
{
    UIView *tabView=[[UIView alloc]initWithFrame:CGRectMake(0, StatusBarHeight+40, UISCreen_Width, 80)];
    tabView.backgroundColor=[UIColor whiteColor];
    [self.view addSubview:tabView];
    //出租按钮
    btnRentOut=[[UIButton alloc]initWithFrame:CGRectMake(UISCreen_Width/2-115, 25, 100, 35)];
    btnRentOut.backgroundColor=[UIColor colorWithRed:71/255.0 green:121/255.0 blue:231/255.0 alpha:1];
    [btnRentOut setTitle:@"出租" forState:UIControlStateNormal];
    [btnRentOut addTarget:self action:@selector(DoRentOut) forControlEvents:UIControlEventTouchUpInside];
    [tabView addSubview:btnRentOut];
    FType=1;
    
    //出售按钮
    btnSale=[[UIButton alloc]initWithFrame:CGRectMake(UISCreen_Width/2+10, 25, 100, 35)];
    btnSale.backgroundColor=[UIColor colorWithRed:247/255.0 green:247/255.0 blue:247/255.0 alpha:1.0];
    [btnSale setTitle:@"出售" forState:UIControlStateNormal];
    [btnSale setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    [btnSale addTarget:self action:@selector(DoSale) forControlEvents:UIControlEventTouchUpInside];
    [tabView addSubview:btnSale];
    
}
//出租事件
-(void)DoRentOut{
    btnRentOut.backgroundColor=[UIColor colorWithRed:71/255.0 green:121/255.0 blue:231/255.0 alpha:1];
    [btnRentOut setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    
    btnSale.backgroundColor=[UIColor colorWithRed:247/255.0 green:247/255.0 blue:247/255.0 alpha:1.0];
    [btnSale setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    FType=1;
    txtFPrice.placeholder=@"万元/年";
}

//出售事件
-(void)DoSale{
    btnSale.backgroundColor=[UIColor colorWithRed:71/255.0 green:121/255.0 blue:231/255.0 alpha:1];
    [btnSale setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    
    btnRentOut.backgroundColor=[UIColor colorWithRed:247/255.0 green:247/255.0 blue:247/255.0 alpha:1.0];
    [btnRentOut setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    FType=2;
    txtFPrice.placeholder=@"总价（万元）";
    
}

//初始化输入域
-(void)initInputArea
{
    UIView *inputView=[[UIView alloc]initWithFrame:CGRectMake(0, StatusBarHeight+125, UISCreen_Width, 145)];
    inputView.backgroundColor=[UIColor whiteColor];
    [self.view addSubview:inputView];
    //小区名称
    UILabel *lblFName = [[UILabel alloc] init];
    lblFName.frame = CGRectMake(30,15,50,15);
    lblFName.numberOfLines = 0;
    [inputView addSubview:lblFName];
    NSMutableAttributedString *titleFName = [[NSMutableAttributedString alloc] initWithString:@"小区名称" attributes:@{NSFontAttributeName: [UIFont fontWithName:@"PingFangSC-Regular" size: 12],NSForegroundColorAttributeName: [UIColor colorWithRed:51/255.0 green:51/255.0 blue:51/255.0 alpha:1.0]}];
    lblFName.attributedText = titleFName;
    txtFName=[[UITextField alloc]initWithFrame:CGRectMake(85, 15, UISCreen_Width-135, 20)];
    txtFName.placeholder=@"请输入";
    txtFName.font=[UIFont fontWithName:@"PingFangSC-Regular" size:15];
    txtFName.keyboardType=UIKeyboardTypeDefault;
    [inputView addSubview:txtFName];
    //初始化分割线
    UIView *spFName = [[UIView alloc] init];
    spFName.frame = CGRectMake(22,45,UISCreen_Width-2*22,0.5);
    spFName.backgroundColor = [UIColor colorWithRed:232/255.0 green:232/255.0 blue:235/255.0 alpha:1];
    [inputView addSubview:spFName];
    //面积
    UILabel *lblFArea = [[UILabel alloc] init];
    lblFArea.frame = CGRectMake(30,65,50,15);
    lblFArea.numberOfLines = 0;
    [inputView addSubview:lblFArea];
    NSMutableAttributedString *titleFArea = [[NSMutableAttributedString alloc] initWithString:@"面积" attributes:@{NSFontAttributeName: [UIFont fontWithName:@"PingFangSC-Regular" size: 12],NSForegroundColorAttributeName: [UIColor colorWithRed:51/255.0 green:51/255.0 blue:51/255.0 alpha:1.0]}];
    lblFArea.attributedText = titleFArea;
    txtFArea=[[UITextField alloc]initWithFrame:CGRectMake(85, 65, UISCreen_Width/2-85, 20)];
    txtFArea.placeholder=@"请输入";
    txtFArea.font=[UIFont fontWithName:@"PingFangSC-Regular" size:15];
    txtFArea.keyboardType=UIKeyboardTypeDecimalPad;
    [inputView addSubview:txtFArea];
    //价格
    UILabel *lblFPrice = [[UILabel alloc] init];
    lblFPrice.frame = CGRectMake(UISCreen_Width/2,65,50,15);
    lblFPrice.numberOfLines = 0;
    [inputView addSubview:lblFPrice];
    NSMutableAttributedString *titleFPrice = [[NSMutableAttributedString alloc] initWithString:@"价格" attributes:@{NSFontAttributeName: [UIFont fontWithName:@"PingFangSC-Regular" size: 12],NSForegroundColorAttributeName: [UIColor colorWithRed:51/255.0 green:51/255.0 blue:51/255.0 alpha:1.0]}];
    lblFPrice.attributedText = titleFPrice;
    txtFPrice=[[UITextField alloc]initWithFrame:CGRectMake(UISCreen_Width/2+50, 65, UISCreen_Width/2-85, 20)];
    txtFPrice.placeholder=@"万元/年";
    txtFPrice.font=[UIFont fontWithName:@"PingFangSC-Regular" size:15];
    txtFPrice.keyboardType=UIKeyboardTypeDecimalPad;
    [inputView addSubview:txtFPrice];
    //初始化分割线
    UIView *spFPrice = [[UIView alloc] init];
    spFPrice.frame = CGRectMake(22,90,UISCreen_Width-2*22,0.5);
    spFPrice.backgroundColor = [UIColor colorWithRed:232/255.0 green:232/255.0 blue:235/255.0 alpha:1];
    [inputView addSubview:spFPrice];
    //楼层
    UILabel *lblFStorey=[[UILabel alloc]init];
    lblFStorey.frame = CGRectMake(30,120,50,15);
    lblFStorey.numberOfLines = 0;
    [inputView addSubview:lblFStorey];
    NSMutableAttributedString *titleFStorey = [[NSMutableAttributedString alloc] initWithString:@"楼层" attributes:@{NSFontAttributeName: [UIFont fontWithName:@"PingFangSC-Regular" size: 12],NSForegroundColorAttributeName: [UIColor colorWithRed:51/255.0 green:51/255.0 blue:51/255.0 alpha:1.0]}];
    lblFStorey.attributedText = titleFStorey;
    txtFStorey=[[UITextField alloc]initWithFrame:CGRectMake(85, 120, UISCreen_Width/2-85, 20)];
    txtFStorey.placeholder=@"请输入";
    txtFStorey.font=[UIFont fontWithName:@"PingFangSC-Regular" size:15];
    txtFStorey.keyboardType=UIKeyboardTypeNumberPad;
    [inputView addSubview:txtFStorey];
    //装修
    UILabel *lblFFitment=[[UILabel alloc]init];
    lblFFitment.frame = CGRectMake(UISCreen_Width/2,120,50,15);
    lblFFitment.numberOfLines = 0;
    [inputView addSubview:lblFFitment];
    NSMutableAttributedString *titleFFitment = [[NSMutableAttributedString alloc] initWithString:@"装修" attributes:@{NSFontAttributeName: [UIFont fontWithName:@"PingFangSC-Regular" size: 12],NSForegroundColorAttributeName: [UIColor colorWithRed:51/255.0 green:51/255.0 blue:51/255.0 alpha:1.0]}];
    lblFFitment.attributedText = titleFFitment;
    txtFFitment=[[UITextField alloc]initWithFrame:CGRectMake(UISCreen_Width/2+50, 120, UISCreen_Width/2-85, 20)];
    txtFFitment.placeholder=@"请选择";
    txtFFitment.font=[UIFont fontWithName:@"PingFangSC-Regular" size:15];
    txtFFitment.tag = 1; //绑定tag
    txtFFitment.delegate = self; //设置代理
    [inputView addSubview:txtFFitment];
    self.pickerFFitment = [[UIPickerView alloc]initWithFrame:CGRectMake(0, 0, UISCreen_Width-17, 170)];
    self.pickerFFitment.delegate = self;
    self.pickerFFitment.dataSource = self;
    
    
}

//初始化备注域
-(void)initRemarkArea
{
    UIView *remarkView=[[UIView alloc]initWithFrame:CGRectMake(0, StatusBarHeight+275, UISCreen_Width, 105)];
    remarkView.backgroundColor=[UIColor whiteColor];
    [self.view addSubview:remarkView];
    
    UILabel *lblFRemark=[[UILabel alloc]init];
    lblFRemark.frame = CGRectMake(30,25,50,15);
    lblFRemark.numberOfLines = 0;
    [remarkView addSubview:lblFRemark];
    NSMutableAttributedString *titleFRemark = [[NSMutableAttributedString alloc] initWithString:@"备注" attributes:@{NSFontAttributeName: [UIFont fontWithName:@"PingFangSC-Regular" size: 12],NSForegroundColorAttributeName: [UIColor colorWithRed:51/255.0 green:51/255.0 blue:51/255.0 alpha:1.0]}];
    lblFRemark.attributedText = titleFRemark;
    txtFRemark=[[UITextField alloc]initWithFrame:CGRectMake(85, 25, UISCreen_Width-135, 20)];
    txtFRemark.placeholder=@"请输入";
    txtFRemark.font=[UIFont fontWithName:@"PingFangSC-Regular" size:15];
    txtFRemark.keyboardType=UIKeyboardTypeNumberPad;
    [remarkView addSubview:txtFRemark];
    //初始化分割线
    UIView *spFRemark = [[UIView alloc] init];
    spFRemark.frame = CGRectMake(22,55,UISCreen_Width-2*22,0.5);
    spFRemark.backgroundColor = [UIColor colorWithRed:232/255.0 green:232/255.0 blue:235/255.0 alpha:1];
    [remarkView addSubview:spFRemark];
    //电话
    UILabel *lblFMobile=[[UILabel alloc]init];
    lblFMobile.frame = CGRectMake(30,75,50,15);
    lblFMobile.numberOfLines = 0;
    [remarkView addSubview:lblFMobile];
    NSMutableAttributedString *titleFMobile = [[NSMutableAttributedString alloc] initWithString:@"电话" attributes:@{NSFontAttributeName: [UIFont fontWithName:@"PingFangSC-Regular" size: 12],NSForegroundColorAttributeName: [UIColor colorWithRed:51/255.0 green:51/255.0 blue:51/255.0 alpha:1.0]}];
    lblFMobile.attributedText = titleFMobile;
    txtFMobile=[[UITextField alloc]initWithFrame:CGRectMake(85, 75, UISCreen_Width-135, 20)];
    txtFMobile.font=[UIFont fontWithName:@"PingFangSC-Regular" size:15];
    txtFMobile.tag=2;
    txtFMobile.delegate = self; //设置代理
    [remarkView addSubview:txtFMobile];
}

//初始化底部
-(void)initBottomArea
{
    bottomView=[[UIView alloc]initWithFrame:CGRectMake(0, StatusBarHeight+385, UISCreen_Width, 500)];
    bottomView.backgroundColor=[UIColor whiteColor];
    [self.view addSubview: bottomView];
    UILabel *lblFIsTop=[[UILabel alloc]init];
    lblFIsTop.frame = CGRectMake(30,15,70,15);
    lblFIsTop.numberOfLines = 0;
    [bottomView addSubview:lblFIsTop];
    NSMutableAttributedString *titleFIsTop = [[NSMutableAttributedString alloc] initWithString:@"置顶发布" attributes:@{NSFontAttributeName: [UIFont fontWithName:@"PingFangSC-Regular" size: 12],NSForegroundColorAttributeName: [UIColor colorWithRed:51/255.0 green:51/255.0 blue:51/255.0 alpha:1.0]}];
    lblFIsTop.attributedText = titleFIsTop;
    swtFIsTop=[[UISwitch alloc]initWithFrame:CGRectMake(UISCreen_Width-60, 15, 45, 15)];
    swtFIsTop.onTintColor=[UIColor colorWithRed:71/255.0 green:121/255.0 blue:231/255.0 alpha:1];
    swtFIsTop.enabled=NO;
    [bottomView addSubview:swtFIsTop];
    
    
    //按钮
    btnSave= [[UIButton alloc]initWithFrame:CGRectMake(30, 90, UISCreen_Width-30*2, 50)];
    btnSave.backgroundColor=[UIColor colorWithRed:71/255.0 green:121/255.0 blue:231/255.0 alpha:1];
    [btnSave setTitle:@"确认发布" forState:UIControlStateNormal];
    [btnSave addTarget:self action:@selector(DoSave) forControlEvents:UIControlEventTouchUpInside];
    btnSave.userInteractionEnabled=NO;
    btnSave.alpha=0.4;
    [bottomView addSubview:btnSave];
}


- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    //self.navigationController.navigationBar.topItem.title = @"";
}

// 点击空白处收键盘
-(void)fingerTapped:(UITapGestureRecognizer *)gestureRecognizer {
    [self.view endEditing:YES];
}

//输入框代理
- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    [textField resignFirstResponder];
    return YES;
}

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField{
    NSLog(@"这里是编辑：%@",textField);
    if (textField.tag == 1) {   //具体弹出方法请看这
        [self forDetailsOnNationality]; //这里调用弹出界面
        return NO;   //这里设置textField输入框不能输入
    }else if (textField.tag==2){
        return NO;
    }else return YES;
}


//#pragma PickerView Delegate
-(NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView{
    return 1;   // 这个方法控制的是pickerView的列数
}
//pickview代理
- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component{
    return arrayFFitment.count;   //这里就返回pickerView的行数
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component{
    //返回的是每一行显示的内容，_nationalityContent是数组，我在里面放的是字典
    return [[arrayFFitment objectAtIndex:row] objectForKey:@"value"];
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component{ //这方法就是选中某一行，获取它的内容
    hidFFitment= [[arrayFFitment objectAtIndex:row] objectForKey:@"value"];
    FFitment = [[[arrayFFitment objectAtIndex:row] objectForKey:@"key"] integerValue];
}
//选择器添加确认取消按钮
- (void)forDetailsOnNationality{
    
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"\n\n\n\n\n\n\n\n" message:nil preferredStyle:UIAlertControllerStyleActionSheet];
        UIAlertAction *ok = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            txtFFitment.text = hidFFitment;
        }];
        
        UIAlertAction *no = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDefault handler:nil];
        [alertController.view addSubview:self.pickerFFitment];
        [alertController addAction:ok];
        [alertController addAction:no];
    
        [self presentViewController:alertController animated:YES completion:nil];
    
}

//校验必填项
-(void)CheckForm{
    if ([[txtFName.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]] length]>0 && [[txtFArea.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]] length]>0&&[[txtFPrice.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]] length]>0) {
        btnSave.alpha=1;
        btnSave.userInteractionEnabled=TRUE;
    }
    else{
        btnSave.alpha=0.4;
        btnSave.userInteractionEnabled=FALSE;
    }
    
}


//确认发布事件
-(void)DoSave {
    NSMutableDictionary *dic=[[NSMutableDictionary alloc]init];
    
    [dic setObject:[NSNumber numberWithInt:FType] forKey:@"FPubType"];
    [dic setObject:txtFName.text forKey:@"FName"];
    [dic setObject:txtFArea.text forKey:@"FArea"];
    [dic setObject:txtFPrice.text forKey:@"FPrice"];
    [dic setObject:txtFStorey.text forKey:@"FStorey"];
    [dic setObject:[NSNumber numberWithInt:FFitment] forKey:@"FFitment"];
    [dic setObject:txtFRemark.text forKey:@"FRemark"];
    [dic setObject:txtFMobile.text forKey:@"FLinkTel"];
    [dic setObject:[NSNumber numberWithInt:swtFIsTop.on?1:0] forKey:@"FIsTop"];
    
    if(_FID>0){
        NSDictionary *Httpheaders=@{@"Authorization":self.AuthorizationStr };
        [dic setObject:[NSNumber numberWithInt:_FID] forKey:@"FID"];
        [HqAFHttpClient starRequestWithHeaders:Httpheaders withURLString:@"/api/PrecisePub/MolPrecisePub" withParam:dic requestIsNeedJson:FALSE responseIsNeedJson:TRUE method:Post wihtCompleBlock:^(NSHTTPURLResponse *response, id responseObject) {
            
            BaseServerModel *result= [BaseServerModel modelWithDictionary:responseObject];
            
            if(result.code==2){
                //登录状态过期
                [MyTools GotoLogin];
            }
            if(result.code==1){
                [self.navigationController popViewControllerAnimated:YES];
            }else{
                UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"失败" message:result.message preferredStyle:UIAlertControllerStyleAlert];
                UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
                }];
                [alertController addAction:cancelAction];
                [self presentViewController:alertController animated:YES completion:nil];
            }
            
        }];
    }
    else{
        [dic setObject:[NSNumber numberWithInt:0] forKey:@"FID"];
    }
    
    
}


@end
