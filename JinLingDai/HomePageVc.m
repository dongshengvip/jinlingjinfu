//
//  HomePageVc.m
//  JinLingDai
//
//  Created by 001 on 2017/6/27.
//  Copyright © 2017年 JLD. All rights reserved.
//
#import "AppDelegate.h"
#import "HomePageVc.h"
#import "UIImageView+Radius.h"
#import <YYKit.h>
#import "ADVPageView.h"
#import <MJRefresh.h>
#import "ManageOfBankVc.h"
//#import "SectionHeadValue1View.h"//标头
#import "RecommendCell.h"
#import "RollAdvLabView.h"//滚动文字广告
#import "UpAndDownButton.h"
#import "BorrowModel.h"
#import "HTMLVC.h"
#import "ChuJieXiangQingVc.h"
#import "JLDShareManager.h"

#import "AnnouceModel.h"


#import "NSDate+Formatter.h"

//#import "BankGiftImageView.h"
@interface HomePageVc ()<UITableViewDelegate,UITableViewDataSource,ADVPageViewDelegate>{
    
}
@property (nonatomic, strong) UITableView *myTab;
@property (nonatomic, strong) NSMutableArray *dataArr;
@property (nonatomic, strong) ADVPageView *advView;
@property (nonatomic, strong) UIView *collection;
//@property (nonatomic, assign) BOOL isOnLineStatues;
@property (nonatomic, assign) BOOL refreshGongGao;
@property (nonatomic, copy) NSArray *ADVImgArr;
@property (nonatomic, copy) NSString *invest_count;

@property (nonatomic, strong) NSArray *listsOfannouce;//公告
@end
#define coloctionArr @[@"银行存管", @"电子存证", @"国企控股", @"风控措施"]
#define SudoH5Url @[@"11", @"12", @"9", @"3"]
@implementation HomePageVc

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor blackColor];
    self.automaticallyAdjustsScrollViewInsets = NO;
    [self setNavBlackColor];
    
    
    
    self.myTab = [[UITableView alloc]initWithFrame:CGRectZero style:UITableViewStyleGrouped];
//    self.myTab.rowHeight = ChangedHeight(270);
    
    self.myTab.delegate = self;
    self.myTab.dataSource = self;
//    self.myTab.estimatedSectionHeaderHeight = 0;
//    self.myTab.estimatedSectionFooterHeight = 0;
    _advView = [ADVPageView new];
    _advView.hasTip = YES;
    _advView.delegate = self;
    _advView.height = ChangedHeight(170);
    self.myTab.tableHeaderView = _advView;
    
    self.myTab.sectionHeaderHeight = ChangedHeight(35);
    self.myTab.sectionFooterHeight = ChangedHeight(4);
    
    MJRefreshNormalHeader *mjHeadView = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [self.dataArr removeAllObjects];
        [self loadADVImgData:YES];
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
    mjHeadView.labelLeftInset = 40;
    self.myTab.mj_header = mjHeadView;
    
    [self.myTab registerClass:[RecommendCell class] forCellReuseIdentifier:@"RecommendCell"];
    [self.myTab registerClass:[RollAdvLabView class] forHeaderFooterViewReuseIdentifier:@"RollTextHed"];
    [self.view addSubview:self.myTab];
    [self.myTab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view).insets(UIEdgeInsetsMake(StatusBarHeight, 0, 0, 0));
    }];
    
    
}



- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];

    if (self.dataArr) {
        [self.dataArr removeAllObjects];
        [self loadADVImgData:NO];
    }else{
        self.dataArr = [[NSMutableArray alloc] init];
        [self loadADVImgData:YES];
    }
}


