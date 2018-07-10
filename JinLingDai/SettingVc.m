//
//  SettingVc.m
//  JinLingDai
//
//  Created by 001 on 2017/6/28.
//  Copyright © 2017年 JLD. All rights reserved.
//

#import "SettingVc.h"
#import <Masonry.h>
#import <YYKit.h>
#import "UIImage+Comment.h"
#import "UserManager.h"
#import "ChangePassWordVc.h"
#import "ExchangePasswordVc.h"
#import "GesterPassWordVc.h"
#import "UIColor+Util.h"
#import "AboutCompanyVc.h"
#import "FeedBackVc.h"
#import <SDImageCache.h>
//#import "BankGiftImageView.h"
#import "OSCMotionManager.h"
#import "MBProgressHUD+NetWork.h"
#define TitleArr @[@[@"修改登录密码", @"修改交易密码", @"手势密码",@"修改手势密码",@"摇一摇写反馈"], @[@"清理缓存", @"关于我们", @"意见反馈", @"测试环境"]]
@interface SettingVc ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic, strong) UITableView *myTab;
@property (nonatomic, strong) UISwitch *gesterSwitch;
@property (nonatomic, strong) UISwitch *ShakeSwitch;
@property (nonatomic, strong) UISegmentedControl *testUrlSegment;
@property (nonatomic, strong) UIView *footerView;
@property (nonatomic, strong) UserModel *model;
@end

@implementation SettingVc

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor blackColor];

    [self setNavBlackColor];
    self.title  = @"设置";
    self.myTab = [[UITableView alloc]initWithFrame:CGRectZero style:UITableViewStyleGrouped];
    self.myTab.delegate = self;
    self.myTab.dataSource = self;
    self.myTab.estimatedSectionHeaderHeight = 0;
    self.myTab.estimatedSectionFooterHeight = 0;
    self.myTab.sectionFooterHeight = ChangedHeight(4);
    self.myTab.rowHeight = ChangedHeight(46);
//    [self.myTab registerClass:[UITableViewCell class] forCellReuseIdentifier:@"userCell"];
    self.myTab.tableFooterView = self.footerView;
    [self.view addSubview:self.self.myTab];
    [self.myTab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
    
    self.gesterSwitch = [[UISwitch alloc]init];
    self.gesterSwitch.tag = 10;
    self.gesterSwitch.onTintColor = [UIColor getOrangeColor];
    [self.gesterSwitch addTarget:self action:@selector(switchChange:) forControlEvents:UIControlEventValueChanged];
    self.model = [UserManager shareManager].user;
    
    self.ShakeSwitch = [[UISwitch alloc]init];
    self.ShakeSwitch.tag = 20;
    self.ShakeSwitch.onTintColor = [UIColor getOrangeColor];
    [self.ShakeSwitch addTarget:self action:@selector(switchChange:) forControlEvents:UIControlEventValueChanged];
    if (istext) {
        self.testUrlSegment = [[UISegmentedControl alloc]initWithItems:@[@"生产",@"develop",@"master"]];
        if (![[NSUserDefaults standardUserDefaults] valueForKey:@"testUrl"]) {
            self.testUrlSegment.selectedSegmentIndex = 0;
        }else if ([[[NSUserDefaults standardUserDefaults] valueForKey:@"testUrl"] isEqualToString:@"develop"]){
            self.testUrlSegment.selectedSegmentIndex = 1;
        }else if ([[[NSUserDefaults standardUserDefaults] valueForKey:@"testUrl"] isEqualToString:@"master"]){
            self.testUrlSegment.selectedSegmentIndex = 2;
        }else{
            self.testUrlSegment.selectedSegmentIndex = 3;
        }
        self.testUrlSegment.tintColor = [UIColor getOrangeColor];
        [self.testUrlSegment addTarget:self action:@selector(testUrlChanged:) forControlEvents:UIControlEventValueChanged];
    }
}

