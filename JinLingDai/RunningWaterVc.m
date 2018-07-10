//
//  RunningWaterVc.m
//  JinLingDai
//
//  Created by 001 on 2017/7/6.
//  Copyright © 2017年 JLD. All rights reserved.
//

#import "RunningWaterVc.h"
#import "TitleBarView.h"
#import "WaterChildVc.h"
@interface RunningWaterVc ()<UIScrollViewDelegate>
{
    UIView *bgView ;
}
@property (nonatomic, strong) UIScrollView *scroll;
@property (nonatomic, strong) NSMutableDictionary *childVcDic;
@property (nonatomic, strong) TitleBarView *titleView;
@end
#define TitleBarArr @[@[@"全部",@"全部"], @[@"充值",@"充值"],@[@"提现",@"提现"],@[@"出借",@"出借"],@[@"冻结",@"冻结"],@[@"回款",@"回款"]]
@implementation RunningWaterVc

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"账户流水";
    [self setNavBlackColor];
    
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.titleView = [[TitleBarView alloc]initWithFrame:CGRectMake(0, StatusBarHeight + 44, K_WIDTH, ChangedHeight(60))];
    
    self.titleView.isNeedScroll = NO;
    self.titleView.currentCollor = [UIColor getBlueColor];
    __weak typeof(self) weakMine = self;
    self.titleView.titleButtonClicked = ^(NSUInteger index) {
        [weakMine setContentViewAtindex:index];
        [weakMine.scroll setContentOffset:CGPointMake(K_WIDTH * index, 0) animated:YES];
    };
    
    [self.view addSubview:self.titleView];
    
    
    [self.titleView reloadAllUpAndDownButtonsOfTitleBarWithTitles:TitleBarArr];
    
    
    
    [self.view addSubview:self.titleView];
    self.scroll = [[UIScrollView alloc]init];
    self.scroll.delegate = self;
    self.scroll.pagingEnabled = YES;
    [self.view addSubview:self.scroll];
    [self.scroll mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.equalTo(self.view);
        make.top.equalTo(self.titleView.mas_bottom);
    }];
    
    bgView = [UIView new];
    [self.scroll addSubview:bgView];
    [bgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.scroll);
        make.width.equalTo(self.view).multipliedBy(TitleBarArr.count*1.0);
        make.height.equalTo(self.view).offset(ChangedHeight(- 60) - StatusBarHeight - 44);
    }];
    
    
    WaterChildVc *allVc = [[WaterChildVc alloc]init];
    [self.scroll addSubview:allVc.view];
    [allVc.view mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.bottom.equalTo(bgView);
        make.width.equalTo(self.view);
    }];
    [allVc loadRunningBill:@"0"];
    [self addChildViewController:allVc];
    self.childVcDic = [[NSMutableDictionary alloc]init];
    [self.childVcDic setValue:allVc forKey:@"0"];
}


- (void)setContentViewAtindex:(NSInteger)index{
    if (self.childVcDic[[NSString stringWithFormat:@"%@",@(index)]]) {
        return;
    }
    WaterChildVc *water = [[WaterChildVc alloc]init];
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
    
    [self addChildViewController:water];
    [self.childVcDic setValue:water forKey:[NSString stringWithFormat:@"%@",@(index)]];
    
    switch (index) {
        case 4:
            index = 5;
            break;
        case 5:
            index = 4;
            break;
        default:
            break;
    }
    
    [water loadRunningBill:[NSString stringWithFormat:@"%@",@(index)]];
    
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    NSInteger idex = (NSInteger)scrollView.contentOffset.x/K_WIDTH;
    [self.titleView scrollToCenterWithIndex:idex];
    [self setContentViewAtindex:idex];
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
