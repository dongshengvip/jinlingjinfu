//
//  SecondVc.m
//  JinLingDai
//
//  Created by 001 on 2017/6/27.
//  Copyright © 2017年 JLD. All rights reserved.
//

#import "SecondVc.h"

#import "TitleBarView.h"
#import "ChuJieXiangQingVc.h"
#import <YYKit.h>
#import "ProductChildVc.h"
#import "ADVPageView.h"
#import "HTMLVC.h"

@interface SecondVc ()<UIScrollViewDelegate,ADVPageViewDelegate>
{
    UIView *bgView ;
}
@property (nonatomic, strong) ADVPageView *advView;
@property (nonatomic, copy) NSArray *ADVImgArr;
@property (nonatomic, strong) UIScrollView *scroll;
@property (nonatomic, strong) NSMutableDictionary *childVcDic;
@property (nonatomic, strong) TitleBarView *titleView;
//@property (nonatomic, assign) BOOL/ isAnimat;
@end
#define TitleBarArr @[@"综合性排序", @"收益率排序"]
@implementation SecondVc

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor blackColor];
    [self setNavBlackColor];
//    self.title = @"产品";
//    self.automaticallyAdjustsScrollViewInsets = NO;
//    UIImageView *headView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"banner-123"]];

    _advView = [ADVPageView new];
    //    _advView.hasTip = YES;
    _advView.delegate = self;
//    _advView.height = ChangedHeight(170);
    [self.view addSubview:_advView];
    [_advView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.view);
        make.top.equalTo(self.view).offset(StatusBarHeight);
        make.height.mas_equalTo(ChangedHeight(170));
    }];
    self.titleView = [[TitleBarView alloc]initWithFrame:CGRectMake(0, 0, K_WIDTH, ChangedHeight(40))];
    
    self.titleView.isNeedScroll = NO;
    self.titleView.currentCollor = [UIColor getOrangeColor];
    
    [self.view addSubview:self.titleView];

    [self.titleView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.view);
        make.top.equalTo(_advView.mas_bottom);
        make.height.mas_equalTo(ChangedHeight(40));
    }];
    __weak typeof(self) weakMine = self;
    self.titleView.titleButtonClicked = ^(NSUInteger index) {
        [weakMine setContentViewAtindex:index];
        [weakMine.scroll setContentOffset:CGPointMake(K_WIDTH * index, 0) animated:YES];
    };
    
    [self.titleView reloadAllButtonsOfTitleBarWithTitles:TitleBarArr];
    self.scroll = [[UIScrollView alloc]init];
    self.scroll.delegate = self;
    self.scroll.backgroundColor = [UIColor infosBackViewColor];
    self.scroll.pagingEnabled = YES;
    [self.view addSubview:self.scroll];
    [self.scroll mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.equalTo(self.view);
        make.top.equalTo(self.titleView.mas_bottom);
    }];
    
//    [self loadBaner];
    [self setFirstVc];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    if (!self.ADVImgArr || !self.ADVImgArr.count) {
        [self loadBaner];
    }
}

- (void)setFirstVc{
    bgView = [UIView new];
    bgView.backgroundColor = [UIColor infosBackViewColor];
    [self.scroll addSubview:bgView];
    [bgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.scroll);
        make.width.equalTo(self.view).multipliedBy(TitleBarArr.count*1.0);
        make.height.equalTo(self.scroll);
    }];
    ProductChildVc *allVc = [[ProductChildVc alloc]init];
    [self.scroll addSubview:allVc.view];
    [allVc.view mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.bottom.equalTo(bgView);
        make.width.equalTo(self.view);
    }];
    
    [allVc loadDingQiData:@"1"];
    allVc.RuboToBuyBlock = ^(NSString *productid) {
        [self buyProduct:productid];
    };
    [self addChildViewController:allVc];
    self.childVcDic = [[NSMutableDictionary alloc]init];
    [self.childVcDic setValue:allVc forKey:@"0"];
}
- (void)reloadListData{
    if (!self.scroll) {
        return;
    }
    [self.scroll removeAllSubviews];
    [self.childVcDic enumerateKeysAndObjectsUsingBlock:^(id  _Nonnull key, id  _Nonnull obj, BOOL * _Nonnull stop) {
        UIViewController *vc = obj;
        [vc removeFromParentViewController];
    }];
    self.childVcDic = nil;
    [self.titleView scrollToCenterWithIndex:0];
    [self.scroll setContentOffset:CGPointZero];
    [self setFirstVc];
}

- (void)setContentViewAtindex:(NSInteger)index{
    if (self.childVcDic[[NSString stringWithFormat:@"%@",@(index)]]) {
        return;
    }
    ProductChildVc *water = [[ProductChildVc alloc]init];
    [self.scroll addSubview:water.view];
    [water.view mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.equalTo(bgView);
        make.width.equalTo(self.view);
        if (index == TitleBarArr.count - 1) {
            make.right.equalTo(bgView);
        }else{
            make.left.equalTo(bgView).offset(K_WIDTH * index);
        }
    }];
    [water loadDingQiData:[NSString stringWithFormat:@"%@",@(index + 1)]];
    water.RuboToBuyBlock = ^(NSString *productid) {
        [self buyProduct:productid];
    };
    [self addChildViewController:water];
    [self.childVcDic setValue:water forKey:[NSString stringWithFormat:@"%@",@(index)]];
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    NSInteger idex = (NSInteger)scrollView.contentOffset.x/K_WIDTH;
    [self.titleView scrollToCenterWithIndex:idex];
    [self setContentViewAtindex:idex];
}

- (void)loadBaner{
    NSString *postUrl ;
    kAppPostHost(postUrl);
    [NetworkManager startNetworkRequestDataFromRemoteServerByPostMethodWithURLString:[NSString stringWithFormat:@"%@page/discovery",postUrl]
          withParameters:@{
                           @"user_from":@"3"
                           }
                 ShowHUD:YES
                 success:^(NSURLSessionDataTask *task, id responseObject) {
                     if ([responseObject[@"status"] integerValue] == 200) {
                         
                         NSMutableArray *arr = [NSMutableArray array];
                         if ([responseObject[@"data"][@"list"] isKindOfClass:[NSArray class]]) {
                             self.ADVImgArr = responseObject[@"data"][@"list"];
                             [self.ADVImgArr enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                                 [arr addObject:obj[@"pic"]];
                             }];
                         }
                         
                         [self.advView setItems:arr andTimeInterval:5.f];
                     }
                 } failure:^(NSURLSessionDataTask *task, NSError *error) {
                     
                 }];
}

- (void)buyProduct:(NSString *)productId{
    ChuJieXiangQingVc *vc = [[ChuJieXiangQingVc alloc]init];
    vc.borrow_id = productId;
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