- (void)testUrlChanged:(UISegmentedControl *)sender{
    switch (sender.selectedSegmentIndex) {
        case 0:
            [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"testUrl"];
            break;
        case 1:
            [[NSUserDefaults standardUserDefaults] setValue:@"develop" forKey:@"testUrl"];
            break;
        case 2:{
            [[NSUserDefaults standardUserDefaults] setValue:@"master" forKey:@"testUrl"];
        }
//            break;
//        default:[[NSUserDefaults standardUserDefaults] setValue:@"preview" forKey:@"testUrl"];
            break;
            
    }
    [[NSUserDefaults standardUserDefaults] synchronize];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return TitleArr.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (istext) {
        return [TitleArr[section] count];
    }
    return section == 1?[TitleArr[section] count]-1:[TitleArr[section] count];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0 && indexPath.row == 3) {
        if (!self.model.hadGester) {
            return 0;
        }
    }
    return ChangedHeight(46);
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return ChangedHeight(5);
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"userCell"];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"userCell"];
        [cell setSeparatorInset:UIEdgeInsetsZero];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        cell.textLabel.textColor = [UIColor getColor:84 G:85 B:86];
        cell.detailTextLabel.textColor = [UIColor newSecondTextColor];
    }
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    
    
    
    cell.textLabel.text = TitleArr[indexPath.section][indexPath.row];
    
    
    if (indexPath.section && indexPath.row == 0) {
        cell.detailTextLabel.text = [NSString stringWithFormat:@"%.2f M",[[SDImageCache sharedImageCache] getSize]/1024/1024.0];
    }
//    if (self.model.hadGester) {
    if (indexPath.row == 2 && indexPath.section == 0) {
        cell.accessoryType = UITableViewCellAccessoryNone;
        [cell.contentView addSubview:self.gesterSwitch];
        [self.gesterSwitch setOn:self.model.gesterOn];
        [self.gesterSwitch mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(cell.contentView);
            make.right.equalTo(cell.contentView).offset(ChangedHeight(- 8));
            make.height.mas_equalTo(ChangedHeight(23));
            make.width.mas_equalTo(ChangedHeight(40));
        }];
    }
    if (indexPath.row == 4 && indexPath.section == 0) {
        cell.accessoryType = UITableViewCellAccessoryNone;
        [cell.contentView addSubview:self.ShakeSwitch];
        [self.ShakeSwitch setOn:[self.model.shake_status integerValue] == 1];
        [self.ShakeSwitch mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(cell.contentView);
            make.right.equalTo(cell.contentView).offset(ChangedHeight(- 8));
            make.height.mas_equalTo(ChangedHeight(23));
            make.width.mas_equalTo(ChangedHeight(40));
        }];
    }
    
    if (indexPath.row == 3 && indexPath.section == 1) {
        cell.accessoryType = UITableViewCellAccessoryNone;
        [cell.contentView addSubview:self.testUrlSegment];
//        [self.ShakeSwitch setOn:[self.model.shake_status integerValue] == 1];
        [self.testUrlSegment mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(cell.contentView);
            make.right.equalTo(cell.contentView).offset(ChangedHeight(- 8));
            make.height.mas_equalTo(ChangedHeight(35));
            make.width.mas_equalTo(ChangedHeight(120));
        }];
    }
    if (!self.model.hadGester){
        switch (indexPath.row) {
            case 3:{
                if (indexPath.section == 0) {
                    cell.textLabel.text = @"";
                    cell.accessoryType = UITableViewCellAccessoryNone;
                }
            }
                break;
            default:cell.textLabel.text = TitleArr[indexPath.section][indexPath.row];
                break;
        }
        
    }
    
    
    return cell;
}
- (UIView *)footerView{
    if (!_footerView) {
        _footerView = [UIView new];
        _footerView.height = ChangedHeight(100);
        UIButton *btn = [UIButton new];
        [btn addTarget:self action:@selector(logout) forControlEvents:UIControlEventTouchUpInside];
        [btn setTitle:@"退出登录" forState:UIControlStateNormal];
        btn.titleLabel.font = [UIFont gs_fontNum:15];
        btn.layer.cornerRadius = 4;
        btn.backgroundColor = [UIColor getOrangeColor];
        [_footerView addSubview:btn];
        [btn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(_footerView).insets(UIEdgeInsetsMake(ChangedHeight(35), ChangedHeight(35), ChangedHeight(25), ChangedHeight(30)));
        }];
        
    }
    return _footerView;
}

