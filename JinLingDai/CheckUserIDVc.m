//
//  CheckUserIDVc.m
//  JinLingDai
//
//  Created by 001 on 2017/7/7.
//  Copyright © 2017年 JLD. All rights reserved.
//

#import "CheckUserIDVc.h"
#define TitleArr @[@"请输入手机号：", @"请输入验证码："]
#import <YYKit.h>
#import "GSValidate.h"
#import "MBProgressHUD+NetWork.h"
@interface CheckUserIDVc ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic, strong) UITableView *myTab;
@property (nonatomic, strong) UITextField *passwordText;//原来密码
@property (nonatomic, strong) UITextField *checkoutText;//检验
@property (nonatomic, strong) UIView *footerView;
@property (nonatomic, strong)UIButton *sendCodeBtn;
@property (nonatomic, strong) NSTimer *cdTimer;                 //倒计时
@property (nonatomic) NSInteger countDown;                      //倒计时
@end

static NSInteger MAX_COUNTDOWN = 60;
@implementation CheckUserIDVc

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setNavBlackColor];
    self.title = @"绑定手机号";
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
    
    self.passwordText = [[UITextField alloc]init];
    self.passwordText.font = [UIFont gs_fontNum:13];
    self.passwordText.attributedPlaceholder = [[NSAttributedString alloc]initWithString:@"请输入手机号码" attributes:
                                               @{NSFontAttributeName:[UIFont gs_fontNum:13],
                                                 NSForegroundColorAttributeName:[UIColor getColor:134 G:135 B:136]
                                                 }];
    
    _sendCodeBtn = [UIButton new];
    [_sendCodeBtn setTitle:@"发送验证码" forState:UIControlStateNormal];
    [_sendCodeBtn setTitleColor:[UIColor getBlueColor] forState:UIControlStateNormal];
    _sendCodeBtn.titleLabel.font = [UIFont gs_fontNum:13];
    [_sendCodeBtn addTarget:self action:@selector(sendCodeToTel) forControlEvents:UIControlEventTouchUpInside];
    _sendCodeBtn.bounds = CGRectMake(0, 0, ChangedHeight(70), ChangedHeight(50));
    
    self.checkoutText = [[UITextField alloc]init];
    self.checkoutText.font = [UIFont gs_fontNum:13];
    self.checkoutText.rightView = _sendCodeBtn;
    self.checkoutText.rightViewMode = UITextFieldViewModeAlways;
    self.checkoutText.attributedPlaceholder = [[NSAttributedString alloc]initWithString:@"请输入校验码" attributes:
                                               @{NSFontAttributeName:[UIFont gs_fontNum:13],
                                                 NSForegroundColorAttributeName:[UIColor getColor:134 G:135 B:136]
                                                 }];
}
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    if (self.navigationController.viewControllers.count == 1) {
        self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"back"] style:UIBarButtonItemStylePlain target:self action:@selector(dismissSelfVc)];
    }
}
- (void)dismissSelfVc{
    if (self.navigationController.viewControllers.count > 1) {
        [self.navigationController popViewControllerAnimated:YES];
    }
    [self dismissViewControllerAnimated:YES completion:nil];
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
        [btn addTarget:self action:@selector(sendUpInfo) forControlEvents:UIControlEventTouchUpInside];
        [btn setTitle:@"提交" forState:UIControlStateNormal];
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
    return 2;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return ChangedHeight(5);
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"myCell"];
    cell.textLabel.text = TitleArr[indexPath.row];
    cell.textLabel.font = [UIFont gs_fontNum:13];
    cell.accessoryType = UITableViewCellAccessoryNone;
    cell.textLabel.textColor = [UIColor getColor:82 G:83 B:84];
    switch (indexPath.row) {
        case 0:
        {
            [cell.contentView addSubview:self.passwordText];
            [self.passwordText mas_makeConstraints:^(MASConstraintMaker *make) {
                make.right.top.height.equalTo(cell.contentView);
                make.left.equalTo(cell.contentView).offset(ChangedHeight(110));
            }];
        }
            break;
        default:
        {
            [cell.contentView addSubview:self.checkoutText];
            [self.checkoutText mas_makeConstraints:^(MASConstraintMaker *make) {
                make.right.top.height.equalTo(cell.contentView);
                make.left.equalTo(cell.contentView).offset(ChangedHeight(110));
            }];
        }
            break;
    }
    return cell;
}
/**
 提交
 */
- (void)sendUpInfo{
    if (![GSValidate validateString:self.passwordText.text withRequireType:RequireTypeIsMobile]) {
        [MBProgressHUD showError:@"请输入正确手机号"];
        return;
    }
    if (!self.checkoutText.text.length) {
        [MBProgressHUD showError:@"请输入验证码"];
        return;
    }
    NSString *postUrl ;
    kAppPostHost(postUrl);
    [NetworkManager startNetworkRequestDataFromRemoteServerByPostMethodWithURLString:[NSString stringWithFormat:@"%@user/validatephone",postUrl]
          withParameters:@{
                           @"tel":self.passwordText.text,
                           @"verify_code":self.checkoutText.text,
                           @"token":[UserManager shareManager].userId//	用户令牌
                           }
                 ShowHUD:YES
                 success:^(NSURLSessionDataTask *task, id responseObject) {
                     if ([responseObject[@"status"] integerValue] == 200){
                         dispatch_async(dispatch_get_main_queue(), ^{
                             UserModel *model = [UserManager shareManager].user;
                             model.tel = self.passwordText.text;
                             [[UserManager shareManager] saveUserModel:model];
                             [[NSUserDefaults standardUserDefaults] setValue:@"1" forKey:RefreshUser];
                             [MBProgressHUD showSuccess:responseObject[@"message"]];
                             [self performSelector:@selector(dismissSelfVc) withObject:nil afterDelay:1.f];
                         });
                     }
                 } failure:^(NSURLSessionDataTask *task, NSError *error) {
                     
                 }];
}

/**
 发送验证码的接口
 */
- (void)sendCodeToTel{
    if (![GSValidate validateString:self.passwordText.text withRequireType:RequireTypeIsMobile]) {
        [MBProgressHUD showError:@"请输入正确手机号"];
        return;
    }
    NSString *postUrl ;
    kAppPostHost(postUrl);
    [NetworkManager startNetworkRequestDataFromRemoteServerByPostMethodWithURLString:[NSString stringWithFormat:@"%@user/commitphone",postUrl]
          withParameters:@{
                           @"tel":self.passwordText.text
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
