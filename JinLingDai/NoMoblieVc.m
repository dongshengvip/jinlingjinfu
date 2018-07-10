//
//  NoMoblieVc.m
//  JinLingDai
//
//  Created by 001 on 2017/8/17.
//  Copyright © 2017年 JLD. All rights reserved.
//

#import "NoMoblieVc.h"
#import <YYKit.h>
#import "MBProgressHUD+NetWork.h"
#define TitleArr2 @[@"输入账号：", @"交易密码：", @"设置新密码：", @"确认新密码："]
@interface NoMoblieVc ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic, strong) UITableView *myTab;
@property (nonatomic, strong) UITextField *telText;//账号
@property (nonatomic, strong) UITextField *exchangeTex;//交易密码
@property (nonatomic, strong) UITextField *passwordText;//新密码
@property (nonatomic, strong) UITextField *checkPassText;//确认密码
@property (nonatomic, strong) UIView *footerView;

@end

@implementation NoMoblieVc

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    [self setNavOrangeColor];
    
    
    //    [self.navigationController.navigationBar setTintColor:[UIColor blackColor]];
    //    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"back"] style:UIBarButtonItemStylePlain target:self action:@selector(goBack)];
    self.title = @"其他方式找回密码";
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
    
    self.telText = [[UITextField alloc]init];
    self.telText.font = [UIFont gs_fontNum:13];
    self.telText.keyboardType = UIKeyboardTypeNumberPad;
    self.telText.attributedPlaceholder = [[NSAttributedString alloc]initWithString:@"请输入您的账号" attributes:
                                               @{NSFontAttributeName:[UIFont gs_fontNum:13],
                                                 NSForegroundColorAttributeName:[UIColor getColor:134 G:135 B:136]
                                                 }];
    
    self.exchangeTex = [[UITextField alloc]init];
    self.exchangeTex.secureTextEntry = YES;
    self.exchangeTex.keyboardType = UIKeyboardTypeNumberPad;
    self.exchangeTex.font = [UIFont gs_fontNum:13];
    self.exchangeTex.attributedPlaceholder = [[NSAttributedString alloc]initWithString:@"请输入6位数字交易密码" attributes:
                                               @{NSFontAttributeName:[UIFont gs_fontNum:13],
                                                 NSForegroundColorAttributeName:[UIColor getColor:134 G:135 B:136]
                                                 }];
    
    self.passwordText = [[UITextField alloc]init];
    self.passwordText.secureTextEntry = YES;
    self.passwordText.font = [UIFont gs_fontNum:13];
    self.passwordText.attributedPlaceholder = [[NSAttributedString alloc]initWithString:@"请输入新的密码" attributes:
                                          @{NSFontAttributeName:[UIFont gs_fontNum:13],
                                            NSForegroundColorAttributeName:[UIColor getColor:134 G:135 B:136]
                                            }];
    
    self.checkPassText = [[UITextField alloc]init];
    self.checkPassText.secureTextEntry = YES;
    self.checkPassText.font = [UIFont gs_fontNum:13];
    self.checkPassText.attributedPlaceholder = [[NSAttributedString alloc]initWithString:@"请再次输入密码" attributes:
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
        _footerView.height = ChangedHeight(220);
        
        UIButton *noMobile = [UIButton buttonWithType:UIButtonTypeCustom];
        noMobile.titleLabel.font = [UIFont gs_fontNum:13];
        [noMobile addTarget:self action:@selector(NoMoblieToChangePass) forControlEvents:UIControlEventTouchUpInside];
        [noMobile setTitle:@"联系客服找回" forState:UIControlStateNormal];
        [noMobile setTitleColor:[UIColor newSecondTextColor] forState:UIControlStateNormal];
        [_footerView addSubview:noMobile];
        [noMobile mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(_footerView).offset(ChangedHeight(5));
            make.right.equalTo(_footerView);
            make.height.mas_equalTo(ChangedHeight(30));
            make.width.mas_equalTo(ChangedHeight(90));
        }];
        UIButton *btn = [UIButton new];
        [btn addTarget:self action:@selector(changePasswordSoure) forControlEvents:UIControlEventTouchUpInside];
        [btn setTitle:@"确认修改" forState:UIControlStateNormal];
        btn.titleLabel.font = [UIFont gs_fontNum:15];
        btn.layer.cornerRadius = 4;
        btn.backgroundColor = [UIColor getOrangeColor];
        [_footerView addSubview:btn];
        [btn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(_footerView).insets(UIEdgeInsetsMake(ChangedHeight(170), ChangedHeight(35), ChangedHeight(10), ChangedHeight(35)));
        }];
        
    }
    return _footerView;
}

