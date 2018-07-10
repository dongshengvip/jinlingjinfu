//
//  MineVc.m
//  JinLingDai
//
//  Created by 001 on 2017/6/27.
//  Copyright © 2017年 JLD. All rights reserved.
//

#import "MineVc.h"
#import "UserInfoView.h"
#import "SettingVc.h"
#import "UserInfoVc.h"
#import <YYKit.h>
#import "LogingVc.h"
#import "MessageVc.h"
#import "RechargeVc.h"
#import "ExtractVc.h"
#import "MessageModel.h"
#import "MBProgressHUD+NetWork.h"
#import "UIImage+Comment.h"
#import "MyCapitalVc.h"
#import "NetworkManager.h"
#import <MJRefresh.h>
//#import "UINavigationBar+BackgroundColor.h"
#define TitleArr @[@[@"定期项目", @"账户流水", @"资金统计", @"我的奖励"], @[@"设置", @"客服电话", @"客服QQ"]]
#define CellVcArr @[@[@"DingQiXiangMuVc", @"RunningWaterVc", @"ZiJinTongJiVc", @"MyIncentiveVc"], @[@"SettingVc", @"联系客服",@""]]
@interface MineVc ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic, strong) UITableView    *myTab;
@property (nonatomic, strong) UserInfoView   *userView;
@property (nonatomic, strong) UserModel      *userModel;
@property (nonatomic, strong) UserMoneyModel *userMoney;
//@property (nonatomic, assign) BOOL isAnimat;
@end

@implementation MineVc

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor blackColor];
    [self setNavBlackColor];
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.userView = [UserInfoView new];
    self.userView.height = ChangedHeight(215);
    //message
    __weak typeof(self) weakMine = self;
    self.userView.messageClickedBlock = ^{
        if (!weakMine.userModel) {
            [weakMine LoginUser];
            return ;
        }
        MessageVc *vc = [[MessageVc alloc]init];
        vc.hidesBottomBarWhenPushed = YES;
        vc.statues = @"1";
        vc.title = @"消息通知";
        [vc setRightNavBarBtn];
        weakMine.isAnimat = YES;
        [weakMine.navigationController pushViewController:vc animated:YES];
    };

    //充值
    self.userView.rechargeBtnClickedBlock = ^{
        if (!weakMine.userModel) {
            [weakMine LoginUser];
            return ;
        }
        if (![[UserManager shareManager] canExtractMoney]) {
            return;
        }
        
        
        RechargeVc *vc = [[RechargeVc alloc]init];
        vc.hidesBottomBarWhenPushed = YES;
        weakMine.isAnimat = YES;
        [weakMine.navigationController pushViewController:vc animated:YES];
    };
    //提现
    self.userView.extractBtnClickedBlock = ^{
        if (!weakMine.userModel) {
            [weakMine LoginUser];
            return ;
        }
        if (![[UserManager shareManager] canExtractMoney]) {
            return;
        }
        
        if (![[UserManager shareManager] canExtractMoney]) {
            return;
        }
        
        ExtractVc *vc = [[ExtractVc alloc]init];
        vc.hidesBottomBarWhenPushed = YES;
        weakMine.isAnimat = YES;
        [weakMine.navigationController pushViewController:vc animated:YES];
    };
    //点击头像
    self.userView.userHeadClickedBlock = ^{
        if (!weakMine.userModel) {
            [weakMine LoginUser];
            return ;
        }
        UserInfoVc *vc = [[UserInfoVc alloc]init];
        vc.hidesBottomBarWhenPushed = YES;
        weakMine.isAnimat = YES;
        weakMine.isAnimat = YES;
        [weakMine.navigationController pushViewController:vc animated:YES];
    };
    self.myTab = [[UITableView alloc]initWithFrame:CGRectZero style:UITableViewStyleGrouped];
    self.myTab.tableHeaderView = self.userView;
    self.myTab.delegate = self;
    self.myTab.dataSource = self;
    self.myTab.estimatedSectionHeaderHeight = 0;
    self.myTab.estimatedSectionFooterHeight = 0;
    self.myTab.sectionFooterHeight = 0.1;
    self.myTab.rowHeight = ChangedHeight(48);
    [self.myTab registerClass:[UITableViewCell class] forCellReuseIdentifier:@"userCell"];
    
    [self.view addSubview:self.self.myTab];
    [self.myTab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view).insets(UIEdgeInsetsMake(StatusBarHeight, 0, 0, 0));
    }];
    
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(userHadLogOut) name:UserLogout object:nil];
    
}

