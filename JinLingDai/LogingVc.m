//
//  LogingVc.m
//  JinLingDai
//
//  Created by 001 on 2017/6/30.
//  Copyright © 2017年 JLD. All rights reserved.
//
#import "JLDTabBarController.h"
#import "LogingVc.h"
#import "RegistUserVc.h"
#import "FindPassword1Vc.h"
#import "UIView+Radius.h"
#import "UIImage+Comment.h"
#import "MBProgressHUD+NetWork.h"
#import "UserManager.h"
#import "NetworkManager.h"
#import <YYKit.h>

@interface LogingVc (){
    UIButton *rememburBtn;
    UIButton *backBtn;
}
@property (nonatomic, strong) UITextField *telText;
@property (nonatomic, strong) UITextField *PassText;
@end

@implementation LogingVc

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor blackColor];
    [self setLayoutContent];
    [self setNavOrangeColor];
}

- (void)setLayoutContent{
    
    UIView *bgView = [UIView new];
    bgView.backgroundColor = [UIColor infosBackViewColor];
    [self.view addSubview:bgView];
    [bgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view).insets(UIEdgeInsetsMake(StatusBarHeight, 0, 0, 0));
    }];
    
    backBtn = [UIButton new];
    backBtn.titleLabel.font = [UIFont gs_fontNum:17];
    [backBtn setTitle:@"X" forState:UIControlStateNormal];
    [backBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [backBtn addTarget:self action:@selector(dismissVcToOther) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:backBtn];
    [backBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(bgView).offset(ChangedHeight(10));
        make.top.equalTo(bgView).offset(ChangedHeight(10));
        make.width.height.mas_equalTo(30);
    }];
    
    UIImageView *imgLogo = [[UIImageView alloc]init];
//    imgLogo.backgroundColor = [UIColor getOrangeColor];
    imgLogo.image = [UIImage imageNamed:@"LOGO"];
    [self.view addSubview:imgLogo];
    [imgLogo mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view);
        make.top.equalTo(self.view).offset(ChangedHeight(80));
