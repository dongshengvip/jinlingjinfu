//
//  ExchangePasswordVc.m
//  JinLingDai
//
//  Created by 001 on 2017/7/3.
//  Copyright © 2017年 JLD. All rights reserved.
//

#import "ExchangePasswordVc.h"

#define TitleArr @[@"设置交易密码：", @"请确认交易密码："]
#define TitleArr2 @[@"手机验证码：", @"银行卡后八位：", @"设置新交易密码：", @"请确认交易密码："]
#import <YYKit.h>
#import "GSValidate.h"
#import "MBProgressHUD+NetWork.h"
@interface ExchangePasswordVc ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic, strong) UITableView *myTab;
@property (nonatomic, strong) UITextField *passwordText;//原来密码
@property (nonatomic, strong) UITextField *checkoutText;//检验
@property (nonatomic, strong) UIView *footerView;
@property (nonatomic, strong) UITextField *cartText;//银行卡
@property (nonatomic, strong) UITextField *checkCodeText;
@property (nonatomic, strong) UIButton *sendCodeBtn;
@property (nonatomic, strong) NSTimer *cdTimer;                 //倒计时
@property (nonatomic) NSInteger countDown;                      //倒计时
@end
static NSInteger MAX_COUNTDOWN = 60;
@implementation ExchangePasswordVc