- (MJRefreshGifHeader *)getGiftHead{
    MJRefreshGifHeader *giftHead = [MJRefreshGifHeader headerWithRefreshingBlock:^{
        [self loadUserMoney];
    }];
    NSMutableArray *giftArr = [NSMutableArray array];
    for (NSInteger i = 0; i < 16; i ++) {
        [giftArr addObject:[UIImage imageNamed:[NSString stringWithFormat:@"gift-%@",@(i)]]];
    }
    giftHead.stateLabel.hidden = YES;
    giftHead.lastUpdatedTimeLabel.hidden = YES;
    [giftHead setImages:giftArr duration:0.6f forState:MJRefreshStateRefreshing];
    [giftHead setImages:@[[UIImage imageNamed:@"gift-0"]] forState:MJRefreshStateIdle];//闲置
    [giftHead setImages:@[[UIImage imageNamed:@"gift-15"]] forState:MJRefreshStatePulling];//松开刷新
    return giftHead;
}

- (void)LoginUser{
    LogingVc *vc = [[LogingVc alloc]init];
    UINavigationController *nav = [[UINavigationController alloc]initWithRootViewController:vc];
    [self presentViewController:nav animated:YES completion:nil];

}

- (void)userHadLogOut{
    self.userModel = nil;
    [self.userView layoutContent:nil];
    [self.userView layoutMoneyContent:nil];
    [self.myTab.mj_header endRefreshing];
    self.myTab.mj_header = nil;
}

- (void)loadUserMoney{
    NSString *postUrl ;
    kAppPostHost(postUrl);
    dispatch_group_t group = dispatch_group_create();
    dispatch_group_enter(group);
    [NetworkManager startNetworkRequestDataFromRemoteServerByPostMethodWithURLString:[NSString stringWithFormat:@"%@user/fundinfo",postUrl]
      withParameters:@{
                       @"token":[UserManager shareManager].userId
                       }
     ShowHUD:YES
             success:^(NSURLSessionDataTask *task, id responseObject) {
                 dispatch_group_leave(group);
                 if ([responseObject[@"status"] integerValue] == 200) {
                     dispatch_async(dispatch_get_main_queue(), ^{
                         self.userMoney = [UserMoneyModel modelWithDictionary:responseObject[@"data"]];
                         [[UserManager shareManager] saveUserMoney:self.userMoney];
                     });

                 }
             }
             failure:^(NSURLSessionDataTask *task, NSError *error) {
                 dispatch_group_leave(group);
             }];
    dispatch_group_enter(group);
    
    [NetworkManager startNetworkRequestDataFromRemoteServerByPostMethodWithURLString:[NSString stringWithFormat:@"%@user/userinfo",postUrl]
              withParameters:@{
                               @"token":[UserManager shareManager].userId
                               }
     ShowHUD:YES 
                     success:^(NSURLSessionDataTask *task, id responseObject) {
                         dispatch_group_leave(group);
                         if ([responseObject[@"status"] integerValue] == 200) {
                             dispatch_async(dispatch_get_main_queue(), ^{
                                 self.userModel = [UserModel modelWithJSON:responseObject[@"data"]];
                                 [[UserManager shareManager] saveUserModel:self.userModel];
                             });
                             
                         }
                     } failure:^(NSURLSessionDataTask *task, NSError *error) {
                         dispatch_group_leave(group);
                     }];
   
    
    dispatch_group_notify(group, dispatch_get_global_queue(0, 0), ^{
        dispatch_async(dispatch_get_main_queue(), ^{
            [[NSUserDefaults standardUserDefaults] setObject:nil forKey:RefreshUser];
            [self.myTab.mj_header endRefreshing];
            [self.userView layoutContent:self.userModel];
            [self.userView layoutMoneyContent:self.userMoney];
            [[NSUserDefaults standardUserDefaults] setObject:[NSDate date] forKey:UserDate];
        });
        
    });
}
/**
 隐藏导航栏
 
 @param animated v1
 */
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
//    [self.navigationController setNavigationBarHidden:YES animated:self.isAnimat];
//
//    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
    
    self.userModel = [UserManager shareManager].user;
    self.userMoney = [UserManager shareManager].money;
    if (!self.userModel) {
        [self.userView layoutContent:[UserManager shareManager].user];
        [self.userView layoutMoneyContent:nil];
        [self.userView setRedMessageShow:NO];
        self.myTab.mj_header = nil;
        return;
    }else{
        self.myTab.mj_header = [self getGiftHead];
        [self loadNewMessage];
    }
    if (!self.userMoney) {
        [self loadUserMoney];
    }else{
        if ([[NSUserDefaults standardUserDefaults] objectForKey:RefreshUser]) {
            [self loadUserMoney];
        }else{
            [self.userView layoutContent:self.userModel];
            [self.userView layoutMoneyContent:self.userMoney];
        }
        
    }
}


