//
//  AnnouceVc.m
//  JinLingDai
//
//  Created by 001 on 2017/8/15.
//  Copyright © 2017年 JLD. All rights reserved.
//

#import "AnnouceVc.h"
#import "AnnouceCell.h"
#import "NetworkManager.h"
#import <MJRefresh.h>
#import "NoMoreDataView.h"
#import <YYKit.h>
#import "HTMLVC.h"
#import "TableViewAnimationKit.h"
#import "UITableView+XSAnimationKit.h"
@interface AnnouceVc ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic, strong) UITableView *myTab;
@property (nonatomic, strong) NSMutableArray *dataArr;
@property (nonatomic, assign) NSInteger pageNo;
@end

@implementation AnnouceVc

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setNavBlackColor];
    self.title = @"平台公告";
    self.myTab.backgroundColor = [UIColor infosBackViewColor];
    self.automaticallyAdjustsScrollViewInsets = NO;
    [self.view addSubview:self.myTab];
    [self.myTab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view).insets(UIEdgeInsetsMake(StatusBarHeight + 44, 0, 0, 0));
    }];
    self.dataArr = [NSMutableArray array];

    [self loadMoreData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)loadMoreData{
    self.pageNo ++;
    NSString *postUrl ;
    kAppPostHost(postUrl);
    [NetworkManager startNetworkRequestDataFromRemoteServerByPostMethodWithURLString:[NSString stringWithFormat:@"%@annouce/lists",postUrl]
          withParameters:@{
                           @"page":@(self.pageNo),
                           @"limit":@"10"
                           }
                 ShowHUD:YES
                 success:^(NSURLSessionDataTask *task, id responseObject) {
                     if ([responseObject[@"status"] integerValue] == 200) {
                         dispatch_async(dispatch_get_main_queue(), ^{
                             [self.myTab.mj_header endRefreshing];
                             [self.myTab.mj_footer endRefreshing];
                             
                             if ([responseObject[@"data"] isKindOfClass:[NSDictionary class]]) {
                                 if ([responseObject[@"data"][@"totalpage"] integerValue] <= self.pageNo) {
                                     [self.myTab.mj_footer endRefreshingWithNoMoreData];
                                     self.myTab.tableFooterView = [NoMoreDataView new];
                                 }
                                 NSArray *arr = [NSArray modelArrayWithClass:[AnnouceModel class] json:responseObject[@"data"][@"list"]];
                                 if (arr) {
                                     [self.dataArr addObjectsFromArray:arr];
                                     
                                 }
                                 [self.myTab reloadData];
                                 if (self.pageNo == 1) {
                                     [self starAnimationWithTableView:self.myTab];
                                 }
                             }
                         });
                     }
                 } failure:^(NSURLSessionDataTask *task, NSError *error) {
                     [self.myTab.mj_header endRefreshing];
                     [self.myTab.mj_footer endRefreshing];
                 }];
}

- (UITableView *)myTab {
   if (!_myTab) {
       _myTab = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
       _myTab.separatorColor = [UIColor clearColor];
       _myTab.rowHeight = ChangedHeight(75);
       _myTab.delegate = self;
       _myTab.dataSource = self;
       [_myTab registerClass:[AnnouceCell class] forCellReuseIdentifier:@"AnnouceCell"];
       _myTab.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
           [self.dataArr removeAllObjects];
           self.pageNo =0;
           [self loadMoreData];
       }];
       
       MJRefreshBackNormalFooter *mjFooter = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
           [self loadMoreData];
       }];
       [mjFooter setTitle:@"" forState:MJRefreshStateNoMoreData];
       _myTab.mj_footer = mjFooter;
   }
   return _myTab;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataArr.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    AnnouceModel *model = self.dataArr[indexPath.row];
    model.iconName = [NSString stringWithFormat:@"money-%@",@(indexPath.row%14)];
    AnnouceCell *cell = [tableView dequeueReusableCellWithIdentifier:@"AnnouceCell"];
    
    [cell setContenView:model];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
        AnnouceModel *model = self.dataArr[indexPath.row];
        HTMLVC *vc = [[HTMLVC alloc] init];
        vc.title = @"公告详情";
//        [vc setShareBtn];
        vc.H5Url = Nilstr2Space(model.link);
        vc.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:vc animated:YES];
}

- (void)starAnimationWithTableView:(UITableView *)tableView {
    
    [TableViewAnimationKit showWithAnimationType:4 tableView:tableView];
}

@end