- (void)NoMoblieToChangePass{
    dispatch_async(dispatch_get_main_queue(), ^{
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"联系客服" message:@"电话：400-889-7650" preferredStyle:UIAlertControllerStyleAlert];
        [alert addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil]];
        [alert addAction:[UIAlertAction actionWithTitle:@"拨打" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            NSMutableString *str=[[NSMutableString alloc] initWithFormat:@"tel:%@",@"4008897650"];
            UIWebView *callWebview = [[UIWebView alloc] init];
            [callWebview loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:str]]];
            [self.view addSubview:callWebview];
            
            
        }]];
        [self presentViewController:alert animated:YES completion:nil];
    });
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return TitleArr2.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return ChangedHeight(5);
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"myCell"];
    cell.textLabel.text = TitleArr2[indexPath.row];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.accessoryType = UITableViewCellAccessoryNone;
    cell.textLabel.font = [UIFont gs_fontNum:13];
    cell.textLabel.textColor = [UIColor getColor:82 G:83 B:84];
    switch (indexPath.row) {
        case 0:
        {
            [cell.contentView addSubview:self.telText];
            [self.telText mas_makeConstraints:^(MASConstraintMaker *make) {
                make.right.top.height.equalTo(cell.contentView);
                make.left.equalTo(cell.contentView).offset(ChangedHeight(90));
            }];
        }
            break;
        case 1:
        {
            [cell.contentView addSubview:self.exchangeTex];
            [self.exchangeTex mas_makeConstraints:^(MASConstraintMaker *make) {
                make.right.top.height.equalTo(cell.contentView);
                make.left.equalTo(cell.contentView).offset(ChangedHeight(90));
            }];
            
        }
            break;
        case 2:
        {
            [cell.contentView addSubview:self.passwordText];
            [self.passwordText mas_makeConstraints:^(MASConstraintMaker *make) {
                make.right.top.height.equalTo(cell.contentView);
                make.left.equalTo(cell.contentView).offset(ChangedHeight(90));
            }];
            
        }
            break;
        default:{
            [cell.contentView addSubview:self.checkPassText];
            [self.checkPassText mas_makeConstraints:^(MASConstraintMaker *make) {
                make.right.top.height.equalTo(cell.contentView);
                make.left.equalTo(cell.contentView).offset(ChangedHeight(90));
            }];
        }
            break;
    }
    return cell;
}

- (void)changePasswordSoure{
    if (self.telText.text.length < 1) {
        [MBProgressHUD showError:@"请输入账号"];
        return;
    }
    if (self.exchangeTex.text.length < 6) {
        [MBProgressHUD showError:@"请输入正确的6位交易密码"];
        return;
    }
    if (self.passwordText.text.length < 8) {
        [MBProgressHUD showError:@"请输入8位以上密码"];
        return;
    }
    if (![self.checkPassText.text isEqualToString:self.passwordText.text]) {
        [MBProgressHUD showError:@"两次输入的密码不一致"];
        return;
    }
    NSString *postUrl ;
    kAppPostHost(postUrl);
    [NetworkManager startNetworkRequestDataFromRemoteServerByPostMethodWithURLString:[NSString stringWithFormat:@"%@user/findpwd",postUrl]
      withParameters:@{
                       @"new_pwd":self.passwordText.text,//	新密码	string
                       @"trade_pwd":self.exchangeTex.text,//	交易密码	string
                       @"username":self.telText.text	//用户名
                       }
             ShowHUD:YES
             success:^(NSURLSessionDataTask *task, id responseObject) {
                 if ([responseObject[@"status"] integerValue] == 200) {
                     dispatch_async(dispatch_get_main_queue(), ^{
                         [MBProgressHUD showSuccess:@"修改密码成功"];
                         [[UserManager shareManager] logoutUsr];
                         [[UserManager shareManager] logoutMoney];
                         
                         dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.f * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                             [self.navigationController popToRootViewControllerAnimated:YES];
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

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
