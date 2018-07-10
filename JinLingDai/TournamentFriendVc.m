//
//  TournamentFriendVc.m
//  JinLingDai
//
//  Created by 001 on 2017/8/18.
//  Copyright © 2017年 JLD. All rights reserved.
//

#import "TournamentFriendVc.h"
#import "UpAndDownButton.h"
#import "JLDShareManager.h"
@interface TournamentFriendVc ()
@property (nonatomic, strong) UIScrollView *scroll;
@property (nonatomic, strong) UILabel *FriendsLab;
@property (nonatomic, strong) UILabel *BagLab;
@property (nonatomic, strong) UIView *caverView;
@end

@implementation TournamentFriendVc


- (void)viewDidLoad {
    [super viewDidLoad];
    [self setNavBlackColor];
    self.title = @"邀请好友";
    self.view.backgroundColor = [UIColor infosBackViewColor];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"邀请规则" style:UIBarButtonItemStylePlain target:self action:@selector(showRulesOfAct)];
    self.scroll = [[UIScrollView alloc]init];
    [self.view addSubview:self.scroll];
    [self.scroll mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view).insets(UIEdgeInsetsMake(0, 0, ChangedHeight(70), 0));
    }];
    
    UIImageView *banner = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"邀请Banner"]];
//    banner.backgroundColor = [UIColor whiteColor];
    [self.scroll addSubview:banner];
    [banner mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.equalTo(self.scroll);
        make.width.equalTo(self.view);
        make.height.mas_equalTo(ChangedHeight(157));
    }];
    
    
    UIView *contenBgView = [UIView new];
    contenBgView.backgroundColor = [UIColor whiteColor];
    [self.scroll addSubview:contenBgView];
    [contenBgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.scroll);
        make.top.equalTo(banner.mas_bottom).offset(2);
        make.width.equalTo(self.view);
        make.height.mas_equalTo(ChangedHeight(85));
    }];
    
    UpAndDownButton *friendsBtn = [UpAndDownButton buttonWithType:UIButtonTypeCustom];
    friendsBtn.icon.image = [UIImage imageNamed:@"friends"];
    friendsBtn.titleLab.text = @"邀请记录";
    [friendsBtn addTarget:self action:@selector(showFriendsList) forControlEvents:UIControlEventTouchUpInside];
    [contenBgView addSubview:friendsBtn];
    [friendsBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.bottom.equalTo(contenBgView);
        make.width.equalTo(contenBgView).multipliedBy(0.5).offset(-1);
    }];
    
    self.FriendsLab = [UILabel new];
    self.FriendsLab.textAlignment = NSTextAlignmentCenter;
    self.FriendsLab.textColor = [UIColor getOrangeColor];
    self.FriendsLab.font = [UIFont gs_fontNum:15];
    [friendsBtn addSubview:self.FriendsLab];
    [self.FriendsLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(friendsBtn);
        make.bottom.equalTo(friendsBtn).offset(-ChangedHeight(10));
    }];
    
    
    UpAndDownButton *redBageBtn = [UpAndDownButton buttonWithType:UIButtonTypeCustom];
    redBageBtn.icon.image = [UIImage imageNamed:@"邀请Bag"];
    redBageBtn.titleLab.text = @"红包记录";
    [redBageBtn addTarget:self action:@selector(RedBagOfFirendsVc) forControlEvents:UIControlEventTouchUpInside];
    [contenBgView addSubview:redBageBtn];
    [redBageBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.top.bottom.equalTo(contenBgView);
        make.width.equalTo(contenBgView).multipliedBy(0.5).offset(-1);
    }];
    
    self.BagLab = [UILabel new];
    self.BagLab.textAlignment = NSTextAlignmentCenter;
    self.BagLab.textColor = [UIColor getOrangeColor];
    self.BagLab.font = [UIFont gs_fontNum:15];
    [redBageBtn addSubview:self.BagLab];
    [self.BagLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(redBageBtn);
        make.bottom.equalTo(redBageBtn).offset(-ChangedHeight(10));
    }];
    
    UIView *line = [UIView new];
    line.backgroundColor = [UIColor newSeparatorColor];
    [contenBgView addSubview:line];
    [line mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(contenBgView);
        make.width.mas_equalTo(1);
        make.height.equalTo(contenBgView).offset(ChangedHeight(-35));
    }];
    
    UIImageView *contenImg = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"邀请"]];
    [self.scroll addSubview:contenImg];
    [contenImg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.equalTo(self.scroll);
        make.top.equalTo(contenBgView.mas_bottom).offset(ChangedHeight(15));
        make.height.mas_equalTo(ChangedHeight(190));
    }];
    
    UIButton *btn = [UIButton new];
    [btn addTarget:self action:@selector(showToFriends) forControlEvents:UIControlEventTouchUpInside];
    [btn setTitle:@"立即邀请" forState:UIControlStateNormal];
    btn.titleLabel.font = [UIFont gs_fontNum:15];
    btn.layer.cornerRadius = 4;
    btn.backgroundColor = [UIColor getOrangeColor];
    [self.view addSubview:btn];
    [btn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view).offset(ChangedHeight(35));
        make.right.equalTo(self.view).offset(ChangedHeight(- 35));
        make.centerX.equalTo(self.view);
