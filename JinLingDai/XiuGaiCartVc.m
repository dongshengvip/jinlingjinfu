//
//  XiuGaiCartVc.m
//  JinLingDai
//
//  Created by 001 on 2017/7/5.
//  Copyright © 2017年 JLD. All rights reserved.
//

#import "XiuGaiCartVc.h"
#import "UIImage+Comment.h"
#import "MBProgressHUD+NetWork.h"
#import "JiaoYiMoneyView.h"
#import <SDWebImageManager.h>
@interface XiuGaiCartVc ()
{
    UIButton *logoBtn;
}
@property (nonatomic, strong) UIImageView *cartBGView;
@property (nonatomic, strong) UIImageView *cartLogo;
@property (nonatomic, strong) UILabel *cartLab;
@property (nonatomic, strong) UILabel *cartNumLab;
@property (nonatomic, strong) JiaoYiMoneyView *jiaoyiAlert;
@end

@implementation XiuGaiCartVc

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setNavBlackColor];
    self.title = @"解绑银行卡";
    
    UIScrollView *scroll = [[UIScrollView alloc] init];
    scroll.scrollEnabled = NO;
    [self.view addSubview:scroll];
    [scroll mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
    
    UIView *helperView = [UIView new];
    [scroll addSubview:helperView];
    [helperView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(scroll);
        make.width.equalTo(self.view);
        make.height.equalTo(self.view).offset(-StatusBarHeight - 44);
    }];
    
    self.cartBGView = [[UIImageView alloc]init];
    self.cartBGView.image = [UIImage imageNamed:@"银行卡背景"];
    self.cartBGView.layer.cornerRadius = 6;
    [helperView addSubview:self.cartBGView];
    [self.cartBGView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(helperView).offset(ChangedHeight(15));
        make.right.equalTo(helperView).offset(ChangedHeight(- 15));
        make.top.equalTo(helperView).offset(ChangedHeight(10));
        make.height.mas_equalTo(ChangedHeight(120));
    }];
    
    self.cartLogo = [[UIImageView alloc]init];
    
    
    [self.cartLogo.image imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];

    [self.cartBGView addSubview:self.cartLogo];
    [self.cartLogo mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.cartBGView).offset(ChangedHeight(15));
        make.top.equalTo(self.cartBGView).offset(ChangedHeight(10));
        make.size.mas_equalTo(CGSizeMake(ChangedHeight(20), ChangedHeight(20)));
    }];
    
    
    logoBtn = [UIButton new];
    
