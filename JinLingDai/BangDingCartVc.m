//
//  BangDingCartVc.m
//  JinLingDai
//
//  Created by 001 on 2017/7/4.
//  Copyright © 2017年 JLD. All rights reserved.
//

#import "BangDingCartVc.h"
#import "GSValidate.h"
#import "MBProgressHUD+NetWork.h"
#import <YYKit.h>
//#import "UserManager.h"
#import "ChoseBankCartVc.h"
#import "AddressPickerView.h"
#define TitleArr @[@"持卡人：", @"银行卡号：", @"选择地区：", @"设置开户行：", @"手机号：", @"验证码："]
#define TitleArr2 @[@"", @"新银行卡号：", @"预留手机号：", @"验证码："]
#define BankNameArr @[@"中国银行", @"上海银行", @"建设银行", @"工商银行", @"北京银行", @"光大银行", @"广发银行", @"华夏银行",@"交通银行", @"民生银行", @"农业银行",@"平安银行",@"浦发银行",@"兴业银行",@"招商银行",@"中信银行",@"邮政储蓄"]
#define BankTextNameArr @[@"中国银行", @"上海银行", @"建设", @"工商", @"北京", @"光大", @"广发", @"华夏",@"交通", @"民生", @"农业",@"平安",@"浦发",@"兴业",@"招商",@"中信",@"邮"]
@interface BangDingCartVc ()<UITableViewDelegate,UITableViewDataSource,AddressPickerViewDelegate>{
    UIButton *btn;
}
@property (nonatomic, strong) UITableView *myTab;
@property (nonatomic, strong) UITextField *codeText;//验证码
@property (nonatomic, strong) UITextField *cartNum;//卡号
@property (nonatomic, strong) UITextField *telNum;//手机码
@property (nonatomic, strong) UITextField *bankAddress;//开户行
@property (nonatomic, strong) UITextField *CityAddress;//开户行
//@property (nonatomic, copy) NSString *bankName;//银行名字
@property (nonatomic, strong) UIView *footerView;
@property (nonatomic, strong)UIButton *sendCodeBtn;
@property (nonatomic, strong) NSTimer *cdTimer;                 //倒计时
@property (nonatomic) NSInteger countDown;                      //倒计时


@property (nonatomic, strong) UIView *coverView;

@property (nonatomic ,strong) AddressPickerView * pickerView;
@end
static NSInteger MAX_COUNTDOWN = 60;
@implementation BangDingCartVc

