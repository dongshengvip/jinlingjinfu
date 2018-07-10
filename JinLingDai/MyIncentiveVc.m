//
//  MyIncentiveVc.m
//  JinLingDai
//
//  Created by 001 on 2017/7/5.
//  Copyright © 2017年 JLD. All rights reserved.
//

#import "MyIncentiveVc.h"
#import "TitleBarView.h"
#import "MyJiaXiQuanVc.h"
#import "MyRedBagVc.h"
#import "RedBagOfFirendsVc.h"
#import <YYKit.h>
#import "MBProgressHUD+NetWork.h"
#define TitleArr @[@"邀请红包", @"系统红包", @"加息券"]
@interface MyIncentiveVc ()<UIScrollViewDelegate>{
    UIView *jiaXiView;
}
//@property (nonatomic, strong) UITableView *myTab;
@property (nonatomic, strong) TitleBarView *titleBtnView;
@property (nonatomic, strong) MyJiaXiQuanVc *jiaxiVc;
@property (nonatomic, strong) MyRedBagVc *redBagVc;
@property (nonatomic, strong) RedBagOfFirendsVc *friendsBag;
@property (nonatomic, strong) UIScrollView *contenView;
@property (nonatomic, strong) NSMutableDictionary *childDic;
@end

@implementation MyIncentiveVc

- (void)presentShow{
    dispatch_async(dispatch_get_main_queue(), ^{
        UIAlertController *alert  = [UIAlertController alertControllerWithTitle:@"兑换优惠券" message:@"请输入兑换码" preferredStyle:UIAlertControllerStyleAlert];
        [alert addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil]];
        [alert addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
            textField.keyboardType = UIKeyboardTypeAlphabet;
        }];
        [alert addAction:[UIAlertAction actionWithTitle:@"确认兑换" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            UITextField *textField = alert.textFields.firstObject;
            if (textField.text.length) {
                [self rechangeBar:textField.text];
            }
            
        }]];
        [self presentViewController:alert animated:YES completion:nil];
    });
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setNavBlackColor];
    self.title = @"我的奖励";
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:@"➕" style:UIBarButtonItemStylePlain target:self action:@selector(presentShow)];
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.titleBtnView = [[TitleBarView alloc]initWithFrame:CGRectMake(0, StatusBarHeight + 44, K_WIDTH, ChangedHeight(40))];
    [self.titleBtnView setCurrentCollor:[UIColor getBlueColor]];
    [self.titleBtnView reloadAllButtonsOfTitleBarWithTitles:TitleArr];
    [self.view addSubview:self.titleBtnView];

    __weak typeof(self) weakSelf = self;
    self.titleBtnView.titleButtonClicked = ^(NSUInteger index) {
//        if (index) {
//            [weakSelf setJiaXiViewController];
//        }
         [weakSelf setChildrenVc:index];
        [weakSelf.contenView setContentOffset:CGPointMake(index*K_WIDTH, 0) animated:YES];
    };
    self.contenView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, ChangedHeight(40), K_WIDTH, K_HEIGHT - StatusBarHeight - 44 - ChangedHeight(40))];
    self.contenView.delegate = self;
    self.contenView.backgroundColor = [UIColor infosBackViewColor];
    self.contenView.pagingEnabled = YES;
    [self.view addSubview:self.contenView];
    [self.contenView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.equalTo(self.view);
        make.top.equalTo(self.titleBtnView.mas_bottom);
    }];

    jiaXiView = [UIView new];
    [self.contenView addSubview:jiaXiView];
    [jiaXiView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.contenView);
        make.width.equalTo(self.view).multipliedBy(TitleArr.count * 1.0);
        make.height.mas_equalTo(self.view).offset(-ChangedHeight(40) - StatusBarHeight - 44);
    }];
    

    self.childDic = [[NSMutableDictionary alloc] init];
    
    [self setChildrenVc:0];
}

