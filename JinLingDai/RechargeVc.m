//
//  RechargeVc.m
//  JinLingDai
//
//  Created by 001 on 2017/7/3.
//  Copyright © 2017年 JLD. All rights reserved.
//

#import "RechargeVc.h"
#import <Masonry.h>
#import <YYKit.h>
#import <TTTAttributedLabel.h>
#import "UIColor+Util.h"
#import "JiaoYiMoneyView.h"
#import "JLDShareManager.h"
#import "IQKeyboardManager.h"
#import "MBProgressHUD+NetWork.h"
#import "ExplainVc.h"
#import "GSValidate.h"
#import "HTMLVC.h"
#import <IQUIView+IQKeyboardToolbar.h>
#import <IQKeyboardReturnKeyHandler.h>
//#import <FUMobilePay/FUMobilePay.h>
@interface RechargeVc ()<UITableViewDelegate,UITableViewDataSource,UITextFieldDelegate>
{
    UIImageView *logoImage;
    UILabel *bankNameLab;
    UILabel *cartNumLab;
    BOOL _wasKeyboardManagerEnabled;
    IQKeyboardReturnKeyHandler *returnKeyHandler;
}
@property (nonatomic, strong) UITableView *myTab;
@property (nonatomic, strong) UITextField *moneyText;//输入金额
@property (nonatomic, strong) UIView *footerView;
@property (nonatomic, strong) UIView *bankView;
@property (nonatomic, strong) JiaoYiMoneyView *jiaoyiAlert;
@property (nonatomic, copy) NSString *password;
@property (nonatomic, strong) UITextField *PassText;
@property (nonatomic, strong) TTTAttributedLabel *agreementLab;
@property (nonatomic, strong)UIButton *sendCodeBtn;
@property (nonatomic, strong) NSTimer *cdTimer;                 //倒计时
@property (nonatomic) NSInteger countDown;                      //倒计时
@end
static NSInteger MAX_COUNTDOWN = 60;
@implementation RechargeVc

- (void)goBack{
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)dealloc{
//    returnKeyHandler = nil;
}

- (void)viewDidLoad {
    [super viewDidLoad];
//    returnKeyHandler = [[IQKeyboardReturnKeyHandler alloc] initWithViewController:self];
    self.view.backgroundColor = [UIColor whiteColor];
    [self setNavBlackColor];
    self.title = @"充值";
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:@"充值说明" style:UIBarButtonItemStylePlain target:self action:@selector(rechargeInfo)];
    self.myTab = [[UITableView alloc]initWithFrame:CGRectZero style:UITableViewStyleGrouped];
    self.myTab.delegate = self;
    self.myTab.dataSource = self;
    self.myTab.estimatedSectionHeaderHeight = 0;
    self.myTab.estimatedSectionFooterHeight = 0;
    self.myTab.sectionFooterHeight = 0.1;
    self.myTab.sectionHeaderHeight = ChangedHeight(5);
    [self.myTab registerClass:[UITableViewCell class] forCellReuseIdentifier:@"remainCell"];
    [self.myTab registerClass:[UITableViewCell class] forCellReuseIdentifier:@"rechargeCell"];
    
    self.myTab.tableFooterView = self.footerView;
    [self.view addSubview:self.self.myTab];
    [self.myTab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
    
    self.moneyText = [[UITextField alloc]init];
    self.moneyText.font = [UIFont gs_fontNum:14];
    self.moneyText.keyboardType = UIKeyboardTypeDecimalPad;
    self.moneyText.delegate = self;
    self.moneyText.attributedPlaceholder = [[NSAttributedString alloc]initWithString:@"输入充值金额" attributes:@{NSFontAttributeName:[UIFont gs_fontNum:14],NSForegroundColorAttributeName:[UIColor getColor:134 G:135 B:136]}];
    
    
    self.jiaoyiAlert = [[JiaoYiMoneyView alloc]init];
    
    __weak typeof(self) weakSelf = self;
    self.jiaoyiAlert.inputPassEndBlock = ^(NSString *password) {
        [weakSelf.jiaoyiAlert hidenAlertType];
        weakSelf.password = password;
        [weakSelf jiaoyiLoadResult:password];
    };
    
    if (self.bankView) {
        [self setBankInfo];
    }
    
    _sendCodeBtn = [UIButton new];
    [_sendCodeBtn setTitle:@"发送验证码" forState:UIControlStateNormal];
    [_sendCodeBtn setTitleColor:[UIColor getBlueColor] forState:UIControlStateNormal];
    _sendCodeBtn.titleLabel.font = [UIFont gs_fontNum:13];
    [_sendCodeBtn addTarget:self action:@selector(sendCodeToTel) forControlEvents:UIControlEventTouchUpInside];
    _sendCodeBtn.bounds = CGRectMake(0, 0, ChangedHeight(70), ChangedHeight(50));
    self.PassText = [[UITextField alloc]init];
    self.PassText.keyboardType = UIKeyboardTypeNumberPad;

    self.PassText.rightView = _sendCodeBtn;
    self.PassText.rightViewMode = UITextFieldViewModeAlways;
    self.PassText.attributedPlaceholder = [[NSAttributedString alloc]initWithString:@"请输入短信验证码" attributes:
                                           @{NSFontAttributeName:[UIFont gs_fontNum:14],
                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                  NSForegroundColorAttributeName:[UIColor getColor:134 G:135 B:136]
                                             }];
    [self loadBankLimit];
}
-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    _wasKeyboardManagerEnabled = [[IQKeyboardManager sharedManager] isEnabled];
    [[IQKeyboardManager sharedManager] setEnable:NO];
