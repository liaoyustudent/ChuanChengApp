//
//  ViewController.m
//  ChuanChengApp
//
//  Created by liaoyu on 2018/11/14.
//  Copyright © 2018年 ChuanCheng. All rights reserved.
//

#import "ViewController.h"
#import "MarkView.h"
#import "Constant.h"
#import "UILoginInputCell.h"
#import <WebKit/WebKit.h>
#import "HqAFHttpClient.h"
#import "BaseServerModel.h"
#import "NaviViewController.h"

@interface ViewController ()<UIScrollViewDelegate>
{
    int _TopBarHeight;
    int _defultInde;//默认的标签
    int _rememberStatus;//记住密码状态
}
@property (nonatomic, strong) UIView *baseView;
@property (nonatomic, strong) MarkView *markView;
@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, strong) UIView *loginView;
@property (nonatomic, strong) UITextField *loginAccount;
@property (nonatomic, strong) UITextField *loginPwd;
@property (nonatomic,strong) UIButton *btnLogin;
@property (nonatomic,strong) UIImageView *imgViewRember;//记住密码选项
@end

@implementation ViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor=[UIColor whiteColor];
    _TopBarHeight=38;
    _defultInde=1;//默认初始登录页
    _rememberStatus=1;//默认选中
    //self.firstRequest = [[PageableRequest alloc] init];
    //self.secondRequest = [[PageableRequest alloc] init];
    [self layoutSubviews];
    
    
    UITapGestureRecognizer *tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(fingerTapped:)];
    //设置成NO表示当前控件响应后会传播到其他控件上，默认为YES。
    tapGestureRecognizer.cancelsTouchesInView = NO;
    //将触摸事件添加到当前view
    [self.view addGestureRecognizer:tapGestureRecognizer];
    
}

//布局
- (void)layoutSubviews{
    UIView *baseView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, UISCreen_Width, UISCreen_Height - StatusBarHeight)];
    [self.view addSubview:baseView];
    self.baseView = baseView;
    //顶部
    [self.baseView addSubview:[self layoutTopView]];
    
    //markview
    self.markView = [self layoutMarkView];
    [self.baseView addSubview:self.markView];
    //scrollView
    self.scrollView = [self layoutScrollView];
    [self.baseView addSubview:self.scrollView];
    //登录页初始化
    self.loginView= [self layoutLogin];
    [self.scrollView addSubview:self.loginView];
    //初始化账号和密码
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    self.loginAccount.text=[userDefaults objectForKey:@"userName"];
    self.loginPwd.text=[userDefaults objectForKey:@"pwd"];
    [self ChangeLoginText];
}

-(UIView *)layoutTopView{
    UIView *topview=[[UIView alloc]initWithFrame:CGRectMake(0, 0, UISCreen_Width, _TopBarHeight+StatusBarHeight)];
    UILabel *lbTelLink = [[UILabel alloc] init];
    lbTelLink.frame = CGRectMake(UISCreen_Width-90,StatusBarHeight+7,60,14.5);
    lbTelLink.text = @"联系客服";
    lbTelLink.font = [UIFont fontWithName:@"PingFangSC-Regular" size:15];
    lbTelLink.textColor = [UIColor colorWithRed:153/255.0 green:153/255.0 blue:153/255.0 alpha:1];
    
    UITapGestureRecognizer *singleTapForget =[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(onClickForget)];
    [lbTelLink addGestureRecognizer:singleTapForget];
    [lbTelLink setUserInteractionEnabled:YES];
    
    [topview addSubview:lbTelLink];
    return  topview;
}