//        make.size.mas_equalTo(CGSizeMake(ChangedHeight(105), ChangedHeight(40)));
    }];
    
    UIView *textBGView = [UIView new];
    textBGView.bounds = CGRectMake(0, 0, K_WIDTH - ChangedHeight(70), ChangedHeight(100));
    textBGView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:textBGView];
    [textBGView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view).offset(ChangedHeight(35));
        make.right.equalTo(self.view).offset(ChangedHeight(-35));
        make.height.mas_equalTo(ChangedHeight(100));
        make.top.equalTo(imgLogo.mas_bottom).offset(ChangedHeight(55));
    }];
    [textBGView setCornerRadiusAdvance:5.f];
    
    UIView *horLine = [UIView new];
    horLine.backgroundColor = [UIColor newSeparatorColor];
    [textBGView addSubview:horLine];
    [horLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(textBGView).offset(1);
        make.right.equalTo(textBGView).offset(-1);
        make.height.mas_equalTo(1);
        make.centerY.equalTo(textBGView);
    }];
    
    UIImageView *leftImage = [[UIImageView alloc]init];
    //    leftImage.backgroundColor  = [UIColor redColor];
    leftImage.frame = CGRectMake(0, 0, ChangedHeight(30), ChangedHeight(20));
    leftImage.image = [UIImage imageNamed:@"用户名"];
    leftImage.contentMode = UIViewContentModeScaleAspectFit;
    self.telText = [[UITextField alloc]init];
    self.telText.leftView = leftImage;
    self.telText.leftViewMode = UITextFieldViewModeAlways;
    self.telText.attributedPlaceholder = [[NSAttributedString alloc]initWithString:@"请输入手机号或用户名" attributes:
                                          @{NSFontAttributeName:[UIFont gs_fontNum:14],
                                            NSForegroundColorAttributeName:[UIColor getColor:134 G:135 B:136]
                                            }];
    [textBGView addSubview:self.telText];
    [self.telText mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(textBGView).offset(ChangedHeight(5));
        make.right.top.equalTo(textBGView);
        make.bottom.equalTo(horLine.mas_top);
    }];
    
    UIImageView *leftImage2 = [[UIImageView alloc]init];
    //    leftImage2.backgroundColor  = [UIColor redColor];
    leftImage2.contentMode = UIViewContentModeScaleAspectFit;
    leftImage2.image = [UIImage imageNamed:@"密码"];
    leftImage2.frame = CGRectMake(0, 0, ChangedHeight(30), ChangedHeight(20));
    self.PassText = [[UITextField alloc]init];
    self.PassText.leftView = leftImage2;
    self.PassText.secureTextEntry = YES;
    self.PassText.leftViewMode = UITextFieldViewModeAlways;
    self.PassText.attributedPlaceholder = [[NSAttributedString alloc]initWithString:@"请输入密码" attributes:
                                           @{NSFontAttributeName:[UIFont gs_fontNum:14],
                                             NSForegroundColorAttributeName:[UIColor getColor:134 G:135 B:136]
                                             }];
    [textBGView addSubview:self.PassText];
    [self.PassText mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(textBGView).offset(ChangedHeight(5));
        make.right.bottom.equalTo(textBGView);
        make.top.equalTo(horLine.mas_bottom);
    }];
    
    
    rememburBtn = [UIButton new];
    rememburBtn.hidden = YES;
    [rememburBtn addTarget:self action:@selector(rememburBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [rememburBtn setImage:[UIImage imageNamed:@"记住密码1"] forState:UIControlStateNormal];
    [rememburBtn setImage:[UIImage imageNamed:@"记住密码"] forState:UIControlStateSelected];
    [rememburBtn setTitleColor:[UIColor getColor:134 G:135 B:136] forState:UIControlStateNormal];
    [rememburBtn setTitle:@"记住密码" forState:UIControlStateNormal];
    rememburBtn.titleLabel.font = [UIFont gs_fontNum:15];
    [rememburBtn setImageEdgeInsets:UIEdgeInsetsMake(0, -2, 0, 0)];
    [rememburBtn setTitleEdgeInsets:UIEdgeInsetsMake(0, 2, 0, 0)];
    [self.view addSubview:rememburBtn];
    [rememburBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(textBGView);
        make.top.equalTo(textBGView.mas_bottom).offset(ChangedHeight(4));
        make.width.mas_equalTo(ChangedHeight(80));
        make.height.mas_equalTo(ChangedHeight(30));
    }];
    
    UIButton *loginBtn = [UIButton new];
    [loginBtn addTarget:self action:@selector(loginBtnClicked) forControlEvents:UIControlEventTouchUpInside];
    [loginBtn setTitle:@"登录" forState:UIControlStateNormal];
    loginBtn.layer.cornerRadius = 6;
    loginBtn.backgroundColor = [UIColor getOrangeColor];
    [self.view addSubview:loginBtn];
    [loginBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view);
        make.top.equalTo(rememburBtn.mas_bottom).offset(ChangedHeight(63));
        make.left.right.equalTo(textBGView);
        make.height.mas_equalTo(ChangedHeight(40));
    }];
    
    UIButton *forgetBtn = [UIButton new];
    [forgetBtn addTarget:self action:@selector(forgetPassword) forControlEvents:UIControlEventTouchUpInside];
    [forgetBtn setTitle:@"忘记密码 ?>>" forState:UIControlStateNormal];
    [forgetBtn setTitleColor:[UIColor getBlueColor] forState:UIControlStateNormal];
    [self.view addSubview:forgetBtn];
    [forgetBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(loginBtn);
        make.top.equalTo(loginBtn.mas_bottom).offset(ChangedHeight(10));
        make.height.mas_equalTo(ChangedHeight(25));
    }];
    UIButton *registBtn = [UIButton new];
    [registBtn addTarget:self action:@selector(fastRegistUser) forControlEvents:UIControlEventTouchUpInside];
    [registBtn setTitle:@"快速注册" forState:UIControlStateNormal];
    [registBtn setTitleColor:[UIColor getBlueColor] forState:UIControlStateNormal];
    [self.view addSubview:registBtn];
    [registBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(loginBtn);
        make.top.equalTo(loginBtn.mas_bottom).offset(ChangedHeight(10));
        make.height.mas_equalTo(ChangedHeight(25));
    }];
    
