//
//  RegistUserVc.m
//  JinLingDai
//
//  Created by 001 on 2017/7/1.
//  Copyright © 2017年 JLD. All rights reserved.
//
#import "JLDTabBarController.h"
#import "RegistUserVc.h"
#import <Masonry.h>
#import "UIColor+Util.h"
#import "UIView+Masonry.h"
#import <TTTAttributedLabel.h>
#import <YYKit.h>
#import "GSValidate.h"
#import "MBProgressHUD+NetWork.h"
#import "NetworkManager.h"
#import "RedBagAleartView.h"
#import "JLDActAlertView.h"
#import "HTMLVC.h"
@interface RegistUserVc ()<TTTAttributedLabelDelegate>
{
    
}
@property (nonatomic, strong) UITextField *telText;
@property (nonatomic, strong) UITextField *checkoutText;
@property (nonatomic, strong) UITextField *PassText;
@property (nonatomic, strong) UITextField *checkPassText;
@property (nonatomic, strong) UILabel *timeLab;
@property (nonatomic, strong) UIButton *sendCodeBtn;
@property (nonatomic, strong) UIButton *agreeBtn;
@property (nonatomic, strong) NSTimer *cdTimer;                 //倒计时
@property (nonatomic) NSInteger countDown;                      //倒计时
@property (nonatomic, strong) RedBagAleartView *alertView;
//@property (nonatomic, strong) JLDActAlertView *actView;
@end
static NSInteger MAX_COUNTDOWN = 60;
@implementation RegistUserVc

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor infosBackViewColor];
//    [self.navigationController.navigationBar setTintColor:[UIColor getOrangeColor]];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"back"] style:UIBarButtonItemStylePlain target:self action:@selector(backToLastVc)];
    [self setNavOrangeColor];