- (void)goBack{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    [self setNavBlackColor];
//    [self.navigationController.navigationBar setTintColor:[UIColor blackColor]];
//    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"back"] style:UIBarButtonItemStylePlain target:self action:@selector(goBack)];
    self.title = [[UserManager shareManager].user.is_setpinpass  integerValue] == 0?@"设置交易密码":@"修改交易密码";
    self.myTab = [[UITableView alloc]initWithFrame:CGRectZero style:UITableViewStyleGrouped];
    self.myTab.delegate = self;
    self.myTab.dataSource = self;
    self.myTab.estimatedSectionHeaderHeight = 0;
    self.myTab.estimatedSectionFooterHeight = 0;
    self.myTab.sectionFooterHeight = 0.1;
    self.myTab.rowHeight = ChangedHeight(45);
    [self.myTab registerClass:[UITableViewCell class] forCellReuseIdentifier:@"myCell"];
    //
    self.myTab.tableFooterView = self.footerView;
    [self.view addSubview:self.myTab];
    [self.myTab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
    
    _sendCodeBtn = [UIButton new];
    [_sendCodeBtn setTitle:@"发送验证码" forState:UIControlStateNormal];
    [_sendCodeBtn setTitleColor:[UIColor getBlueColor] forState:UIControlStateNormal];
    _sendCodeBtn.titleLabel.font = [UIFont gs_fontNum:13];
    [_sendCodeBtn addTarget:self action:@selector(sendCodeToTel) forControlEvents:UIControlEventTouchUpInside];
    _sendCodeBtn.size = CGSizeMake(ChangedHeight(70), ChangedHeight(50));
    
    self.checkCodeText = [[UITextField alloc]init];
    self.checkCodeText.font = [UIFont gs_fontNum:13];
    self.checkCodeText.keyboardType = UIKeyboardTypeNumberPad;
    self.checkCodeText.rightView = _sendCodeBtn;
    self.checkCodeText.rightViewMode = UITextFieldViewModeAlways;
    self.checkCodeText.attributedPlaceholder = [[NSAttributedString alloc]initWithString:@"请输入验证码" attributes:
                                               @{NSFontAttributeName:[UIFont gs_fontNum:13],
                                                 NSForegroundColorAttributeName:[UIColor getColor:134 G:135 B:136]
                                                 }];
    self.cartText = [[UITextField alloc]init];
    self.cartText.font = [UIFont gs_fontNum:13];
    self.cartText.keyboardType = UIKeyboardTypePhonePad;
    self.cartText.attributedPlaceholder = [[NSAttributedString alloc]initWithString:@"请输入银行卡后八位" attributes:
                                           @{NSFontAttributeName:[UIFont gs_fontNum:13],
                                             NSForegroundColorAttributeName:[UIColor getColor:134 G:135 B:136]
                                             }];
    
    self.passwordText = [[UITextField alloc]init];
    self.passwordText.secureTextEntry = YES;
    self.passwordText.keyboardType = UIKeyboardTypePhonePad;
    self.passwordText.font = [UIFont gs_fontNum:13];
    self.passwordText.attributedPlaceholder = [[NSAttributedString alloc]initWithString:@"请输入6位数字支付密码" attributes:
                                                  @{NSFontAttributeName:[UIFont gs_fontNum:13],
                                                    NSForegroundColorAttributeName:[UIColor getColor:134 G:135 B:136]
                                                    }];
    
    
    self.checkoutText = [[UITextField alloc]init];
    self.checkoutText.keyboardType = UIKeyboardTypePhonePad;
    self.checkoutText.font = [UIFont gs_fontNum:13];
    self.checkoutText.secureTextEntry = YES;
    self.checkoutText.attributedPlaceholder = [[NSAttributedString alloc]initWithString:@"请再次输入支付密码" attributes:
                                               @{NSFontAttributeName:[UIFont gs_fontNum:13],
                                                 NSForegroundColorAttributeName:[UIColor getColor:134 G:135 B:136]
                                                 }];
    
    
    
}

/**
 表的脚部
 
 @return 脚
 */
- (UIView *)footerView{
    if (!_footerView) {
        _footerView = [UIView new];
        _footerView.height = ChangedHeight(270);
        UIButton *btn = [UIButton new];
        [btn addTarget:self action:@selector(changePasswordSoure) forControlEvents:UIControlEventTouchUpInside];
        [btn setTitle:@"确认提交" forState:UIControlStateNormal];
        btn.titleLabel.font = [UIFont gs_fontNum:15];
        btn.layer.cornerRadius = 4;
        btn.backgroundColor = [UIColor getOrangeColor];
        [_footerView addSubview:btn];
        [btn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(_footerView).insets(UIEdgeInsetsMake(ChangedHeight(220), ChangedHeight(35), ChangedHeight(10), ChangedHeight(35)));
        }];
        
    }
    return _footerView;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [[UserManager shareManager].user.is_setpinpass  integerValue] == 0?TitleArr.count:TitleArr2.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return ChangedHeight(5);
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"myCell"];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.textLabel.text = [[UserManager shareManager].user.is_setpinpass  integerValue]== 0?TitleArr[indexPath.row]:TitleArr2[indexPath.row];
    cell.accessoryType = UITableViewCellAccessoryNone;
    cell.textLabel.textColor = [UIColor getColor:82 G:83 B:84];
    cell.textLabel.font = [UIFont gs_fontNum:13];
    switch (indexPath.row) {
        case 0:
        {
            if ([[UserManager shareManager].user.is_setpinpass integerValue] == 0) {
                [cell.contentView addSubview:self.passwordText];
                [self.passwordText mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.right.top.height.equalTo(cell.contentView);
                    make.left.equalTo(cell.contentView).offset(ChangedHeight(110));
                }];
            }else{
                [cell.contentView addSubview:self.checkCodeText];
                [self.checkCodeText mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.right.top.height.equalTo(cell.contentView);
                    make.left.equalTo(cell.contentView).offset(ChangedHeight(110));
                }];
            }
            
        }
            break;
        case 2:
        {
                [cell.contentView addSubview:self.passwordText];
                [self.passwordText mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.right.top.height.equalTo(cell.contentView);
                    make.left.equalTo(cell.contentView).offset(ChangedHeight(110));
                }];
        }
            break;

        case 3:
        {
            [cell.contentView addSubview:self.checkoutText];
            [self.checkoutText mas_makeConstraints:^(MASConstraintMaker *make) {
                make.right.top.height.equalTo(cell.contentView);
                make.left.equalTo(cell.contentView).offset(ChangedHeight(110));
            }];
        }
            break;

        default:
        {
            if ([[UserManager shareManager].user.is_setpinpass integerValue] == 0) {
                [cell.contentView addSubview:self.checkoutText];
                [self.checkoutText mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.right.top.height.equalTo(cell.contentView);
                    make.left.equalTo(cell.contentView).offset(ChangedHeight(110));
                }];
            }else{
                [cell.contentView addSubview:self.cartText];
                [self.cartText mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.right.top.height.equalTo(cell.contentView);
                    make.left.equalTo(cell.contentView).offset(ChangedHeight(110));
                }];
            }
            
        }
            break;
    }
    return cell;
}
/**
 修改密码
 */
