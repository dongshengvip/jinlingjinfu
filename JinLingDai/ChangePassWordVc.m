//
//  ChangePassWordVcViewController.m
//  JinLingDai
//
//  Created by 001 on 2017/7/3.
//  Copyright © 2017年 JLD. All rights reserved.
//

#import "ChangePassWordVc.h"
#import <YYKit.h>
#import "MBProgressHUD+NetWork.h"
#define TitleArr @[@"原登录密码：", @"设置新密码：", @"确认新密码："]
@interface ChangePassWordVc ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic, strong) UITableView *myTab;
@property (nonatomic, strong) UITextField *oldPasswordText;//新密码
//@property (nonatomic, strong) UITextField *checkoutText;//检验
@property (nonatomic, strong) UITextField *novelPasswordText;//确认新密码

@property (nonatomic, strong) UITextField *checkCodeText;//原登录密码
//@property (nonatomic, strong) UIButton *sendCodeBtn;
//@property (nonatomic, strong) NSTimer *cdTimer;                 //倒计时
//@property (nonatomic) NSInteger countDown;                      //倒计时

@property (nonatomic, strong) UIView *footerView;

@end

static NSInteger MAX_COUNTDOWN = 60;
@implementation ChangePassWordVc

- (void)goBack{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor infosBackViewColor];
//    [self.navigationController.navigationBar setTintColor:[UIColor blackColor]];
//    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"back"] style:UIBarButtonItemStylePlain target:self action:@selector(goBack)];
    [self setNavBlackColor];
    self.title = @"修改登录密码";
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


    
    self.checkCodeText = [[UITextField alloc]init];
    self.checkCodeText.font = [UIFont gs_fontNum:13];
    self.checkCodeText.attributedPlaceholder = [[NSAttributedString alloc]initWithString:@"请输入原登录密码" attributes:
                                                @{NSFontAttributeName:[UIFont gs_fontNum:13],
                                                  NSForegroundColorAttributeName:[UIColor getColor:134 G:135 B:136]
                                                  }];
    
    self.oldPasswordText = [[UITextField alloc]init];
    self.oldPasswordText.font = [UIFont gs_fontNum:13];
    self.oldPasswordText.secureTextEntry = YES;
//    self.oldPasswordText.keyboardType = UIKeyboardTypeNumberPad;
    self.oldPasswordText.attributedPlaceholder = [[NSAttributedString alloc]initWithString:@"请输入新的密码" attributes:
                                               @{NSFontAttributeName:[UIFont gs_fontNum:13],
                                                 NSForegroundColorAttributeName:[UIColor getColor:134 G:135 B:136]
                                                 }];
    
    self.novelPasswordText = [[UITextField alloc]init];
    self.novelPasswordText.secureTextEntry = YES;
    self.novelPasswordText.font = [UIFont gs_fontNum:13];
    self.novelPasswordText.attributedPlaceholder = [[NSAttributedString alloc]initWithString:@"请再次输入新密码" attributes:
                                               @{NSFontAttributeName:[UIFont gs_fontNum:13],
                                                 NSForegroundColorAttributeName:[UIColor getColor:134 G:135 B:136]
                                                 }];
    

//    self.checkoutText = [[UITextField alloc]init];
//    self.checkoutText.font = [UIFont gs_fontNum:13];
//    self.checkoutText.secureTextEntry = YES;
//    self.checkoutText.attributedPlaceholder = [[NSAttributedString alloc]initWithString:@"请再次输入新密码" attributes:
//                                               @{NSFontAttributeName:[UIFont gs_fontNum:13],
//                                                 NSForegroundColorAttributeName:[UIColor getColor:134 G:135 B:136]
//                                                 }];
    
}

/**
 表的脚部
 
 @return 脚
 */
