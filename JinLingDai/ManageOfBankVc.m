//
//  ManageOfBankVc.m
//  JinLingDai
//
//  Created by 001 on 2017/9/12.
//  Copyright © 2017年 JLD. All rights reserved.
//

#import "ManageOfBankVc.h"
#import <YYKit.h>
#import "MBProgressHUD+NetWork.h"
#import "ListOfBanks.h"
#import "ASPickerView.h"
#import "UIViewController+BackButtonHandler.h"
//#import "BankGiftImageView.h"
#import "RedBagAleartView.h"
#define TitleArr @[@"真实姓名：", @"身份证号：", @"银行卡号：", @"开户银行：", @"预留手机号：", @"短信验证码："]


@interface ManageOfBankVc ()<UITableViewDelegate,UITableViewDataSource,ASPickerViewDelegate,UITextFieldDelegate>
@property (nonatomic, strong) UITableView *myTab;
@property (nonatomic, strong) ASPickerView *pickerView;
@property (nonatomic, strong) UITextField *realNameText;//真实姓名
@property (nonatomic, strong) UITextField *cartNum;//身份证号

@property (nonatomic, strong) UITextField *bankCartText;//银行卡号

@property (nonatomic, strong) UITextField *CityAddress;//开户行
@property (nonatomic, strong) UITextField *telNum;//手机码
@property (nonatomic, strong) UITextField *codeText;//验证码
@property (nonatomic, strong) UIView *footerView;
@property (nonatomic, copy) NSArray *listArr;
@property (nonatomic, copy) NSString *store_order;      //订单号
@property (nonatomic, strong) NSMutableArray *nameArr;
@property (nonatomic, assign) NSInteger index;                      //索引
@property (nonatomic, strong) UIButton *sendCodeBtn;
@property (nonatomic, strong) NSTimer *cdTimer;                 //倒计时
@property (nonatomic) NSInteger countDown;                      //倒计时

@property (nonatomic, strong) RedBagAleartView *redBagAleart;
@end