- (void)changePasswordSoure{
    if ([[UserManager shareManager].user.is_setpinpass integerValue] == 1) {
        if (self.cartText.text.length != 8){
            [MBProgressHUD showError:@"请正确的输入银行卡后八位"];
            return;
        }
        if (self.passwordText.text.length != 6) {
            [MBProgressHUD showError:@"请输入6位数交易密码"];
            return;
        }
        if (![self.passwordText.text isEqualToString:self.checkoutText.text]) {
            [MBProgressHUD showError:@"两次输入的密码不一致"];
            return;
        }
        NSString *postUrl ;
        kAppPostHost(postUrl);
        [NetworkManager startNetworkRequestDataFromRemoteServerByPostMethodWithURLString:[NSString stringWithFormat:@"%@user/changetradepwd",postUrl]
          withParameters:@{
                           @"bank_last_num":self.cartText.text,//	银行卡后8位	string
                           @"new_trade_pwd":self.passwordText.text ,//	新的交易密码	string
                           @"token":[UserManager shareManager].userId,//	用户ID	string
                           @"verify_code":self.checkCodeText.text //	短信验证码	string
                           }
         ShowHUD:YES
                 success:^(NSURLSessionDataTask *task, id responseObject) {
                     if ([responseObject[@"status"] integerValue] == 200) {
                         dispatch_async(dispatch_get_main_queue(), ^{
                             
                             [MBProgressHUD showSuccess:@"交易密码修改成功"];
                             [self.navigationController popViewControllerAnimated:YES];
                         });
                     }
                 } failure:^(NSURLSessionDataTask *task, NSError *error) {
                     
                 }];

    }else{
        if (self.passwordText.text.length != 6) {
            [MBProgressHUD showError:@"请输入6位数交易密码"];
            return;
        }
        if (![self.passwordText.text isEqualToString:self.checkoutText.text]) {
            [MBProgressHUD showError:@"两次输入的密码不一致"];
            return;
        }

        NSString *postUrl ;
        kAppPostHost(postUrl);
        [NetworkManager startNetworkRequestDataFromRemoteServerByPostMethodWithURLString:[NSString stringWithFormat:@"%@bank/set_paypwd",postUrl]
          withParameters:@{
                           @"trade_pwd":self.passwordText.text,//	交易密码	string
                           @"token":[UserManager shareManager].userId//	用户id	number
                           }
         ShowHUD:YES
                 success:^(NSURLSessionDataTask *task, id responseObject) {
                     if ([responseObject[@"status"]intValue] == 200) {
                         dispatch_async(dispatch_get_main_queue(), ^{
                             UserModel *model = [UserManager shareManager].user;
                             model.is_setpinpass = @"1";
                             [[UserManager shareManager] saveUserModel:model];
                             [MBProgressHUD showSuccess:@"交易密码设置成功"];
                             if (self.navigationController.viewControllers.count>1) {
                                 [self.navigationController popViewControllerAnimated:YES];
                             }else{
                                 [self dismissViewControllerAnimated:YES completion:nil];
                             }
                             
                         });
                     }
                 } failure:^(NSURLSessionDataTask *task, NSError *error) {
                     
                 }];
        
    }
}

/**
 发送验证码的接口
 */
- (void)sendCodeToTel{
    
    NSString *postUrl ;
    kAppPostHost(postUrl);
    [NetworkManager startNetworkRequestDataFromRemoteServerByPostMethodWithURLString:[NSString stringWithFormat:@"%@user/commitphone",postUrl]
          withParameters:@{
                           @"tel":[UserManager shareManager].user.tel,
                           @"type":@"3"
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