- (UIView *)footerView{
    if (!_footerView) {
        _footerView = [UIView new];
        _footerView.height = ChangedHeight(240);
        UIButton *btn = [UIButton new];
        [btn addTarget:self action:@selector(changePasswordSoure) forControlEvents:UIControlEventTouchUpInside];
        [btn setTitle:@"确认修改" forState:UIControlStateNormal];
        btn.titleLabel.font = [UIFont gs_fontNum:15];
        btn.layer.cornerRadius = 4;
        btn.backgroundColor = [UIColor getOrangeColor];
        [_footerView addSubview:btn];
        [btn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(_footerView).insets(UIEdgeInsetsMake(ChangedHeight(190), ChangedHeight(35), ChangedHeight(10), ChangedHeight(35)));
        }];
        
    }
    return _footerView;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 3;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return ChangedHeight(5);
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"myCell"];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.textLabel.text = TitleArr[indexPath.row];
    cell.accessoryType = UITableViewCellAccessoryNone;
    cell.textLabel.font = [UIFont gs_fontNum:13];
    cell.textLabel.textColor = [UIColor getColor:82 G:83 B:84];
    switch (indexPath.row) {
        case 0:
        {
            [cell.contentView addSubview:self.checkCodeText];
            [self.checkCodeText mas_makeConstraints:^(MASConstraintMaker *make) {
                make.right.top.height.equalTo(cell.contentView);
                make.left.equalTo(cell.contentView).offset(ChangedHeight(90));
            }];
        }
            break;
        case 1:
        {
            [cell.contentView addSubview:self.oldPasswordText];
            [self.oldPasswordText mas_makeConstraints:^(MASConstraintMaker *make) {
                make.right.top.height.equalTo(cell.contentView);
                make.left.equalTo(cell.contentView).offset(ChangedHeight(90));
            }];
            
        }
            break;
        
        default:{
            [cell.contentView addSubview:self.novelPasswordText];
            [self.novelPasswordText mas_makeConstraints:^(MASConstraintMaker *make) {
                make.right.top.height.equalTo(cell.contentView);
                make.left.equalTo(cell.contentView).offset(ChangedHeight(90));
            }];
        }
            break;
    }
    return cell;
}
/**
 修改密码
 */
- (void)changePasswordSoure{
    if (self.checkCodeText.text.length < 1) {
        [MBProgressHUD showError:@"请输入原登录密码"];
        return;
    }
    if (self.oldPasswordText.text.length < 8) {
        [MBProgressHUD showError:@"请输入8位以上密码"];
        return;
    }
    if (![self.novelPasswordText.text isEqualToString:self.oldPasswordText.text]) {
        [MBProgressHUD showError:@"两次输入的密码不一致"];
        return;
    }
    NSString *postUrl ;
    kAppPostHost(postUrl);
    [NetworkManager startNetworkRequestDataFromRemoteServerByPostMethodWithURLString:[NSString stringWithFormat:@"%@user/changeuserpass",postUrl]
    withParameters:@{
                     @"oldpwd":self.checkCodeText.text,
                     @"newpwd":self.oldPasswordText.text,
                     @"token":[UserManager shareManager].userId
                     }
     ShowHUD:YES
    success:^(NSURLSessionDataTask *task, id responseObject) {
        if ([responseObject[@"status"] integerValue] == 200) {
            dispatch_async(dispatch_get_main_queue(), ^{
                [MBProgressHUD showSuccess:@"修改密码成功"];
                [[UserManager shareManager] logoutUsr];
                [[UserManager shareManager] logoutMoney];
                UIAlertController *alert  = [UIAlertController alertControllerWithTitle:@"温馨提示" message:@"您的密码修改成功，请重新登陆" preferredStyle:UIAlertControllerStyleAlert];
                [alert addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action){
                    [self.navigationController popToRootViewControllerAnimated:NO];
                }]];
                [alert addAction:[UIAlertAction actionWithTitle:@"去登录" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                    UIWindow *window = [UIApplication sharedApplication].keyWindow;
                    UIViewController *vc = [[NSClassFromString(@"LogingVc") alloc] init];
                    UINavigationController *nav = [[UINavigationController alloc]initWithRootViewController:vc];
                    [window.rootViewController presentViewController:nav animated:YES completion:nil];
                    [self.navigationController popToRootViewControllerAnimated:NO];
                }]];

                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.f * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    [self presentViewController:alert animated:YES completion:nil];
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
