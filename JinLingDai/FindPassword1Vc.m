//
//  FindPassword1Vc.m
//  JinLingDai
//
//  Created by 001 on 2017/7/1.
//  Copyright © 2017年 JLD. All rights reserved.
//

#import "FindPassword1Vc.h"
#import "FindPassword2Vc.h"
#import <Masonry.h>
#import "UIColor+Util.h"
#import "GSValidate.h"
#import "MBProgressHUD+NetWork.h"
@interface FindPassword1Vc ()
@property (nonatomic, strong) UITextField *telText;
@property (nonatomic, strong) UITextField *PassText;
@property (nonatomic, strong)UIButton *sendCodeBtn;
@property (nonatomic, strong) NSTimer *cdTimer;                 //倒计时
@property (nonatomic) NSInteger countDown;                      //倒计时

@property (nonatomic, strong) UIButton *noMobile;//没有手机
@end
static NSInteger MAX_COUNTDOWN = 60;
@implementation FindPassword1Vc

- (void)viewDidLoad {
    [super viewDidLoad];

    [self setNavOrangeColor];
    self.title = @"找回密码";
    [self setLayoutContent];
}

- (void)backToLastVc{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)setLayoutContent{

    
    UIView *textBGView = [UIView new];
    textBGView.bounds = CGRectMake(0, 0, K_WIDTH - ChangedHeight(70), ChangedHeight(100));
    textBGView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:textBGView];
    [textBGView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view).offset(ChangedHeight(35));
        make.right.equalTo(self.view).offset(ChangedHeight(-35));
        make.height.mas_equalTo(ChangedHeight(100));
        make.top.equalTo(self.view).offset(ChangedHeight(100));
    }];
    textBGView.layer.cornerRadius = 5.f;
    
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
    leftImage.image = [UIImage imageNamed:@"手机"];
    leftImage.contentMode = UIViewContentModeScaleAspectFit;
    self.telText = [[UITextField alloc]init];
    self.telText.leftView = leftImage;
    self.telText.keyboardType = UIKeyboardTypeNumberPad;
    self.telText.leftViewMode = UITextFieldViewModeAlways;
    self.telText.attributedPlaceholder = [[NSAttributedString alloc]initWithString:@"请输入手机号" attributes:
                                          @{NSFontAttributeName:[UIFont gs_fontNum:14],
                                            NSForegroundColorAttributeName:[UIColor getColor:134 G:135 B:136]
                                            }];
    [textBGView addSubview:self.telText];
    [self.telText mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(textBGView).offset(ChangedHeight(5));
        make.right.top.equalTo(textBGView);
        make.bottom.equalTo(horLine.mas_top);
    }];
    _sendCodeBtn = [UIButton new];
    [_sendCodeBtn setTitle:@"发送验证码" forState:UIControlStateNormal];
    [_sendCodeBtn setTitleColor:[UIColor getBlueColor] forState:UIControlStateNormal];
    _sendCodeBtn.titleLabel.font = [UIFont gs_fontNum:13];
    [_sendCodeBtn addTarget:self action:@selector(sendCodeToTel) forControlEvents:UIControlEventTouchUpInside];
    _sendCodeBtn.bounds = CGRectMake(0, 0, ChangedHeight(70), ChangedHeight(50));
    
    UIImageView *leftImage2 = [[UIImageView alloc]init];
    //    leftImage2.backgroundColor  = [UIColor redColor];
    leftImage2.contentMode = UIViewContentModeScaleAspectFit;
    leftImage2.image = [UIImage imageNamed:@"验证码"];
    leftImage2.frame = CGRectMake(0, 0, ChangedHeight(30), ChangedHeight(20));
    self.PassText = [[UITextField alloc]init];
    self.PassText.keyboardType = UIKeyboardTypeNumberPad;
    self.PassText.leftView = leftImage2;
    self.PassText.leftViewMode = UITextFieldViewModeAlways;
    self.PassText.rightView = _sendCodeBtn;
    self.PassText.rightViewMode = UITextFieldViewModeAlways;
    self.PassText.attributedPlaceholder = [[NSAttributedString alloc]initWithString:@"请输入短信验证码" attributes:
                                           @{NSFontAttributeName:[UIFont gs_fontNum:14],
                                             NSForegroundColorAttributeName:[UIColor getColor:134 G:135 B:136]
                                             }];
    [textBGView addSubview:self.PassText];
    [self.PassText mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(textBGView).offset(ChangedHeight(5));
        make.right.bottom.equalTo(textBGView);
        make.top.equalTo(horLine.mas_bottom);
    }];
    
    
    self.noMobile = [UIButton buttonWithType:UIButtonTypeCustom];
    self.noMobile.titleLabel.font = [UIFont gs_fontNum:13];
    [self.noMobile addTarget:self action:@selector(NoMoblieToChangePass) forControlEvents:UIControlEventTouchUpInside];
    [self.noMobile setTitle:@"手机不在身边？" forState:UIControlStateNormal];
    [self.noMobile setTitleColor:[UIColor newSecondTextColor] forState:UIControlStateNormal];
    [self.view addSubview:self.noMobile];
    [self.noMobile mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(textBGView.mas_bottom).offset(ChangedHeight(5));
        make.right.equalTo(textBGView);
        make.height.mas_equalTo(ChangedHeight(30));
        make.width.mas_equalTo(ChangedHeight(100));
    }];
    
    UIButton *nextBtn = [UIButton new];
    [nextBtn addTarget:self action:@selector(nextStep) forControlEvents:UIControlEventTouchUpInside];
    [nextBtn setTitle:@"下一步" forState:UIControlStateNormal];
    nextBtn.layer.cornerRadius = 6;
    nextBtn.backgroundColor = [UIColor getOrangeColor];
    [self.view addSubview:nextBtn];
    [nextBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view);
        make.top.equalTo(self.noMobile.mas_bottom).offset(ChangedHeight(70));
        make.left.right.equalTo(textBGView);
        make.height.mas_equalTo(ChangedHeight(40));
    }];
    
}

