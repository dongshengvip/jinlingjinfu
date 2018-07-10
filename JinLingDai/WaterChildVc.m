//
//  WaterChildVc.m
//  JinLingDai
//
//  Created by 001 on 2017/7/12.
//  Copyright © 2017年 JLD. All rights reserved.
//

#import "WaterChildVc.h"
#import "WaterBillCell.h"
#import <MJRefresh.h>
#import "WaterModel.h"
#import "NoMoreDataView.h"
#import <YYKit.h>
@interface WaterChildVc ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic, strong) UITableView *myTab;
@property (nonatomic, strong) NSMutableArray *dataArr;
@property (nonatomic, assign) NSInteger pageNo;
@property (nonatomic, assign) NSString *type;
@end

@implementation WaterChildVc

- (void)viewDidLoad {
    [super viewDidLoad];
    self.myTab = [[UITableView alloc]initWithFrame:CGRectZero style:UITableViewStylePlain];
    self.myTab.backgroundColor = [UIColor infosBackViewColor];
    self.myTab.delegate = self;
    self.myTab.dataSource = self;
    self.myTab.separatorColor = [UIColor clearColor];
    self.myTab.rowHeight = ChangedHeight(150);
    if (@available (iOS 11.0, *)) {
        self.myTab.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentAutomatic;
    }
    [self.myTab registerClass:[WaterBillCell class] forCellReuseIdentifier:@"WaterBillCell"];
    [self.view addSubview:self.self.myTab];
    [self.myTab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
    
    self.myTab.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        self.pageNo = 0;
        [self.dataArr removeAllObjects];
        [self loadRunningBill:self.type];
    }];
    MJRefreshBackNormalFooter *mjFooter = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        //        self.pageNo ++;
        [self loadRunningBill:self.type];
    }];
    mjFooter.ignoredScrollViewContentInsetBottom = 30;
    [mjFooter setTitle:@"" forState:MJRefreshStateNoMoreData];
    self.myTab.mj_footer = mjFooter;
    self.dataArr = [[NSMutableArray alloc] init];
}
//0=>全部，1=》充值，2=》提现，3=》出借，4=》回款，5=》冻结
- (void)loadRunningBill:(NSString *)type{
    if (!self.type) {
        self.type = type;
    }
    self.pageNo ++;
    NSString *postUrl ;
    kAppPostHost(postUrl);
    [NetworkManager startNetworkRequestDataFromRemoteServerByPostMethodWithURLString:[NSString stringWithFormat:@"%@user/tradelog",postUrl]
          withParameters:@{
                           @"limit":@"10",//	查询个数	number	默认为5，非必需
                           @"page":@(self.pageNo),//	页码	number	默认为1，非必需
                           @"type":type,//	类型	number	0=>全部，1=》充值，2=》提现，3=》出借，4=》回款，5=》冻结
                           @"token":[UserManager shareManager].userId //	用户ID	number
                           }
     ShowHUD:YES 
                 success:^(NSURLSessionDataTask *task, id responseObject) {
                     [self.myTab.mj_header endRefreshing];
                     [self.myTab.mj_footer endRefreshing];
                     if ([responseObject[@"status"] integerValue] == 200) {
                         dispatch_async(dispatch_get_main_queue(), ^{
                             if ([responseObject[@"data"] isKindOfClass:[NSDictionary class]]) {
                                 if ([responseObject[@"data"][@"totalpage"] integerValue] <= self.pageNo) {
//                                     dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.f * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                                         [self.myTab.mj_footer endRefreshingWithNoMoreData];
//                                     });
                                     NoMoreDataView *nomoreFooter = [NoMoreDataView new];
                                     [nomoreFooter setTipText:@"已经全部加载完毕"];
                                     self.myTab.tableFooterView = nomoreFooter;
                                 }else{
                                     self.myTab.tableFooterView = [UIView new];
                                 }
                                 NSArray *arr = [NSArray modelArrayWithClass:[WaterModel class] json:responseObject[@"data"][@"list"]];
                                 if (arr) {
                                     [self.dataArr addObjectsFromArray:arr];
                                 }
                                 [self.myTab reloadData];
                             }
                         });
                     }
                 } failure:^(NSURLSessionDataTask *task, NSError *error) {
                     [self.myTab.mj_header endRefreshing];
                     [self.myTab.mj_footer endRefreshing];
                 }];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataArr.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    WaterBillCell *cell = [tableView dequeueReusableCellWithIdentifier:@"WaterBillCell"];
    if (self.dataArr.count > indexPath.row) {
        [cell setConten:self.dataArr[indexPath.row]];
    }
    
    return cell;
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