static NSInteger MAX_COUNTDOWN = 60;
@implementation ManageOfBankVc
- (BOOL)navigationShouldPopOnBackButton{
    if (!Nilstr2Space([UserManager shareManager].user.platcust).length || [Nilstr2Zero([UserManager shareManager].user.bind_status) integerValue] == 0) {
//        BankGiftImageView *bankView = [BankGiftImageView shareManage];
//        [bankView.giftImage startAnimating];
//        bankView.hidden = NO;
    }
    return YES;
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
//    BankGiftImageView *bankView = [BankGiftImageView shareManage];
//    [bankView.giftImage stopAnimating];
//    bankView.hidden = YES;
    if([Nilstr2Zero([UserManager shareManager].user.bind_status) integerValue] == 0)self.title = @"绑定银行卡";
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    [self setNavBlackColor];
    self.title = @"开户绑卡";
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
    
    _pickerView = [[ASPickerView alloc]initWithParentViewController:self];
    _pickerView.delegate = self;
    self.realNameText = [[UITextField alloc]init];
    self.realNameText.font = [UIFont gs_fontNum:14];
    //    self.cartNum.keyboardType = UIKeyboardTypeNumberPad;
    self.realNameText.attributedPlaceholder = [[NSAttributedString alloc]initWithString:@"请输入姓名" attributes:
                                          @{
                                            NSFontAttributeName:[UIFont gs_fontNum:14],
                                            NSForegroundColorAttributeName:[UIColor getColor:134 G:135 B:136]
                                            }];
    
    self.cartNum = [[UITextField alloc]init];
    self.cartNum.font = [UIFont gs_fontNum:14];
//    self.cartNum.keyboardType = UIKeyboardTypeNumberPad;
    self.cartNum.attributedPlaceholder = [[NSAttributedString alloc]initWithString:@"请输入您的证件号" attributes:
                                          @{
                                            NSFontAttributeName:[UIFont gs_fontNum:14],
                                            NSForegroundColorAttributeName:[UIColor getColor:134 G:135 B:136]
                                            }];
    
    self.bankCartText = [[UITextField alloc]init];
    self.bankCartText.font = [UIFont gs_fontNum:14];
    self.bankCartText.delegate = self;
    self.bankCartText.keyboardType = UIKeyboardTypeNumberPad;
    self.bankCartText.attributedPlaceholder = [[NSAttributedString alloc]initWithString:@"请输入银行卡号" attributes:
                                               @{
                                                 NSFontAttributeName:[UIFont gs_fontNum:14],
                                                 NSForegroundColorAttributeName:[UIColor getColor:134 G:135 B:136]
                                                 }];
    
    self.CityAddress = [[UITextField alloc]init];
    self.CityAddress.font = [UIFont gs_fontNum:14];
    UIImageView *arrow = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"下划箭头"]];
    arrow.contentMode = UIViewContentModeCenter;
    arrow.bounds = CGRectMake(0, 0, ChangedHeight(35), ChangedHeight(10));
    self.CityAddress.rightView = arrow;
    self.CityAddress.rightViewMode = UITextFieldViewModeAlways;
    self.CityAddress.enabled = NO;
    self.CityAddress.attributedPlaceholder = [[NSAttributedString alloc]initWithString:@"请选择卡开户银行" attributes:
                                              @{
                                                NSFontAttributeName:[UIFont gs_fontNum:14],
                                                NSForegroundColorAttributeName:[UIColor getColor:134 G:135 B:136]
                                                }];
    
    self.telNum = [[UITextField alloc]init];
    self.telNum.font = [UIFont gs_fontNum:14];
    self.telNum.keyboardType = UIKeyboardTypeNumberPad;
    self.telNum.attributedPlaceholder = [[NSAttributedString alloc]initWithString:@"请输入银行卡预留手机号" attributes:
                                         @{
                                           NSFontAttributeName:[UIFont gs_fontNum:14],
                                           NSForegroundColorAttributeName:[UIColor getColor:134 G:135 B:136]
                                           }];
    
    _sendCodeBtn = [UIButton new];
    [_sendCodeBtn setTitle:@"发送验证码" forState:UIControlStateNormal];
    [_sendCodeBtn setTitleColor:[UIColor getBlueColor] forState:UIControlStateNormal];
    _sendCodeBtn.titleLabel.font = [UIFont gs_fontNum:14];
    [_sendCodeBtn addTarget:self action:@selector(sendCodeToTel) forControlEvents:UIControlEventTouchUpInside];
    _sendCodeBtn.size = CGSizeMake(ChangedHeight(80), ChangedHeight(50));
    
    self.codeText = [[UITextField alloc]init];
    self.codeText.rightView = _sendCodeBtn;
    self.codeText.keyboardType = UIKeyboardTypeNumberPad;
    self.codeText.font = [UIFont gs_fontNum:14];
    self.codeText.rightViewMode = UITextFieldViewModeAlways;
    self.codeText.attributedPlaceholder = [[NSAttributedString alloc]initWithString:@"请输入验证码" attributes:
                                           @{
                                             NSFontAttributeName:[UIFont gs_fontNum:14],
                                             NSForegroundColorAttributeName:[UIColor getColor:134 G:135 B:136]
                                             }];
    
    
    _index = -1;
    [self loadBanksList];
    