//    [IQKeyboardManager sharedManager].toolbarDoneBarButtonItemImage = [UIImage imageNamed:@"红包关闭按钮"];
}

-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [[IQKeyboardManager sharedManager] setEnable:_wasKeyboardManagerEnabled];
    
    
}
/**
 表的脚部

 @return 脚
 */
- (UIView *)footerView{
    if (!_footerView) {
        _footerView = [UIView new];
        _agreementLab = [TTTAttributedLabel new];
        _agreementLab.numberOfLines = 2;
        _agreementLab.font = [UIFont gs_fontNum:13];
        _agreementLab.textColor = [UIColor getColor:134 G:135 B:136];
        NSString *tipStr = @"温馨提示：每日单笔不能超过5万,充值前请先阅读《充值说明》";
        [_agreementLab setText:tipStr afterInheritingLabelAttributesAndConfiguringWithBlock:^NSMutableAttributedString *(NSMutableAttributedString *mutableAttributedString) {
            NSMutableParagraphStyle *style = [[NSMutableParagraphStyle alloc] init];
            style.lineSpacing = ChangedHeight(6);
            
            [mutableAttributedString addAttribute:NSParagraphStyleAttributeName value:style range:NSMakeRange(0, tipStr.length)];
            return mutableAttributedString;
        }];
        
        _agreementLab.linkAttributes = @{
                                        (id)kCTForegroundColorAttributeName:[UIColor getBlueColor]
                                        };
        TTTAttributedLabelLink *labLink = [_agreementLab addLinkToPhoneNumber:@"agreement" withRange:[tipStr  rangeOfString:@"《充值说明》"]];
        labLink.linkTapBlock = ^(TTTAttributedLabel *lab, TTTAttributedLabelLink *link) {

            [self rechargeInfo];
        };

        [_footerView addSubview:_agreementLab];
        [_agreementLab mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(_footerView).offset(ChangedHeight(-10));
            make.left.top.equalTo(_footerView).offset(ChangedHeight(10));
//            make.height.mas_equalTo(ChangedHeight(20));
        }];
        _footerView.height = ChangedHeight(140);
        UIButton *btn = [UIButton new];
        [btn addTarget:self action:@selector(rechargeMoney) forControlEvents:UIControlEventTouchUpInside];
        [btn setTitle:@"充值" forState:UIControlStateNormal];
        btn.titleLabel.font = [UIFont gs_fontNum:15];
        btn.layer.cornerRadius = 4;
        btn.backgroundColor = [UIColor getOrangeColor];
        [_footerView addSubview:btn];
        [btn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(_footerView).insets(UIEdgeInsetsMake(ChangedHeight(90), ChangedHeight(35), ChangedHeight(10), ChangedHeight(35)));
        }];
        
    }
    return _footerView;
}

/**
 获取银行的信息view

 @return 银行的信息view
 */
- (UIView *)bankView{
    if (!_bankView) {
        _bankView = [UIView new];
        
        logoImage = [[UIImageView alloc]init];
        [_bankView addSubview:logoImage];
        
        [logoImage mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(_bankView);
            make.left.equalTo(_bankView).offset(ChangedHeight(10));
            make.width.height.mas_equalTo(ChangedHeight(45));
        }];
        
        
        bankNameLab = [UILabel new];
        bankNameLab.textColor = [UIColor darkGrayColor];
        bankNameLab.font = [UIFont systemFontOfSize:18 weight:UIFontWeightMedium];
        [_bankView addSubview:bankNameLab];
        [bankNameLab mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(logoImage);
            make.left.equalTo(logoImage.mas_right).offset(ChangedHeight(15));
        }];
        
        cartNumLab = [UILabel new];
        cartNumLab.textColor = [UIColor darkGrayColor];
        cartNumLab.font = [UIFont gs_fontNum:13];
        [_bankView addSubview:cartNumLab];
        [cartNumLab mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.equalTo(logoImage);
            make.left.equalTo(logoImage.mas_right).offset(ChangedHeight(15));
        }];
    }
    return _bankView;
}

