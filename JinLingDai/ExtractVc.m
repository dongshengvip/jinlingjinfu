//
//  ExtractVc.m
//  JinLingDai
//
//  Created by 001 on 2017/7/3.
//  Copyright © 2017年 JLD. All rights reserved.
//

#import "ExtractVc.h"
#import "ExtractMoneyView.h"
#import "UserManager.h"
#import <YYKit.h>
#import <TTTAttributedLabel.h>
#import "UIImage+Comment.h"
#import "IQKeyboardManager.h"
#import "ExplainVc.h"
#import "JiaoYiMoneyView.h"
#import "GSValidate.h"
#import "MBProgressHUD+NetWork.h"
#import "HTMLVC.h"
#import "RunningWaterVc.h"
@interface ExtractVc ()<UITableViewDelegate,UITableViewDataSource,UITextFieldDelegate>{
    BOOL _wasKeyboardManagerEnabled;
}
@property (nonatomic, strong) UITableView *myTab;
//@property (nonatomic, strong) UITextField *moneyText;//输入金额
@property (nonatomic, strong) UIView *footerView;
@property (nonatomic, strong) ExtractMoneyView *extractView;
@property (nonatomic, strong) UIButton *tipBtn;//余额不足提示
@property (nonatomic, strong) UserModel *user;
@property (nonatomic, copy) NSString *password;
@property (nonatomic, copy) NSString *feeMoney;
@property (nonatomic, strong) JiaoYiMoneyView *jiaoyiAlert;
@property (nonatomic, strong) UITextField *PassText;
@property (nonatomic, strong)UIButton *sendCodeBtn;
@property (nonatomic, strong) NSTimer *cdTimer;                 //倒计时
@property (nonatomic) NSInteger countDown;                      //倒计时

@end
static NSInteger MAX_COUNTDOWN = 60;
@implementation ExtractVc

- (void)goBack{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    [self setNavBlackColor];
    self.title = @"提现";
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:@"提现说明" style:UIBarButtonItemStylePlain target:self action:@selector(rechargeInfo)];
    
    self.myTab = [[UITableView alloc]initWithFrame:CGRectZero style:UITableViewStyleGrouped];
    self.myTab.delegate = self;
    self.myTab.dataSource = self;
    self.myTab.sectionFooterHeight = ChangedHeight(5);
    self.myTab.sectionHeaderHeight = ChangedHeight(5);
    [self.myTab registerClass:[UITableViewCell class] forCellReuseIdentifier:@"remainCell"];
    
    self.myTab.tableFooterView = self.footerView;
    [self.view addSubview:self.self.myTab];
    [self.myTab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
    
   
    
    self.extractView = [ExtractMoneyView new];
    self.extractView.moneyText.delegate = self;
    
    self.tipBtn = [UIButton new];
    self.tipBtn.titleLabel.font = [UIFont gs_fontNum:12];
    [self.tipBtn setImage:[UIImage imageNamed:@"账户余额不足"] forState:UIControlStateNormal];
    [self.tipBtn setTitle:@"账户余额不足" forState:UIControlStateNormal];
    [self.tipBtn setImageEdgeInsets:UIEdgeInsetsMake(0, -2, 0, 0)];
    [self.tipBtn setTitleEdgeInsets:UIEdgeInsetsMake(0, 2, 0, 0)];
    [self.tipBtn setTitleColor:[UIColor getOrangeColor] forState:UIControlStateNormal];
    self.user = [UserManager shareManager].user;
    
    self.jiaoyiAlert = [[JiaoYiMoneyView alloc]init];
    
    __weak typeof(self) weakSelf = self;
    self.jiaoyiAlert.inputPassEndBlock = ^(NSString *password) {
        [weakSelf.jiaoyiAlert hidenAlertType];
        weakSelf.password = password;
        [weakSelf jiaoyiLoadResult:password];
    };
    
    _sendCodeBtn = [UIButton new];
    [_sendCodeBtn setTitle:@"发送验证码" forState:UIControlStateNormal];
    [_sendCodeBtn setTitleColor:[UIColor getBlueColor] forState:UIControlStateNormal];
    _sendCodeBtn.titleLabel.font = [UIFont gs_fontNum:13];
    [_sendCodeBtn addTarget:self action:@selector(sendCodeToTel) forControlEvents:UIControlEventTouchUpInside];
    _sendCodeBtn.bounds = CGRectMake(0, 0, ChangedHeight(70), ChangedHeight(50));
    self.PassText = [[UITextField alloc]init];
    self.PassText.keyboardType = UIKeyboardTypeNumberPad;
//    self.PassText.leftView = leftImage2;
//    self.PassText.leftViewMode = UITextFieldViewModeAlways;
    self.PassText.rightView = _sendCodeBtn;
    self.PassText.rightViewMode = UITextFieldViewModeAlways;
    self.PassText.attributedPlaceholder = [[NSAttributedString alloc]initWithString:@"请输入短信验证码" attributes:
                                           @{NSFontAttributeName:[UIFont gs_fontNum:14],
                                             NSForegroundColorAttributeName:[UIColor getColor:134 G:135 B:136]
                                             }];
//    [textBGView addSubview:self.PassText];
//    [self.PassText mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.left.equalTo(textBGView).offset(ChangedHeight(5));
//        make.right.bottom.equalTo(textBGView);
//        make.top.equalTo(horLine.mas_bottom);
//    }];
}

