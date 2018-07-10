//
//  ProductChildVc.m
//  JinLingDai
//
//  Created by 001 on 2017/7/19.
//  Copyright © 2017年 JLD. All rights reserved.
//

#import "ProductChildVc.h"
#import "ProductionCell.h"
#import "BorrowModel.h"
#import <YYKit.h>
#import <MJRefresh.h>
#import "NoMoreDataView.h"
#define SectionHeadHeight 40
@interface ProductChildVc ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic, strong) UITableView *myTab;
@property (nonatomic, strong) NSMutableArray *dataArr;
@property (nonatomic, assign) NSInteger pageNo;
@end

@implementation ProductChildVc

- (void)viewDidLoad {
    [super viewDidLoad];
    self.myTab = [[UITableView alloc]initWithFrame:CGRectZero style:UITableViewStyleGrouped];
    self.myTab.rowHeight = ChangedHeight(135);
    
    self.myTab.delegate = self;
    self.myTab.dataSource = self;
    self.myTab.estimatedSectionHeaderHeight = 0;
    self.myTab.estimatedSectionFooterHeight = 0;
    if (@available(ios 11.0, *)) {
        NSLog(@"11");
    }
    [self.myTab registerClass:[ProductionCell class] forCellReuseIdentifier:@"interCell"];
    [self.view addSubview:self.myTab];
    [self.myTab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
    self.dataArr = [[NSMutableArray alloc]init];
    
    MJRefreshNormalHeader *mjHeadView = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        self.pageNo = 0;
        [self.dataArr removeAllObjects];
        [self loadDingQiData:self.status];
    }];
    mjHeadView.lastUpdatedTimeLabel.hidden = YES;
    UILabel *tipLab = [UILabel new];
    tipLab.text = @"国企全资控股,安全运营5年,银行存管已对接,值得信赖";
    tipLab.font = [UIFont gs_fontNum:10];
    tipLab.textColor = [UIColor titleColor];
    [self.myTab addSubview:tipLab];
    [tipLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.myTab);
        make.bottom.equalTo(self.myTab.mas_top).offset(-5);
    }];
    mjHeadView.ignoredScrollViewContentInsetTop = 15;
//    mjHeadView setTitle:@"金陵贷国资控股" forState:<#(MJRefreshState)#>
//    mjHeadView.automaticallyChangeAlpha = YES;
//    mjHeadView.arrowView.image = [UIImage imageNamed:@"roket"];
    mjHeadView.labelLeftInset = 40;
//    mjHeadView.activityIndicatorViewStyle = UIActivityIndicatorViewStyleGray;
    
    self.myTab.mj_header = mjHeadView;
    MJRefreshBackNormalFooter *mjFooter = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        [self loadDingQiData:self.status];
    }];
    [mjFooter setTitle:@"" forState:MJRefreshStateNoMoreData];
    self.myTab.mj_footer = mjFooter;
}

//
- (void)loadDingQiData:(NSString *)status{
    if (!self.status) {
        self.status = status;
    }
    self.pageNo ++;
    NSString *postUrl ;
    kAppPostHost(postUrl);
    [NetworkManager startNetworkRequestDataFromRemoteServerByPostMethodWithURLString:[NSString stringWithFormat:@"%@borrow/lists",postUrl]
          withParameters:@{
                           @"borrow_order":status,//	排序方式	number	可选 1：综合排序，2：收益排序，不传为综合排序
                           @"limit":@"10",//	查询个数	number	5
                           @"page":@(self.pageNo),//	页码	number
                           @"type":@"0",//	类型	number	501=>推荐标
                           @"token":[UserManager shareManager].userId//	用户id	number
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
                                 BorrowModel *model = [BorrowModel modelWithJSON:responseObject[@"data"]];
                                 
                                 [self.dataArr addObjectsFromArray:model.list];
                             }
                             [self.myTab reloadData];
                         });
                         
                     }
                 } failure:^(NSURLSessionDataTask *task, NSError *error) {
                     [self.myTab.mj_header endRefreshing];
                     [self.myTab.mj_footer endRefreshing];
                 }];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return self.dataArr.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 0.1;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    ProductionCell *cell = [tableView dequeueReusableCellWithIdentifier:@"interCell"];
    if (indexPath.row < self.dataArr.count) {
        [cell layoutViewsItem:self.dataArr[indexPath.section]];
    }
    
    __weak typeof(self) weakSelf = self;
    cell.robBuyBtnClick = ^{
        dispatch_async(dispatch_get_main_queue(), ^{
            [weakSelf robBuy:indexPath.section];
        });
    };
    return cell;
    
}


- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    if (section == self.dataArr.count) {
        return 0.1;
    }
    return ChangedHeight(4);
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [self robBuy:indexPath.section];
}


- (void)robBuy:(NSInteger)section{
    if (_RuboToBuyBlock) {
        ListModel *model = self.dataArr[section];
        _RuboToBuyBlock(model.id);
    }
    
    
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