//    self.redBagAleart = [[RedBagAleartView alloc]init];
//    self.redBagAleart.redBagType = RedBagUsedNow;
//    __weak typeof(self) weakSelf = self;
//    self.redBagAleart.confirmBtnBlock = ^{
//        [weakSelf.redBagAleart hidenAlertType];
//
//        if ([[UserManager shareManager].user.is_setpinpass integerValue] == 0) {
//            UIViewController *vc = [[NSClassFromString(@"ExchangePasswordVc") alloc]init];
//            [weakSelf.navigationController pushViewController:vc animated:YES];
//        }else{
//            UIWindow *window = [UIApplication sharedApplication].keyWindow;
//            UITabBarController *tab = (UITabBarController *)window.rootViewController;
//            [tab setSelectedIndex:1];
//            [weakSelf.navigationController popToRootViewControllerAnimated:YES];
//        }
//
//    };
    // Do any additional setup after loading the view.
}

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    if ([UserManager shareManager].user.bank_data.count > 0 ) {
        NSString *bankCode = ((bankModel *)[UserManager shareManager].user.bank_data[0]).bank_num;
        [self getBankNameWithNum:bankCode];
        //                self.bankCartText.enabled = NO;
    }
    
}
/**
 获取银行名字
 */
- (void)getBankNameWithNum:(NSString *)bankCode{
    if (bankCode.length < 6) {
        return;
    }
    NSString *postUrl ;
    kAppPostHost(postUrl);
    [NetworkManager startNetworkRequestDataFromRemoteServerByPostMethodWithURLString:[NSString stringWithFormat:@"%@bank/show_bankinfo_bycard",postUrl]
          withParameters:@{
                           @"token":[UserManager shareManager].userId,
                           @"bank_code":bankCode
                           }
                 ShowHUD:NO
                 success:^(NSURLSessionDataTask *task, id responseObject) {
                     if ([responseObject[@"status"] integerValue]) {
//                         NSArray *arr = [NSArray modelArrayWithClass:[ListOfBanks class] json:responseObject[@"data"]];
                         ListOfBanks *model = [ListOfBanks modelWithJSON:responseObject[@"data"]];
                         if (model) {
//                             ListOfBanks *model = arr.firstObject;
                             self.CityAddress.text = Nilstr2Space(model.bank_name);
                             NSPredicate *pre = [NSPredicate predicateWithFormat:@"bank_code == %@",model.bank_code];
                             NSArray *selectedArr = [self.listArr filteredArrayUsingPredicate:pre];
                             if (selectedArr.count) {
                                 _index = [self.listArr indexOfObject:selectedArr.firstObject];
                             }
                             
                         }else{
                             self.CityAddress.text = @"";
                         }
                         
                     }
                 } failure:^(NSURLSessionDataTask *task, NSError *error) {
                     
                 }];
}

//- (void)textFieldDidEndEditing:(UITextField *)textField{
//    [self getBankNameWithNum];
//}
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    NSString *toString = [textField.text stringByReplacingCharactersInRange:range withString:string];
    if (toString.length < 14) {
        self.CityAddress.text = @"";
    }else{
        [self getBankNameWithNum:toString];
    }
    return YES;
}
/**
 获取银行列表
 */