-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    _wasKeyboardManagerEnabled = [[IQKeyboardManager sharedManager] isEnabled];
    [[IQKeyboardManager sharedManager] setEnable:NO];
}

-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [[IQKeyboardManager sharedManager] setEnable:_wasKeyboardManagerEnabled];
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    NSString *toString = [textField.text stringByReplacingCharactersInRange:range withString:string];
    if (toString.length) {
        if (![GSValidate validateString:toString withRequireType:RequireTypeMoney]) {
            return NO;
        }
    }
    [self loadFeeOfMonney:toString];
    return YES;
}

- (void)loadFeeOfMonney:(NSString *)monney{
    if ([monney floatValue] <= 1) {
        self.feeMoney = @"0";
        [self.myTab reloadRow:0 inSection:1 withRowAnimation:UITableViewRowAnimationNone];
        return;
    }
    NSString *postUrl ;
    kAppPostHost(postUrl);
    [NetworkManager startNetworkRequestDataFromRemoteServerByPostMethodWithURLString:[NSString stringWithFormat:@"%@user/withdraw",postUrl]
          withParameters:@{
                           @"token":[UserManager shareManager].userId,
                           @"amount":Nilstr2Zero(monney)
                           }
                 ShowHUD:NO
                 success:^(NSURLSessionDataTask *task, id responseObject) {
                     if ([responseObject[@"status"] integerValue] == 200) {
                         dispatch_async(dispatch_get_main_queue(), ^{
                             if ([responseObject[@"data"] isKindOfClass:[NSDictionary class]]) {
                                 self.feeMoney = [NSString stringWithFormat:@"%.2f",[responseObject[@"data"][@"fee"] floatValue]];
                             }
                             [self.myTab reloadRow:0 inSection:1 withRowAnimation:UITableViewRowAnimationNone];
                         });
                     }else{
                         dispatch_async(dispatch_get_main_queue(), ^{
                             self.feeMoney = @"-1";
                             [self.myTab reloadRow:0 inSection:1 withRowAnimation:UITableViewRowAnimationNone];
                         });
                     }
                 } failure:^(NSURLSessionDataTask *task, NSError *error) {
                    dispatch_async(dispatch_get_main_queue(), ^{
                         [MBProgressHUD showError:@"网络不给力啊"];
                     });
                 }];
    
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 2;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (section == 1) {
        if ([[UserManager shareManager].money.expand_count integerValue]) {
            return 3;
        }
        return 2;
    }
    return 3;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(nonnull NSIndexPath *)indexPath{
    switch (indexPath.row) {
        case 0:
            return ChangedHeight(50);
            break;
        case 1:{
            if (indexPath.section) {
                return ChangedHeight(50);
            }
            return ChangedHeight(95);
        }
            
            break;
        default:return ChangedHeight(40);
            break;
    }
    return ChangedHeight(5);
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (indexPath.section) {
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cartCell"];
        if (!cell) {
            cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"cartCell"];
            cell.selectionStyle = UITableViewCellEditingStyleNone;
            cell.textLabel.font = [UIFont gs_fontNum:13];
            cell.textLabel.textColor = [UIColor grayColor];
        }
        
        if (indexPath.row == 0 || indexPath.row == 2) {
            NSString *shouXu = [_feeMoney  integerValue] >=0 ? Nilstr2Zero(_feeMoney) : @"输入金额大于账户余额";
            NSString *yueTip =  [_feeMoney  integerValue] >=0 ?[NSString stringWithFormat:@"提现手续费:%@元",Nilstr2Zero(_feeMoney)] : @"输入金额大于账户余额";
            NSString *feeMonneyStr = indexPath.row == 0 ? shouXu : [UserManager shareManager].money.expand_count;
            NSString *tipStr = indexPath.row == 0 ? yueTip : [NSString stringWithFormat:@"您还有%@个红包还未使用",[UserManager shareManager].money.expand_count];
            NSMutableAttributedString *attr = [[NSMutableAttributedString alloc]initWithString:tipStr attributes:
                                               @{NSForegroundColorAttributeName:[UIColor grayColor],
                                                 NSFontAttributeName:[UIFont gs_fontNum:13]
                                                 }];
            [attr addAttribute:NSForegroundColorAttributeName value:[UIColor getOrangeColor] range:[attr.string rangeOfString:feeMonneyStr]];
            cell.textLabel.attributedText = attr;
            
            cell.detailTextLabel.text = indexPath.row == 0 ? @"" : @"去看看";
            cell.accessoryType = indexPath.row == 0 ? UITableViewCellAccessoryNone : UITableViewCellAccessoryDisclosureIndicator;
        }else{
            cell.textLabel.text = @"短信验证码:";
            [cell.contentView addSubview:self.PassText];
            [self.PassText mas_makeConstraints:^(MASConstraintMaker *make) {
                make.right.top.height.equalTo(cell.contentView);
                make.left.equalTo(cell.contentView).offset(ChangedHeight(90));
            }];
            cell.accessoryType = UITableViewCellAccessoryNone;
        }
        
        return cell;
    }else{
        
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"remainCell"];
        if (indexPath.row == 0) {
            [cell setSeparatorInset:UIEdgeInsetsZero];
        }
        
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        
        //        [cell setSeparatorInset:UIEdgeInsetsZero];
        
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        if (indexPath.row == 1) {
            [cell.contentView addSubview:self.extractView];
            [self.extractView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.edges.equalTo(cell.contentView);
            }];
        }else if(indexPath.row ==2){
            NSMutableAttributedString *attr = [[NSMutableAttributedString alloc]initWithString:[NSString stringWithFormat:@"账户余额：%@元",[UserManager shareManager].money.active_balance] attributes:
                                               @{NSForegroundColorAttributeName:[UIColor grayColor],
                                                 NSFontAttributeName:[UIFont gs_fontNum:13]
                                                 }];
            [attr addAttribute:NSForegroundColorAttributeName value:[UIColor getOrangeColor] range:[attr.string rangeOfString:[UserManager shareManager].money.active_balance]];
            cell.textLabel.attributedText = attr;
            cell.imageView.image = nil;
            if ([[UserManager shareManager].money.active_balance floatValue] == 0) {
                [cell.contentView addSubview:self.tipBtn];
                [self.tipBtn mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.height.equalTo(cell.contentView);
                    make.left.equalTo(cell.contentView.mas_centerX).offset(ChangedHeight(20));
                    make.width.mas_equalTo(ChangedHeight(100));
                }];
            }
            
        }else{
            [cell setSeparatorInset:UIEdgeInsetsZero];
            bankModel *bank = [UserManager shareManager].user.bank_data[0];
            cell.imageView.image = [UIImage imageNamed:bank.UseableBankName];
            [cell.imageView sd_setImageWithURL:[NSURL URLWithString:bank.bank_img] placeholderImage:[UIImage imageNamed:bank.UseableBankName] options:SDWebImageAllowInvalidSSLCertificates completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
                if (error) {
                    cell.imageView.image = [UIImage imageNamed:bank.UseableBankName];
                }
            }];
            cell.textLabel.text = [NSString stringWithFormat:@"%@  %@",bank.UseableBankName,bank.bankNumText];
        }
        return cell;
    }
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section && indexPath.row == 2) {
        UIViewController *vc = [[NSClassFromString(@"MyIncentiveVc") alloc]init];
        [self.navigationController pushViewController:vc animated:YES];
    }
}
/**
 表的脚部
 
 @return 脚
 */