- (void)goBack{
    if (self.navigationController.viewControllers.count > 1) {
        
    }else{
        [self.navigationController popViewControllerAnimated:YES];
    }
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    [self setNavBlackColor];
    self.title = @"绑定银行卡";
    
    self.myTab = [[UITableView alloc]initWithFrame:CGRectZero style:UITableViewStyleGrouped];
    self.myTab.delegate = self;
    self.myTab.dataSource = self;
    self.myTab.sectionFooterHeight = 0.1;
    self.myTab.rowHeight = ChangedHeight(45);
//    [self.myTab registerClass:[UITableViewCell class] forCellReuseIdentifier:@"myCell"];
    //
    self.myTab.tableFooterView = self.footerView;
    
    [self.view addSubview:self.myTab];
    [self.myTab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
    
    [self.view addSubview:self.coverView];
    [self.coverView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
    self.coverView.hidden = YES;
    [self.view addSubview:self.pickerView];
    
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
    
    self.cartNum = [[UITextField alloc]init];
    self.cartNum.font = [UIFont gs_fontNum:14];
    self.cartNum.keyboardType = UIKeyboardTypeNumberPad;
    self.cartNum.attributedPlaceholder = [[NSAttributedString alloc]initWithString:@"请输入您的银行卡号" attributes:
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
    
    self.CityAddress = [[UITextField alloc]init];
    self.CityAddress.font = [UIFont gs_fontNum:14];

    self.CityAddress.enabled = NO;
    self.CityAddress.attributedPlaceholder = [[NSAttributedString alloc]initWithString:@"请选择银行卡开户地区" attributes:
                                         @{
                                           NSFontAttributeName:[UIFont gs_fontNum:14],
                                           NSForegroundColorAttributeName:[UIColor getColor:134 G:135 B:136]
                                           }];
    
    self.bankAddress = [[UITextField alloc]init];
    self.bankAddress.font = [UIFont gs_fontNum:14];
    self.bankAddress.attributedPlaceholder = [[NSAttributedString alloc]initWithString:@"请输入开户行" attributes:
                                         @{
                                           NSFontAttributeName:[UIFont gs_fontNum:14],
                                           NSForegroundColorAttributeName:[UIColor getColor:134 G:135 B:136]
                                           }];
    
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    if ([UserManager shareManager].user.bank_data.count > 0 ) {
        self.title = @"设置开户行信息";
        self.cartNum.text = ((bankModel *)[UserManager shareManager].user.bank_data[0]).bankNumText;
        self.cartNum.enabled = NO;
    }
    if (self.navigationController.viewControllers.count < 2) {
        
        self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"back"] style:UIBarButtonItemStylePlain target:self action:@selector(backToLastVc)];
    }
}

- (void)backToLastVc{
    if (self.navigationController.viewControllers.count > 1) {
        [self.navigationController popViewControllerAnimated:YES];
    }else
        [self dismissViewControllerAnimated:YES completion:nil];
}
/**
 表的脚部
 
 @return 脚
 */
- (UIView *)footerView{
    if (!_footerView) {
        _footerView = [UIView new];
        UILabel *tip = [UILabel new];
        tip.textColor = [UIColor getBlueColor];
        tip.text = @"*温馨提示：必须绑定本人实名银行卡(信用卡不可用来投资),开户行信息正确才可提现成功";
        tip.font = [UIFont gs_fontNum:12];
        tip.numberOfLines = 2;
        [_footerView addSubview:tip];
        [tip mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.top.equalTo(_footerView);
            make.left.equalTo(_footerView).offset(10);
            make.height.mas_equalTo(ChangedHeight(30));
        }];
        _footerView.height = ChangedHeight(120);
        btn = [UIButton new];
        [btn addTarget:self action:@selector(sendUpYourCart) forControlEvents:UIControlEventTouchUpInside];
        [btn setTitle:@"确认提交" forState:UIControlStateNormal];
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

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return TitleArr.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return ChangedHeight(5);
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{

    return ChangedHeight(45);
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"myCell"];
    if (!cell) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"myCell"];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    cell.textLabel.text = TitleArr[indexPath.row];
    cell.textLabel.textColor = [UIColor getColor:82 G:83 B:84];
    cell.accessoryType = UITableViewCellAccessoryNone;
    cell.textLabel.font = [UIFont gs_fontNum:14];
    cell.detailTextLabel.text = @"";
    cell.detailTextLabel.textColor = [UIColor blackColor];
    cell.detailTextLabel.font = [UIFont gs_fontNum:14];
    switch (indexPath.row) {
        case 2:
        {
            [cell.contentView addSubview:self.CityAddress];
            [self.CityAddress mas_makeConstraints:^(MASConstraintMaker *make) {
                make.right.top.height.equalTo(cell.contentView);
                make.left.equalTo(cell.contentView).offset(ChangedHeight(100));
            }];
        }
            break;
        case 3:
        {
            [cell.contentView addSubview:self.bankAddress];
            [self.bankAddress mas_makeConstraints:^(MASConstraintMaker *make) {
                make.right.top.height.equalTo(cell.contentView);
                make.left.equalTo(cell.contentView).offset(ChangedHeight(100));
            }];
        }
            break;

        case 0:
        {
//            if ([UserManager shareManager].user.bank_data.count == 0) {
                //            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
                cell.detailTextLabel.text = [UserManager shareManager].user.real_name;
//            }

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
    [self.view endEditing:YES];
    if (indexPath.row == 2) {
        self.coverView.hidden = NO;
        [self.pickerView show];
    }
}

- (AddressPickerView *)pickerView{
    if (!_pickerView) {
        _pickerView = [[AddressPickerView alloc]initWithFrame:CGRectMake(0, K_HEIGHT , K_WIDTH, K_HEIGHT/2)];
        _pickerView.delegate = self;
        _pickerView.hidden = YES;
        // 关闭默认支持打开上次的结果
        //        _pickerView.isAutoOpenLast = NO;
    }
    return _pickerView;
}

#pragma mark - AddressPickerViewDelegate
- (void)cancelBtnClick{
    NSLog(@"点击了取消按钮");
    
    [self hidenPicker];
    
}
- (void)sureBtnClickReturnProvince:(NSString *)province City:(NSString *)city Area:(NSString *)area{
    self.CityAddress.text = [NSString stringWithFormat:@"%@-%@%@",province,city,area];
    [self hidenPicker];
}
- (void)hidenPicker{
    [self.pickerView hide];
    self.coverView.hidden = YES;
}
/**
 确认提交
 */
- (void)sendUpYourCart{
//    
//    if (!self.CityAddress.text.length) {
//        [MBProgressHUD showError:@"请选择银行卡办理地区"];
//        return;
//    }
//    if (!self.bankAddress.text.length) {
//        [MBProgressHUD showError:@"请输入银行卡开户行"];
//        return;
//    }
//    
//    if (![GSValidate validateString:self.telNum.text withRequireType:RequireTypeIsMobile]) {
//        [MBProgressHUD showError:@"请输入正确的手机号"];
//        return;
//    }
//    if (!self.codeText.text.length) {
//        [MBProgressHUD showError:@"请输入验证码"];
//        return;
//    }
//    if (self.cartNum.text.length < 6) {
//        [MBProgressHUD showError:@"请输入正确的银行卡号"];
//        return;
//    }
//    
//    btn.enabled = NO;
//    BOOL isSet = [UserManager shareManager].user.bank_data.count > 0;
//    NSString *bank_city = [self.CityAddress.text componentsSeparatedByString:@"-"][1];
//    
//    NSString *bank_province = [self.CityAddress.text componentsSeparatedByString:@"-"][0];
//    if ([bank_province containsString:@"省"]) {
//        bank_province = [bank_province stringByReplacingOccurrencesOfString:@"省" withString:@""];
//    }else if ([bank_province containsString:@"市"]){
//        bank_province = [bank_province stringByReplacingOccurrencesOfString:@"市" withString:@""];
//    }
//    bankModel *cartModel;
//    if (isSet) {
//        cartModel = [UserManager shareManager].user.bank_data[0];
//    }
//    [NetworkManager startNetworkRequestDataFromRemoteServerByPostMethodWithURLString:[NSString stringWithFormat:@"%@user/bindcard",kAppPostHost]
//          withParameters:@{
//                           @"card_num":isSet?cartModel.bank_num:self.cartNum.text,//	银行卡号	string
//                           @"tel":self.telNum.text,//	预留手机号	string
//                           @"token":[UserManager shareManager].userId,//	用户id	number
//                           @"verify_code":self.codeText.text,//	验证码
//                           @"bank_address":self.bankAddress.text,//	开户行地址	string
//                           @"bank_city":[bank_city stringByReplacingOccurrencesOfString:@"市" withString:@""],//	开户行市	string
//                           @"type":isSet?@"1" : @"0",//		类别	string	0：绑卡，1：设置开户卡支行
//                           @"bank_province":bank_province//		开户行省份
//                           }
//     ShowHUD:YES
//                 success:^(NSURLSessionDataTask *task, id responseObject) {
//                     btn.enabled = YES;
//                     if ([responseObject[@"status"] integerValue] == 200) {
//                         dispatch_async(dispatch_get_main_queue(), ^{
//                             
//                             [[NSUserDefaults standardUserDefaults] setObject:@"1" forKey:RefreshUser];
//                             [[NSUserDefaults standardUserDefaults] synchronize];
//                             UserModel *model = [UserManager shareManager].user;
//                             __block bankModel *bank = [[bankModel alloc]init];
//                             if (model.bank_data.count == 0 && [model.is_setpinpass integerValue] == 0) {
//
//                                 [BankTextNameArr enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
//                                     NSString *bankName = obj;
//                                     if ([responseObject[@"data"][@"bankname"] containsString:bankName]) {
//                                         bank.UseableBankName = BankNameArr[idx];
//                                         bank.bank_num = self.cartNum.text;
//                                         return ;
//                                     }
//                                 }];
//
//                                 model.bank_data  = @[bank];
//                                 [[UserManager shareManager] saveUserModel:model];
//                                 SetingExtractPasswordVc *vc = [[SetingExtractPasswordVc alloc]init];
//                                 vc.moneyStr = responseObject[@"data"][@"reward_money"];
//                                 [self.navigationController pushViewController:vc animated:YES];
//                             }else{
//                                 [BankTextNameArr enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
//                                     NSString *bankName = obj;
//                                     if ([responseObject[@"data"][@"bankname"] containsString:bankName]) {
//                                         bank.UseableBankName = BankNameArr[idx];
//                                         bank.bank_num = self.cartNum.text;
//                                         return ;
//                                     }
//                                 }];
//                                 model.bank_data  = @[bank];
//                                 [[UserManager shareManager] saveUserModel:model];
//                                 [MBProgressHUD showSuccess:@"设置开户行成功"];
//                                 [self backToLastVc];
//                             }
//                             
//                         });
//                     }
//                 } failure:^(NSURLSessionDataTask *task, NSError *error) {
//                     dispatch_async(dispatch_get_main_queue(), ^{
//                         btn.enabled = YES;
//                     });
//                 }];
//    
//}
///**
// 发送验证码的接口
// */
//- (void)sendCodeToTel{
//    if (![GSValidate validateString:self.telNum.text withRequireType:RequireTypeIsMobile]) {
//        [MBProgressHUD showError:@"请输入正确的手机号"];
//        return;
//    }
//    [NetworkManager startNetworkRequestDataFromRemoteServerByPostMethodWithURLString:[NSString stringWithFormat:@"%@user/commitphone",kAppPostHost]
//          withParameters:@{
//                           @"tel":self.telNum.text
//                           }
//     ShowHUD:YES 
//                 success:^(NSURLSessionDataTask *task, id responseObject) {
//                     if ([responseObject[@"status"] integerValue] == 200) {
//                         dispatch_async(dispatch_get_main_queue(), ^{
//                             self.countDown = MAX_COUNTDOWN;
//                             [self getCodeCountDown];
//                         });
//                     }
//                 } failure:^(NSURLSessionDataTask *task, NSError *error) {
//                     
//                 }];
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


- (UIView *)coverView {
   if (!_coverView) {
       _coverView = [UIView new];
       [_coverView addGestureRecognizer:[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(hidenPicker)]];
       _coverView.backgroundColor = [UIColor colorWithHex:0x000000 alpha:0.5];
   }
   return _coverView;
}

@end
