//
//  DingQiXiangMuVc.m
//  JinLingDai
//
//  Created by 001 on 2017/7/7.
//  Copyright © 2017年 JLD. All rights reserved.
//

#import "DingQiXiangMuVc.h"
#import "TitleBarView.h"
#import "DingQiChildVc.h"
@interface DingQiXiangMuVc ()<UIScrollViewDelegate>
{
    UIView *bgView ;
}
@property (nonatomic, strong) UIScrollView *scroll;
@property (nonatomic, strong) NSMutableDictionary *childVcDic;
@property (nonatomic, strong) TitleBarView *titleView;
@end
#define DingQingTitleArr @[@"融资中",@"还款中",@"已还款"]
#define statusArr @[@"2", @"6", @"7"]
@implementation DingQiXiangMuVc

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setNavBlackColor];
    self.title = @"定期项目";
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.titleView = [[TitleBarView alloc]initWithFrame:CGRectMake(0, StatusBarHeight + 44, K_WIDTH, ChangedHeight(40))];
    
    self.titleView.isNeedScroll = NO;
    self.titleView.currentCollor = [UIColor getBlueColor];
    __weak typeof(self) weakMine = self;
    self.titleView.titleButtonClicked = ^(NSUInteger index) {
        [weakMine setContentViewAtindex:index];
        [weakMine.scroll setContentOffset:CGPointMake(K_WIDTH * index, 0) animated:YES];
    };
    
    [self.view addSubview:self.titleView];
    
    [self.titleView reloadAllButtonsOfTitleBarWithTitles:DingQingTitleArr];
    
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
        make.width.equalTo(self.view).multipliedBy(3.0);
        make.height.equalTo(self.view).offset(ChangedHeight(- 40) - StatusBarHeight - 44);
    }];
    
    DingQiChildVc *rongZiVc = [[DingQiChildVc alloc]init];
    [self.scroll addSubview:rongZiVc.view];
    [rongZiVc loadDingQiData:statusArr[0]];
    [rongZiVc.view mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.bottom.equalTo(bgView);
        make.width.equalTo(self.view);
    }];
    [self addChildViewController:rongZiVc];
    self.childVcDic = [[NSMutableDictionary alloc]init];
    [self.childVcDic setValue:rongZiVc forKey:@"0"];
}

- (void)setContentViewAtindex:(NSInteger)index{
    //	2=>融资中，6=>还款中，7=>已还款，非必需
    if (self.childVcDic[[NSString stringWithFormat:@"%@",@(index)]]) {
        return;
    }
    DingQiChildVc *rongZiVc = [[DingQiChildVc alloc]init];
    [self.scroll addSubview:rongZiVc.view];
    [rongZiVc loadDingQiData:statusArr[index]];
    [rongZiVc.view mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.equalTo(bgView);
        make.width.equalTo(self.view);
        if (index == 2) {
            make.right.equalTo(bgView);
        }else{
            make.left.equalTo(bgView).offset(K_WIDTH);
        }
    }];
    
    [self addChildViewController:rongZiVc];
    [self.childVcDic setValue:rongZiVc forKey:[NSString stringWithFormat:@"%@",@(index)]];
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