- (void)NoMoblieToChangePass{
    UIViewController *vc = [[NSClassFromString(@"NoMoblieVc") alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
}
/**
 发送验证码的接口
 */
- (void)sendCodeToTel{
    if (![GSValidate validateString:self.telText.text withRequireType:RequireTypeIsMobile]) {
        [MBProgressHUD showError:@"请输入正确手机号"];
        return;
    }
    NSString *postUrl ;
    kAppPostHost(postUrl);
    [NetworkManager startNetworkRequestDataFromRemoteServerByPostMethodWithURLString:[NSString stringWithFormat:@"%@user/commitphone",postUrl]
    withParameters:@{
                     @"tel":self.telText.text,
                     @"type":@"2"
               }
     ShowHUD:YES
     success:^(NSURLSessionDataTask *task, id responseObject) {
         if ([responseObject[@"status"] integerValue] == 200) {
             dispatch_async(dispatch_get_main_queue(), ^{
                 [MBProgressHUD showSuccess:@"验证码已发送"];
                 self.countDown = MAX_COUNTDOWN;
                 [self getCodeCountDown];
             });
             
         }
     } failure:^(NSURLSessionDataTask *task, NSError *error) {
         
     }];
    
}

/**
 找回密码第二步
 */
- (void)nextStep{
    if (![GSValidate validateString:self.telText.text withRequireType:RequireTypeIsMobile]) {
        [MBProgressHUD showError:@"请输入正确手机号"];
        return;
    }
    if (!self.PassText.text.length) {
        [MBProgressHUD showError:@"请输入验证码"];
        return;
    }
    NSString *postUrl ;
    kAppPostHost(postUrl);
    [NetworkManager startNetworkRequestDataFromRemoteServerByPostMethodWithURLString:[NSString stringWithFormat:@"%@user/verifycode",postUrl]
        withParameters:@{
                        @"tel":self.telText.text,
                        @"verify_code":self.PassText.text
                   }
     ShowHUD:YES 
         success:^(NSURLSessionDataTask *task, id responseObject) {
             if ([responseObject[@"status"] integerValue] == 200){
                 dispatch_async(dispatch_get_main_queue(), ^{
                     FindPassword2Vc *vc = [[FindPassword2Vc alloc]init];
                     vc.telStr = [self.telText.text copy];
                     vc.codelStr = [self.PassText.text copy];
                     [self.navigationController pushViewController:vc animated:YES];
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