- (void)userHadLoged{
    [self.dataArr removeAllObjects];
    [self loadADVImgData:YES];

}
//- (void)userHadLogin{
//    [self.dataArr removeAllObjects];
//    [self loadADVImgData:YES];
//    if (!Nilstr2Space([UserManager shareManager].user.platcust).length) {
//        [self bankManagerViewShow];
//    }
//}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section ) {
        RecommendCell *cell = [tableView dequeueReusableCellWithIdentifier:@"RecommendCell"];

        NSLog(@"shuaxin- cell");
        [cell setListItem:self.dataArr];
        __weak typeof(self) weakSelf = self;
        cell.GoToBorrowBlock = ^(NSString *borrowId) {
            ChuJieXiangQingVc *vc = [[ChuJieXiangQingVc alloc]init];
            vc.hidesBottomBarWhenPushed = YES;
            weakSelf.isAnimat = YES;
            vc.borrow_id = [borrowId copy];
            [weakSelf.navigationController pushViewController:vc animated:YES];
        };
        return cell;
    }else{
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"collectionCell"];
        if (!cell) {
            cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"collectionCell"];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
        }
        [cell.contentView addSubview:self.collection];
        [self.collection mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(cell.contentView);
        }];
        return cell;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (section) {
        return 0.1;
    }
    return ChangedHeight(35);
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    if (section) {
        return 0.1;
    }
    return ChangedHeight(4);
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {
        return ChangedHeight(80);
    }
    return ChangedHeight(300);
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    if (section) {
        return nil;
    }
    UITableViewHeaderFooterView *headView;
    RollAdvLabView *sectionHead = [tableView dequeueReusableHeaderFooterViewWithIdentifier:@"RollTextHed"];
    if (self.listsOfannouce && self.refreshGongGao) {
        [sectionHead setcontentView:self.listsOfannouce];
        
    }
    __weak typeof (self) weakSelf = self;
    sectionHead.GongGaoBlock = ^(NSInteger IdStr) {
        UIViewController *vc = [[NSClassFromString(@"AnnouceVc") alloc] init];
        vc.hidesBottomBarWhenPushed = YES;
        [weakSelf.navigationController pushViewController:vc animated:YES];
    };
    headView = sectionHead;
    
    return headView;
}


/**
 获取邀请有奖等按钮

 @return 返回一个view
 */
- (UIView *)collection{
    if (!_collection) {
        _collection = [UIView new];
        UIView *lastView = nil;
        NSInteger startIndex = 0;
//        NSString *online_version = [[NSUserDefaults standardUserDefaults] objectForKey:@"online_version"];
//
//        if ([Nilstr2Zero(online_version) compare:kAppVersion options:NSCaseInsensitiveSearch] == NSOrderedSame) {
//            startIndex = 0;
//        }
        
        for (NSInteger i = startIndex; i <4 ; i ++) {
            UpAndDownButton *btn = [UpAndDownButton new];
            btn.icon.image = [UIImage imageNamed:coloctionArr[i]];
            btn.titleLab.text = coloctionArr[i];
            [btn setTitleColor:[UIColor getColor:83 G:83 B:83] forState:UIControlStateNormal];
            btn.tag = i;
            [btn addTarget:self action:@selector(collectionBtnsClicked:) forControlEvents:UIControlEventTouchUpInside];
            [_collection addSubview:btn];
            
            [btn mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.bottom.equalTo(_collection);
                
                if(lastView){
                    make.width.equalTo(lastView);
                    make.left.equalTo(lastView.mas_right);
                }else{
                    make.left.equalTo(_collection);
                }
                if (i == 3) {
                    make.right.equalTo(_collection);
                }
                
            }];
            lastView = btn;
        }
    }
    return _collection;
}