- (void)logout{
    NSString *postUrl ;
    kAppPostHost(postUrl);
    [NetworkManager startNetworkRequestDataFromRemoteServerByPostMethodWithURLString:[NSString stringWithFormat:@"%@user/logout",postUrl]
          withParameters:@{
                           @"token":[UserManager shareManager].userId
                           }
                 ShowHUD:NO
                 success:^(NSURLSessionDataTask *task, id responseObject) {
                     
                 } failure:^(NSURLSessionDataTask *task, NSError *error) {
                     
                 }];
//    [BPush unbindChannelWithCompleteHandler:^(id result, NSError *error) {
//
//    }];
    [[UserManager shareManager] logoutUsr];
    [[NSNotificationCenter defaultCenter] postNotificationName:UserLogout object:nil];
//    BankGiftImageView *gift = [BankGiftImageView shareManage];
//    [gift.giftImage stopAnimating];
//    gift.hidden = YES;
    
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    switch (indexPath.row) {
        case 0:
        {
            if (indexPath.section == 0) {
                if (![[UserManager shareManager] hasGuanLianTel]) {
                    return;
                }
                ChangePassWordVc *vc= [[ChangePassWordVc alloc]init];
                [self.navigationController pushViewController:vc animated:YES];
            }else{
                dispatch_async(dispatch_get_main_queue(), ^{
                    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:nil message:@"确定要清除缓存的图片和文件？" preferredStyle:UIAlertControllerStyleAlert];
                    [alertController addAction:[UIAlertAction actionWithTitle:@"取消"
                        style:UIAlertActionStyleCancel
                      handler:^(UIAlertAction * _Nonnull action) {
                          return;
                      }]];

                    [alertController addAction:[UIAlertAction actionWithTitle:@"确定"
                                    style:UIAlertActionStyleDefault
                                  handler:^(UIAlertAction * _Nonnull action) {
                                      [[NSURLCache sharedURLCache] removeAllCachedResponses];
                                      [[SDImageCache sharedImageCache] clearMemory];
                                      [[SDImageCache sharedImageCache] clearDisk];
                                      [[[YYImageCache sharedCache] diskCache] removeAllObjects];
                                      [[[YYImageCache sharedCache] memoryCache] removeAllObjects];
                                      [self cleanCacheAndCookie];
                                      [self.myTab reloadRow:2 inSection:1 withRowAnimation:UITableViewRowAnimationNone];
                          
                      }]];
                    [self presentViewController:alertController animated:YES completion:nil];
                });
//                AboutCompanyVc *vc = [[AboutCompanyVc alloc]init];
////                UIViewController *vc = [[NSClassFromString(@"OSCRewardViewController") alloc]init];
//                [self.navigationController pushViewController:vc animated:YES];
            }
        }
            break;
        case 1:
        {
            if (indexPath.section == 0) {
                
                if (![[UserManager shareManager] canExtractMoney]) {
                    return;
                }
                ExchangePasswordVc *vc = [[ExchangePasswordVc alloc]init];
                [self.navigationController pushViewController:vc animated:YES];
            }else{
                AboutCompanyVc *vc = [[AboutCompanyVc alloc]init];
                //                UIViewController *vc = [[NSClassFromString(@"OSCRewardViewController") alloc]init];
                [self.navigationController pushViewController:vc animated:YES];
                
            }
        }
            break;
        case 2:
        {
            if (indexPath.section) {
                FeedBackVc *vc = [[FeedBackVc alloc]init];
//                vc.shakeImage = [UIImage imageNamed:@"FindHead"];
                [self.navigationController pushViewController:vc animated:YES];
                
                return;
            }
            
        }
            break;
        case 3:
        {
            GesterPassWordVc *vc = [[GesterPassWordVc alloc]init];
            vc.circleType = CircleViewTypeVerify;
            vc.title = @"修改手势密码";
            [self.navigationController pushViewController:vc animated:YES];
//            __weak typeof(self) weakMine = self;
//            vc.gesterSuccessBlock = ^{
//                weakMine.model = [UserManager shareManager].user;
//                [weakMine.myTab reloadSection:0 withRowAnimation:UITableViewRowAnimationNone];
//            };
        }
            break;
        case 4:
        {
//            UIViewController *vc = [[NSClassFromString(@"OSCRewardViewController") alloc]init];
//            [self.navigationController pushViewController:vc animated:YES];
        }
            break;
        default:
            break;
    }
}


