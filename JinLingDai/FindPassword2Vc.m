//
//  FindPassword2Vc.m
//  JinLingDai
//
//  Created by 001 on 2017/7/1.
//  Copyright © 2017年 JLD. All rights reserved.
//

#import "FindPassword2Vc.h"
#import "MBProgressHUD+NetWork.h"
@interface FindPassword2Vc (){
    UIView *textBGView;
    UIButton *nextBtn;
}
@property (nonatomic, strong) UITextField *password1Text;
@property (nonatomic, strong) UITextField *password2Text;
@property (nonatomic, strong) UIView *tipView;
@end

@implementation FindPassword2Vc

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"找回密码";
    [self setNavOrangeColor];
    [self setLayoutContent];
}

- (void)setLayoutContent{
    textBGView = [UIView new];
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
    leftImage.image = [UIImage imageNamed:@"密码"];
    leftImage.contentMode = UIViewContentModeScaleAspectFit;
    self.password1Text = [[UITextField alloc]init];
    self.password1Text.leftView = leftImage;
    self.password1Text.secureTextEntry = YES;
    self.password1Text.leftViewMode = UITextFieldViewModeAlways;
    self.password1Text.attributedPlaceholder = [[NSAttributedString alloc]initWithString:@"请输入8位以上数字或字母组合新密码" attributes:
                                          @{NSFontAttributeName:[UIFont gs_fontNum:13],
                                            NSForegroundColorAttributeName:[UIColor getColor:134 G:135 B:136]
                                            }];
    [textBGView addSubview:self.password1Text];
    [self.password1Text mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(textBGView).offset(ChangedHeight(5));
        make.right.top.equalTo(textBGView);
        make.bottom.equalTo(horLine.mas_top);
    }];
    
    UIImageView *leftImage2 = [[UIImageView alloc]init];
    //    leftImage2.backgroundColor  = [UIColor redColor];
    leftImage2.contentMode = UIViewContentModeScaleAspectFit;
    leftImage2.image = [UIImage imageNamed:@"密码"];
    leftImage2.frame = CGRectMake(0, 0, ChangedHeight(30), ChangedHeight(20));
    self.password2Text = [[UITextField alloc]init];
    self.password2Text.leftView = leftImage2;
    self.password2Text.secureTextEntry = YES;
    self.password2Text.leftViewMode = UITextFieldViewModeAlways;
    self.password2Text.attributedPlaceholder = [[NSAttributedString alloc]initWithString:@"确认密码" attributes:
                                           @{NSFontAttributeName:[UIFont gs_fontNum:14],
                                             NSForegroundColorAttributeName:[UIColor getColor:134 G:135 B:136]
                                             }];
    [textBGView addSubview:self.password2Text];
    [self.password2Text mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(textBGView).offset(ChangedHeight(5));
        make.right.bottom.equalTo(textBGView);
        make.top.equalTo(horLine.mas_bottom);
    }];
    
    
    
    
    nextBtn = [UIButton new];
    [nextBtn addTarget:self action:@selector(nextStep:) forControlEvents:UIControlEventTouchUpInside];
    [nextBtn setTitle:@"确定" forState:UIControlStateNormal];
    nextBtn.layer.cornerRadius = 6;
    nextBtn.backgroundColor = [UIColor getOrangeColor];
    [self.view addSubview:nextBtn];
    [nextBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view);
        make.top.equalTo(textBGView.mas_bottom).offset(ChangedHeight(70));
        make.left.right.equalTo(textBGView);
        make.height.mas_equalTo(ChangedHeight(40));
    }];
    
}

- (UIView *)tipView{
    if (!_tipView) {
        _tipView = [UIView new];
        UIImageView *logoImg = [[UIImageView alloc]init];
        logoImg.image = [UIImage imageNamed:@"√"];
        [_tipView addSubview:logoImg];
        [logoImg mas_makeConstraints:^(MASConstraintMaker *make) {
            make.width.height.mas_equalTo(ChangedHeight(70));
            make.centerX.equalTo(_tipView);
            make.top.equalTo(_tipView);
        }];
        
        UILabel *lab = [UILabel new];
        lab.textColor = [UIColor getOrangeColor];
        lab.text = @"恭喜您，密码设置成功，请重新登录";
        [_tipView addSubview:lab];
        [lab mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.bottom.equalTo(_tipView);
        }];
        
    }
    return _tipView;
}

/**
 下一步
 */
- (void)nextStep:(UIButton *)sender{
    sender.selected = !sender.selected;
    
    if (sender.selected) {
        if (self.password1Text.text.length < 8) {
            [MBProgressHUD showError:@"请输入8位数以上密码"];
            return;
        }
        if (![self.password1Text.text isEqualToString:self.password2Text.text]) {
            [MBProgressHUD showError:@"两次输入的密码不一致"];
            return;
        }
        [self.view endEditing:YES];
        sender.enabled = NO;
        NSString *postUrl ;
        kAppPostHost(postUrl);
        [NetworkManager startNetworkRequestDataFromRemoteServerByPostMethodWithURLString:[NSString stringWithFormat:@"%@user/resetpwd",postUrl]
        withParameters:@{
                         @"tel":self.telStr,
                         @"new_pwd":self.password1Text.text,
                         @"verify_code":self.codelStr
                         }
         ShowHUD:YES 
         success:^(NSURLSessionDataTask *task, id responseObject) {
             dispatch_async(dispatch_get_main_queue(), ^{
                 nextBtn.enabled = YES;
             });
             if ([responseObject[@"status"] integerValue] == 200) {
                 dispatch_async(dispatch_get_main_queue(), ^{
                     
                     textBGView.hidden = YES;
                     [self.view addSubview:self.tipView];
                     [self.tipView mas_makeConstraints:^(MASConstraintMaker *make) {
                         make.width.centerX.centerY.equalTo(textBGView);
                         make.height.mas_equalTo(ChangedHeight(110));
                     }];
                     [sender setTitle:@"立即登录" forState:UIControlStateNormal];
                 });
             }
         } failure:^(NSURLSessionDataTask *task, NSError *error) {
             dispatch_async(dispatch_get_main_queue(), ^{
                 nextBtn.enabled = YES;
             });
         }];
        
    }else{
        //登录吧
        [self.navigationController popToRootViewControllerAnimated:YES];
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