- (void)loadBanksList{
    if ([[NSUserDefaults standardUserDefaults] objectForKey:@"bankList"]) {
        _listArr = [NSArray modelArrayWithClass:[ListOfBanks class] json:[[NSUserDefaults standardUserDefaults] objectForKey:@"bankList"]];
        _nameArr = [[NSMutableArray alloc]init];
        [_listArr enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            ListOfBanks *model = obj;
            [_nameArr addObject:model.bank_name];
        }];
        return;
    }
    NSString *postUrl ;
    kAppPostHost(postUrl);
    [NetworkManager startNetworkRequestDataFromRemoteServerByPostMethodWithURLString:[NSString stringWithFormat:@"%@bank/getbanks",postUrl]
      withParameters:@{}
             ShowHUD:YES
             success:^(NSURLSessionDataTask *task, id responseObject) {
                 if ([responseObject[@"status"] integerValue] == 200) {
                     dispatch_async(dispatch_get_main_queue(), ^{
                         
                         if ([responseObject[@"data"] isKindOfClass:[NSArray class]]) {
                            [[NSUserDefaults standardUserDefaults] setObject:responseObject[@"data"] forKey:@"bankList"];
                             _listArr = [NSArray modelArrayWithClass:[ListOfBanks class] json:responseObject[@"data"]];
                             _nameArr = [[NSMutableArray alloc]init];
                             [_listArr enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                                 ListOfBanks *model = obj;
                                 [_nameArr addObject:model.bank_name];
                             }];
                             
                         }
                         
                     });
                 }
             } failure:^(NSURLSessionDataTask *task, NSError *error) {
                 
             }];
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return TitleArr.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return ChangedHeight(30);
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView *view = [UIView new];
    view.backgroundColor = [UIColor colorWithHex:0xf35e3e alpha:0.4];
    UILabel *titleLb = [UILabel new];
    titleLb.text = @"资金存管到厦门国际银行";
    titleLb.font = [UIFont gs_fontNum:16];
    titleLb.textAlignment = NSTextAlignmentCenter;
    titleLb.textColor = [UIColor getOrangeColor];
    [view addSubview:titleLb];
    [titleLb mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(view);
    }];
    return view;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return ChangedHeight(45);
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"myCell"];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.separatorInset = UIEdgeInsetsZero;
    cell.textLabel.text = TitleArr[indexPath.row];
    cell.textLabel.textColor = [UIColor getColor:82 G:83 B:84];
    cell.accessoryType = UITableViewCellAccessoryNone;
    cell.textLabel.font = [UIFont gs_fontNum:14];
    switch (indexPath.row) {
        case 3:
        {
            if (_index >= 0) {
                self.CityAddress.text = self.nameArr[_index];
            }
            [cell.contentView addSubview:self.CityAddress];
            [self.CityAddress mas_makeConstraints:^(MASConstraintMaker *make) {
                make.right.top.height.equalTo(cell.contentView);
                make.left.equalTo(cell.contentView).offset(ChangedHeight(100));
            }];
        }
            break;
        case 2:
        {
            if ([UserManager shareManager].user.bank_data.count > 0 ) {
                self.bankCartText.text = ((bankModel *)[UserManager shareManager].user.bank_data[0]).bank_num;
//                self.bankCartText.enabled = NO;
            }else{
                self.bankCartText.text = @"";
//                self.bankCartText.enabled = YES;
            }
            
            [cell.contentView addSubview:self.bankCartText];
            [self.bankCartText mas_makeConstraints:^(MASConstraintMaker *make) {
                make.right.top.height.equalTo(cell.contentView);
                make.left.equalTo(cell.contentView).offset(ChangedHeight(100));
            }];
        }
            break;
            
        case 0:
        {
            self.realNameText.text= [UserManager shareManager].user.real_name;
            [cell.contentView addSubview:self.realNameText];
            [self.realNameText mas_makeConstraints:^(MASConstraintMaker *make) {
                make.right.top.height.equalTo(cell.contentView);
                make.left.equalTo(cell.contentView).offset(ChangedHeight(100));
            }];
            
        }
            break;
        case 5:
        {
            [cell.contentView addSubview:self.codeText];
            [self.codeText mas_makeConstraints:^(MASConstraintMaker *make) {
                make.right.top.height.equalTo(cell.contentView);
                make.left.equalTo(cell.contentView).offset(ChangedHeight(100));
            }];
        }
            break;
        case 1:
        {
            if (![[UserManager shareManager].user.idcard containsString:@"****"]) {
                self.cartNum.text = [UserManager shareManager].user.idcard;
            }
            
            [cell.contentView addSubview:self.cartNum];
            [self.cartNum mas_makeConstraints:^(MASConstraintMaker *make) {
                make.right.top.height.equalTo(cell.contentView);
                make.left.equalTo(cell.contentView).offset(ChangedHeight(100));
            }];
        }
            break;
        default:{
            [cell.contentView addSubview:self.telNum];
            [self.telNum mas_makeConstraints:^(MASConstraintMaker *make) {
                make.right.top.height.equalTo(cell.contentView);
                make.left.equalTo(cell.contentView).offset(ChangedHeight(100));
            }];
        }
            break;
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row == 3) {
        [self.view endEditing:YES];
//        _pickerView.da =
        if (!self.nameArr.count) {
            [MBProgressHUD showError:@"请刷新后再试"];
            return;
        }
        [_pickerView setDataSource:_nameArr selected:_nameArr.firstObject];
        [_pickerView showPickerView];
    }
}