//初始化MarkView
- (MarkView *)layoutMarkView {
    //@weakify(self)
    MarkView *markview = [[MarkView alloc] initWithFrame:CGRectMake(0, _TopBarHeight+StatusBarHeight, UISCreen_Width, 45) marks:@[@"注册",@"登录"]];
    markview.cancelAnimated = false;
    [markview setHandleClick:^(NSInteger index) {
        [self.scrollView setContentOffset:CGPointMake(UISCreen_Width*index, 0) animated:YES];
    }];
    [markview setIndex:_defultInde];
    
    return markview;
}
//初始化滚动页面
- (UIScrollView *)layoutScrollView {
    UIScrollView *scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, self.markView.bottom+_TopBarHeight+StatusBarHeight, UISCreen_Width, UISCreen_Height-self.markView.bottom-_TopBarHeight-StatusBarHeight)];
    scrollView.contentSize = CGSizeMake(UISCreen_Width * 2, UISCreen_Height-self.markView.bottom-_TopBarHeight-StatusBarHeight);
    scrollView.pagingEnabled = YES;
    scrollView.delegate = self;
    scrollView.showsHorizontalScrollIndicator = NO;
    scrollView.contentOffset = CGPointMake(_defultInde * UISCreen_Width, 0);
    
    return scrollView;
}

#pragma mark UIScrollViewDelegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    if (scrollView == self.scrollView) {
        [self.markView scrollViewDidScroll:scrollView];
    }
}