//        make.top.equalTo(self)
        make.bottom.equalTo(self.view).offset(ChangedHeight(-25));
        make.height.mas_equalTo(ChangedHeight(40));
    }];
    
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    [window addSubview:self.caverView];
    [self.caverView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(window);
    }];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(loadData) name:UserLogin object:nil];
    
//    self.FriendsLab.text = @"6人";
//    self.BagLab.text = @"2人";
    [self loadData];
}

- (void)showToFriends{
    if ([JLDShareManager canShareToFriendds]) {
        ShareModel *model = [[ShareModel alloc] init];
        model.title = @"新手享588元现金红包，全场预期年化12%收益";
        model.logoImage = [UIImage imageNamed:@"LOGO"];
        model.descString = @"金陵金服国企全资控股，安全运营5年，银行存管已对接，供应链金融，值得信赖。注册投资领588红包，和邀请人一起瓜分不限额投资奖金。";
        //        model.resourceUrl = @"";
        NSString *postUrl ;
        kAppPostHost(postUrl);
        if ([UserManager shareManager].user) {
            model.href = [NSString stringWithFormat:@"%@user/register/code/%@",postUrl,[UserManager shareManager].user.code];
            model.isImag = YES;
            [[JLDShareManager shareManager] showShareBoardWithModel:model];
        }else{
            UIAlertController *alert  = [UIAlertController alertControllerWithTitle:@"温馨提示" message:@"未登录分享是无法拿到邀请奖励红包的哦！" preferredStyle:UIAlertControllerStyleAlert];
            [alert addAction:[UIAlertAction actionWithTitle:@"继续分享" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
                model.href = [NSString stringWithFormat:@"%@user/register/code/",postUrl];
                model.isImag = YES;
                [[JLDShareManager shareManager] showShareBoardWithModel:model];
            }]];
            [alert addAction:[UIAlertAction actionWithTitle:@"去登录" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                [self loging];
            }]];
            [self presentViewController:alert animated:YES completion:nil];
        }
        
    }else{
        UIAlertController *warmTip = [UIAlertController alertControllerWithTitle:@"温馨提示" message:@"您还未安装社交软件来分享消息" preferredStyle:UIAlertControllerStyleAlert];
        [warmTip addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil]];
        [self presentViewController:warmTip animated:YES completion:nil];
    }
}

- (void)showFriendsList{
    if ([UserManager shareManager].userId.length == 0) {
        [self loging];
        return;
    }
    UIViewController *vc = [[NSClassFromString(@"FriendsListVC") alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)RedBagOfFirendsVc{
    if ([UserManager shareManager].userId.length == 0) {
        [self loging];
        return;
    }
    UIViewController *vc = [[NSClassFromString(@"MyIncentiveVc") alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)loging{
    UIViewController *vc = [[NSClassFromString(@"LogingVc") alloc]init];
    UINavigationController *nav = [[UINavigationController alloc]initWithRootViewController:vc];
    [self presentViewController:nav animated:YES completion:nil];
}
- (void)showRulesOfAct{
    self.caverView.hidden = !self.caverView.hidden;
}


- (void)loadData{
    if ([UserManager shareManager].userId.length == 0) {
        return;
    }
    NSString *postUrl ;
    kAppPostHost(postUrl);
    [NetworkManager startNetworkRequestDataFromRemoteServerByPostMethodWithURLString:[NSString stringWithFormat:@"%@user/inviteReward",postUrl]
          withParameters:@{
                           @"limit":@"1",
                           @"page":@"1",
                           @"token":[UserManager shareManager].userId
                           }
                 ShowHUD:YES
                 success:^(NSURLSessionDataTask *task, id responseObject) {
                     if ([responseObject[@"status"] integerValue] == 200) {
                         dispatch_async(dispatch_get_main_queue(), ^{
                             if ([responseObject[@"data"] isKindOfClass:[NSDictionary class]]) {
                                 self.FriendsLab.text = [NSString stringWithFormat:@"%@人",responseObject[@"data"][@"friendscount"]];
                                 self.BagLab.text = [NSString stringWithFormat:@"%@个",responseObject[@"data"][@"rewardscount"]];
                             }
                             
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

- (UIView *)caverView {
   if (!_caverView) {
       _caverView = [UIView new];
       _caverView.backgroundColor = [UIColor colorWithHex:0x000000 alpha:0.5];
       _caverView.hidden = YES;
       [_caverView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(showRulesOfAct)]]; 
       UIImageView *rules = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"邀请rules"]];
       [_caverView addSubview:rules];
       [rules mas_makeConstraints:^(MASConstraintMaker *make) {
           make.center.equalTo(_caverView);
       }];
   }
   return _caverView;
}

@end