- (void)setBankInfo{
    bankModel *model = [UserManager shareManager].user.bank_data[0];
    [logoImage sd_setImageWithURL:[NSURL URLWithString:model.bank_img] placeholderImage:[UIImage imageNamed:model.UseableBankName] options:SDWebImageAllowInvalidSSLCertificates completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
        if (error) {
            logoImage.image = [UIImage imageNamed:model.UseableBankName];
        }
    }];
    
    bankNameLab.text = Nilstr2Space(model.UseableBankName);
    
    cartNumLab.text = model.bankNumText;
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
     NSString *toString = [textField.text stringByReplacingCharactersInRange:range withString:string];
    if (toString.length) {
        if (![GSValidate validateString:toString withRequireType:RequireTypeMoney]) {
            return NO;
        }
    }
    return YES;
}
//- (BOOL)textFieldShouldEndEditing:(UITextField *)textField{
//    if (textField.text.length &&![GSValidate validateString:textField.text withRequireType:RequireTypeMoney]) {
//        [MBProgressHUD showError:@"请输入正确的金额"];
//        textField.text = @"";
//    }
//    return YES;
//}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 4;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(nonnull NSIndexPath *)indexPath{
    switch (indexPath.row) {
        case 0:
            return ChangedHeight(50);
            break;
        case 1:
            return ChangedHeight(95);
            break;
        default:return ChangedHeight(40);
            break;
    }
    return ChangedHeight(5);
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row == 0) {
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"remainCell"];
        [cell setSeparatorInset:UIEdgeInsetsZero];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        NSMutableAttributedString *attr = [[NSMutableAttributedString alloc]initWithString:[NSString stringWithFormat:@"账户余额：%@元",[UserManager shareManager].money.active_balance] attributes:
        @{NSForegroundColorAttributeName:[UIColor grayColor],
          NSFontAttributeName:[UIFont gs_fontNum:13]
          }];
        [attr addAttribute:NSForegroundColorAttributeName value:[UIColor getOrangeColor] range:[attr.string rangeOfString:[UserManager shareManager].money.active_balance]];
        cell.textLabel.attributedText = attr;
        cell.imageView.image = [UIImage imageNamed:@"充值"];
        return cell;
    }else{
        
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"rechargeCell"];
//        [cell setSeparatorInset:UIEdgeInsetsZero];
        cell.textLabel.textColor = [UIColor darkGrayColor];
        cell.textLabel.font = [UIFont gs_fontNum:13];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        if (indexPath.row == 1) {
            [cell.contentView addSubview:self.bankView];
            [self.bankView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.edges.equalTo(cell.contentView);
            }];
        }else if(indexPath.row == 2){
            cell.textLabel.text = @"充值金额：";
//            [cell.textLabel sizeToFit];
            [cell.contentView addSubview:self.moneyText];
            [self.moneyText mas_makeConstraints:^(MASConstraintMaker *make) {
                make.centerY.equalTo(cell.contentView);
                make.left.equalTo(cell.contentView).offset(ChangedHeight(95));
                make.right.equalTo(cell.contentView);
            }];
//        }else if (indexPath.row == 3){
//            cell.textLabel.text = @"预留手机号：";
//
//            [cell.contentView addSubview:self.telText];
//            [self.telText mas_makeConstraints:^(MASConstraintMaker *make) {
//                make.centerY.equalTo(cell.contentView);
//                make.left.equalTo(cell.contentView).offset(ChangedHeight(95));
//                make.right.equalTo(cell.contentView);
//            }];
        }else{
            cell.textLabel.text = @"手机验证码：";
            
            [cell.contentView addSubview:self.PassText];
            [self.PassText mas_makeConstraints:^(MASConstraintMaker *make) {
                make.centerY.equalTo(cell.contentView);
                make.left.equalTo(cell.contentView).offset(ChangedHeight(95));
                make.right.equalTo(cell.contentView);
            }];
        }
        return cell;
    }
    
}
/**
 充值
 */
- (void)rechargeMoney{
    if ([self.moneyText.text floatValue] < 100) {
        [MBProgressHUD showError:@"充值金额不能小于100元"];
        return;
    }
    if (!self.PassText.text.length) {
        [MBProgressHUD showError:@"请输入验证码"];
        return;
    }
    self.jiaoyiAlert.titleStr = @"请输入交易密码";
    self.jiaoyiAlert.moneyStr = [NSString stringWithFormat:@"%.2f（元）",[self.moneyText.text floatValue]];
    [self.jiaoyiAlert showAlertType];
}

/**
 充值说明额
 */