#pragma 登录初始化
-(UIView *)layoutLogin{
    //登录主体
    UIView *view=[[UIView alloc]initWithFrame:CGRectMake(UISCreen_Width, 0, UISCreen_Width, UISCreen_Height-self.markView.bottom-_TopBarHeight-StatusBarHeight)];
    
    //初始化输入项
    //账号
    UILoginInputCell *accountCell=[[UILoginInputCell alloc] initWithPoint:CGPointMake(0, 77) placeholder:@"请输入账号" picName:@"ic_zhanghao"];
    self.loginAccount=accountCell.CellTextField;
    [self.loginAccount addTarget:self action:@selector(ChangeLoginText) forControlEvents:UIControlEventEditingChanged];
    [self.loginAccount setAutocorrectionType:UITextAutocorrectionTypeNo];
    [self.loginAccount setAutocapitalizationType:UITextAutocapitalizationTypeNone];
    [view addSubview:accountCell];
    //密码
    UILoginInputCell *pwdCell=[[UILoginInputCell alloc] initWithPoint:CGPointMake(0, 147) placeholder:@"请输入密码" picName:@"r_mima"];
    pwdCell.CellTextField.secureTextEntry=YES;
    self.loginPwd=pwdCell.CellTextField;
    [self.loginPwd addTarget:self action:@selector(ChangeLoginText) forControlEvents:UIControlEventEditingChanged];
    [view addSubview:pwdCell];
    //记住密码
    UIView *remberCell=[[UIView alloc]initWithFrame:CGRectMake(0, 217, UISCreen_Width, 70)];
    UIImage *imgRember=[UIImage imageNamed:@"ic_remenberPwd"];
    self.imgViewRember=[[UIImageView alloc]initWithImage:imgRember];
    self.imgViewRember.frame=CGRectMake(35, 27, imgRember.size.width, imgRember.size.height);
    UITapGestureRecognizer *singleTap =[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(onClickImage)];
    [self.imgViewRember addGestureRecognizer:singleTap];
    [self.imgViewRember setUserInteractionEnabled:YES];
    [remberCell addSubview:self.imgViewRember];
    UILabel *lblrember=[[UILabel alloc]initWithFrame:CGRectMake(65, 27, 150, 14)];
    lblrember.text = @"记住密码";
    lblrember.font = [UIFont fontWithName:@"PingFangSC-Regular" size:15];
    lblrember.textColor = [UIColor colorWithRed:153/255.0 green:153/255.0 blue:153/255.0 alpha:1];
    [remberCell addSubview:lblrember];
    
    UILabel *lblForget=[[UILabel alloc]initWithFrame:CGRectMake(UISCreen_Width-100, 27, 70, 14)];
    lblForget.text=@"忘记密码";
    lblForget.font=[UIFont fontWithName:@"PingFangSC-Regular" size:15];
    lblForget.textColor=[UIColor colorWithRed:53/255.0 green:144/255.0 blue:237/255.0 alpha:1];
    UITapGestureRecognizer *singleTapForget =[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(onClickForget)];
    [lblForget addGestureRecognizer:singleTapForget];
    [lblForget setUserInteractionEnabled:YES];
    [remberCell addSubview:lblForget];
    
    [view addSubview:remberCell];
    //按钮
    self.btnLogin= [[UIButton alloc]initWithFrame:CGRectMake(30, 357, UISCreen_Width-30*2, 50)];
    self.btnLogin.backgroundColor=[UIColor colorWithRed:119/255.0 green:209/255.0 blue:204/255.0 alpha:1];
    [self.btnLogin setTitle:@"立即登录" forState:UIControlStateNormal];
    [self.btnLogin addTarget:self action:@selector(DoLogin) forControlEvents:UIControlEventTouchUpInside];
    self.btnLogin.userInteractionEnabled=NO;
    self.btnLogin.alpha=0.4;
    [view addSubview:_btnLogin];
    
    
    return  view;
}
//登录点击事件
-(void)DoLogin{
    NSString *userName=self.loginAccount.text;
    NSString *pwd=self.loginPwd.text;
    
    [HqAFHttpClient starRequestWithHeaders:nil withURLString:@"/api/Login/GetUserInfo" withParam:@{@"UserName":userName,@"UserPwd":pwd} requestIsNeedJson:FALSE responseIsNeedJson:TRUE method:Post wihtCompleBlock:^(NSHTTPURLResponse *response, id responseObject) {
        BaseServerModel *result= [BaseServerModel modelWithDictionary:responseObject];
        if(result.code==1){
            NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
            //记住密码的偏好设置
            if(_rememberStatus==1){
                [userDefaults setObject:userName forKey:@"userName"];
                [userDefaults setObject:pwd forKey:@"pwd"];
                [userDefaults synchronize];
            }else{
                [userDefaults removeObjectForKey:@"userName"];
                [userDefaults removeObjectForKey:@"pwd"];
                [userDefaults synchronize];
            }
            //保存token
            [userDefaults setObject:result.object forKey:@"TOKEN_KEY"];
            //跳转到首页
            NaviViewController *vc=[[NaviViewController alloc]init];
            [self restoreRootViewController:vc];
            //[UIApplication sharedApplication].delegate.window.rootViewController=vc;
            
        }else{
            UIAlertController *alertController = [UIAlertController alertControllerWithTitle:nil message:result.message preferredStyle:UIAlertControllerStyleAlert];
            UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
            }];
            [alertController addAction:cancelAction];
            [self presentViewController:alertController animated:YES completion:nil];
        }
        
    }];
}

-(void)ChangeLoginText{
    if ([[self.loginAccount.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]] length]>0 && [[self.loginPwd.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]] length]>0) {
        self.btnLogin.alpha=1;
        self.btnLogin.userInteractionEnabled=TRUE;
    }
    else{
        self.btnLogin.alpha=0.4;
        self.btnLogin.userInteractionEnabled=FALSE;
    }
    
}

//点击记住密码触发事件
-(void)onClickImage{
    _rememberStatus=_rememberStatus*-1;
    [self setRememberImg];
}
//忘记密码点击
-(void)onClickForget{
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

//设置记住密码图片状态
-(void)setRememberImg{
    if(_rememberStatus==1){
        UIImage *imgRember=[UIImage imageNamed:@"ic_remenberPwd"];
        _imgViewRember.image=imgRember;
    }else{
        UIImage *imgRember=[UIImage imageNamed:@"ic_code"];
        _imgViewRember.image=imgRember;
    }
}

// 点击空白处收键盘
-(void)fingerTapped:(UITapGestureRecognizer *)gestureRecognizer {
    [self.view endEditing:YES];
}

// 登陆后淡入淡出更换rootViewController
- (void)restoreRootViewController:(UIViewController *)rootViewController
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
