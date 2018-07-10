//
//  MessageVc.m
//  JinLingDai
//
//  Created by 001 on 2017/7/3.
//  Copyright © 2017年 JLD. All rights reserved.
//

#import "MessageVc.h"
#import "ImgTitleRightLabCell.h"
//#import <Masonry.h>
#import <MJRefresh.h>
#import "NoMoreDataView.h"
#import "MessageDetaillVc.h"
#import <YYKit.h>
@interface MessageVc ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic, strong) UITableView *myTab;
@property (nonatomic, strong) NSMutableArray *dataArr;
@property (nonatomic, assign) NSInteger pageNo;

@property (nonatomic, strong) UIView *tipView;
@property (nonatomic, strong) MessageModel *selectModel;
@end

@implementation MessageVc

- (void)goBack{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    [self setNavBlackColor];
//    self.title = @"消息通知";
    self.myTab = [[UITableView alloc]initWithFrame:CGRectZero style:UITableViewStyleGrouped];
    self.myTab.delegate = self;
    self.myTab.dataSource = self;
    self.myTab.estimatedSectionHeaderHeight = 0;
    self.myTab.estimatedSectionFooterHeight = 0;
    self.myTab.sectionFooterHeight = 0.1;
    self.myTab.rowHeight = ChangedHeight(50);
    [self.myTab registerClass:[ImgTitleRightLabCell class] forCellReuseIdentifier:@"messageCell"];
    
    [self.view addSubview:self.self.myTab];
    [self.myTab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
    
    MJRefreshBackNormalFooter *mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        [self loadMessageData];
    }];
    [mj_footer setTitle:@"" forState:MJRefreshStateNoMoreData];
    mj_footer.automaticallyHidden = YES;
    self.myTab.mj_footer = mj_footer;
    
    self.tipView.hidden = YES;
    [self.view addSubview:self.tipView];
    [self.tipView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view).offset(StatusBarHeight + 44);
        make.right.equalTo(self.view);
        make.width.mas_equalTo(ChangedHeight(90));
        make.height.mas_equalTo(ChangedHeight(100));
    }];
}

- (void)setStatues:(NSString *)statues{
    _statues = statues;
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    if (!self.dataArr) {
        self.dataArr = [[NSMutableArray alloc]init];
        
        [self loadMessageData];
    }
}

- (void)setRightNavBarBtn{
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"messageSet"] style:UIBarButtonItemStylePlain target:self action:@selector(showHadRedMessages)];
}