- (UIView *)footerView{
    if (!_footerView) {
        _footerView = [UIView new];
        TTTAttributedLabel *agreementLab = [TTTAttributedLabel new];
        agreementLab.numberOfLines = 2;
        agreementLab.font = [UIFont gs_fontNum:13];
        agreementLab.textColor = [UIColor getColor:134 G:135 B:136];
        NSString *tipStr = @"温馨提示：充值未投资，提现所产生的手续费由个人支付,充值前请先阅读《提现说明》";
        [agreementLab setText:tipStr afterInheritingLabelAttributesAndConfiguringWithBlock:^NSMutableAttributedString *(NSMutableAttributedString *mutableAttributedString) {
            NSMutableParagraphStyle *style = [[NSMutableParagraphStyle alloc] init];
            style.lineSpacing = ChangedHeight(6);
            
            [mutableAttributedString addAttribute:NSParagraphStyleAttributeName value:style range:NSMakeRange(0, tipStr.length)];
            return mutableAttributedString;
        }];
        
        agreementLab.linkAttributes = @{
                                        (id)kCTForegroundColorAttributeName:[UIColor getBlueColor]
                                        };
        TTTAttributedLabelLink *labLink = [agreementLab addLinkToPhoneNumber:@"agreement" withRange:[tipStr  rangeOfString:@"《提现说明》"]];
        labLink.linkTapBlock = ^(TTTAttributedLabel *lab, TTTAttributedLabelLink *link) {
            [self rechargeInfo];
        };

        [_footerView addSubview:agreementLab];
        [agreementLab mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(_footerView).offset(ChangedHeight(-10));
            make.left.top.equalTo(_footerView).offset(ChangedHeight(10));
            //            make.height.mas_equalTo(ChangedHeight(20));
        }];
        
        _footerView.height = ChangedHeight(120);
        UIButton *btn = [UIButton new];
        [btn addTarget:self action:@selector(rechargeMoney) forControlEvents:UIControlEventTouchUpInside];
        [btn setTitle:@"提现" forState:UIControlStateNormal];
        btn.titleLabel.font = [UIFont gs_fontNum:15];
        btn.layer.cornerRadius = 4;
        btn.backgroundColor = [UIColor getOrangeColor];
        [_footerView addSubview:btn];
        [btn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(_footerView).insets(UIEdgeInsetsMake(ChangedHeight(70), ChangedHeight(35), ChangedHeight(10), ChangedHeight(35)));
        }];
        
    }
    return _footerView;
}

