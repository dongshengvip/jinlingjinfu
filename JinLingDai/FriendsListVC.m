//
//  FriendsListVC.m
//  JinLingDai
//
//  Created by 001 on 2017/8/21.
//  Copyright © 2017年 JLD. All rights reserved.
//

#import "FriendsListVC.h"
#import "FriendsCell.h"
#import <MJRefresh.h>
#import <YYKit.h>
#import "NoMoreDataView.h"
@interface FriendsListVC ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic, strong) UITableView *myTab;
@property (nonatomic, strong) NSMutableArray *friendsArr;
@property (nonatomic, assign) NSInteger pageNo;
@end

@implementation FriendsListVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor infosBackViewColor];
    [self setNavBlackColor];
    self.title = @"邀请记录";
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.myTab = [[UITableView alloc]initWithFrame:CGRectZero style:UITableViewStylePlain];
    self.myTab.backgroundColor = [UIColor infosBackViewColor];
    self.myTab.delegate = self;
    self.myTab.dataSource = self;
    self.myTab.separatorColor = [UIColor clearColor];
    self.myTab.rowHeight = ChangedHeight(90);
    [self.myTab registerClass:[FriendsCell class] forCellReuseIdentifier:@"FriendsCell"];
    [self.view addSubview:self.myTab];
    [self.myTab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view).insets(UIEdgeInsetsMake(StatusBarHeight + 44, 0, 0, 0));
    }];
    self.myTab.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [self.friendsArr removeAllObjects];
        self.pageNo = 0;
        [self loadData];
    }];
    MJRefreshBackNormalFooter *mjFooter = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        [self loadData];
    }];
    [mjFooter setTitle:@"" forState:MJRefreshStateNoMoreData];
    self.myTab.mj_footer = mjFooter;
    self.friendsArr = [[NSMutableArray alloc] init];
    [self loadData];
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.friendsArr.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    FriendsCell *cell = [tableView dequeueReusableCellWithIdentifier:@"FriendsCell"];
    if (indexPath.row < self.friendsArr.count) {
       [cell setContenView:self.friendsArr[indexPath.row]];
    }
    
    return cell;
}

- (void)loadData{
    if ([UserManager shareManager].userId.length == 0) {
        return;
    }
    NSString *postUrl ;
    kAppPostHost(postUrl);
    self.pageNo ++;
    [NetworkManager startNetworkRequestDataFromRemoteServerByPostMethodWithURLString:[NSString stringWithFormat:@"%@user/inviteReward",postUrl]
          withParameters:@{
                           @"limit":@"10",
                           @"page":@(self.pageNo),
                           @"token":[UserManager shareManager].userId
                           }
                 ShowHUD:YES
                 success:^(NSURLSessionDataTask *task, id responseObject) {
                     [self.myTab.mj_header endRefreshing];
                     [self.myTab.mj_footer endRefreshing];
                     if ([responseObject[@"status"] integerValue] == 200) {
                         dispatch_async(dispatch_get_main_queue(), ^{
                             if ([responseObject[@"data"] isKindOfClass:[NSDictionary class]]) {
                                 if ([responseObject[@"data"][@"totalpage"] integerValue] <=self.pageNo) {
                                     [self.myTab.mj_footer endRefreshingWithNoMoreData];
                                     NoMoreDataView *nomoreFooter = [NoMoreDataView new];
                                     [nomoreFooter setTipText:@"已经全部加载完成"];
                                     self.myTab.tableFooterView = nomoreFooter;
                                 }else{
                                     self.myTab.tableFooterView = [UIView new];
                                 }
                                 
                                 NSArray *arr = [NSArray modelArrayWithClass:[FriendsinfoModel class] json:responseObject[@"data"][@"friendsinfo"]];
                                 [self.friendsArr addObjectsFromArray:arr];
                             }
                             
                             [self.myTab reloadData];
                         });
                     }
                 } failure:^(NSURLSessionDataTask *task, NSError *error) {
                     [self.myTab.mj_header endRefreshing];
                     [self.myTab.mj_footer endRefreshing];
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