- (void)showHadRedMessages{
    self.tipView.hidden = !self.tipView.hidden;
}
- (void)loadMessageData{
    self.pageNo ++;
    NSString *postUrl ;
    kAppPostHost(postUrl);
    [NetworkManager startNetworkRequestDataFromRemoteServerByPostMethodWithURLString:[NSString stringWithFormat:@"%@user/innermsg",postUrl]
          withParameters:@{
                           @"limit":@"20",//	查询个数	string
                           @"page":@(self.pageNo),//	页码	string
                           @"status":_statues,//	状态	string	0全部，1未读，2已读
                           @"token":[UserManager shareManager].userId//	用户id	string
                           }
     ShowHUD:YES 
                 success:^(NSURLSessionDataTask *task, id responseObject) {
                     if ([responseObject[@"status"] integerValue] == 200) {
                         [self.myTab.mj_header endRefreshing];
                         [self.myTab.mj_footer endRefreshing];
                         dispatch_async(dispatch_get_main_queue(), ^{
                             
                             if ([responseObject[@"data"] isKindOfClass:[NSDictionary class]]) {
                                 if ([responseObject[@"data"][@"totalpage"] integerValue] <= self.pageNo) {
//                                     dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.2f * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                                         [self.myTab.mj_footer endRefreshingWithNoMoreData];
//                                     });
                                 
                                     self.myTab.tableFooterView = [NoMoreDataView new];
                                 }
                                 NSArray *arr = [NSArray modelArrayWithClass:[MessageModel class] json:responseObject[@"data"][@"list"]];
                                 if (arr) {
                                    [self.dataArr addObjectsFromArray:arr];
                                    
                                 }
                                
                             }
                              [self.myTab reloadData];
                         });
                     }
                 } failure:^(NSURLSessionDataTask *task, NSError *error) {
//                     [self.myTab.mj_header endRefreshing];
                     [self.myTab.mj_footer endRefreshing];
                 }];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [self.dataArr count];
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return ChangedHeight(5);
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    ImgTitleRightLabCell *cell = [tableView dequeueReusableCellWithIdentifier:@"messageCell"];
    cell.CellType = NSCellDefulet;
    [cell setSeparatorInset:UIEdgeInsetsZero];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    if (self.dataArr.count > indexPath.row) {
        MessageModel *model = self.dataArr[indexPath.row];
        [cell layoutContent:model];
        cell.logoImg.hidden = [model.status integerValue] == 1;
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    //    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.row < self.dataArr.count) {
        ImgTitleRightLabCell *cell = [tableView cellForRowAtIndexPath:indexPath];
        cell.logoImg.hidden = YES;
        MessageDetaillVc *vc = [[MessageDetaillVc alloc]init];
        MessageModel *Model = self.dataArr[indexPath.row];
        vc.messageModel = [Model modelCopy];
        
        Model.status = @"1";
        
        [self.navigationController pushViewController:vc animated:YES];
    }
    
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath{
    return YES;
}

- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath{
    return UITableViewCellEditingStyleDelete;
}

- (NSArray *)tableView:(UITableView *)tableView editActionsForRowAtIndexPath:(NSIndexPath *)indexPath{
    NSString *title1 = @"标为已读";
    UITableViewRowAction *button1 = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleDefault title:title1 handler:^(UITableViewRowAction *action, NSIndexPath *indexPath)
                                     {
                                         [self tableView:self.myTab commitEditingStyle:UITableViewCellEditingStyleInsert forRowAtIndexPath:indexPath];
                                     }];
    
    NSString *title2 = @"删除";
    button1.backgroundColor = [UIColor getOrangeColor];
    UITableViewRowAction *button2 = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleDefault title:title2 handler:^(UITableViewRowAction *action, NSIndexPath *indexPath)
                                     {
                                         [self tableView:self.myTab commitEditingStyle:UITableViewCellEditingStyleDelete forRowAtIndexPath:indexPath];
                                     }];
    button2.backgroundColor = [UIColor redColor];
    MessageModel *model = self.dataArr[indexPath.row];
    if ([model.status integerValue] == 1) {
        return @[button2];
    }
    return @[button2,button1];
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    MessageModel *model = self.dataArr[indexPath.row];
    self.selectModel = model;
    if(editingStyle == UITableViewCellEditingStyleDelete){
        [self deleteinnermsg:model.id];
    }else if (editingStyle == UITableViewCellEditingStyleInsert){
        
        [self changeAllMessage:model.id];
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

- (UIView *)tipView {
   if (!_tipView) {
       _tipView = [UIView new];
       _tipView.backgroundColor = [UIColor whiteColor];
       
       UIButton *changellBtn = [UIButton buttonWithType:UIButtonTypeCustom];
       [changellBtn setTitle:@"全部标为已读" forState:UIControlStateNormal];
       changellBtn.titleLabel.font = [UIFont gs_fontNum:14];
       [changellBtn setTitleColor:[UIColor titleColor] forState:UIControlStateNormal];
       [changellBtn addTarget:self action:@selector(changeAll) forControlEvents:UIControlEventTouchUpInside];
       [_tipView addSubview:changellBtn];
       [changellBtn mas_makeConstraints:^(MASConstraintMaker *make) {
           make.top.left.right.equalTo(_tipView);
       }];
       
       UIButton *hadRedBtn = [UIButton buttonWithType:UIButtonTypeCustom];
       hadRedBtn.titleLabel.font = [UIFont gs_fontNum:14];
       [hadRedBtn setTitle:@"已读消息" forState:UIControlStateNormal];
       [hadRedBtn setTitleColor:[UIColor titleColor] forState:UIControlStateNormal];
       [hadRedBtn addTarget:self action:@selector(gotoHadRedList) forControlEvents:UIControlEventTouchUpInside];
       [_tipView addSubview:hadRedBtn];
       [hadRedBtn mas_makeConstraints:^(MASConstraintMaker *make) {
           make.bottom.left.right.equalTo(_tipView);
           make.top.equalTo(changellBtn.mas_bottom).offset(ChangedHeight(1));
           make.height.equalTo(changellBtn);
       }];
       UIView *line = [UIView new];
       line.backgroundColor = [UIColor newSeparatorColor];
       [_tipView addSubview:line];
       [line mas_makeConstraints:^(MASConstraintMaker *make) {
           make.left.right.equalTo(changellBtn);
           make.top.equalTo(changellBtn.mas_bottom);
           make.height.mas_equalTo(1);
       }];
   }
   return _tipView;
}

- (void)gotoHadRedList{
    self.tipView.hidden = YES;
    MessageVc *vc = [[MessageVc alloc] init];
    vc.statues = @"2";
    vc.title = @"已读消息";
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)changeAll{
    [self changeAllMessage:@"0"];
}
- (void)changeAllMessage:(NSString *)messageId{
    self.tipView.hidden = YES;
    if (self.dataArr.count ==0 ) {
        return;
    }
    NSString *postUrl ;
    kAppPostHost(postUrl);
    [NetworkManager startNetworkRequestDataFromRemoteServerByPostMethodWithURLString:[NSString stringWithFormat:@"%@user/change_msg_status",postUrl]
      withParameters:@{
                       @"mid":messageId,
                       @"token":[UserManager shareManager].userId
                       }
             ShowHUD:YES
             success:^(NSURLSessionDataTask *task, id responseObject) {
                 if ([responseObject[@"status"] integerValue] == 200) {
                     dispatch_async(dispatch_get_main_queue(), ^{
                         if ([messageId integerValue] == 0) {
                             self.pageNo = 0;
                             [self.dataArr removeAllObjects];
                             [self loadMessageData];
                         }else{
                             self.selectModel.status = @"1";
                             [self.myTab reloadData];
                         }
                         
                     });
                     
                 }
             } failure:^(NSURLSessionDataTask *task, NSError *error) {
                 
             }];
}

- (void)deleteinnermsg:(NSString *)messageId{
    NSString *postUrl ;
    kAppPostHost(postUrl);
    [NetworkManager startNetworkRequestDataFromRemoteServerByPostMethodWithURLString:[NSString stringWithFormat:@"%@user/deleteinnermsg",postUrl]
          withParameters:@{
                           @"mid":messageId,//	消息id	string
                           @"token":[UserManager shareManager].userId//string
                           }
                 ShowHUD:YES
                 success:^(NSURLSessionDataTask *task, id responseObject) {
                     if ([responseObject[@"status"] integerValue] == 200) {
                         dispatch_async(dispatch_get_main_queue(), ^{
                             NSIndexPath *indedx = [NSIndexPath indexPathForRow:[self.dataArr indexOfObject:self.selectModel] inSection:0];
                             [self.dataArr removeObject:self.selectModel];
                             if (self.dataArr.count) {
                                 [self.myTab deleteRowAtIndexPath:indedx withRowAnimation:UITableViewRowAnimationFade];
                             }else
                                 [self.myTab reloadData];
                         });
                     }
                 } failure:^(NSURLSessionDataTask *task, NSError *error) {
                     
                 }];
}
@end