//    [logoBtn setTintColor:[UIColor redColor]];
    [self.cartBGView addSubview:logoBtn];
    [logoBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(self.cartBGView);
        make.height.equalTo(self.cartBGView).offset(ChangedHeight( - 30));
        make.width.equalTo(logoBtn.mas_height);
    }];
    
    self.cartLab = [UILabel new];
    self.cartLab.font = [UIFont gs_fontNum:15];
    [self.cartBGView addSubview:self.cartLab];
    [self.cartLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.cartLogo.mas_right).offset(ChangedHeight(8));
        make.centerY.equalTo(self.cartLogo);
    }];
    
    self.cartNumLab = [UILabel new];
    self.cartNumLab.textColor = [UIColor whiteColor];
    self.cartNumLab.textAlignment = NSTextAlignmentCenter;
    self.cartNumLab.font = [UIFont gs_fontNum:18];
    [self.cartBGView addSubview:self.cartNumLab];
    [self.cartNumLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.cartBGView.mas_centerY);
        make.left.right.equalTo(self.cartBGView);
    }];
    
    UIButton *btn = [UIButton new];
    [btn addTarget:self action:@selector(rechargeMoney) forControlEvents:UIControlEventTouchUpInside];
    [btn setTitle:@"确认解绑" forState:UIControlStateNormal];
    btn.titleLabel.font = [UIFont gs_fontNum:15];
    btn.layer.cornerRadius = 4;
    btn.backgroundColor = [UIColor getOrangeColor];
    [helperView addSubview:btn];
    [btn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view).offset(ChangedHeight(35));
        make.right.equalTo(self.view).offset(ChangedHeight(- 35));
        make.height.mas_equalTo(ChangedHeight(40));
        make.top.equalTo(self.cartBGView.mas_bottom).offset(ChangedHeight(170));
    }];
    
    self.jiaoyiAlert = [[JiaoYiMoneyView alloc]init];
    
    __weak typeof(self) weakSelf = self;
    self.jiaoyiAlert.inputPassEndBlock = ^(NSString *password) {
        [weakSelf.jiaoyiAlert hidenAlertType];
//        weakSelf.password = password;
        [weakSelf jiaoyiLoadResult:password];
    };
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    bankModel *bankModel = [UserManager shareManager].user.bank_data[0];
    self.cartLab.text = bankModel.UseableBankName;
    self.cartNumLab.text = bankModel.bankNumText;
    [self.cartLogo sd_setImageWithURL:[NSURL URLWithString:bankModel.bank_img] placeholderImage:[UIImage imageNamed:bankModel.UseableBankName] options:SDWebImageAllowInvalidSSLCertificates completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
        if (error) {
            self.cartLogo.image = [UIImage imageNamed:bankModel.UseableBankName];
        }
    }];
    
    
    UIImage *cartImg = [UIImage imageNamed:bankModel.UseableBankName];
    [cartImg imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
    
    [logoBtn setBackgroundImage:[cartImg imageWithColor:[UIColor colorWithRed:240/255.0 green:240/255.0 blue:240/255.0 alpha:0.4]] forState:UIControlStateNormal];
}

/**
 输入交易密码后调用充值
 */
- (void)jiaoyiLoadResult:(NSString *)password{
    NSString *postUrl ;
    kAppPostHost(postUrl);
        [NetworkManager startNetworkRequestDataFromRemoteServerByPostMethodWithURLString:[NSString stringWithFormat:@"%@user/verifytradepwd",postUrl]
                  withParameters:@{
                                   @"trade_pwd":password,//    支付密码    string
                                   @"token":[UserManager shareManager].userId//    用户id    string
                                   }
                         ShowHUD:YES
                         success:^(NSURLSessionDataTask *task, id responseObject) {
                             if ([responseObject[@"status"] integerValue] == 200) {
                                 dispatch_async(dispatch_get_main_queue(), ^{
                                     [self jiebangcart:password];
                                     
                                 });
                                 
                             }
                         } failure:^(NSURLSessionDataTask *task, NSError *error) {
                             
                         }];

}
- (void)rechargeMoney{
    self.jiaoyiAlert.titleStr = @"解绑银行卡";
    self.jiaoyiAlert.moneyStr = @"请输入支付密码进行解绑";
    
    [self.jiaoyiAlert showAlertType];
}
- (void)jiebangcart:(NSString *)password{
    NSString *postUrl ;
    kAppPostHost(postUrl);
    [NetworkManager startNetworkRequestDataFromRemoteServerByPostMethodWithURLString:[NSString stringWithFormat:@"%@bank/unbind",postUrl]
      withParameters:@{
                       @"token":[UserManager shareManager].userId   // 用户token    string
                       }
             ShowHUD:YES
             success:^(NSURLSessionDataTask *task, id responseObject) {
                 if ([responseObject[@"status"]integerValue] == 200 ) {
                     

//                         [[UserManager shareManager] loadMewModel:^(BOOL succ) {
                             dispatch_async(dispatch_get_main_queue(), ^{
                             [MBProgressHUD showSuccess:@"解绑银行卡成功"];
                             if (self.JieBangCartBlock) {
                                 UserModel *model = [UserManager shareManager].user;
                                 model.bind_status = @"0";
                                 [[UserManager shareManager] saveUserModel:model];
                                 _JieBangCartBlock(YES);
                             }
                             [self.navigationController popViewControllerAnimated:YES];
                                 });
//                         }];
                     
                     
                 }
             } failure:^(NSURLSessionDataTask *task, NSError *error) {
                 
             }];
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