//    self.tit
    self.title = @"注册";

    [self setLayoutContent];
}
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    JLDTabBarController *tab = (JLDTabBarController *)[UIApplication sharedApplication].keyWindow.rootViewController;
    tab.presentVc = self;
}
- (void)setLayoutContent{
    
    UIView *textBGView = [UIView new];
    textBGView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:textBGView];
    [textBGView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view).offset(ChangedHeight(35));
        make.right.equalTo(self.view).offset(ChangedHeight(-35));
        make.height.mas_equalTo(ChangedHeight(200));
        make.top.equalTo(self.view).offset(ChangedHeight(100));
    }];
    [textBGView.layer setCornerRadius:5.f];
    
    UIView *horLine1 = [UIView new];
    horLine1.backgroundColor = [UIColor newSeparatorColor];
    [textBGView addSubview:horLine1];
    [horLine1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(textBGView);
        make.height.mas_equalTo(1);
        
    }];
    
    UIView *horLine2 = [UIView new];
    horLine2.backgroundColor = [UIColor newSeparatorColor];
    [textBGView addSubview:horLine2];
    [horLine2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.height.equalTo(horLine1);
    }];
    
    
    UIView *horLine3 = [UIView new];
    horLine3.backgroundColor = [UIColor newSeparatorColor];
    [textBGView addSubview:horLine3];
    [horLine3 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.height.equalTo(horLine1);
    }];
    
    [textBGView distributeSpacingVerticallyWith:@[horLine1,horLine2,horLine3]];
    
    UIImageView *leftImage = [[UIImageView alloc]init];
    //    leftImage.backgroundColor  = [UIColor redColor];
    leftImage.frame = CGRectMake(0, 0, ChangedHeight(30), ChangedHeight(20));
    leftImage.image = [UIImage imageNamed:@"手机"];
    leftImage.contentMode = UIViewContentModeScaleAspectFit;
    self.telText = [[UITextField alloc]init];
    self.telText.leftView = leftImage;
    self.telText.keyboardType = UIKeyboardTypeNumberPad;
    self.telText.leftViewMode = UITextFieldViewModeAlways;
    self.telText.attributedPlaceholder = [[NSAttributedString alloc]initWithString:@"请输入手机号" attributes:
                                          @{NSFontAttributeName:[UIFont gs_fontNum:13],
                                            NSForegroundColorAttributeName:[UIColor getColor:134 G:135 B:136]
                                            }];
    [textBGView addSubview:self.telText];
    [self.telText mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(textBGView).offset(ChangedHeight(5));
        make.right.top.equalTo(textBGView);
        make.bottom.equalTo(horLine1.mas_top);
    }];
    
    _sendCodeBtn = [UIButton new];
    [_sendCodeBtn setTitle:@"发送验证码" forState:UIControlStateNormal];
    [_sendCodeBtn setTitleColor:[UIColor getBlueColor] forState:UIControlStateNormal];
    _sendCodeBtn.titleLabel.font = [UIFont gs_fontNum:13];
    [_sendCodeBtn addTarget:self action:@selector(sendCodeToTel) forControlEvents:UIControlEventTouchUpInside];
    _sendCodeBtn.size = CGSizeMake(ChangedHeight(70), ChangedHeight(50));
    UIImageView *leftImage3 = [[UIImageView alloc]init];
    //    leftImage2.backgroundColor  = [UIColor redColor];
    leftImage3.contentMode = UIViewContentModeScaleAspectFit;
    leftImage3.image = [UIImage imageNamed:@"验证码"];
    leftImage3.frame = CGRectMake(0, 0, ChangedHeight(30), ChangedHeight(20));
    self.checkoutText = [[UITextField alloc]init];
    self.checkoutText.leftView = leftImage3;
    self.checkoutText.keyboardType = UIKeyboardTypeNumberPad;
    self.checkoutText.leftViewMode = UITextFieldViewModeAlways;
    self.checkoutText.rightView = _sendCodeBtn;
    self.checkoutText.rightViewMode = UITextFieldViewModeAlways;
    self.checkoutText.attributedPlaceholder = [[NSAttributedString alloc]initWithString:@"请输入验证码" attributes:
                                           @{NSFontAttributeName:[UIFont gs_fontNum:13],
                                             NSForegroundColorAttributeName:[UIColor getColor:134 G:135 B:136]
                                             }];
    [textBGView addSubview:self.checkoutText];
    [self.checkoutText mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(textBGView).offset(ChangedHeight(5));
        make.right.bottom.equalTo(horLine2);
        make.top.equalTo(horLine1.mas_bottom);
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
    self.PassText.attributedPlaceholder = [[NSAttributedString alloc]initWithString:@"请输入8位以上数字或字母组合密码" attributes:
                                           @{NSFontAttributeName:[UIFont gs_fontNum:13],
                                             NSForegroundColorAttributeName:[UIColor getColor:134 G:135 B:136]
                                             }];
    [textBGView addSubview:self.PassText];
    [self.PassText mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(textBGView).offset(ChangedHeight(5));
        make.right.equalTo(textBGView);
        make.bottom.equalTo(horLine3.mas_top);
        make.top.equalTo(horLine2.mas_bottom);
    }];
    
    UIImageView *leftImage4 = [[UIImageView alloc]init];
    //    leftImage2.backgroundColor  = [UIColor redColor];
    leftImage4.contentMode = UIViewContentModeScaleAspectFit;
    leftImage4.image = [UIImage imageNamed:@"密码"];
    leftImage4.frame = CGRectMake(0, 0, ChangedHeight(30), ChangedHeight(20));
    self.checkPassText = [[UITextField alloc]init];
    self.checkPassText.leftView = leftImage4;
    self.checkPassText.secureTextEntry = YES;
    self.checkPassText.leftViewMode = UITextFieldViewModeAlways;
    self.checkPassText.attributedPlaceholder = [[NSAttributedString alloc]initWithString:@"请再次输入密码" attributes:
                                           @{NSFontAttributeName:[UIFont gs_fontNum:13],
                                             NSForegroundColorAttributeName:[UIColor getColor:134 G:135 B:136]
                                             }];
    [textBGView addSubview:self.checkPassText];
    [self.checkPassText mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(textBGView).offset(ChangedHeight(5));
        make.right.bottom.equalTo(textBGView);
        make.top.equalTo(horLine3.mas_bottom);
    }];
    
    TTTAttributedLabel *loginLab = [TTTAttributedLabel new];
    loginLab.font = [UIFont gs_fontNum:13];
    loginLab.textColor = [UIColor getColor:134 G:135 B:136];
    [loginLab setText:@"已有账户,现在登录>>" afterInheritingLabelAttributesAndConfiguringWithBlock:^NSMutableAttributedString *(NSMutableAttributedString *mutableAttributedString) {
        [mutableAttributedString addAttributes:@{NSFontAttributeName:[UIFont gs_fontNum:13],NSForegroundColorAttributeName:[UIColor getColor:134 G:135 B:136]} range:NSMakeRange(0, 11)];
        return mutableAttributedString;
    }];
    
    loginLab.linkAttributes = @{
                                (id)kCTForegroundColorAttributeName:[UIColor getBlueColor],
                                (id)kCTFontAttributeName:[UIFont gs_fontNum:13]
                                };

    [loginLab addLinkToPhoneNumber:@"login" withRange:[@"已有账户,现在登录>>" rangeOfString:@"现在登录>>"]];
    loginLab.delegate = self;