/**
 提现
 */
- (void)rechargeMoney{
    if ([self.extractView.moneyText.text length] == 0) {
        [MBProgressHUD showError:@"请输入提现金额"];
        return;
    }
    if ([self.extractView.moneyText.text floatValue] < 1) {
        [MBProgressHUD showError:@"提现金额需大于1元"];
        return;
    }
    if (!self.PassText.text.length) {
        [MBProgressHUD showError:@"请输入验证码"];
        return;
    }
    self.jiaoyiAlert.titleStr = @"请输入交易密码";
    self.jiaoyiAlert.moneyStr = [NSString stringWithFormat:@"%.2f（元）",[self.extractView.moneyText.text floatValue]];
    [self.jiaoyiAlert showAlertType];
}

/**
 输入交易密码后调用接口
 */
- (void)jiaoyiLoadResult:(NSString *)password{
    
    bankModel *bank = [UserManager shareManager].user.bank_data[0];
    NSString *postUrl ;
    kAppPostHost(postUrl);
    [NetworkManager startNetworkRequestDataFromRemoteServerByPostMethodWithURLString:[NSString stringWithFormat:@"%@bank/dowithdraw_bankstore",postUrl]
          withParameters:@{
                           @"amount":self.extractView.moneyText.text,//    提现金额    string
                           @"banknum":bank.bank_num,//    银行卡号    string
                           @"trade_pwd":password,//    交易密码    string
                           @"token":[UserManager shareManager].userId,//    用户id    string
                           @"verify_code":self.PassText.text,//    验证码    string
                           }
                 ShowHUD:YES
                 success:^(NSURLSessionDataTask *task, id responseObject) {
                     if ([responseObject[@"status"] integerValue] == 200) {
                         dispatch_async(dispatch_get_main_queue(), ^{
                             [MBProgressHUD showSuccess:@"您已提现成功"];
                             [[NSUserDefaults standardUserDefaults] setObject:@"1" forKey:RefreshUser];
                             [[NSUserDefaults standardUserDefaults] synchronize];
                             [self performSelector:@selector(popToUserVc) withObject:nil afterDelay:1.f];
                             
                         });
                     }
                 } failure:^(NSURLSessionDataTask *task, NSError *error) {
                     
                 }];
}



- (void)popToUserVc{
    NSMutableArray *vcArr = [NSMutableArray arrayWithArray:self.navigationController.viewControllers];
    [vcArr removeLastObject];
    [vcArr addObject:[[RunningWaterVc alloc] init]];
    [self.navigationController setViewControllers:vcArr];
}
/**
 提现说明
 */
- (void)rechargeInfo{
    NSString *postUrl ;
    kAppPostHost(postUrl);
    HTMLVC *vc = [[HTMLVC alloc]init];
    vc.H5Url = [NSString stringWithFormat:@"%@User/tixian",postUrl];
    vc.title = @"提现说明";
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
/** 发送验证码的接口 */
- (void)sendCodeToTel{
    if (![UserManager shareManager].hasGuanLianTel) {
//        [MBProgressHUD showError:@"请输入正确手机号"];
        return;
        
    }
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

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
