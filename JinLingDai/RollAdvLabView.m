//
//  RollAdvLabView.m
//  JinLingDai
//
//  Created by 001 on 2017/7/22.
//  Copyright © 2017年 JLD. All rights reserved.
//

#import "RollAdvLabView.h"
#import "NSMutableAttributedString+contentText.h"
#import <YYKit.h>
@interface RollAdvLabView ()<UIScrollViewDelegate>{
//    long long touziCount;
}
@property (nonatomic, strong) NSTimer *cdTimer;                 //计时器
@property (nonatomic, strong) UIScrollView *scroll;
@property (nonatomic, assign) NSInteger currentPage;
@property (nonatomic, strong) NSArray *modelArr;
@end

@implementation RollAdvLabView

- (instancetype) initWithReuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithReuseIdentifier:reuseIdentifier]) {
        self.contentView.backgroundColor = [UIColor whiteColor];
        
        self.icon = [[UIImageView alloc]init];
        self.icon.image = [UIImage imageNamed:@"公告"];
        [self.contentView addSubview:self.icon];
        [self.icon mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(self.contentView);
            make.left.equalTo(self.contentView).offset(10);
        }];
        
        self.scroll = [[UIScrollView alloc]init];
        self.scroll.scrollEnabled = NO;
        self.scroll.delegate = self;
        [self.contentView addSubview:self.scroll];
        [self.scroll mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.icon.mas_right).offset(7);
            make.right.bottom.top.equalTo(self.contentView);
        }];
        
        _currentPage = 1;
        
        
    }
    return self;
}

- (void)setcontentView:(NSArray *)item{
    if (self.cdTimer) {
        [self.cdTimer invalidate];
        self.cdTimer = nil;
        self.currentPage = 1;
    }
    [self.scroll removeAllSubviews];
    if (!item.count) {
        return;
    }
    self.modelArr = [item copy];
    [self.scroll setContentOffset:CGPointMake(0, CGRectGetHeight(self.scroll.bounds))];
//    __block NSInteger index= 1;
    
//     touziCount = [item[0] longLongValue] * 100;
    
    
    UIView *last = nil;
    for (NSInteger i = 0; i < item.count + 2; i++) {
        AnnouceModel *model;
        if (i >= 1 && i < item.count + 1) {
            model = (AnnouceModel *)item[i - 1];
        }
        UILabel *lab = [UILabel new];
        lab.tag = i + 19;
        if (i==item.count + 1) {
            lab.tag = 20;
            model = (AnnouceModel *)item.firstObject;
        }else if (i == 0){
            lab.tag = item.count - 1;
            model = (AnnouceModel *)item.lastObject;
        }
        [lab addGestureRecognizer:[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(GongGaoClick:)]];
        lab.font = [UIFont gs_fontNum:13];
        lab.textColor = [UIColor titleColor];
        lab.text = model.title;
        [self.scroll addSubview:lab];
        lab.userInteractionEnabled = YES;
        
        [lab mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.equalTo(self.scroll);
            //            make.right.lessThanOrEqualTo(self.scroll);
            //            make.width.mas_equalTo(200);
            make.width.equalTo(self.contentView).offset(ChangedHeight(- 35));
            make.height.equalTo(self.contentView);
            if (i == 0) {
                make.top.equalTo(self.scroll);
            }else{
                make.top.equalTo(last.mas_bottom);
            }
            if (i == item.count + 1) {
                make.bottom.equalTo(self.scroll);
            }
        }];
        last = lab;
    }

    self.cdTimer = [NSTimer scheduledTimerWithTimeInterval:5.f target:self selector:@selector(timeAdd:) userInfo:@(item.count) repeats:YES];

    [[NSRunLoop currentRunLoop] addTimer:self.cdTimer forMode:NSRunLoopCommonModes];
}

- (void)timeAdd:(NSTimer *)userinfo{
    self.currentPage ++;
    
    NSInteger itemCount = [[userinfo userInfo] integerValue];
    
    [UIView animateWithDuration:1.f animations:^{
        [self.scroll setContentOffset:CGPointMake(0, CGRectGetHeight(self.scroll.bounds) * self.currentPage)];
    }];
    if(self.currentPage == 0){
        self.currentPage = itemCount;
        [self.scroll setContentOffset:CGPointMake(0, CGRectGetHeight(self.scroll.bounds) * self.currentPage)];
    }else if(self.currentPage == itemCount + 1){
        self.currentPage = 1;
        self.scroll.contentOffset = CGPointMake(0, CGRectGetHeight(self.scroll.bounds));
    }
}

- (void)GongGaoClick:(UIGestureRecognizer *)sender{
    if (_GongGaoBlock) {
        AnnouceModel *model = self.modelArr[sender.view.tag - 20];
        if ([model.click_status integerValue] == 1) {
            _GongGaoBlock(sender.view.tag - 20);
        }
    }
}
- (void)dealloc{
    [self.cdTimer invalidate];
    self.cdTimer = nil;
}

@end
