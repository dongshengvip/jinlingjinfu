//
//  SetingExtractPasswordVc.m
//  JinLingDai
//
//  Created by 001 on 2017/7/6.
//  Copyright © 2017年 JLD. All rights reserved.
//

#import "SetingExtractPasswordVc.h"
#import "BaseTextField.h"
#import <YYKit.h>
#import "MBProgressHUD+NetWork.h"

#define TitleArr @[@"创建交易密码:", @"确认交易密码:"]
@interface SetingExtractPasswordVc ()<UITextFieldDelegate,UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, strong) BaseTextField *password1;
@property (nonatomic, strong) BaseTextField *password2;
@property (nonatomic, strong) UITableView *myTab;
@property (nonatomic, strong) UIView *footerView;
@end

@implementation SetingExtractPasswordVc

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setNavBlackColor];
    
    self.title = @"设置交易密码";
    
    self.myTab = [[UITableView alloc]initWithFrame:CGRectZero style:UITableViewStyleGrouped];
    self.myTab.delegate = self;
    self.myTab.dataSource = self;
    self.myTab.sectionFooterHeight = 0.1;
    self.myTab.estimatedSectionHeaderHeight = 0;
    self.myTab.estimatedSectionFooterHeight = 0;
    self.myTab.rowHeight = ChangedHeight(45);
    [self.myTab registerClass:[UITableViewCell class] forCellReuseIdentifier:@"myCell"];
    //
    self.myTab.tableFooterView = self.footerView;
    [self.view addSubview:self.myTab];
    [self.myTab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
    
    self.password1 = [[BaseTextField alloc]init];
    self.password1.font = [UIFont gs_fontNum:13];
    self.password1.secureTextEntry = YES;
    self.password1.keyboardType = UIKeyboardTypeNumberPad;
    self.password1.attributedPlaceholder = [[NSAttributedString alloc]initWithString:@"请输入交易密码" attributes:
                                                  @{NSFontAttributeName:[UIFont gs_fontNum:13],
                                                    NSForegroundColorAttributeName:[UIColor getColor:134 G:135 B:136]
                                                    }];
    
    self.password2 = [[BaseTextField alloc]init];
    self.password2.secureTextEntry = YES;
    self.password2.keyboardType = UIKeyboardTypeNumberPad;
    self.password2.font = [UIFont gs_fontNum:13];
    self.password2.attributedPlaceholder = [[NSAttributedString alloc]initWithString:@"请再次输入交易密码" attributes:
                                                    @{NSFontAttributeName:[UIFont gs_fontNum:13],
                                                      NSForegroundColorAttributeName:[UIColor getColor:134 G:135 B:136]
                                                      }];
    
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES animated:YES];
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:YES];
}


- (UIView *)footerView {
    if (!_footerView) {
        _footerView = [UIView new];
        _footerView.height = ChangedHeight(150);
        UILabel *tipLab = [UILabel new];
        tipLab.numberOfLines = 0;
        tipLab.textColor = [UIColor getBlueColor];
        tipLab.font = [UIFont gs_fontNum:13];
        tipLab.text = @"温馨提示：交易密码只支持6位数字";
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

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 2;
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
            [cell.contentView addSubview:self.password1];
            [self.password1 mas_makeConstraints:^(MASConstraintMaker *make) {
                make.right.top.height.equalTo(cell.contentView);
                make.left.equalTo(cell.contentView).offset(ChangedHeight(90));
            }];
        }
            break;
        case 1:
        {
            [cell.contentView addSubview:self.password2];
            [self.password2 mas_makeConstraints:^(MASConstraintMaker *make) {
                make.right.top.height.equalTo(cell.contentView);
                make.left.equalTo(cell.contentView).offset(ChangedHeight(90));
            }];
            
        }
            break;
            
        default:{
            
        }
            break;
    }
    return cell;
}

- (void)confirmToBank{
    if (self.password1.text.length != 6) {
        [MBProgressHUD showError:@"请输入6位数字密码"];
        return;
    }
    if (![self.password2.text isEqualToString:self.password1.text]) {
        [MBProgressHUD showError:@"两次输入的密码不一致"];
        return;
    }
    NSString *postUrl ;
    kAppPostHost(postUrl);
    [NetworkManager startNetworkRequestDataFromRemoteServerByPostMethodWithURLString:[NSString stringWithFormat:@"%@bank/set_paypwd",postUrl]
          withParameters:@{
                           @"trade_pwd":self.password1.text,//	交易密码	string
                           @"token":[UserManager shareManager].userId//	用户id	number
                           }
     ShowHUD:YES 
                 success:^(NSURLSessionDataTask *task, id responseObject) {
                     
                     if ([responseObject[@"status"]intValue] == 200) {
                         dispatch_async(dispatch_get_main_queue(), ^{
                             
                             NSMutableArray *arr = [NSMutableArray arrayWithArray:self.navigationController.viewControllers];
                             if (arr.count > 2) {
                                 [arr removeLastObject];
                                 [arr removeLastObject];
                                 [self.navigationController setViewControllers:arr];
                             }else{
                                 [self dismissViewControllerAnimated:YES completion:nil];
                             }
                         });
                     }
                 } failure:^(NSURLSessionDataTask *task, NSError *error) {
                     
                 }];
    
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    [textField resignFirstResponder];
    return YES;
}



- (void)accomplishSettingPassWord{

    
    
    
    
    
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