- (void)rechargeInfo{
    HTMLVC *vc = [[HTMLVC alloc]init];
    vc.title = @"充值说明";
    NSString *postUrl ;
    kAppPostHost(postUrl);
    vc.H5Url = [NSString stringWithFormat:@"%@User/tibchong",postUrl];
    [self.navigationController pushViewController:vc animated:YES];

}

/**
 输入交易密码后调用充值
 */
- (void)jiaoyiLoadResult:(NSString *)password{
    NSString *postUrl ;
    kAppPostHost(postUrl);
    [NetworkManager startNetworkRequestDataFromRemoteServerByPostMethodWithURLString:[NSString stringWithFormat:@"%@bank/actcharge_quick",postUrl]
    withParameters:@{
                   @"amount":self.moneyText.text,//    充值金额    string
                   @"mcode":self.PassText.text ,//   验证码    string
                   @"tradepwd":password ,//   交易密码    string
                   @"token":[UserManager shareManager].userId//    用户id    string
                   }
         ShowHUD:YES
         success:^(NSURLSessionDataTask *task, id responseObject) {
             if ([responseObject[@"status"] integerValue] == 200) {
                 dispatch_async(dispatch_get_main_queue(), ^{
                     
                     [MBProgressHUD showSuccess:@"支付成功，银行处理中"];
                     dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.f * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                         [self.navigationController popViewControllerAnimated:YES];
                     });
                 });
                 
             }
         } failure:^(NSURLSessionDataTask *task, NSError *error) {
             
         }];
   
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/** 发送验证码的接口 */
- (void)sendCodeToTel{
//    if (![UserManager shareManager].hasGuanLianTel) {
//        [MBProgressHUD showError:@"请输入正确手机号"];
//        return;
//        
//    }
    NSString *postUrl ;
    kAppPostHost(postUrl);
    [NetworkManager startNetworkRequestDataFromRemoteServerByPostMethodWithURLString:[NSString stringWithFormat:@"%@bank/applysms",postUrl]
          withParameters:@{
                           @"token":[UserManager shareManager].userId
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
/** 倒计时 */
- (void)getCodeCountDown{
    [self clearTimer];
    self.countDown--;
    if(self.countDown > 0){
        [self.sendCodeBtn setEnabled:NO];
        [self.sendCodeBtn setTitle:[NSString stringWithFormat:@"%d秒后获取", (int)self.countDown] forState:UIControlStateNormal];
        //        self.sendCodeBtn.layer.borderColor = GS_COLOR_GRAY.CGColor;
        [self.sendCodeBtn setTitleColor:[UIColor getColor:134 G:135 B:136] forState:UIControlStateNormal];        self.cdTimer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(getCodeCountDown) userInfo:nil repeats:NO];
        
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

- (void)loadBankLimit{
    NSString *postUrl ;
    kAppPostHost(postUrl);
    [NetworkManager startNetworkRequestDataFromRemoteServerByPostMethodWithURLString:[NSString stringWithFormat:@"%@bank/get_limit_money",postUrl]
          withParameters:@{
                           @"token":[UserManager shareManager].userId
                           }
                 ShowHUD:YES
                 success:^(NSURLSessionDataTask *task, id responseObject) {
                     if ([responseObject[@"status"] integerValue] == 200) {
                         dispatch_async(dispatch_get_main_queue(), ^{
                             if ([responseObject[@"data"] isKindOfClass:[NSArray class]]) {
                                 return ;
                             }
                             if ([responseObject[@"data"] isKindOfClass:[NSDictionary class]]) {
                                 if (!responseObject[@"data"][@"str_limit"]) {
                                     return;
                                 }
                             }
                             NSString *tipStr = [NSString stringWithFormat:@"温馨提示：%@,充值前请先阅读《充值说明》",responseObject[@"data"][@"str_limit"]];
                             [_agreementLab setText:tipStr afterInheritingLabelAttributesAndConfiguringWithBlock:^NSMutableAttributedString *(NSMutableAttributedString *mutableAttributedString) {
                                 NSMutableParagraphStyle *style = [[NSMutableParagraphStyle alloc] init];
                                 style.lineSpacing = ChangedHeight(6);
                                 
                                 [mutableAttributedString addAttribute:NSParagraphStyleAttributeName value:style range:NSMakeRange(0, tipStr.length)];
                                 return mutableAttributedString;
                             }];
                             TTTAttributedLabelLink *labLink = [_agreementLab addLinkToPhoneNumber:@"agreement" withRange:[tipStr  rangeOfString:@"《充值说明》"]];
                             labLink.linkTapBlock = ^(TTTAttributedLabel *lab, TTTAttributedLabelLink *link) {
                                 
                                 [self rechargeInfo];
                             };
                             
                         });
                     }
                 } failure:^(NSURLSessionDataTask *task, NSError *error) {
                     
                 }];
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