#pragma mark - AspickerviewDelegate
-(void)asPickerViewDidSelected:(ASPickerView *)picker{
    _index = [picker.picker selectedRowInComponent:0];
    [self.myTab reloadRow:3 inSection:0 withRowAnimation:UITableViewRowAnimationNone];
}

/**
 开户绑卡申请,获取验证码
 */
- (void)sendCodeToTel{
    if (!self.realNameText.text.length) {
        [MBProgressHUD showError:@"请输入真实姓名"];
        return;
    }
    if (!self.cartNum.text.length) {
        [MBProgressHUD showError:@"请输入证件号"];
        return;
    }
    if (!self.bankCartText.text.length) {
        [MBProgressHUD showError:@"请输入银行卡号"];
        return;
    }
    if (!self.CityAddress.text.length) {
        [MBProgressHUD showError:@"请选择开户行"];
        return;
    }
    if (!self.telNum.text.length) {
        [MBProgressHUD showError:@"请输入预留手机号"];
        return;
    }
    NSString *postUrl ;
    kAppPostHost(postUrl);
    ListOfBanks *model = self.listArr[_index];
    [NetworkManager startNetworkRequestDataFromRemoteServerByPostMethodWithURLString:[NSString stringWithFormat:@"%@bank/apply_openaccount",postUrl]
      withParameters:@{
                       @"bankname":model.bank_code,//	开户银行编号	string
                       @"banknum":self.bankCartText.text,//	银行卡号	string
                       @"idcard":self.cartNum.text,//	身份证号码	string
                       @"name":self.realNameText.text,//	真实姓名	string
                       @"tel":self.telNum.text,//	手机号	string
                       @"token":[UserManager shareManager].userId//	用户token	string
                       }
             ShowHUD:YES
             success:^(NSURLSessionDataTask *task, id responseObject) {
                 if ([responseObject[@"status"] integerValue] == 200) {
                     dispatch_async(dispatch_get_main_queue(), ^{
                         [MBProgressHUD showSuccess:@"验证码已发送"];
                         self.countDown = MAX_COUNTDOWN;
                         [self getCodeCountDown];
                         if([responseObject[@"data"] isKindOfClass:[NSDictionary class]]){
                             self.store_order = responseObject[@"data"][@"bank_store_order_no"];
                         }
                         
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
 开户绑卡确认,提交
 */
- (void)confirmToBank{
    if (!self.realNameText.text.length) {
        [MBProgressHUD showError:@"请输入真实姓名"];
        return;
    }
    if (!self.cartNum.text.length) {
        [MBProgressHUD showError:@"请输入证件号"];
        return;
    }
    if (!self.bankCartText.text.length) {
        [MBProgressHUD showError:@"请输入银行卡号"];
        return;
    }
    if (!self.CityAddress.text.length) {
        [MBProgressHUD showError:@"请选择开户行"];
        return;
    }
    if (!self.telNum.text.length) {
        [MBProgressHUD showError:@"请输入手机号"];
        return;
    }
    if (!self.codeText.text.length) {
        [MBProgressHUD showError:@"请输入验证码"];
        return;
    }
    NSString *postUrl ;
    kAppPostHost(postUrl);
    ListOfBanks *model = self.listArr[_index];
    [NetworkManager startNetworkRequestDataFromRemoteServerByPostMethodWithURLString:[NSString stringWithFormat:@"%@bank/confirm_openaccount",postUrl]
          withParameters:@{
                           @"bank_store_order_no":Nilstr2Space(self.store_order),//    原订单号    string
                           @"bankname":model.bank_code,//    开户银行编号    string
                           @"banknum":self.bankCartText.text,//    银行卡号    string
                           @"idcard":self.cartNum.text,//    身份证号码    string
                           @"name":self.realNameText.text,//    真实姓名    string
                           @"tel":self.telNum.text,//    手机号    string
                           @"token":[UserManager shareManager].userId,//    用户token    string
                           @"mcode":self.codeText.text//    验证码    string
                           }
                 ShowHUD:YES
                 success:^(NSURLSessionDataTask *task, id responseObject) {
                     if ([responseObject[@"status"] integerValue] == 200) {
                         
                             [[UserManager shareManager] loadMewModel:^(BOOL succ) {
                                 dispatch_async(dispatch_get_main_queue(), ^{
                                     [[NSUserDefaults standardUserDefaults] setObject:@"1" forKey:RefreshUser];
                                     if (self.BangcartBlock) {
                                         if (!succ) {
                                             UserModel *model = [UserManager shareManager].user;
                                             bankModel *bank = [bankModel new];
                                             bank.bank_num = self.cartNum.text;
                                             model.bind_status = @"1";
                                             model.bank_data = @[bank];
                                             [[UserManager shareManager] saveUserModel:model];
                                         }
                                         
                                         _BangcartBlock(YES);
                                         
                                     }

                                     if ([responseObject[@"data"] isKindOfClass:[NSDictionary class]]) {
                                         if ([responseObject[@"data"][@"status"] integerValue] == 1) {
                                             if ([[UserManager shareManager].user.is_setpinpass integerValue] == 0) {
                                                             UIViewController *vc = [[NSClassFromString(@"ExchangePasswordVc") alloc]init];
                                                             [self.navigationController pushViewController:vc animated:YES];
                                             }else{
                                                 [MBProgressHUD showSuccess:@"恭喜您绑卡成功"];
                                             }
//                                             NSString *confirmString = [[UserManager shareManager].user.is_setpinpass integerValue] == 0?@"设置交易密码":@"立即投资";
//                                             [self.redBagAleart aleartWithTip:@"" Message:@"恭喜您建立子账户成功" Thanks:@"感谢您对金陵贷的支持～" Cancel:nil Confirm:confirmString];
//                                             [self.redBagAleart showAlertType];
                                         }
                                     }
                                     
                                     

                                     });
                             }];
                         
                         
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

- (UIView *)footerView {
   if (!_footerView) {
       _footerView = [UIView new];
       _footerView.height = ChangedHeight(150);
       UILabel *tipLab = [UILabel new];
       tipLab.numberOfLines = 0;
       tipLab.textColor = [UIColor getBlueColor];
       tipLab.font = [UIFont gs_fontNum:13];
       tipLab.text = @"温馨提示：如果银行卡是二类账户，将会影响您的提现，具体账户类型可咨询发卡行。老用户数据会自动获取，但不可变更信息否则会影响您的提现和充值。";
       [_footerView addSubview:tipLab];
       [tipLab mas_makeConstraints:^(MASConstraintMaker *make) {
           make.left.top.equalTo(_footerView).offset(ChangedHeight(10));
           make.right.equalTo(_footerView).offset(ChangedHeight(-10));
       }];
       UIButton *btn = [UIButton new];
       [btn addTarget:self action:@selector(confirmToBank) forControlEvents:UIControlEventTouchUpInside];
       [btn setTitle:@"确认提交" forState:UIControlStateNormal];
       btn.titleLabel.font = [UIFont gs_fontNum:15];
       btn.layer.cornerRadius = 4;
       btn.backgroundColor = [UIColor getOrangeColor];
       [_footerView addSubview:btn];
       [btn mas_makeConstraints:^(MASConstraintMaker *make) {
           make.edges.equalTo(_footerView).insets(UIEdgeInsetsMake(ChangedHeight(100), ChangedHeight(35), ChangedHeight(10), ChangedHeight(35)));
       }];
   }
   return _footerView;
}


@end
