//
//  HuanKuanJiHuaVc.m
//  JinLingDai
//
//  Created by 001 on 2017/7/10.
//  Copyright © 2017年 JLD. All rights reserved.
//

#import "HuanKuanJiHuaVc.h"
#import "HuanKuanCell.h"
#import "PlantListModel.h"
#import <YYKit.h>

@interface HuanKuanJiHuaVc ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic, strong) UITableView *myTab;
@property (nonatomic, copy) NSArray *dataArr;
@property (nonatomic, strong) UIView *tabHeadView;
@end
#define tipTitleArr @[@"收益日期",@"本金（元）",@"利息（元）",@"状态"]
@implementation HuanKuanJiHuaVc

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"收益计划";
    
    self.myTab = [[UITableView alloc]initWithFrame:CGRectZero style:UITableViewStylePlain];
    self.myTab.backgroundColor = [UIColor infosBackViewColor];
    self.myTab.delegate = self;
    self.myTab.dataSource = self;
    self.myTab.rowHeight = ChangedHeight(40);
    self.myTab.tableHeaderView = self.tabHeadView;
    self.myTab.tableFooterView = [UIView new];
    [self.myTab registerClass:[HuanKuanCell class] forCellReuseIdentifier:@"HuanKuanCell"];
    [self.view addSubview:self.self.myTab];
    [self.myTab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
    
//    self.dataArr = [NSMutableArray array];
//    for (int i = 0; i < 6; i ++) {
//        [self.dataArr addObject:@"0"];
//    }
}

- (UIView *)tabHeadView{
    if (!_tabHeadView) {
        _tabHeadView = [UIView new];
        _tabHeadView.height = ChangedHeight(55);
        UIView *bgView = [UIView new];
        bgView.backgroundColor = [UIColor whiteColor];
        [_tabHeadView addSubview:bgView];
        [bgView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(_tabHeadView).insets(UIEdgeInsetsMake(ChangedHeight(10), ChangedHeight(10), 0, ChangedHeight(10)));
        }];
        
        UIView *lastView = nil;
        for (NSInteger i = 0; i < tipTitleArr.count; i ++) {
            UILabel *lab = [UILabel new];
            lab.textAlignment = NSTextAlignmentCenter;
            lab.textColor = [UIColor titleColor];
            lab.font = [UIFont gs_fontNum:13];
            lab.text = tipTitleArr[i];
            [_tabHeadView addSubview:lab];
            [lab mas_makeConstraints:^(MASConstraintMaker *make) {
                make.centerY.equalTo(bgView);
                if (i == 0) {
                    make.left.equalTo(bgView);
                }else{
                    make.left.equalTo(lastView.mas_right);
                    make.width.equalTo(lastView);
                }
                if (i == tipTitleArr.count - 1) {
                    make.right.equalTo(bgView);
                }
            }];
            lastView = lab;
        }
    }
    return _tabHeadView;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataArr.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    HuanKuanCell *cell = [tableView dequeueReusableCellWithIdentifier:@"HuanKuanCell"];
    [cell setSeparatorInset:UIEdgeInsetsZero];
    [cell setContenView:self.dataArr[indexPath.row]];;
    return cell;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self loadPlanList];
}

- (void)loadPlanList{
    NSString *postUrl ;
    kAppPostHost(postUrl);
    [NetworkManager startNetworkRequestDataFromRemoteServerByPostMethodWithURLString:[NSString stringWithFormat:@"%@income/planlist",postUrl]
          withParameters:@{
                           @"borrow_id":self.invest_id,//	id	number
                           @"limit":@"100",
                           @"page":@"1",
                           @"token":[UserManager shareManager].userId	//用户id	number
                           }
     ShowHUD:YES 
                 success:^(NSURLSessionDataTask *task, id responseObject) {
                     if ([responseObject[@"status"] integerValue] == 200) {
                         dispatch_async(dispatch_get_main_queue(), ^{
                             if ([responseObject[@"data"] isKindOfClass:[NSDictionary class]]) {
                                 self.dataArr = [NSArray modelArrayWithClass:[PlantListModel class] json:responseObject[@"data"][@"list"]];
                                 [self.myTab reloadData];
                             }
                             
                         });
                     }
                 } failure:^(NSURLSessionDataTask *task, NSError *error) {
                     
                 }];
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