//    UIImageView *redImg = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"登录注册页低"]];
//    [self.view addSubview:redImg];
//    [redImg mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.bottom.equalTo(self.view).offset(ChangedHeight( - 10));
//        make.centerX.equalTo(self.view);
//    }];

}
- (void)dismissVcToOther{
    JLDTabBarController *tab = (JLDTabBarController *)[UIApplication sharedApplication].keyWindow.rootViewController;
    tab.presentVc = nil;
    [self dismissViewControllerAnimated:YES completion:nil];
}
/**
 隐藏导航栏
 
 @param animated v1
 */
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
//    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
    if (self.navigationController.viewControllers.count == 1) {
        JLDTabBarController *tab = (JLDTabBarController *)[UIApplication sharedApplication].keyWindow.rootViewController;
        tab.presentVc = self;
        [self.navigationController setNavigationBarHidden:YES animated:NO];
    }else{
        self.title = @"登录";
        backBtn.hidden = YES;
    }
    
}

/**
 不隐藏导航栏
 
 @param animated 1
 */
//- (void)viewWillDisappear:(BOOL)animated{
//    [super viewWillDisappear:animated];
////    if (self.navigationController.viewControllers.count == 1) {
//        [self.navigationController setNavigationBarHidden:NO animated:NO];
////    }
//
//}


/**
 记住密码功能

 @param sender 记住密码
 */
- (void)rememburBtnClick:(UIButton *)sender{
    sender.selected = !sender.selected;
}

/**
 登录
 */
- (void)loginBtnClicked{
    

    if (!self.telText.text.length) {
        [MBProgressHUD showError:@"请输入手机号或用户名"];
        return;
    }
    if (!self.PassText.text.length) {
        [MBProgressHUD showError:@"请输入密码"];
        return;
    }
//    NSString *channel_id = [[NSUserDefaults standardUserDefaults]objectForKey:@"channel_id"];
    NSString *postUrl ;
    kAppPostHost(postUrl);
    [NetworkManager startNetworkRequestDataFromRemoteServerByPostMethodWithURLString:[NSString stringWithFormat:@"%@user/actlogin",postUrl]
    withParameters:@{
                     @"password":self.PassText.text,
                     @"username":self.telText.text
//                     @"channel_id":Nilstr2Space(channel_id)
                     }
     ShowHUD:YES 
    success:^(NSURLSessionDataTask *task, id responseObject) {
        if ([responseObject[@"status"] integerValue] == 200) {
            dispatch_async(dispatch_get_main_queue(), ^{
                UserModel *user = [UserModel modelWithJSON:responseObject[@"data"]];
                //            user.uid = responseObject[@"data"][@"uid"];
                [[UserManager shareManager] saveUserModel:user];
                UserMoneyModel *moneyModel = [[UserMoneyModel alloc] init];
                moneyModel.active_balance = responseObject[@"data"][@"mayuse"];
                [[UserManager shareManager] saveUserModel:user];
                [[UserManager shareManager] saveUserMoney:moneyModel];
                [[NSUserDefaults standardUserDefaults] setObject:@"1" forKey:RefreshUser];
                [[NSUserDefaults standardUserDefaults] setObject:responseObject[@"data"][@"token"] forKey:@"token"];
                [[NSUserDefaults standardUserDefaults] synchronize];
                //通知
                [[NSNotificationCenter defaultCenter] postNotificationName:UserLogin object:nil];
                
                [[UserManager shareManager] loadMewModel:^(BOOL succ) {
                    [self dismissViewControllerAnimated:YES completion:nil];
                }];
                
            });
            
        }
        
    }
    failure:^(NSURLSessionDataTask *task, NSError *error) {
       
    }];
    
    
}

/**
 忘记密码
 */
- (void)forgetPassword{
    FindPassword1Vc *vc = [[FindPassword1Vc alloc]init];
    [self.navigationController pushViewController:vc animated:YES];
}

/**
 快速注册
 */
- (void)fastRegistUser{
    if (self.navigationController.viewControllers.count == 1){
        RegistUserVc *vc = [[RegistUserVc alloc]init];
        [self.navigationController pushViewController:vc animated:YES];
    }else{
        [self.navigationController popViewControllerAnimated:YES];
    }
    
}

- (BOOL)hidesBottomBarWhenPushed{
    return YES;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