- (void)setChildrenVc:(NSInteger)index{
    if (self.childDic[@(index)]) {
        return;
    }
    switch (index) {
        case 0:
        {
            if (!_friendsBag) {
                _friendsBag = [[RedBagOfFirendsVc alloc] init];
                [jiaXiView addSubview:_friendsBag.view];
                [_friendsBag.view mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.top.left.bottom.equalTo(jiaXiView);
                    make.width.equalTo(self.view);
                }];
                [self addChildViewController:_friendsBag];
                [self.childDic setObject:_friendsBag forKey:@(index)];
            }
        }
            break;
        case 1:
        {
            if (!_redBagVc) {
                _redBagVc = [[MyRedBagVc alloc]init];
                [jiaXiView addSubview:_redBagVc.view];
                [_redBagVc.view mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.top.bottom.equalTo(jiaXiView);
                    make.width.equalTo(self.view);
                    make.left.equalTo(jiaXiView).offset(K_WIDTH * index);
                }];
                [self addChildViewController:_redBagVc];
                [self.childDic setObject:_redBagVc forKey:@(index)];
            }
        }
            break;
        default:{
            if (!_jiaxiVc) {
                _jiaxiVc = [[MyJiaXiQuanVc alloc] init];
//                self.jiaxiVc.view.frame = CGRectMake(K_WIDTH, 0, K_WIDTH, K_HEIGHT - 64 - ChangedHeight(40));
                [jiaXiView addSubview:_jiaxiVc.view];
                [self.jiaxiVc.view mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.right.top.bottom.equalTo(jiaXiView);
                    make.width.equalTo(self.view);
                    make.left.equalTo(jiaXiView).offset(K_WIDTH * index);
                }];
                
                [self addChildViewController:_jiaxiVc];
                [self.childDic setObject:_jiaxiVc forKey:@(index)];
                
            }
        }
            break;
    }
}
- (void)setJiaXiViewController{
    if (!_jiaxiVc) {
        
        _jiaxiVc = [[MyJiaXiQuanVc alloc] init];
        self.jiaxiVc.view.frame = CGRectMake(K_WIDTH, 0, K_WIDTH, K_HEIGHT - StatusBarHeight - 44 - ChangedHeight(40));
        [jiaXiView addSubview:_jiaxiVc.view];
        [self.jiaxiVc.view mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.top.bottom.equalTo(jiaXiView);
            make.width.equalTo(self.view);
            make.left.equalTo(self.redBagVc.view.mas_right);
        }];
        
        [self addChildViewController:_jiaxiVc];
        
    }
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    NSInteger index = (NSInteger)scrollView.contentOffset.x/K_WIDTH;
//    if (index) {
        [self setChildrenVc:index];
//    }
    [self.titleBtnView scrollToCenterWithIndex:index];
}

- (void)rechangeBar:(NSString *)bar{
    NSString *postUrl ;
    kAppPostHost(postUrl);
    [NetworkManager startNetworkRequestDataFromRemoteServerByPostMethodWithURLString:[NSString stringWithFormat:@"%@reward/rewardcode",postUrl]
          withParameters:@{
                           @"code":bar,//	兑换码	string
                           @"token":[UserManager shareManager].userId//	用户token	string
                           }
                 ShowHUD:YES
                 success:^(NSURLSessionDataTask *task, id responseObject) {
                     if ([responseObject[@"status"] integerValue] == 200) {
                         dispatch_async(dispatch_get_main_queue(), ^{
                             [MBProgressHUD showSuccess:@"兑换成功"];
                             [self.contenView setContentOffset:CGPointMake(K_WIDTH, 0)];
                             [self.titleBtnView scrollToCenterWithIndex:1];
                             [jiaXiView removeAllSubviews];
                             [self.childDic removeAllObjects];
                             if (_redBagVc) {
                                 [_redBagVc removeFromParentViewController];
                                 _redBagVc = nil;
                             }
                             if (_jiaxiVc) {
                                 [_jiaxiVc removeFromParentViewController];
                                 _jiaxiVc = nil;
                             }
                             if (_friendsBag) {
                                 [_friendsBag removeFromParentViewController];
                                 _friendsBag = nil;
                             }
                             
                             [self setChildrenVc:1];
                         });
                         
                     }
                 } failure:^(NSURLSessionDataTask *task, NSError *error) {
                     
                 }];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