- (void)switchChange:(UISwitch *)sender{
    if (sender.tag == 20) {
        NSString *postUrl ;
        kAppPostHost(postUrl);
//        self.model.shake_status = sender.isOn? @"1" : @"0";
        [NetworkManager startNetworkRequestDataFromRemoteServerByPostMethodWithURLString:[NSString stringWithFormat:@"%@user/shakeChange",postUrl]
              withParameters:@{
                               @"shake_status":sender.isOn? @"1" : @"0",//    摇一摇状态    string    0关闭，1开启
                               @"token":[UserManager shareManager].userId//    用户token    string
                               }
                     ShowHUD:YES
                     success:^(NSURLSessionDataTask *task, id responseObject) {
                         dispatch_async(dispatch_get_main_queue(), ^{
                             [MBProgressHUD showSuccess:responseObject[@"message"]];
                             if ([responseObject[@"data"] isKindOfClass:[NSDictionary class]]) {
                                 self.model.shake_status = responseObject[@"data"][@"shake_status"];
                             }else
                                 self.model.shake_status = sender.isOn? @"1" : @"0";
                             [[UserManager shareManager] saveUserModel:self.model];
                             [OSCMotionManager shareMotionManager].isShaking = NO;
                             [OSCMotionManager shareMotionManager].canShake = [[UserManager shareManager].user.shake_status integerValue] == 1;
                         });
                     } failure:^(NSURLSessionDataTask *task, NSError *error) {
                         [sender setOn:!sender.isOn];
                     }];
        
        return;
    }
    if (self.model.gesterOn == sender.isOn) {
        return;
    }
    if (!sender.isOn) {
        GesterPassWordVc *vc = [[GesterPassWordVc alloc]init];
        vc.circleType = CircleViewTypeLogin;
        vc.title = @"验证手势密码";
        [self.navigationController pushViewController:vc animated:YES];
        __weak typeof(self) weakMine = self;
        vc.gesterSuccessBlock = ^{
            weakMine.model = [UserManager shareManager].user;
            weakMine.model.hadGester = NO;
            weakMine.model.gesterOn = NO;
            [[UserManager shareManager] saveUserModel:weakMine.model];
            [weakMine.myTab reloadSection:0 withRowAnimation:UITableViewRowAnimationNone];
        };
    }else{
        if (self.model.hadGester) {
            return;
        }
        GesterPassWordVc *vc = [[GesterPassWordVc alloc]init];
        vc.circleType = CircleViewTypeSetting;
        vc.title = @"设置手势密码";
        [self.navigationController pushViewController:vc animated:YES];
        __weak typeof(self) weakMine = self;
        vc.gesterSuccessBlock = ^{
            weakMine.model = [UserManager shareManager].user;
            [weakMine.gesterSwitch setOn:weakMine.model.gesterOn];
            [weakMine.myTab reloadSection:0 withRowAnimation:UITableViewRowAnimationNone];
        };
    }
    [sender setOn: self.model.gesterOn];
//    self.model.gesterOn = sender.isOn;
//    [[UserManager shareManager] saveUserModel:self.model];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/**清除缓存和cookie*/
- (void)cleanCacheAndCookie{
    //清除cookies
    NSHTTPCookie *cookie;
    NSHTTPCookieStorage *storage = [NSHTTPCookieStorage sharedHTTPCookieStorage];
    for (cookie in [storage cookies]){
        [storage deleteCookie:cookie];
    }
    //清除UIWebView的缓存
    [[NSURLCache sharedURLCache] removeAllCachedResponses];
    NSURLCache * cache = [NSURLCache sharedURLCache];
    [cache removeAllCachedResponses];
    [cache setDiskCapacity:0];
    [cache setMemoryCapacity:0];
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