- (void)loadADVImgData:(BOOL)refresh{
    self.refreshGongGao = refresh;
    dispatch_group_t group = dispatch_group_create();
    
    NSString *postUrl ;
    kAppPostHost(postUrl);
    if (refresh) {
        dispatch_group_enter(group);
        
    [NetworkManager startNetworkRequestDataFromRemoteServerByPostMethodWithURLString:[NSString stringWithFormat:@"%@Main/bnlist",postUrl]
      withParameters:@{}
     ShowHUD:YES
                     success:^(NSURLSessionDataTask *task, id responseObject) {
                         dispatch_group_leave(group);
                         if ([responseObject[@"status"] integerValue] == 200) {
                             dispatch_async(dispatch_get_main_queue(), ^{
                                 if ([responseObject[@"data"] isKindOfClass:[NSDictionary class]]) {
                                     self.ADVImgArr = responseObject[@"data"][@"list"];
                                     
                                 }
                             });
                             
                         }
                     } failure:^(NSURLSessionDataTask *task, NSError *error) {
                         dispatch_group_leave(group);
                     }];
    
    dispatch_group_enter(group);
        
    [NetworkManager startNetworkRequestDataFromRemoteServerByPostMethodWithURLString:[NSString stringWithFormat:@"%@sum/statistics",postUrl]
      withParameters:@{}
             ShowHUD:YES
             success:^(NSURLSessionDataTask *task, id responseObject) {
                 dispatch_group_leave(group);
                 if ([responseObject[@"status"] integerValue] == 200) {
                     if ([responseObject[@"data"] isKindOfClass:[NSDictionary class]]) {
                         dispatch_async(dispatch_get_main_queue(), ^{
                             [self.advView setTotalLab:responseObject[@"data"][@"capital_sum"] interest:responseObject[@"data"][@"interest_sum"]];
                             self.invest_count = responseObject[@"data"][@"invest_count"];
                         });
                     }
                     
                 }
             } failure:^(NSURLSessionDataTask *task, NSError *error) {
                 dispatch_group_leave(group);
             }];
    dispatch_group_enter(group);
    [NetworkManager startNetworkRequestDataFromRemoteServerByPostMethodWithURLString:[NSString stringWithFormat:@"%@annouce/lists",postUrl]
      withParameters:@{
                       @"page":@(1),
                       @"limit":@"5"
                       }
             ShowHUD:YES
             success:^(NSURLSessionDataTask *task, id responseObject) {
                 dispatch_group_leave(group);
                 if ([responseObject[@"status"] integerValue] == 200) {
                     if ([responseObject[@"data"] isKindOfClass:[NSDictionary class]]) {
                         dispatch_async(dispatch_get_main_queue(), ^{
                             self.listsOfannouce = [NSArray modelArrayWithClass:[AnnouceModel class] json:responseObject[@"data"][@"list"]];
                         });
                     }
                 }
             } failure:^(NSURLSessionDataTask *task, NSError *error) {
                 dispatch_group_leave(group);
             }];
    }
    dispatch_group_enter(group);
    [NetworkManager startNetworkRequestDataFromRemoteServerByPostMethodWithURLString:[NSString stringWithFormat:@"%@borrow/lists",postUrl]
      withParameters:@{
                       //@"borrow_duration";,//	借款期限(单位月)	number
                       @"limit":@"2",//	查询个数	number	5
                       @"page":@"1",//	页码	number
                       @"type":@"501",//	类型	number
                       @"token":[UserManager shareManager].userId
                       }
             ShowHUD:YES
             success:^(NSURLSessionDataTask *task, id responseObject) {
                 dispatch_group_leave(group);
                 if ([responseObject[@"status"] integerValue] == 200) {
                     dispatch_async(dispatch_get_main_queue(), ^{
                         NSLog(@"shuaxin- succ");
                         BorrowModel *model = [BorrowModel modelWithJSON:responseObject[@"data"]];
                         //
                         if (model.list.count > 2) {
                             [self.dataArr addObjectsFromArray:@[model.list.firstObject,model.list[1]]];
                         }else{
                             [self.dataArr addObjectsFromArray:model.list];
                         }
                     });
                 }
             } failure:^(NSURLSessionDataTask *task, NSError *error) {
                 dispatch_group_leave(group);
             }];
    dispatch_group_notify(group, dispatch_get_main_queue(), ^{
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.myTab.mj_header endRefreshing];
            if (refresh) {
                NSMutableArray *arr = [NSMutableArray array];
                [self.ADVImgArr enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                    [arr addObject:obj[@"pic"]];
                }];
                [self.advView setItems:arr andTimeInterval:5.f];

            }
            [self.myTab reloadData];
        });
    });
}
/**
 邀请有奖等按钮等触发
 */
- (void)collectionBtnsClicked: (UIButton *)sender{

    NSString *postUrl ;
    kAppPostHost(postUrl);
    HTMLVC *vc= [[HTMLVC alloc] init];
    vc.H5Url = [NSString stringWithFormat:@"%@Page/showinfomation?type=%@",postUrl,SudoH5Url[sender.tag]];
    [vc setShareBtn];
//    vc.isShare = sender.tag == 0;
    vc.title = coloctionArr[sender.tag];
    vc.hidesBottomBarWhenPushed = YES;
    self.isAnimat = YES;
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)pageView:(ADVPageView *)pageView didSelected:(NSInteger)index{
    NSString *postUrl ;
    kAppPostHost(postUrl);
    if(self.ADVImgArr.count > index){
        NSString *jumpUrlStr = self.ADVImgArr[index][@"jump_url"];
        if (Nilstr2Space(jumpUrlStr).length <= postUrl.length) {
            return;
        }
        HTMLVC *vc= [[HTMLVC alloc] init];
        NSString *urlStr = self.ADVImgArr[index][@"jump_url"];
        vc.H5Url = [urlStr containsString:@"?"]?[urlStr stringByAppendingString:[NSString stringWithFormat:@"&src=%@",[UserManager shareManager].urlUserId]]:[urlStr stringByAppendingString:[NSString stringWithFormat:@"?src=%@",[UserManager shareManager].urlUserId]];
        [vc setShareBtn];
        vc.title = self.ADVImgArr[index][@"title"];
        vc.hidesBottomBarWhenPushed = YES;
        self.isAnimat = YES;
        [self.navigationController pushViewController:vc animated:YES];
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