- (void)loadNewMessage{
    NSString *postUrl ;
    kAppPostHost(postUrl);
    [NetworkManager startNetworkRequestDataFromRemoteServerByPostMethodWithURLString:[NSString stringWithFormat:@"%@user/innermsg",postUrl]
      withParameters:@{
                       @"limit":@"1",//	查询个数	string
                       @"page":@"1",//	页码	string
                       @"status":@"1",//	状态	string	0全部，1未读，2已读
                       @"token":[UserManager shareManager].userId	//用户id	string
                       }
             ShowHUD:NO
             success:^(NSURLSessionDataTask *task, id responseObject) {
                 if ([responseObject[@"status"] integerValue] == 200) {
                     if ([responseObject[@"data"] isKindOfClass:[NSDictionary class]]) {
                         dispatch_async(dispatch_get_main_queue(), ^{
                             NSArray *arr = [NSArray modelArrayWithClass:[MessageModel class] json:responseObject[@"data"][@"list"]];
                             [self.userView setRedMessageShow:arr.count];
                         });
                     }
                 }
             } failure:^(NSURLSessionDataTask *task, NSError *error) {
                 
             }];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return TitleArr.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [TitleArr[section] count];
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return ChangedHeight(5);
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"userCell"];
    [cell setSeparatorInset:UIEdgeInsetsZero];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    cell.imageView.image = [UIImage imageNamed:TitleArr[indexPath.section][indexPath.row]];
    cell.textLabel.text = TitleArr[indexPath.section][indexPath.row];
    cell.textLabel.textColor = [UIColor getColor:81 G:82 B:83];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
//    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.section == 0 ||(indexPath.section == 1&& indexPath.row == 0)) {
        if (!self.userModel) {
            [self LoginUser];
            return;
        }
        UIViewController *vc = [[NSClassFromString(CellVcArr[indexPath.section][indexPath.row]) alloc] init];
        vc.hidesBottomBarWhenPushed = YES;
        self.isAnimat = YES;
        [self.navigationController pushViewController:vc animated:YES];
    }
    
    if (indexPath.section == 1) {
        if (indexPath.row == 1) {
            dispatch_async(dispatch_get_main_queue(), ^{
                UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"客服电话" message:@"电话：400-889-7650" preferredStyle:UIAlertControllerStyleAlert];
                [alert addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil]];
                [alert addAction:[UIAlertAction actionWithTitle:@"拨打" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                    NSMutableString *str=[[NSMutableString alloc] initWithFormat:@"tel:%@",@"4008897650"];
                    UIWebView *callWebview = [[UIWebView alloc] init];
                    [callWebview loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:str]]];
                    [self.view addSubview:callWebview];
                    
                }]];
                [self presentViewController:alert animated:YES completion:nil];
            });
            
        }else if (indexPath.row == 2){
            dispatch_async(dispatch_get_main_queue(), ^{
                UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"客服QQ" message:@"QQ号：2730407005" preferredStyle:UIAlertControllerStyleAlert];
                [alert addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil]];
                [alert addAction:[UIAlertAction actionWithTitle:@"联系" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                    NSString *SM910QQSERVICE = @"2730407005";
                    NSString *qq=[NSString stringWithFormat:@"mqq://im/chat?chat_type=wpa&uin=%@&version=1&src_type=web",SM910QQSERVICE];
                    NSURL *url = [NSURL URLWithString:qq];
                    if ([[[UIDevice currentDevice] systemVersion] floatValue] > 10.0) {
                        [[UIApplication sharedApplication] openURL:url options:@{} completionHandler:^(BOOL success) {
                            
                        }];
                    }else
                        [[UIApplication sharedApplication] openURL:url];
                }]];
                [self presentViewController:alert animated:YES completion:nil];
            });
            
        }
    }
}

//- (void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath{
//    
//}
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
