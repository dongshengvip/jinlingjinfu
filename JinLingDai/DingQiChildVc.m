//
//  DingQiChildVc.m
//  JinLingDai
//
//  Created by 001 on 2017/7/12.
//  Copyright © 2017年 JLD. All rights reserved.
//

#import "DingQiChildVc.h"
#import "XiangMuCell.h"
#import <MJRefresh.h>
#import "TouZiModel.h"
#import "NoMoreDataView.h"
#import "XiangMuDetailVc.h"
#import <YYKit.h>
@interface DingQiChildVc ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic, strong) UITableView *myTab;
@property (nonatomic, strong) NSMutableArray *dataArr;
@property (nonatomic, assign) NSInteger pageNo;
@end

@implementation DingQiChildVc

- (void)viewDidLoad {
    [super viewDidLoad];
    self.myTab = [[UITableView alloc]initWithFrame:CGRectZero style:UITableViewStylePlain];
    self.myTab.backgroundColor = [UIColor infosBackViewColor];
    self.myTab.delegate = self;
    self.myTab.dataSource = self;
    self.myTab.separatorColor = [UIColor clearColor];
    self.myTab.rowHeight = ChangedHeight(145);
    if (@available (iOS 11.0, *)) {
        self.myTab.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentAutomatic;
    }
    [self.myTab registerClass:[XiangMuCell class] forCellReuseIdentifier:@"XiangMuCell"];
    [self.view addSubview:self.self.myTab];
    [self.myTab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
//        make.top.equalTo(self.view)
    }];
    
    self.myTab.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        self.pageNo = 0;
        [self.dataArr removeAllObjects];
//        [self.myTab.mj_footer resetNoMoreData];
        //后面须臾奥放在返回数据里面
//        NoMoreDataView *footer = [NoMoreDataView new];
//        [footer setTipText:@"没有更多了"];
        self.myTab.tableFooterView = [UIView new];
        [self loadDingQiData:self.status];
    }];
    MJRefreshBackNormalFooter *mjFooter = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        //        self.pageNo ++;
        [self loadDingQiData:self.status];
    }];
    mjFooter.ignoredScrollViewContentInsetBottom = 40;
    [mjFooter  setTitle:@"" forState:MJRefreshStateNoMoreData];
    self.myTab.mj_footer = mjFooter;
    self.dataArr = [[NSMutableArray alloc]init];
    
}

//2=>融资中，6=>还款中，7=>已还款，非必需
- (void)loadDingQiData:(NSString *)status{
    if (!self.status) {
        self.status = status;
    }
    self.pageNo ++;
    NSString *postUrl ;
    kAppPostHost(postUrl);
    [NetworkManager startNetworkRequestDataFromRemoteServerByPostMethodWithURLString:[NSString stringWithFormat:@"%@user/investlist",postUrl]
      withParameters:@{
                       @"limit":@(10),	//查询个数	number	非必需
                       @"page":	@(self.pageNo),//页码	number	非必需
                       @"status":status,	//状态类型	number	2=>融资中，6=>还款中，7=>已还款，非必需
                       @"token":[UserManager shareManager].userId	//用户id	number
                       }
     ShowHUD:YES 
             success:^(NSURLSessionDataTask *task, id responseObject) {
                 [self.myTab.mj_header endRefreshing];
                 [self.myTab.mj_footer endRefreshing];
                 if ([responseObject[@"status"] integerValue] == 200) {
                     dispatch_async(dispatch_get_main_queue(), ^{
                         if (responseObject[@"data"] && [responseObject[@"data"] isKindOfClass:[NSDictionary class]]) {
                             if ([responseObject[@"data"][@"totalpage"] integerValue] <= self.pageNo) {
//                                 dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.f * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                                     [self.myTab.mj_footer endRefreshingWithNoMoreData];
//                                 });
                                 //后面须臾奥放在返回数据里面
                                 NoMoreDataView *footer = [NoMoreDataView new];
                                 [footer setTipText:@"没有更多了"];
                                 self.myTab.tableFooterView = footer;
                             }
                             NSArray *arr = [NSArray modelArrayWithClass:[TouZiModel class] json:responseObject[@"data"][@"list"]];
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
    XiangMuCell *cell = [tableView dequeueReusableCellWithIdentifier:@"XiangMuCell"];
    if (indexPath.row < self.dataArr.count) {
        [cell setConten:self.dataArr[indexPath.row]];
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    XiangMuDetailVc *vc =[[XiangMuDetailVc alloc]init];
    vc.model = self.dataArr[indexPath.row];
    [self.navigationController pushViewController:vc animated:YES];
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
