//
//  RedBagOfFirendsVc.m
//  JinLingDai
//
//  Created by 001 on 2017/8/21.
//  Copyright © 2017年 JLD. All rights reserved.
//

#import "RedBagOfFirendsVc.h"
#import "RedBagOfFriendsCell.h"
#import "NoMoreDataView.h"
#import <MJRefresh.h>
#import <YYKit.h>
@interface RedBagOfFirendsVc ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic, strong) UITableView *myTab;
@property (nonatomic, strong) NSMutableArray *redArr;
@property (nonatomic, assign) NSInteger pageNo;
@end

@implementation RedBagOfFirendsVc

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor infosBackViewColor];
    [self setNavBlackColor];
    self.title = @"邀请记录";
//    self.automaticallyAdjustsScrollViewInsets = NO;
    self.myTab = [[UITableView alloc]initWithFrame:CGRectZero style:UITableViewStylePlain];
    self.myTab.backgroundColor = [UIColor infosBackViewColor];
    self.myTab.delegate = self;
    self.myTab.dataSource = self;
    if (@available (iOS 11.0, *)) {
        self.myTab.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentAutomatic;
    }
    self.myTab.separatorColor = [UIColor clearColor];
    self.myTab.rowHeight = ChangedHeight(125);
    [self.myTab registerClass:[RedBagOfFriendsCell class] forCellReuseIdentifier:@"RedBagOfFriendsCell"];
    [self.view addSubview:self.myTab];
    [self.myTab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
    
    self.redArr = [[NSMutableArray alloc] init];
    [self loadData];
    
    self.myTab.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [self.redArr removeAllObjects];
        self.pageNo = 0;
        [self loadData];
    }];
    MJRefreshBackNormalFooter *mjFooter = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        [self loadData];
    }];
    mjFooter.ignoredScrollViewContentInsetBottom = 30;
    [mjFooter setTitle:@"" forState:MJRefreshStateNoMoreData];
    self.myTab.mj_footer = mjFooter;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.redArr.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    RedBagOfFriendsCell *cell = [tableView dequeueReusableCellWithIdentifier:@"RedBagOfFriendsCell"];
    if (indexPath.row < self.redArr.count) [cell setContentView:self.redArr[indexPath.row]];
    return cell;
}

- (void)loadData{
    self.pageNo ++;
    NSString *postUrl ;
    kAppPostHost(postUrl);
    [NetworkManager startNetworkRequestDataFromRemoteServerByPostMethodWithURLString:[NSString stringWithFormat:@"%@reward/inviteRewardDetail",postUrl]
      withParameters:@{
                       @"limit":@"10",//	查询数量	number	可选
                       @"page":@(self.pageNo),//	页码	number	可选
                       @"token":[UserManager shareManager].userId//	用户token	string
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
                             
                             NSArray *arr = [NSArray modelArrayWithClass:[YaoQingBagModel class] json:responseObject[@"data"][@"rewardinfo"]];
                             [self.redArr addObjectsFromArray:arr];
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
