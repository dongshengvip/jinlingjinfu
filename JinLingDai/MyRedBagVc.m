//
//  MyRedBagVc.m
//  JinLingDai
//
//  Created by 001 on 2017/7/8.
//  Copyright © 2017年 JLD. All rights reserved.
//

#import "MyRedBagVc.h"
#import "MBProgressHUD+NetWork.h"
#import "NewRedBagCell.h"
#import "JiangLiModel.h"
#import "NoMoreDataView.h"
#import <YYKit.h>
#import "RuleofRedbagVc.h"
@interface MyRedBagVc ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic, strong) UITableView *myTab;
@property (nonatomic, strong) NSMutableArray *usableBagArr;
@property (nonatomic, strong) NSMutableArray *usedBagArr;
@property (nonatomic, strong) NSMutableArray *pastBagArr;
@end
#define SectionTitle @[@"未使用", @"已使用", @"已过期"]

@implementation MyRedBagVc

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setNavBlackColor];
    
    self.title = @"我的红包";
    self.myTab = [[UITableView alloc]initWithFrame:CGRectZero style:UITableViewStyleGrouped];
    self.myTab.delegate = self;
    self.myTab.dataSource = self;
    if (@available (iOS 11.0, *)) {
        self.myTab.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentAutomatic;
    }
    self.myTab.estimatedSectionHeaderHeight = 0;
    self.myTab.estimatedSectionFooterHeight = 0;
    self.myTab.tableHeaderView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 0, ChangedHeight(5))];
    self.myTab.rowHeight = ChangedHeight(110);
    self.myTab.sectionFooterHeight = ChangedHeight(5);
    [self.myTab registerClass:[NewRedBagCell class] forCellReuseIdentifier:@"tabCell"];
    [self.view addSubview:self.myTab];
    [self.myTab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
    self.usedBagArr = [[NSMutableArray alloc] init];
    self.usableBagArr = [[NSMutableArray alloc] init];
    self.pastBagArr = [[NSMutableArray alloc] init];
    
    [self loadJiangLiData];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    
}

- (void)loadJiangLiData{
    NSString *postUrl ;
    kAppPostHost(postUrl);
    [NetworkManager startNetworkRequestDataFromRemoteServerByPostMethodWithURLString:[NSString stringWithFormat:@"%@user/reward",postUrl]
          withParameters:@{
                           @"type":@"1",
                           @"token":[UserManager shareManager].userId
                           }
     ShowHUD:YES 
                 success:^(NSURLSessionDataTask *task, id responseObject) {
                     if ([responseObject[@"status"] integerValue] == 200) {
                         dispatch_async(dispatch_get_main_queue(), ^{
                             JiangLiModel *model = [JiangLiModel modelWithJSON:responseObject[@"data"]];
                             [model.list enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                                 RedBagModel *redModel = obj;
                                 switch ([redModel.status integerValue]) {
                                     case 1:
                                     {
                                         redModel.imgStr = [NSString stringWithFormat:@"%@-usable",redModel.money];
                                         
                                         [self.usableBagArr addObject:redModel];
                                     }
                                         break;
                                     case 4:
                                     {
                                         redModel.imgStr = [NSString stringWithFormat:@"%@-used",redModel.money];
                                         [self.usedBagArr addObject:redModel];
                                     }
                                         break;
                                     default:{
                                         redModel.imgStr = [NSString stringWithFormat:@"%@-past",redModel.money];
                                         [self.pastBagArr addObject:redModel];
                                     }
                                         break;
                                 }
                             }];
                             if (model.list.count == 0) {
                                 NoMoreDataView *nomoreFooter = [NoMoreDataView new];
                                 [nomoreFooter setTipText:@"还未获取到红包"];
                                 self.myTab.tableFooterView = nomoreFooter;
                             }
                             [self.myTab reloadData];
                         });
                         
                     }
                 } failure:^(NSURLSessionDataTask *task, NSError *error) {
                     
                 }];
}


-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 3;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    switch (section) {
        case 0:
            return self.usableBagArr.count;
            break;
        case 1:
            return self.usedBagArr.count;
            break;
        default:return  self.pastBagArr.count;
            break;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    //    return ChangedHeight(35);
    switch (section) {
        case 0:
        {
            return self.usableBagArr.count?ChangedHeight(35):0;
        }
            break;
        case 1:{
            return self.usedBagArr.count?ChangedHeight(35):0;
        }
            break;
        default:{
            return self.pastBagArr.count?ChangedHeight(35):0;
        }
            break;
    }
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView *view = [UIView new];
    switch (section) {
        case 0:
        {
            if (self.usableBagArr.count == 0) {
                return view;
            }
        }
            break;
        case 1:{
            if (self.usedBagArr.count == 0) {
                return view;
            }
        }
            break;
        default:{
            if (self.pastBagArr.count == 0) {
                return view;
            }
        }
            break;
    }
    UILabel *lab = [UILabel new];
    view.backgroundColor = [UIColor whiteColor];
    lab.text = SectionTitle[section];;
    [view addSubview:lab];
    [lab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(view).insets(UIEdgeInsetsMake(0, ChangedHeight(15), 0, 0));
    }];
    return view;
}



- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    NewRedBagCell *cell = [tableView dequeueReusableCellWithIdentifier:@"tabCell"];
//    __weak typeof(self) weakMine = self;//处理红包详情
//    cell.redBagSlectedBlock = ^(NSInteger index) {
//        RedBagModel *model;
//        switch (indexPath.section) {
//            case 0:
//                model = self.usableBagArr[index];
//                break;
//            case 1:
//                model = self.usedBagArr[index];
//                break;
//
//            default:model = self.pastBagArr[index];
//                break;
//        }
//        RuleofRedbagVc *vc = [[RuleofRedbagVc alloc]init];
//        vc.bagModel = model;
//        [weakMine.navigationController pushViewController:vc animated:YES];
//    };
    switch (indexPath.section) {//设置红包内容
        case 0:
        {
            [cell setContenView:self.usableBagArr[indexPath.row]];
        }
            break;
        case 1:
        {
            [cell setContenView:self.usedBagArr[indexPath.row]];
        }
            break;

        default:{
            [cell setContenView:self.pastBagArr[indexPath.row]];
        }
            break;
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
