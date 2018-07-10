//
//  UserNameAndIdCheckVc.m
//  JinLingDai
//
//  Created by 001 on 2017/7/7.
//  Copyright © 2017年 JLD. All rights reserved.
//

#import "UserNameAndIdCheckVc.h"
#define TitleArr @[@"真实姓名：", @"身份证号："]
#import <YYKit.h>
#import "MBProgressHUD+NetWork.h"
#import "UserManager.h"
#import "GSValidate.h"
#import "RedBagAleartView.h"
@interface UserNameAndIdCheckVc ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic, strong) UITableView *myTab;
@property (nonatomic, strong) UITextField *nameText;//姓名
@property (nonatomic, strong) UITextField *IDCartText;//身份证
@property (nonatomic, strong) UIView *footerView;
//@property (nonatomic, strong) RedBagAleartView *alertView;
@end

@implementation UserNameAndIdCheckVc

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setNavBlackColor];
    self.title = @"实名认证";
    self.myTab = [[UITableView alloc]initWithFrame:CGRectZero style:UITableViewStyleGrouped];
    self.myTab.delegate = self;
    self.myTab.dataSource = self;
    self.myTab.sectionFooterHeight = 0.1;
    self.myTab.rowHeight = ChangedHeight(45);
    [self.myTab registerClass:[UITableViewCell class] forCellReuseIdentifier:@"myCell"];
    //
    self.myTab.tableFooterView = self.footerView;
    [self.view addSubview:self.myTab];
    [self.myTab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
    
    self.nameText = [[UITextField alloc]init];
    self.nameText.font = [UIFont gs_fontNum:13];
        self.nameText.attributedPlaceholder = [[NSAttributedString alloc]initWithString:@"请输入姓名" attributes:
                                                   @{NSFontAttributeName:[UIFont gs_fontNum:13],
                                                     NSForegroundColorAttributeName:[UIColor getColor:134 G:135 B:136]
                                                     }];
    
    
    self.IDCartText = [[UITextField alloc]init];
    self.IDCartText.font = [UIFont gs_fontNum:13];
        self.IDCartText.attributedPlaceholder = [[NSAttributedString alloc]initWithString:@"请输入身份证号" attributes:
                                                   @{NSFontAttributeName:[UIFont gs_fontNum:13],
                                                     NSForegroundColorAttributeName:[UIColor getColor:134 G:135 B:136]
                                                     }];
    
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    if (self.navigationController.viewControllers.count < 2) {
        
        self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"back"] style:UIBarButtonItemStylePlain target:self action:@selector(backToLastVc)];
    }
}

- (void)backToLastVc{
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
        [btn setTitle:@"认证" forState:UIControlStateNormal];
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
    return ChangedHeight(50);
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    return @"认证实名身份信息是您投资的必要条件，为保障您的资金安全，请务必保证信息的正确有效";
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
            [cell.contentView addSubview:self.nameText];
            [self.nameText mas_makeConstraints:^(MASConstraintMaker *make) {
                make.right.top.height.equalTo(cell.contentView);
                make.left.equalTo(cell.contentView).offset(ChangedHeight(80));
            }];
        }
            break;
        default:
        {
            [cell.contentView addSubview:self.IDCartText];
            [self.IDCartText mas_makeConstraints:^(MASConstraintMaker *make) {
                make.right.top.height.equalTo(cell.contentView);
                make.left.equalTo(cell.contentView).offset(ChangedHeight(80));
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
    if (!self.nameText.text.length) {
        [MBProgressHUD showError:@"请输入姓名"];
        return;
    }
    if (![GSValidate validateString:self.IDCartText.text withRequireType:RequireTypeIdentityCard]) {
        [MBProgressHUD showError:@"请输入正确的身份证号"];
        return;
    }
    NSString *postUrl ;
    kAppPostHost(postUrl);
    [NetworkManager startNetworkRequestDataFromRemoteServerByPostMethodWithURLString:[NSString stringWithFormat:@"%@user/verify",postUrl]
      withParameters:@{
                       @"token":[UserManager shareManager].userId,
                       @"idcard":self.IDCartText.text,
                       @"real_name":self.nameText.text
                       }
     ShowHUD:YES 
             success:^(NSURLSessionDataTask *task, id responseObject) {
                 if ([responseObject[@"status"] integerValue] == 200) {
                     dispatch_async(dispatch_get_main_queue(), ^{
                         [[NSUserDefaults standardUserDefaults] setObject:@"1" forKey:RefreshUser];
                         [[NSUserDefaults standardUserDefaults] synchronize];
                         UserModel *model = [UserManager shareManager].user;
                         model.real_name = self.nameText.text;
                         model.is_verify = @"1";
                         [[UserManager shareManager] saveUserModel:model];

                         if (self.navigationController.viewControllers.count > 1) {
                             [self.navigationController popViewControllerAnimated:YES];
                         }else
                             [self dismissViewControllerAnimated:YES completion:nil];
                         
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