//    loginLab add
    [self.view addSubview:loginLab];
    [loginLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(textBGView);
        make.top.equalTo(textBGView.mas_bottom).offset(ChangedHeight(4));
        make.height.mas_equalTo(ChangedHeight(30));
    }];
    
    UIButton *registBtn = [UIButton new];
    [registBtn addTarget:self action:@selector(registNow) forControlEvents:UIControlEventTouchUpInside];
    [registBtn setTitle:@"注册" forState:UIControlStateNormal];
    registBtn.layer.cornerRadius = 6;
    registBtn.backgroundColor = [UIColor getOrangeColor];
    [self.view addSubview:registBtn];
    [registBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view);
        make.top.equalTo(loginLab.mas_bottom).offset(ChangedHeight(23));
        make.left.right.equalTo(textBGView);
        make.height.mas_equalTo(ChangedHeight(40));
    }];
    
    [self.view addSubview:self.agreeBtn];
    [self.agreeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(registBtn.mas_bottom).offset(ChangedHeight(15));
        make.height.width.mas_equalTo(15);
        make.left.equalTo(registBtn);
    }];
    TTTAttributedLabel *agreementLab = [TTTAttributedLabel new];
    agreementLab.numberOfLines = 0;
    agreementLab.font = [UIFont gs_fontNum:13];
    agreementLab.textColor = [UIColor getColor:134 G:135 B:136];
    [agreementLab setText:@"同意金陵金服《用户服务协议》、《隐私政策协议》" afterInheritingLabelAttributesAndConfiguringWithBlock:^NSMutableAttributedString *(NSMutableAttributedString *mutableAttributedString) {
        return mutableAttributedString;
    }];
    
    agreementLab.linkAttributes = @{
                                    (id)kCTForegroundColorAttributeName:[UIColor getBlueColor]
                                    };
    TTTAttributedLabelLink *labLink = [agreementLab addLinkToPhoneNumber:@"agreement" withRange:[@"同意金陵金服《用户服务协议》《隐私政策协议》"  rangeOfString:@"《用户服务协议》"]];
    labLink.linkTapBlock = ^(TTTAttributedLabel *lab, TTTAttributedLabelLink *link) {
        NSString *postUrl ;
        kAppPostHost(postUrl);
        HTMLVC *vc= [[HTMLVC alloc]init];
        vc.title = @"用户服务协议";
        vc.H5Url = [NSString stringWithFormat:@"%@Page/showinfomation?type=0",postUrl];
        
        [self.navigationController pushViewController:vc animated:YES];
    };
    TTTAttributedLabelLink *labLink2 = [agreementLab addLinkToPhoneNumber:@"agreement" withRange:[@"同意金陵金服《用户服务协议》《隐私政策协议》"  rangeOfString:@"《隐私政策协议》"]];
    labLink2.linkTapBlock = ^(TTTAttributedLabel *lab, TTTAttributedLabelLink *link) {
        NSString *postUrl ;
        kAppPostHost(postUrl);
        HTMLVC *vc= [[HTMLVC alloc]init];
        vc.title = @"隐私政策协议";
        vc.H5Url = [NSString stringWithFormat:@"%@page/privacyagreement",postUrl];
        
        [self.navigationController pushViewController:vc animated:YES];
    };
    agreementLab.delegate = self;
    [self.view addSubview:agreementLab];
    [agreementLab mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.centerX.equalTo(registBtn);
        make.top.equalTo(registBtn.mas_bottom).offset(ChangedHeight(15));
//        make.height.mas_equalTo(ChangedHeight(25));
        make.left.equalTo(self.agreeBtn.mas_right).offset(5);
        make.right.equalTo(registBtn);
    }];
    
    _alertView = [[RedBagAleartView alloc]init];
    
    _alertView.redBagType = RedBagUsedNow;
//        __weak typeof(self) weakSelf = self;
    _alertView.confirmBtnBlock = ^{
//                [weakSelf.alertView hidenAlertType];
        UIWindow *window = [UIApplication sharedApplication].keyWindow;
//        UIViewController *vc = [[NSClassFromString(@"UserNameAndIdCheckVc") alloc] init];
//        UINavigationController *nav = [[UINavigationController alloc]initWithRootViewController:vc];
//        [window.rootViewController presentViewController:nav animated:YES completion:nil];
        JLDActAlertView *actView = [JLDActAlertView shareManager];
        [actView showAlertType:BankShowType toView:window];
    };
    
}

- (void)registNow{
    if (![GSValidate validateString:self.telText.text withRequireType:RequireTypeIsMobile]) {
        [MBProgressHUD showError:@"请输入正确的手机号"];
        return;
    }
    if (self.PassText.text.length < 8 ) {
        [MBProgressHUD showError:@"请输入8位密码"];
        return;
    }
    if (![self.PassText.text isEqualToString:self.checkPassText.text]) {
        [MBProgressHUD showError:@"输入的密码不一致"];
        return;
    }
    
    NSString *postUrl ;
    kAppPostHost(postUrl);
    [NetworkManager startNetworkRequestDataFromRemoteServerByPostMethodWithURLString:[NSString stringWithFormat:@"%@/user/regaction",postUrl]
    withParameters:@{
                     @"password":self.PassText.text,
                     @"tel":self.telText.text,
                     @"verify_code":self.checkoutText.text,
                     @"invite_code":@"97d62fc7a4c47db1983e6f2b855c0b40"
                     }
     ShowHUD:YES
    success:^(NSURLSessionDataTask *task, id responseObject) {
        if ([responseObject[@"status"] integerValue] == 200) {
            dispatch_async(dispatch_get_main_queue(), ^{
                if (responseObject[@"data"][@"reward_money"] && [responseObject[@"data"][@"reward_money"] integerValue]) {
                    [_alertView aleartWithTip:responseObject[@"data"][@"reward_money"]
                                      Message:@"恭喜您获得\n奖励红包" Thanks:@"感谢您对金陵金服的支持～" Cancel:nil Confirm:@"确认"];
                    [_alertView showAlertType];
                }
                
            });
            [self loginUser];

        }
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        
    }];
    
}

- (void)loginUser{
//    NSString *channel_id = [[NSUserDefaults standardUserDefaults]objectForKey:@"channel_id"];
    NSString *postUrl ;
    kAppPostHost(postUrl);
    [NetworkManager startNetworkRequestDataFromRemoteServerByPostMethodWithURLString:[NSString stringWithFormat:@"%@user/actlogin",postUrl]
      withParameters:@{
                       @"password":self.PassText.text,
                       @"username":self.telText.text
//                       @"channel_id":Nilstr2Space(channel_id)
                       }
     ShowHUD:YES
             success:^(NSURLSessionDataTask *task, id responseObject) {
                 if ([responseObject[@"status"] integerValue] == 200) {

                     dispatch_async(dispatch_get_main_queue(), ^{
                         
                         UserModel *user = [UserModel modelWithJSON:responseObject[@"data"]];
                         [[UserManager shareManager] saveUserModel:user];
                         UserMoneyModel *moneyModel = [[UserMoneyModel alloc] init];
                         moneyModel.active_balance = responseObject[@"data"][@"mayuse"];
                         
                         [[UserManager shareManager] saveUserModel:user];
                         [[UserManager shareManager] saveUserMoney:moneyModel];
                         
                         [[NSUserDefaults standardUserDefaults] setObject:@"1" forKey:RefreshUser];
                         
                         [[NSUserDefaults standardUserDefaults] setObject:responseObject[@"data"][@"token"] forKey:@"token"];
                         [[NSUserDefaults standardUserDefaults] synchronize];
                         [[UserManager shareManager] loadMewModel:^(BOOL succ) {
                             [self dismissViewControllerAnimated:YES completion:nil];
                         }];
                         //通知
//                         [[NSNotificationCenter defaultCenter] postNotificationName:UserLogin object:nil];

                     });
                     
                 }
                 
             }
             failure:^(NSURLSessionDataTask *task, NSError *error) {
                 
             }];
}

- (void)backToLastVc{
    if (self.navigationController.viewControllers.count > 1) {
        [self.navigationController popViewControllerAnimated:YES];
    }else{
        JLDTabBarController *tab = (JLDTabBarController *)[UIApplication sharedApplication].keyWindow.rootViewController;
        tab.presentVc = nil;
        [self dismissViewControllerAnimated:YES completion:nil];
    }
    
    
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/**
 发送验证码的接口
 */
- (void)sendCodeToTel{
    
    if (![GSValidate validateString:self.telText.text withRequireType:RequireTypeIsMobile]) {
        [MBProgressHUD showError:@"请输入正确的手机号"];
        return;
    }
    NSString *postUrl ;
    kAppPostHost(postUrl);
    [NetworkManager startNetworkRequestDataFromRemoteServerByPostMethodWithURLString:[NSString stringWithFormat:@"%@user/commitphone",postUrl]
        withParameters:@{
                         @"tel":self.telText.text,
                         @"type":@"1"
                   }
     ShowHUD:YES 
         success:^(NSURLSessionDataTask *task, id responseObject) {
             if ([responseObject[@"status"] integerValue] == 200) {
                 dispatch_async(dispatch_get_main_queue(), ^{
                     [MBProgressHUD showSuccess:@"验证码发送成功"];
                     self.countDown = MAX_COUNTDOWN;
                     [self getCodeCountDown];
                 });
             }
         } failure:^(NSURLSessionDataTask *task, NSError *error) {
             
         }];
    
}

/**
 倒计时
 */
- (void)getCodeCountDown{
    [self clearTimer];
    self.countDown--;
    if(self.countDown > 0){
        [self.sendCodeBtn setEnabled:NO];
        [self.sendCodeBtn setTitle:[NSString stringWithFormat:@"%d秒后获取", (int)self.countDown] forState:UIControlStateNormal];
//        self.sendCodeBtn.layer.borderColor = GS_COLOR_GRAY.CGColor;
        [self.sendCodeBtn setTitleColor:[UIColor getColor:134 G:135 B:136] forState:UIControlStateNormal];
        self.cdTimer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(getCodeCountDown) userInfo:nil repeats:NO];
    }else{
        [self.sendCodeBtn setEnabled:YES];
        [self.sendCodeBtn setTitle:@"获取验证码" forState:UIControlStateNormal];
        [self.sendCodeBtn setTitleColor:[UIColor getBlueColor] forState:UIControlStateNormal];
    }
}
- (void)clearTimer{
    if(self.cdTimer){
        [self.cdTimer invalidate];
        self.cdTimer = nil;
    }
}

/**
 富文本可以点击的代理

 @param label lab
 @param phoneNumber 代号（标签）
 */
- (void)attributedLabel:(TTTAttributedLabel *)label didSelectLinkWithPhoneNumber:(NSString *)phoneNumber{
    if ([phoneNumber isEqualToString:@"login"]) {
        if (self.navigationController.viewControllers.count == 1) {
            UIViewController *vc= [[NSClassFromString(@"LogingVc") alloc] init];
            [self.navigationController pushViewController:vc animated:YES];
        }else
            [self.navigationController popViewControllerAnimated:YES];
    }else if ([phoneNumber isEqualToString:@"用户服务协议"]){
        
    }
}



/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (UIButton *)agreeBtn {
   if (!_agreeBtn) {
       _agreeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
       _agreeBtn.selected = YES;
       [_agreeBtn setImage:[UIImage imageNamed:@"unfinished"] forState:UIControlStateNormal];
       [_agreeBtn setImage:[UIImage imageNamed:@"finished"] forState:UIControlStateSelected];
       [_agreeBtn addTarget:self action:@selector(agreeBtnCLick) forControlEvents:UIControlEventTouchUpInside];
   }
   return _agreeBtn;
}

- (void)agreeBtnCLick{
    _agreeBtn.selected = !_agreeBtn.selected;
}
@end
